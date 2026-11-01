# SSG Benchmark Results (methodology v2)

**Generated:** Sun Nov  1 00:35:15 UTC 2026
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
| eleventy | 3.1.6 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| hugo | hugo v0.145.0-666444f0a52132f9fec9f71cf25b441cc6a4f355 linux/amd64 BuildDate=2025-02-26T15:41:25Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 0.18.1 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [x86_64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.16 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 47 | 46 | 49 | 13.2 | 12 |
| hugo | 100 | 80 | 79 | 93 | 19.7 | 102 |
| hugo | 1000 | 402 | 401 | 428 | 79.7 | 1002 |
| zola | 10 | 21 | 21 | 21 | 14.7 | 13 |
| zola | 100 | 53 | 52 | 53 | 19.9 | 103 |
| zola | 1000 | 399 | 390 | 400 | 70.3 | 1003 |
| jekyll | 10 | 491 | 490 | 522 | 36.0 | 12 |
| jekyll | 100 | 564 | 559 | 566 | 39.4 | 102 |
| jekyll | 1000 | 1259 | 1255 | 1272 | 62.9 | 1002 |
| hwaro | 10 | 26 | 26 | 28 | 13.0 | 12 |
| hwaro | 100 | 60 | 58 | 61 | 20.9 | 102 |
| hwaro | 1000 | 428 | 411 | 447 | 50.9 | 1002 |
| eleventy | 10 | 437 | 434 | 440 | 55.6 | 12 |
| eleventy | 100 | 547 | 544 | 554 | 67.6 | 102 |
| eleventy | 1000 | 1546 | 1535 | 1546 | 153.0 | 1002 |
| pelican | 10 | 306 | 302 | 306 | 30.4 | 11 |
| pelican | 100 | 514 | 514 | 517 | 31.4 | 101 |
| pelican | 1000 | 2569 | 2553 | 2587 | 39.8 | 1001 |
| hexo | 10 | 405 | 397 | 410 | 42.1 | 12 |
| hexo | 100 | 630 | 629 | 638 | 69.8 | 102 |
| hexo | 1000 | 2449 | 2447 | 2465 | 219.9 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 81 | 80 | 86 | 22.1 | 24 |
| hugo | 100 | 264 | 255 | 274 | 38.1 | 123 |
| hugo | 1000 | 2002 | 1983 | 2032 | 150.1 | 1113 |
| zola | 10 | 351 | 341 | 351 | 133.9 | 25 |
| zola | 100 | 507 | 505 | 528 | 140.6 | 124 |
| zola | 1000 | 1712 | 1693 | 1860 | 210.7 | 1114 |
| jekyll | 10 | 558 | 549 | 563 | 39.7 | 22 |
| jekyll | 100 | 650 | 648 | 655 | 44.4 | 121 |
| jekyll | 1000 | 1530 | 1529 | 1537 | 81.9 | 1111 |
| hwaro | 10 | 40 | 39 | 42 | 17.4 | 23 |
| hwaro | 100 | 91 | 87 | 104 | 29.1 | 122 |
| hwaro | 1000 | 718 | 713 | 728 | 76.2 | 1112 |
| eleventy | 10 | 518 | 515 | 531 | 59.2 | 22 |
| eleventy | 100 | 700 | 699 | 703 | 85.6 | 121 |
| eleventy | 1000 | 2270 | 2266 | 2281 | 175.8 | 1111 |
| pelican | 10 | 432 | 431 | 445 | 32.4 | 21 |
| pelican | 100 | 989 | 989 | 996 | 35.1 | 120 |
| pelican | 1000 | 6395 | 6387 | 6410 | 56.9 | 1110 |
| hexo | 10 | 598 | 598 | 602 | 66.2 | 22 |
| hexo | 100 | 954 | 952 | 954 | 102.7 | 121 |
| hexo | 1000 | 3877 | 3858 | 3975 | 366.5 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 83 | 81 | 92 | 22.9 | 24 |
| hugo | 100 | 286 | 278 | 288 | 37.9 | 123 |
| hugo | 1000 | 2800 | 2759 | 2830 | 169.8 | 1113 |
| zola | 10 | 345 | 343 | 359 | 139.9 | 25 |
| zola | 100 | 1404 | 1377 | 1415 | 193.7 | 124 |
| zola | 1000 | 106023 | 104437 | 109030 | 736.9 | 1114 |
| jekyll | 10 | 565 | 559 | 570 | 39.6 | 22 |
| jekyll | 100 | 698 | 697 | 699 | 44.4 | 121 |
| jekyll | 1000 | 2092 | 2070 | 2103 | 86.6 | 1111 |
| hwaro | 10 | 44 | 43 | 45 | 19.5 | 23 |
| hwaro | 100 | 108 | 106 | 136 | 30.7 | 122 |
| hwaro | 1000 | 2457 | 2440 | 2457 | 98.8 | 1112 |
| eleventy | 10 | 521 | 519 | 527 | 61.6 | 22 |
| eleventy | 100 | 744 | 734 | 755 | 88.7 | 121 |
| eleventy | 1000 | 3022 | 2998 | 3084 | 185.1 | 1111 |
| pelican | 10 | 443 | 441 | 455 | 32.4 | 21 |
| pelican | 100 | 1035 | 1030 | 1057 | 35.3 | 120 |
| pelican | 1000 | 6717 | 6708 | 6765 | 58.8 | 1110 |
| hexo | 10 | 610 | 610 | 616 | 66.0 | 22 |
| hexo | 100 | 983 | 982 | 1004 | 105.4 | 121 |
| hexo | 1000 | 5499 | 5467 | 5587 | 417.3 | 1111 |

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
