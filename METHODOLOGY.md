# Benchmark Methodology (v2)

This document describes how the benchmark measures SSG build performance,
what each scenario means, and which cross-SSG deviations are known and
accepted. Results produced before v2 (CSV files without a `scenario` column)
are tagged **legacy** in the dashboard and are **not comparable** with v2
numbers.

## Why v1 results were unreliable

The original methodology had several flaws that could flip rankings:

1. **Workloads were not comparable.** Hugo received a unique tag per post
   (`post-N`), so at 5,000 posts Hugo built **15,012 pages** while Zola built
   5,001 and Hwaro 5,000. Hugo also ran with `--minify` while others didn't,
   and Hwaro had every feature (sitemap, feeds, taxonomies, highlighting)
   disabled.
2. **Timing included Docker overhead.** The clock wrapped the entire
   `docker run` lifecycle (container start/stop, image load, macOS virtiofs
   mount). At 10 pages this overhead dominated: ~200 ms wall for builds that
   actually take 15–20 ms.
3. **Memory/CPU were never measured** in Docker mode (hardcoded 0).
4. **Content was random** (`$RANDOM`, unseeded): every SSG and every run got
   different input sizes.
5. **Caches leaked between iterations.** `.jekyll-cache`, Gatsby's `.cache`,
   Hexo's `db.json` survived, so some SSGs got warm rebuilds while others
   always built cold.

## Measurement (v2)

- **Build time** is measured *inside* the container by a small shell script
  (`.bench/run.sh`) that timestamps only the build command with GNU date
  (nanosecond resolution). Container start/stop, image load and volume setup
  are excluded.
- **Peak memory** is read from the container's cgroup
  (`/sys/fs/cgroup/memory.peak`), covering the whole build process tree.
  Note: this includes page cache attributed to the cgroup.
- **Warmup:** each (SSG, scenario, page count) gets `WARMUP` (default 1)
  unrecorded builds first, so OS page cache and JIT effects don't land in
  iteration 1.
- **Cold builds:** between iterations, build outputs *and* caches are removed
  (`public`, `_site`, `output`, `build`, `dist`, `.jekyll-cache`, `.cache`,
  `.docusaurus`, `db.json`, `resources`, `node_modules/.cache`). Every
  recorded iteration is a full cold build. (`npm install` / gem resolution is
  done once, outside timing.)
- **Statistics:** the summary and dashboard report the **median** of the
  recorded iterations (plus min/max). Increase `ITERATIONS` for tighter
  intervals.
- **Execution order:** iterations are **interleaved** across SSGs — one
  iteration of every SSG, then the next round, rotating which SSG starts each
  round (`EXEC_ORDER`, default `interleaved`). Running all of one SSG's
  iterations back to back charges any drift in host speed — thermal
  throttling, a noisy neighbour — to whichever SSG happened to be running
  then, and with a fixed SSG order that bias points the same way every run.
  `EXEC_ORDER=sequential` restores the batched order for disk-constrained
  hosts, at the cost of reintroducing it.
- **Network isolation:** timed builds run with `--network=none` and telemetry
  disabled (`BUILD_NETWORK`, default `none`). Several node-based generators
  ping analytics or update-notifier endpoints during `build`; that latency
  depends on the host's connectivity, not the generator. All dependency
  resolution (`npm install`, `bundle lock`) happens beforehand, outside timing.
- **Resource limits:** containers run with `--cpus=4 --memory=4g` by default
  (`DOCKER_CPUS`, `DOCKER_MEMORY`, optional `DOCKER_CPUSET` pinning). `--cpus`
  is clamped to the host's CPU count, because asking for more than the host
  has does not fail — it silently enforces nothing while the run records a
  limit. Swap is disabled (`--memory-swap` = `--memory`) so an SSG that
  overruns the cap is OOM-killed and recorded as `oom` rather than silently
  paged and recorded as "slow". Builds finishing within 10% of the cap are
  flagged. All SSGs get identical limits; absolute numbers depend on the host,
  so only compare within a run.

## Pinned toolchains

Every SSG version is pinned in [`docker/versions.env`](docker/versions.env) and
passed to each image as a `--build-arg`; nothing installs a floating version.
Node-based SSGs additionally pin their npm trees exactly (no caret ranges), and
Jekyll pins its Gemfile.

This matters beyond reproducibility. Before v2.1 the drift was not uniform:
hwaro was built from `main` while every other SSG came from a release, and Hugo
came from Alpine's package (2023-era, and musl-linked) while everything else
was current and glibc. All Node SSGs now share one base image too — Astro was
on Node 22 while the rest were on Node 20.

Each run records what it actually measured in `versions.json` (pinned *and*
observed versions, base OS, language runtime), rendered into `summary.md` and
carried into the dashboard's `data.json`.

### Variant builds (`hwaro-main`)

