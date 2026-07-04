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
- **Resource limits:** containers run with `--cpus=4 --memory=4g` by default
  (`DOCKER_CPUS`, `DOCKER_MEMORY`). All SSGs get identical limits; absolute
  numbers depend on the host, so only compare within a run.

## Deterministic content

`scripts/generate-content.sh` generates a seeded corpus (`SEED`, default 42):

- The markdown **body of post N is byte-identical across all SSGs** and across
  runs. Only the front-matter format differs per SSG.
- Titles, dates and tags are pure functions of the post index (no clock, no
  RNG at emit time), so any two runs — on any machine — benchmark the same
  input.
- Bodies are cached under `.corpus/` (`make clean-corpus` to reset).

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

## Output parity guard

After every iteration the benchmark counts the HTML files produced. The
summary compares medians across SSGs per (scenario, page count) and flags a
**MISMATCH** when `max > min × 1.10 + 5`. If that fires, the SSGs did
different amounts of work and the timing comparison is invalid — this guard
is what caught the v1 Hugo 3× page explosion. A per-SSG `undercount` status
also flags any build that produced fewer HTML files than input pages.

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

## CSV schema (v2)

```csv
ssg,scenario,page_count,iteration,build_time_ms,peak_memory_kb,output_files,status
hugo,blog,1000,1,842,45120,1123,success
```

`status` ∈ `success` | `failed` | `undercount`. Each run directory also
contains `config.json` (all knobs + host info), per-iteration build logs, and
`summary.md` with the median tables and the parity check.
