# SSG Benchmark Results (methodology v2)

**Generated:** Fri Aug 28 18:53:53 KST 2026
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
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.14 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 547 | 516 | 1737 | 85.7 | 1002 |
| zola | 1000 | 679 | 571 | 1015 | 71.8 | 1003 |
| jekyll | 1000 | 1888 | 1858 | 2076 | 70.8 | 1002 |
| hwaro | 1000 | 649 | 613 | 716 | 64.2 | 1002 |
| eleventy | 1000 | 1330 | 1249 | 1377 | 163.6 | 1002 |
| pelican | 1000 | 1483 | 1480 | 1486 | 43.1 | 1001 |
| hexo | 1000 | 1538 | 1519 | 1544 | 210.7 | 1002 |
| gatsby | 1000 | 32068 | 29758 | 45596 | 2864.4 | 1002 |
| astro | 1000 | 8475 | 8155 | 9268 | 752.0 | 1001 |
| docusaurus | 1000 | 38100 | 37320 | 42499 | 2368.2 | 1103 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1040 | 1026 | 1058 | 154.7 | 1113 |
| zola | 1000 | 990 | 931 | 1359 | 210.3 | 1114 |
| jekyll | 1000 | 3359 | 3269 | 3875 | 98.6 | 1111 |
| hwaro | 1000 | 809 | 801 | 1306 | 69.6 | 1112 |
| eleventy | 1000 | 1535 | 1488 | 2358 | 186.1 | 1111 |
| pelican | 1000 | 3131 | 2956 | 3352 | 51.4 | 1110 |
| hexo | 1000 | 2389 | 2366 | 2605 | 340.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1104 | 1081 | 1141 | 163.0 | 1113 |
| zola | 1000 | 28293 | 28094 | 28710 | 1084.3 | 1114 |
| jekyll | 1000 | 3468 | 3425 | 3787 | 101.2 | 1111 |
| hwaro | 1000 | 1873 | 1756 | 2016 | 70.7 | 1112 |
| eleventy | 1000 | 1862 | 1796 | 1904 | 190.1 | 1111 |
| pelican | 1000 | 3076 | 2824 | 3207 | 51.8 | 1110 |
| hexo | 1000 | 2933 | 2846 | 3083 | 412.2 | 1111 |

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