This repo has two jobs. One is the cross-SSG comparison above, where hwaro is
pinned to a release like everything else. The other is measuring hwaro's own
development — "did this month's commits make it faster?" — which needs a build
from `main`, exactly what the pinning above forbids.

Those are separate rows, not a redefinition of the first. An SSG id may be
`<family>-<variant>`, and `hwaro-main` is hwaro built from its main branch:

```sh
./scripts/benchmark.sh -s hwaro,hwaro-main       # or: make benchmark-hwaro-main
```

The variant is constrained so that a difference in its numbers can only be a
difference in hwaro's source:

- **Same Dockerfile**, not a copy. `hwaro-main` builds from
  `docker/Dockerfile.hwaro` with `HWARO_VERSION` replaced — same Crystal image,
  same `shards build` flags, same runner stage. A dedicated
  `Dockerfile.hwaro-main` would be free to drift, and a drifted compiler flag
  would read as a hwaro performance change.
- **Same site, same content.** Templates, scenario overlay, generated corpus,
  build command and output directory all resolve to the *family*, so both rows
  do identical work.
- **Same run.** Benchmark them together and the interleaved execution order
  puts both through the same host drift, which is the whole point of comparing
  them.
- **Not stale.** A branch's contents move while its name does not, so the image
  layer that clones it would be cached forever. The runner resolves the ref to
  its current commit (`git ls-remote`) and keys the layer on that; the probe in
  `versions.json` reports the built commit, not just the shard version — which
  on `main` is whatever the last release bumped it to and would otherwise be
  indistinguishable from the release row.

`hwaro-main` is opt-in: it is in no default SSG set, no scheduled workflow and
no published run. The comparison this repo publishes contains one hwaro, and it
is the released one.

## Deterministic content

`scripts/generate-content.sh` generates a seeded corpus (`SEED`, default 42):

- The markdown **body of post N is byte-identical across all SSGs** and across
  runs. Only the front-matter format differs per SSG.
- Titles, dates and tags are pure functions of the post index, and the body
  text comes from an **explicit LCG defined in the script** — not bash's
  `$RANDOM`, whose generator changed in bash 5.1 and so produced different
  corpora on macOS and Linux from the same seed.
- Bodies are cached under `.corpus/`, stamped with the generator revision and
  the seed; a mismatched stamp regenerates (`make clean-corpus` to force).
- Each run records a **corpus digest** in `config.json` and `summary.md`. Two
  runs with the same digest were fed the same bytes; matching configs are not
  by themselves evidence of that.

## Scenarios

| | minimal | blog | heavy |
|---|---|---|---|
| Markdown → HTML pages | ✓ | ✓ | ✓ |
| Site index (10 recent) | ✓ | ✓ | ✓ |
| All-posts listing page | ✓ | ✓ | ✓ |
| Tags (2/post, pool of 10) | – | ✓ | ✓ |
| Tag pages + tag index | – | ✓ | ✓ |
| Pagination (10/page) | – | ✓ | ✓ |
| Feed (atom/rss, limit 20) | – | ✓ | ✓ |
| Fenced code blocks (3/post) | – | ✓ | ✓ |
| Build-time syntax highlighting | – | ✓ | ✓ |
| Sidebar on every page (recent 10 + tag cloud w/ counts) | – | – | ✓ |
| Breadcrumb nav on every page | – | – | ✓ |
| Prev/next post navigation | – | – | ✓ |
| Sitemap | – | – | – |

- **minimal** answers: how fast is the core parse→render→write pipeline?
- **blog** answers: how fast is a realistic content blog (taxonomies,
  pagination, feeds, build-time syntax highlighting)?
- **heavy** answers: how fast is a template-heavy site? Content and features
  are identical to `blog`, but the layouts do much more work per page: a
  sidebar partial (site-wide recent posts + a tag cloud with counts) is
  rendered on **every** page via the SSG's include/partial mechanism, plus
  breadcrumbs and prev/next post navigation on post pages. This stresses
  template composition and per-page access to site-wide collections —
  `heavy` emits the same page set as `blog`, so any time delta between the
  two is pure template overhead.

Highlighting engines used in `blog`/`heavy` (all build-time, no client JS):
Hugo=Chroma, Zola=giallo/syntect, Hwaro=Tartrazine (`mode="server"`),
Jekyll=Rouge, Eleventy=Prism plugin, Pelican=Pygments, Hexo=highlight.js.

Sidebar/nav implementations use each SSG's native idiom (Hugo partial +
`.Site.Taxonomies`, Zola `include` + `get_taxonomy`, Jekyll include +
`site.tags`, Hwaro partial + `get_taxonomy`, Eleventy include + a small
`tagList` collection in `.eleventy.js`, Pelican include + the `tags` common
context, Hexo `partial()` + `site.tags`). The default page count is 1000.

### Scenario support matrix

