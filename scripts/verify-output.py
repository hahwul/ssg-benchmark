#!/usr/bin/env python3
"""Verify that a finished build actually contains the scenario's features.

The scenarios are the benchmark's fairness contract: `blog` claims every SSG
builds tag pages, pagination, a feed and build-time syntax highlighting, and
`heavy` claims every page additionally renders a sidebar, breadcrumbs and
prev/next navigation. Until now nothing checked that. A config key that an SSG
silently ignores — a renamed section, a plugin that stopped loading, a template
that no longer resolves — makes that SSG skip real work and post a better time
for it. The output-count parity guard cannot see this: skipping highlighting or
emitting an empty sidebar changes the bytes, not the file count.

This is the check that makes a version bump safe, too. If Hugo's layout lookup
changes and `layouts/_default/` stops resolving, Hugo still emits the right
number of pages — they are just empty. That shows up here and nowhere else.

Emits JSON on stdout. Exits 0 unless --strict is passed, so a verification
miss annotates a run rather than destroying it.
"""

import argparse
import json
import os
import re
import sys

POST_FILE_RE = re.compile(r"post-(\d+)(?:/index)?\.html$")
PRE_BLOCK_RE = re.compile(r"<pre\b.*?</pre>", re.DOTALL | re.IGNORECASE)
TAG_DIR_RE = re.compile(r"(?:^|/)tags?/([^/]+)/")

FEED_NAMES = ("atom.xml", "rss.xml", "feed.xml", "index.xml", "rss2.xml", "feed.atom")
# Zola/Hugo/Jekyll/Pelican/Hexo/Eleventy all land on one of these shapes.
PAGINATION_RE = re.compile(r"(?:^|/)(?:page|pages)/(\d+)(?:/index)?\.html$|(?:^|/)page(\d+)\.html$")


def html_files(root):
    out = []
    for dirpath, _dirnames, filenames in os.walk(root):
        for name in filenames:
            if name.endswith(".html"):
                full = os.path.join(dirpath, name)
                out.append((full, os.path.relpath(full, root)))
    return out


def read(path, limit=2_000_000):
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as fh:
            return fh.read(limit)
    except OSError:
        return ""


def check(name, ok, detail=""):
    return {"name": name, "ok": bool(ok), "detail": detail}


def find_sample_post(files):
    """The lowest-numbered post page, so every SSG is sampled at the same post."""
    best = None
    for full, rel in files:
        m = POST_FILE_RE.search(rel)
        if m:
            idx = int(m.group(1))
            if best is None or idx < best[0]:
                best = (idx, full, rel)
    return best


def has_highlighted_code(html):
    """True when a <pre> block was tokenised at build time.

    Engine-agnostic on purpose: Chroma with noClasses emits inline-styled
    spans, Rouge and Pygments emit class-per-token spans, Prism emits
    .token spans, highlight.js emits .hljs-* spans. What they all share is
    that the code inside <pre> stops being a flat text node. A build that
    skipped highlighting has <pre><code>...</code></pre> and no spans.
    """
    for block in PRE_BLOCK_RE.findall(html):
        if "<span" in block.lower():
            return True
    return False


def run_checks(args):
    root = args.output_dir
    checks = []

    if not os.path.isdir(root):
        return [check("output_dir", False, "%s does not exist" % root)]

    files = html_files(root)
    rels = [rel for _full, rel in files]

    post_pages = sum(1 for rel in rels if POST_FILE_RE.search(rel))
    checks.append(check(
        "post_pages", post_pages >= args.pages,
        "%d post pages for %d inputs" % (post_pages, args.pages)))

    sample = find_sample_post(files)
    if sample is None:
        checks.append(check("sample_post", False, "no post-N.html found"))
        return checks
    _idx, sample_path, sample_rel = sample
    html = read(sample_path)
    checks.append(check("sample_post", len(html) > 0, sample_rel))

    # A page that renders but is empty passes every count-based guard. Posts
    # carry several paragraphs of lorem plus headings; anything under 1KB means
    # the template resolved to nothing.
    checks.append(check(
        "post_not_empty", len(html) >= 1024,
        "%d bytes in %s" % (len(html), sample_rel)))

    index = os.path.join(root, "index.html")
    checks.append(check("index_page", os.path.isfile(index), "index.html"))

    if args.scenario in ("blog", "heavy"):
        tags = {m.group(1) for rel in rels for m in [TAG_DIR_RE.search(rel)] if m}
        checks.append(check(
            "tag_pages", len(tags) >= args.min_tags,
            "%d tag pages (expected >= %d)" % (len(tags), args.min_tags)))

        feed = next(
            (n for n in FEED_NAMES
             if os.path.isfile(os.path.join(root, n))
             or os.path.isfile(os.path.join(root, "feed", n))),
            None)
        checks.append(check("feed", feed is not None, feed or "no feed file found"))

        paginated = sum(1 for rel in rels if PAGINATION_RE.search(rel))
        checks.append(check(
            "pagination", paginated >= args.min_pagination,
            "%d pagination pages (expected >= %d)" % (paginated, args.min_pagination)))

        checks.append(check(
            "syntax_highlighting", has_highlighted_code(html),
            "tokenised <pre> in %s" % sample_rel))

    if args.scenario == "heavy":
        for marker, label in (
            ('class="sidebar"', "sidebar"),
            ('class="breadcrumbs"', "breadcrumbs"),
            ('class="post-nav"', "post_nav"),
        ):
            checks.append(check(label, marker in html, "%s in %s" % (marker, sample_rel)))

        # A sidebar element that renders with an empty tag cloud is the same
        # skipped work as no sidebar at all.
        tail = html.split('class="sidebar"', 1)[-1] if 'class="sidebar"' in html else ""
        checks.append(check(
            "sidebar_populated", tail.count("<li") >= 5,
            "%d <li> entries after the sidebar element" % tail.count("<li")))

    return checks


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--ssg", required=True)
    p.add_argument("--scenario", required=True)
    p.add_argument("--output-dir", required=True)
    p.add_argument("--pages", type=int, required=True)
    p.add_argument("--min-tags", type=int, default=8,
                   help="tag pool is 10; allow slack for slugging differences")
    p.add_argument("--min-pagination", type=int, default=2)
    p.add_argument("--strict", action="store_true",
                   help="exit non-zero when any check fails")
    args = p.parse_args()

    checks = run_checks(args)
    failed = [c["name"] for c in checks if not c["ok"]]
    result = {
        "ssg": args.ssg,
        "scenario": args.scenario,
        "pages": args.pages,
        "ok": not failed,
        "failed": failed,
        "checks": checks,
    }
    json.dump(result, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 1 if (failed and args.strict) else 0


if __name__ == "__main__":
    sys.exit(main())
