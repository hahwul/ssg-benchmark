# SSG Benchmark Results (methodology v2)

**Generated:** Wed Aug 12 21:53:05 KST 2026
**SSGs:** hugo zola jekyll hwaro eleventy pelican hexo gatsby astro docusaurus
**Scenarios:** minimal blog heavy
**Page counts:** 1000
**Iterations:** 3 (+1 warmup, cold builds, median reported)
**Execution order:** interleaved | **Build network:** none
**Seed:** 42 | **Docker:** cpus=4 mem=4g
**Corpus digest:** `minimal@1000=30714edb6c4a0644 blog@1000=033bc142b6b7f386 heavy@1000=033bc142b6b7f386` (same digest = same input bytes)

## Toolchain versions

Exactly what was measured. Timings from runs with different versions here
are not comparable, however similar the methodology.

| SSG | Version | Base image OS | Runtime |
|-----|---------|---------------|---------|
| astro | astro  v5.18.2 | Debian GNU/Linux 12 (bookworm) | v22.23.2 |
| docusaurus | 3.10.2 | Debian GNU/Linux 12 (bookworm) | v22.23.2 |
| eleventy | 3.1.6 | Debian GNU/Linux 12 (bookworm) | v22.23.2 |
| gatsby | Gatsby CLI version: 5.16.0 | Debian GNU/Linux 12 (bookworm) | v22.23.2 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.2 |
| hugo | hugo v0.145.0-666444f0a52132f9fec9f71cf25b441cc6a4f355 linux/arm64 BuildDate=2025-02-26T15:41:25Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 0.18.1 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [aarch64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.13 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 539 | 531 | 556 | 83.4 | 1002 |
| zola | 1000 | 530 | 495 | 534 | 72.2 | 1003 |
| jekyll | 1000 | 1658 | 1633 | 1786 | 71.9 | 1002 |
| hwaro | 1000 | 602 | 599 | 620 | 64.4 | 1002 |
| eleventy | 1000 | 1188 | 1119 | 1206 | 164.8 | 1002 |
| pelican | 1000 | 1350 | 1350 | 1503 | 43.6 | 1001 |
| hexo | 1000 | 1357 | 1355 | 1406 | 199.3 | 1002 |
| gatsby | 1000 | 29749 | 28583 | 30409 | 2853.5 | 1002 |
| astro | 1000 | 7806 | 7709 | 8039 | 749.7 | 1001 |
| docusaurus | 1000 | 36746 | 32721 | 36748 | 2190.3 | 1103 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 974 | 937 | 1036 | 155.4 | 1113 |
| zola | 1000 | 975 | 956 | 1105 | 212.0 | 1114 |
| jekyll | 1000 | 3240 | 3186 | 3571 | 99.9 | 1111 |
| hwaro | 1000 | 779 | 691 | 925 | 71.1 | 1112 |
| eleventy | 1000 | 1519 | 1497 | 1532 | 187.7 | 1111 |
| pelican | 1000 | 2908 | 2848 | 2934 | 51.3 | 1110 |
| hexo | 1000 | 2124 | 2101 | 2215 | 351.5 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1118 | 1113 | 1148 | 163.8 | 1113 |
| zola | 1000 | 28903 | 28393 | 29301 | 1084.8 | 1114 |
| jekyll | 1000 | 3261 | 3259 | 3353 | 102.5 | 1111 |
| hwaro | 1000 | 1625 | 1541 | 1694 | 72.8 | 1112 |
| eleventy | 1000 | 1914 | 1782 | 1921 | 191.7 | 1111 |
| pelican | 1000 | 2988 | 2757 | 3318 | 51.2 | 1110 |
| hexo | 1000 | 2936 | 2859 | 3094 | 383.0 | 1111 |

## Output parity check

Median HTML file counts per (scenario, page count). Large spreads mean
the SSGs are NOT doing comparable work — investigate before comparing times.
`UNDERCOUNT` means an SSG rendered fewer post pages than the corpus
contained, regardless of how many aggregate pages it emitted.
Machine-readable verdict: `parity.json`.

- minimal @ 1000p: hugo=1002 zola=1003 jekyll=1002 hwaro=1002 eleventy=1002 pelican=1001 hexo=1002 gatsby=1002 astro=1001 docusaurus=1103 → OK
- blog @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK
- heavy @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK

## Scenario feature verification

Confirms the features each scenario promises are present in the emitted
HTML — highlighting, tag pages, feed, pagination, sidebar. An SSG that
silently skips one of these is doing less work than its rivals, which the
output-count parity check cannot detect. Per-SSG reports:
`verify_<ssg>_<scenario>_<pages>.json`.

| SSG | Scenario | Pages | Failed checks |
|-----|----------|-------|---------------|
| jekyll | blog | 1000 | pagination |
| pelican | blog | 1000 | tag_pages feed pagination |
| jekyll | heavy | 1000 | pagination |
| pelican | heavy | 1000 | tag_pages feed pagination |

**Timings involving these SSGs are not comparable** until the cause is
fixed: they measure a smaller workload.

## Raw Data

See `results.csv` (per-iteration) and `config.json` (run settings).
