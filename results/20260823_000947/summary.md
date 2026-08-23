# SSG Benchmark Results (methodology v2)

**Generated:** Sun Aug 23 00:31:14 UTC 2026
**SSGs:** hugo zola jekyll hwaro eleventy pelican hexo
**Scenarios:** minimal blog heavy
**Page counts:** 10 100 1000
**Iterations:** 3 (+1 warmup, cold builds, median reported)
**Execution order:** interleaved | **Build network:** none
**Seed:** 42 | **Docker:** cpus=2 mem=5g
**Corpus digest:** `minimal@10=8511a9689f568f90 minimal@100=8a490d1a37612ef7 minimal@1000=30714edb6c4a0644 blog@10=9b21d85c3e2db72a blog@100=959bd6d6fa756b49 blog@1000=033bc142b6b7f386 heavy@10=9b21d85c3e2db72a heavy@100=959bd6d6fa756b49 heavy@1000=033bc142b6b7f386` (same digest = same input bytes)

## Toolchain versions

Exactly what was measured. Timings from runs with different versions here
are not comparable, however similar the methodology.

| SSG | Version | Base image OS | Runtime |
|-----|---------|---------------|---------|
| eleventy | 3.1.6 | Debian GNU/Linux 12 (bookworm) | v22.23.2 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.2 |
| hugo | hugo v0.145.0-666444f0a52132f9fec9f71cf25b441cc6a4f355 linux/amd64 BuildDate=2025-02-26T15:41:25Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 0.18.1 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [x86_64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.14 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 42 | 40 | 46 | 15.1 | 12 |
| hugo | 100 | 71 | 69 | 73 | 23.4 | 102 |
| hugo | 1000 | 348 | 320 | 353 | 87.1 | 1002 |
| zola | 10 | 20 | 20 | 21 | 14.7 | 13 |
| zola | 100 | 49 | 48 | 49 | 19.5 | 103 |
| zola | 1000 | 344 | 339 | 346 | 70.3 | 1003 |
| jekyll | 10 | 523 | 522 | 531 | 36.1 | 12 |
| jekyll | 100 | 619 | 615 | 619 | 39.1 | 102 |
| jekyll | 1000 | 1149 | 1140 | 1185 | 62.4 | 1002 |
| hwaro | 10 | 27 | 26 | 27 | 13.9 | 12 |
| hwaro | 100 | 52 | 51 | 54 | 21.4 | 102 |
| hwaro | 1000 | 353 | 323 | 360 | 52.4 | 1002 |
| eleventy | 10 | 443 | 426 | 449 | 53.6 | 12 |
| eleventy | 100 | 549 | 536 | 560 | 70.5 | 102 |
| eleventy | 1000 | 1393 | 1385 | 1420 | 147.4 | 1002 |
| pelican | 10 | 351 | 341 | 358 | 32.0 | 11 |
| pelican | 100 | 572 | 560 | 586 | 32.8 | 101 |
| pelican | 1000 | 2645 | 2639 | 2771 | 41.4 | 1001 |
| hexo | 10 | 405 | 403 | 421 | 41.3 | 12 |
| hexo | 100 | 652 | 649 | 653 | 72.6 | 102 |
| hexo | 1000 | 2376 | 2350 | 2425 | 221.4 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 72 | 71 | 77 | 23.7 | 24 |
| hugo | 100 | 230 | 229 | 242 | 39.2 | 123 |
| hugo | 1000 | 1845 | 1832 | 2212 | 161.0 | 1113 |
| zola | 10 | 349 | 328 | 389 | 133.9 | 25 |
| zola | 100 | 506 | 451 | 508 | 140.4 | 124 |
| zola | 1000 | 1702 | 1686 | 1878 | 210.2 | 1114 |
| jekyll | 10 | 637 | 631 | 661 | 39.4 | 22 |
| jekyll | 100 | 684 | 666 | 691 | 44.4 | 121 |
| jekyll | 1000 | 1386 | 1372 | 1511 | 81.8 | 1111 |
| hwaro | 10 | 38 | 37 | 40 | 18.2 | 23 |
| hwaro | 100 | 77 | 73 | 96 | 29.5 | 122 |
| hwaro | 1000 | 478 | 448 | 540 | 79.6 | 1112 |
| eleventy | 10 | 527 | 522 | 529 | 57.1 | 22 |
| eleventy | 100 | 667 | 664 | 669 | 89.5 | 121 |
| eleventy | 1000 | 2084 | 2055 | 2091 | 177.4 | 1111 |
| pelican | 10 | 500 | 498 | 501 | 34.0 | 21 |
| pelican | 100 | 1006 | 995 | 1037 | 36.0 | 120 |
| pelican | 1000 | 6387 | 6280 | 6511 | 58.0 | 1110 |
| hexo | 10 | 628 | 625 | 634 | 65.6 | 22 |
| hexo | 100 | 929 | 918 | 935 | 104.7 | 121 |
| hexo | 1000 | 3665 | 3637 | 3722 | 382.6 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 73 | 73 | 78 | 24.2 | 24 |
| hugo | 100 | 262 | 261 | 264 | 42.3 | 123 |
| hugo | 1000 | 2576 | 2471 | 2654 | 174.8 | 1113 |
| zola | 10 | 385 | 356 | 406 | 139.9 | 25 |
| zola | 100 | 1607 | 1566 | 1635 | 193.9 | 124 |
| zola | 1000 | 121202 | 120693 | 125848 | 738.1 | 1114 |
| jekyll | 10 | 579 | 576 | 601 | 39.4 | 22 |
| jekyll | 100 | 738 | 733 | 756 | 44.1 | 121 |
| jekyll | 1000 | 1947 | 1876 | 2112 | 86.6 | 1111 |
| hwaro | 10 | 40 | 40 | 41 | 20.6 | 23 |
| hwaro | 100 | 123 | 93 | 127 | 30.9 | 122 |
| hwaro | 1000 | 2477 | 2466 | 2650 | 101.8 | 1112 |
| eleventy | 10 | 498 | 488 | 502 | 59.2 | 22 |
| eleventy | 100 | 711 | 703 | 713 | 93.0 | 121 |
| eleventy | 1000 | 2826 | 2793 | 3744 | 183.6 | 1111 |
| pelican | 10 | 461 | 455 | 478 | 34.0 | 21 |
| pelican | 100 | 1073 | 1053 | 1073 | 36.6 | 120 |
| pelican | 1000 | 6692 | 6667 | 7156 | 60.1 | 1110 |
| hexo | 10 | 597 | 596 | 608 | 66.7 | 22 |
| hexo | 100 | 978 | 973 | 991 | 106.4 | 121 |
| hexo | 1000 | 5324 | 5299 | 5416 | 393.7 | 1111 |

## Output parity check

Median HTML file counts per (scenario, page count). Large spreads mean
the SSGs are NOT doing comparable work — investigate before comparing times.
`UNDERCOUNT` means an SSG rendered fewer post pages than the corpus
contained, regardless of how many aggregate pages it emitted.
Machine-readable verdict: `parity.json`.

- minimal @ 10p: hugo=12 zola=13 jekyll=12 hwaro=12 eleventy=12 pelican=11 hexo=12 → OK
- minimal @ 100p: hugo=102 zola=103 jekyll=102 hwaro=102 eleventy=102 pelican=101 hexo=102 → OK
- minimal @ 1000p: hugo=1002 zola=1003 jekyll=1002 hwaro=1002 eleventy=1002 pelican=1001 hexo=1002 → OK
- blog @ 10p: hugo=24 zola=25 jekyll=22 hwaro=23 eleventy=22 pelican=21 hexo=22 → OK
- blog @ 100p: hugo=123 zola=124 jekyll=121 hwaro=122 eleventy=121 pelican=120 hexo=121 → OK
- blog @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK
- heavy @ 10p: hugo=24 zola=25 jekyll=22 hwaro=23 eleventy=22 pelican=21 hexo=22 → OK
- heavy @ 100p: hugo=123 zola=124 jekyll=121 hwaro=122 eleventy=121 pelican=120 hexo=121 → OK
- heavy @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK

## Scenario feature verification

Confirms the features each scenario promises are present in the emitted
HTML — highlighting, tag pages, feed, pagination, sidebar. An SSG that
silently skips one of these is doing less work than its rivals, which the
output-count parity check cannot detect. Per-SSG reports:
`verify_<ssg>_<scenario>_<pages>.json`.

| SSG | Scenario | Pages | Failed checks |
|-----|----------|-------|---------------|
| hugo | blog | 10 | pagination |
| zola | blog | 10 | pagination |
| jekyll | blog | 10 | pagination |
| hwaro | blog | 10 | pagination |
| eleventy | blog | 10 | pagination |
| pelican | blog | 10 | tag_pages feed pagination |
| hexo | blog | 10 | pagination |
| jekyll | blog | 100 | pagination |
| pelican | blog | 100 | tag_pages feed pagination |
| jekyll | blog | 1000 | pagination |
| pelican | blog | 1000 | tag_pages feed pagination |
| hugo | heavy | 10 | pagination |
| zola | heavy | 10 | pagination |
| jekyll | heavy | 10 | pagination |
| hwaro | heavy | 10 | pagination |
| eleventy | heavy | 10 | pagination |
| pelican | heavy | 10 | tag_pages feed pagination |
| hexo | heavy | 10 | pagination |
| jekyll | heavy | 100 | pagination |
| pelican | heavy | 100 | tag_pages feed pagination |
| jekyll | heavy | 1000 | pagination |
| pelican | heavy | 1000 | tag_pages feed pagination |

**Timings involving these SSGs are not comparable** until the cause is
fixed: they measure a smaller workload.

## Raw Data

See `results.csv` (per-iteration) and `config.json` (run settings).
