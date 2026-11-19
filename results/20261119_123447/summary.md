# SSG Benchmark Results (methodology v2)

**Generated:** Thu Nov 19 12:49:34 KST 2026
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
| astro | astro  v7.4.5 | Debian GNU/Linux 12 (bookworm) | v22.23.5 |
| docusaurus | 3.10.2 | Debian GNU/Linux 12 (bookworm) | v22.23.5 |
| eleventy | 3.1.8 | Debian GNU/Linux 12 (bookworm) | v22.23.5 |
| gatsby | Gatsby CLI version: 5.16.0 | Debian GNU/Linux 12 (bookworm) | v22.23.5 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.5 |
| hugo | hugo v0.169.0-1da10fc44701c566b1669cdb2d12638f155138bd linux/arm64 BuildDate=2026-10-27T14:52:20Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 1.0.0 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [aarch64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.16 |
| zola | zola 0.23.6 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 504 | 485 | 505 | 123.7 | 1002 |
| zola | 1000 | 395 | 388 | 1091 | 86.2 | 1003 |
| jekyll | 1000 | 1643 | 1639 | 1752 | 90.3 | 1002 |
| hwaro | 1000 | 461 | 455 | 497 | 135.0 | 1002 |
| eleventy | 1000 | 1087 | 1078 | 1117 | 170.7 | 1002 |
| pelican | 1000 | 1183 | 1180 | 1212 | 64.1 | 1001 |
| hexo | 1000 | 1195 | 1195 | 1227 | 208.9 | 1002 |
| gatsby | 1000 | 30696 | 28875 | 31102 | 3541.3 | 1002 |
| astro | 1000 | 4228 | 4219 | 4484 | 881.9 | 1001 |
| docusaurus | 1000 | 27689 | 27444 | 27816 | 2409.4 | 1103 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 936 | 934 | 966 | 174.5 | 1113 |
| zola | 1000 | 820 | 820 | 847 | 119.6 | 1114 |
| jekyll | 1000 | 2820 | 2816 | 2821 | 99.4 | 1111 |
| hwaro | 1000 | 557 | 536 | 559 | 134.6 | 1112 |
| eleventy | 1000 | 1349 | 1343 | 1350 | 183.2 | 1111 |
| pelican | 1000 | 2445 | 2415 | 2445 | 51.3 | 1110 |
| hexo | 1000 | 1609 | 1589 | 1629 | 344.0 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1047 | 1046 | 1056 | 180.3 | 1113 |
| zola | 1000 | 803 | 791 | 804 | 120.7 | 1114 |
| jekyll | 1000 | 3052 | 3006 | 3069 | 102.1 | 1111 |
| hwaro | 1000 | 680 | 677 | 684 | 209.7 | 1112 |
| eleventy | 1000 | 1654 | 1644 | 1715 | 189.5 | 1111 |
| pelican | 1000 | 2523 | 2502 | 2524 | 51.2 | 1110 |
| hexo | 1000 | 2250 | 2241 | 2273 | 383.5 | 1111 |

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
