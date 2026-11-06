# SSG Benchmark Results (methodology v2)

**Generated:** Fri Nov  6 09:30:27 KST 2026
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
| astro | astro  v7.4.5 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| docusaurus | 3.10.2 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| eleventy | 3.1.8 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| gatsby | Gatsby CLI version: 5.16.0 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| hugo | hugo v0.169.0-1da10fc44701c566b1669cdb2d12638f155138bd linux/arm64 BuildDate=2026-10-27T14:52:20Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 0.22.1 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [aarch64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.16 |
| zola | zola 0.23.6 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 579 | 532 | 618 | 129.4 | 1002 |
| zola | 1000 | 485 | 423 | 503 | 90.0 | 1003 |
| jekyll | 1000 | 1738 | 1716 | 1955 | 86.6 | 1002 |
| hwaro | 1000 | 487 | 487 | 528 | 184.6 | 1002 |
| eleventy | 1000 | 1179 | 1163 | 1890 | 171.3 | 1002 |
| pelican | 1000 | 1252 | 1248 | 1252 | 65.5 | 1001 |
| hexo | 1000 | 1240 | 1213 | 1262 | 209.5 | 1002 |
| gatsby | 1000 | 34176 | 33378 | 40193 | 3503.6 | 1002 |
| astro | 1000 | 4434 | 4117 | 4477 | 888.7 | 1001 |
| docusaurus | 1000 | 30366 | 30216 | 30392 | 2474.5 | 1103 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 992 | 972 | 1006 | 174.5 | 1113 |
| zola | 1000 | 869 | 832 | 871 | 119.0 | 1114 |
| jekyll | 1000 | 3291 | 3250 | 3683 | 99.7 | 1111 |
| hwaro | 1000 | 598 | 579 | 630 | 165.9 | 1112 |
| eleventy | 1000 | 1520 | 1519 | 1569 | 187.4 | 1111 |
| pelican | 1000 | 3036 | 2787 | 3226 | 51.1 | 1110 |
| hexo | 1000 | 1774 | 1770 | 1841 | 343.5 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1013 | 997 | 1082 | 178.2 | 1113 |
| zola | 1000 | 796 | 793 | 839 | 120.6 | 1114 |
| jekyll | 1000 | 3088 | 3078 | 3234 | 102.0 | 1111 |
| hwaro | 1000 | 699 | 685 | 723 | 242.1 | 1112 |
| eleventy | 1000 | 1710 | 1689 | 1721 | 188.7 | 1111 |
| pelican | 1000 | 2662 | 2642 | 2713 | 51.1 | 1110 |
| hexo | 1000 | 2370 | 2298 | 2443 | 372.8 | 1111 |

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