| SSG | minimal | blog | heavy |
|-----|---------|------|-------|
| hugo, zola, hwaro, jekyll, eleventy, pelican, hexo | ✓ | ✓ | ✓ |
| gatsby, astro, docusaurus, blades | ✓ | – | – |

Gatsby/Astro would need bespoke application code for tag pages, pagination
and feeds (which would benchmark *our* code, not the SSG); Docusaurus cannot
disable framework pagination; Blades is kept minimal-only. They run in
`minimal` as cross-checks.

A variant inherits its family's row, so `hwaro-main` supports all three
scenarios — the point of a variant is that it does identical work.

## Output parity guard

After every iteration the benchmark counts the HTML files produced. The
summary compares medians across SSGs per (scenario, page count) and flags a
**MISMATCH** when `max > min × 1.10 + 5`. If that fires, the SSGs did
different amounts of work and the timing comparison is invalid — this guard
is what caught the v1 Hugo 3× page explosion.

A per-SSG `undercount` status flags any build that rendered fewer **post**
pages than the corpus contained. It counts post pages specifically, not total
HTML: index, tag, pagination and archive pages inflate the total, so an SSG
that rendered 900 of 1000 posts while emitting 200 aggregate pages would
otherwise pass a naive `total < page_count` test while doing 10% less of the
work that scales.

The verdict is written to `parity.json` as well as `summary.md`, so CI and the
dashboard can distinguish a clean run from one already known to be invalid.
`STRICT_PARITY=true` makes a mismatch fail the run.

## Scenario feature verification

The parity guard counts files; it cannot see whether the files contain the
work. A config key an SSG silently ignores — a renamed section, a plugin that
stopped loading, a template that no longer resolves — makes that SSG skip real
work while emitting exactly the right number of pages.

After the final iteration, `scripts/verify-output.py` inspects the emitted HTML
for the features the scenario promised:

| Check | Scenarios | What it asserts |
|---|---|---|
| `post_pages`, `post_not_empty` | all | every post rendered, and not to a blank page |
| `index_page` | all | the site index exists |
| `tag_pages` | blog, heavy | ≥8 of the 10 tag pages exist |
| `feed` | blog, heavy | a feed file was emitted |
| `pagination` | blog, heavy | ≥2 pagination pages exist |
| `syntax_highlighting` | blog, heavy | code inside `<pre>` was tokenised into spans |
| `sidebar`, `breadcrumbs`, `post_nav` | heavy | the markers are present on post pages |
| `sidebar_populated` | heavy | the sidebar's tag cloud is not empty |

The highlighting check is engine-agnostic on purpose: Chroma, Rouge, Pygments,
Prism, syntect and highlight.js all turn the code into spans, and a build that
skipped highlighting has none. Reports land in
`verify_<ssg>_<scenario>_<pages>.json`; failures are tabulated in `summary.md`.
Non-fatal by default; `STRICT_VERIFY=true` makes them fail the run.

This is also the guard that makes a version bump safe. If Hugo's layout lookup
changes and `layouts/_default/` stops resolving, Hugo still emits the right
number of pages — they are simply empty, which nothing else in the suite would
notice.

## Known deviations (accepted, O(1) or O(N)-links only)

- **Zola always emits** `404.html`, `sitemap.xml` and `robots.txt` (not
  configurable). Sitemap/robots are not HTML and 404 is one page.
- **Pelican** uses a purpose-built minimal theme (`sites/pelican/theme/`)
  because the bundled `simple` theme forces author/category archives and
  paginated tag pages. It has no separate all-posts listing page (its
  paginated index covers that role): −1 page vs the others.
- **Docusaurus** (minimal-only) always paginates its post list (N/10 list
  pages) and builds a React SPA per page — it does structurally more work by
  design.
- **Feeds** differ slightly in format (RSS vs Atom) and item rendering;
  all are capped at 20 items.
- **Jekyll/Eleventy/Hexo have no sitemap plugin enabled**; sitemap is off
  everywhere it is configurable, so only Zola emits one.

## CSV schema (v2.1)

```csv
ssg,scenario,page_count,iteration,build_time_ms,peak_memory_kb,output_files,status,post_files
hugo,blog,1000,1,842,45120,1123,success,1000
```

`status` ∈ `success` | `failed` | `undercount` | `oom`. `post_files` is
appended after `status` so the field positions v2 readers rely on are
unchanged.

Each run directory also contains:

| File | Contents |
|---|---|
| `config.json` | every knob, host info, effective resource limits, corpus digest |
| `versions.json` | pinned vs. measured SSG versions, base OS, runtime |
| `parity.json` | machine-readable output-parity verdict |
| `verify_*.json` | per-SSG scenario feature checks |
| `summary.md` | median tables, parity check, feature verification, resource incidents |
| `*.log` | per-iteration build logs, image build logs, dependency install logs |
