#!/usr/bin/env python3
"""Compare the two most recent benchmark runs and emit a markdown delta table.

Replaces an inline shell comparison that was wrong in three ways at once:

  * it read column 4 of results.csv as the build time, but column 4 is
    `iteration` — so every "time" it reported was 1, 2 or 3 and every delta
    came out as 0;
  * it took the first matching row per SSG regardless of scenario or page
    count, so even with the right column it would have compared a 10-page
    minimal build against a 1000-page heavy one;
  * it picked the runs to compare with `ls -t`, which on a fresh checkout
    sorts by checkout time — effectively at random.

Rows are matched on (ssg, scenario, page_count) and compared as medians of the
successful iterations, which is what the summary tables report. Cells present
in only one run are listed rather than silently dropped, and runs built from
different toolchain versions or a different corpus are called out, because a
delta across those is not a performance change.
"""

import csv
import json
import os
import re
import sys

RUN_DIR_RE = re.compile(r"^\d{8}_\d{6}$")


def load_rows(run_dir):
    """{(ssg, scenario, pages): median_ms} over successful iterations."""
    path = os.path.join(run_dir, "results.csv")
    if not os.path.isfile(path):
        return {}

    buckets = {}
    with open(path, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        if not reader.fieldnames or "build_time_ms" not in reader.fieldnames:
            return {}  # v1 schema: not comparable with v2, skip rather than guess
        for row in reader:
            if row.get("status") != "success":
                continue
            try:
                key = (row["ssg"], row.get("scenario", "legacy"), int(row["page_count"]))
                buckets.setdefault(key, []).append(int(row["build_time_ms"]))
            except (KeyError, TypeError, ValueError):
                continue

    return {k: median(v) for k, v in buckets.items() if v}


def median(values):
    s = sorted(values)
    n = len(s)
    return s[n // 2] if n % 2 else (s[n // 2 - 1] + s[n // 2]) // 2


def read_json(run_dir, name):
    try:
        with open(os.path.join(run_dir, name), encoding="utf-8") as fh:
            return json.load(fh)
    except (OSError, ValueError):
        return None


def version_map(run_dir):
    data = read_json(run_dir, "versions.json") or {}
    return {k: v.get("version") for k, v in (data.get("measured") or {}).items()}


def main(results_root):
    if not os.path.isdir(results_root):
        print("No results directory to compare.")
        return 0

    # Run directories are named for their start time, so name order is time
    # order — no reliance on filesystem timestamps.
    runs = sorted(d for d in os.listdir(results_root) if RUN_DIR_RE.match(d))
    if len(runs) < 2:
        print("Not enough historical data for comparison.")
        return 0

    current, previous = runs[-1], runs[-2]
    cur = load_rows(os.path.join(results_root, current))
    prev = load_rows(os.path.join(results_root, previous))

    print("## 📊 Benchmark Comparison")
    print()
    print("Comparing **%s** with **%s** (median of successful iterations)." % (current, previous))
    print()

    if not cur or not prev:
        print("One of the runs has no comparable v2 results.")
        return 0

    # A timing delta across different SSG versions or different input is not a
    # performance change, and saying so is the whole point of recording them.
    cur_v, prev_v = version_map(os.path.join(results_root, current)), version_map(os.path.join(results_root, previous))
    changed = sorted(s for s in set(cur_v) & set(prev_v) if cur_v[s] != prev_v[s])
    if changed:
        print("> **Toolchain changed between these runs** — deltas below are not")
        print("> like-for-like for: %s" % ", ".join(changed))
        print()

    cur_cfg = read_json(os.path.join(results_root, current), "config.json") or {}
    prev_cfg = read_json(os.path.join(results_root, previous), "config.json") or {}
    if cur_cfg.get("corpus_digests") and prev_cfg.get("corpus_digests") \
            and cur_cfg["corpus_digests"] != prev_cfg["corpus_digests"]:
        print("> **Corpus digest differs** — the two runs were fed different input.")
        print()

    print("| SSG | Scenario | Pages | Previous (ms) | Current (ms) | Change |")
    print("|-----|----------|-------|---------------|--------------|--------|")

    for key in sorted(set(cur) & set(prev)):
        ssg, scenario, pages = key
        p, c = prev[key], cur[key]
        diff = c - p
        pct = (diff * 100.0 / p) if p else 0.0
        if diff > 0:
            change = "⬆️ +%d (+%.1f%%)" % (diff, pct)
        elif diff < 0:
            change = "⬇️ %d (%.1f%%)" % (diff, pct)
        else:
            change = "➡️ 0"
        print("| %s | %s | %d | %d | %d | %s |" % (ssg, scenario, pages, p, c, change))

    only_cur = sorted(set(cur) - set(prev))
    only_prev = sorted(set(prev) - set(cur))
    if only_cur or only_prev:
        print()
        print("Not comparable (present in only one run):")
        print()
        for key in only_cur:
            print("- new in `%s`: %s / %s @ %dp" % (current, key[0], key[1], key[2]))
        for key in only_prev:
            print("- missing from `%s`: %s / %s @ %dp" % (current, key[0], key[1], key[2]))

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else "results"))
