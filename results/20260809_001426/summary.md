# SSG Benchmark Results (methodology v2)

**Generated:** Sun Aug  9 00:34:17 UTC 2026
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
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.13 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 44 | 42 | 46 | 15.1 | 12 |
| hugo | 100 | 74 | 73 | 76 | 23.8 | 102 |
| hugo | 1000 | 317 | 315 | 335 | 81.9 | 1002 |
| zola | 10 | 19 | 18 | 19 | 14.7 | 13 |
| zola | 100 | 44 | 44 | 48 | 19.7 | 103 |
| zola | 1000 | 322 | 318 | 322 | 70.3 | 1003 |
| jekyll | 10 | 494 | 493 | 511 | 35.9 | 12 |
| jekyll | 100 | 565 | 558 | 570 | 39.2 | 102 |
| jekyll | 1000 | 1209 | 1179 | 1211 | 62.7 | 1002 |
| hwaro | 10 | 23 | 22 | 25 | 13.7 | 12 |
| hwaro | 100 | 50 | 47 | 51 | 22.0 | 102 |
| hwaro | 1000 | 389 | 340 | 434 | 52.5 | 1002 |
| eleventy | 10 | 433 | 428 | 434 | 53.7 | 12 |
| eleventy | 100 | 543 | 534 | 551 | 68.9 | 102 |
| eleventy | 1000 | 1442 | 1431 | 1456 | 145.2 | 1002 |
| pelican | 10 | 333 | 332 | 333 | 31.9 | 11 |
| pelican | 100 | 539 | 533 | 559 | 33.1 | 101 |
| pelican | 1000 | 2635 | 2626 | 2653 | 41.6 | 1001 |
| hexo | 10 | 394 | 394 | 400 | 41.3 | 12 |
| hexo | 100 | 631 | 624 | 639 | 69.7 | 102 |
| hexo | 1000 | 2412 | 2398 | 2440 | 213.8 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 70 | 67 | 77 | 23.5 | 24 |
| hugo | 100 | 227 | 223 | 229 | 39.9 | 123 |
| hugo | 1000 | 1823 | 1802 | 1859 | 157.5 | 1113 |
| zola | 10 | 326 | 313 | 364 | 133.9 | 25 |
| zola | 100 | 455 | 437 | 482 | 140.4 | 124 |
| zola | 1000 | 1638 | 1616 | 1913 | 211.9 | 1114 |
| jekyll | 10 | 558 | 554 | 560 | 39.4 | 22 |
| jekyll | 100 | 639 | 638 | 678 | 44.5 | 121 |
| jekyll | 1000 | 1453 | 1445 | 1466 | 81.9 | 1111 |
| hwaro | 10 | 36 | 34 | 39 | 17.2 | 23 |
| hwaro | 100 | 73 | 71 | 95 | 29.7 | 122 |
| hwaro | 1000 | 668 | 622 | 688 | 76.2 | 1112 |
| eleventy | 10 | 505 | 503 | 509 | 57.6 | 22 |
| eleventy | 100 | 689 | 684 | 689 | 87.4 | 121 |
| eleventy | 1000 | 2107 | 2102 | 2127 | 172.5 | 1111 |
| pelican | 10 | 452 | 451 | 456 | 33.9 | 21 |
| pelican | 100 | 1017 | 1010 | 1022 | 36.4 | 120 |
| pelican | 1000 | 6400 | 6329 | 6534 | 58.2 | 1110 |
| hexo | 10 | 596 | 595 | 600 | 65.4 | 22 |
| hexo | 100 | 939 | 928 | 947 | 104.7 | 121 |
| hexo | 1000 | 3834 | 3794 | 3857 | 385.1 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 75 | 71 | 77 | 26.0 | 24 |
| hugo | 100 | 253 | 249 | 267 | 40.2 | 123 |
| hugo | 1000 | 2517 | 2508 | 2518 | 170.8 | 1113 |
| zola | 10 | 384 | 359 | 407 | 139.9 | 25 |
| zola | 100 | 1432 | 1390 | 1485 | 193.7 | 124 |
| zola | 1000 | 105845 | 105620 | 106289 | 737.2 | 1114 |
| jekyll | 10 | 567 | 560 | 577 | 39.2 | 22 |
| jekyll | 100 | 689 | 688 | 716 | 44.2 | 121 |
| jekyll | 1000 | 2019 | 1990 | 2066 | 86.9 | 1111 |
| hwaro | 10 | 39 | 38 | 40 | 22.4 | 23 |
| hwaro | 100 | 107 | 98 | 123 | 30.7 | 122 |
| hwaro | 1000 | 2379 | 2374 | 2384 | 99.7 | 1112 |
| eleventy | 10 | 512 | 505 | 514 | 58.7 | 22 |
| eleventy | 100 | 698 | 694 | 714 | 87.2 | 121 |
| eleventy | 1000 | 2914 | 2906 | 2954 | 183.0 | 1111 |
| pelican | 10 | 467 | 467 | 467 | 34.1 | 21 |
| pelican | 100 | 1051 | 1036 | 1054 | 36.7 | 120 |
| pelican | 1000 | 6714 | 6670 | 6718 | 60.1 | 1110 |
| hexo | 10 | 599 | 598 | 602 | 65.6 | 22 |
| hexo | 100 | 989 | 970 | 990 | 106.3 | 121 |
| hexo | 1000 | 5424 | 5416 | 5447 | 382.4 | 1111 |

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
