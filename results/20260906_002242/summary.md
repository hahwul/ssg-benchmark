# SSG Benchmark Results (methodology v2)

**Generated:** Sun Sep  6 00:42:35 UTC 2026
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
| hugo | 10 | 40 | 40 | 41 | 15.0 | 12 |
| hugo | 100 | 67 | 65 | 71 | 23.6 | 102 |
| hugo | 1000 | 339 | 334 | 340 | 81.1 | 1002 |
| zola | 10 | 18 | 18 | 18 | 14.9 | 13 |
| zola | 100 | 44 | 44 | 45 | 19.7 | 103 |
| zola | 1000 | 322 | 318 | 324 | 70.3 | 1003 |
| jekyll | 10 | 502 | 500 | 523 | 36.0 | 12 |
| jekyll | 100 | 570 | 565 | 576 | 39.2 | 102 |
| jekyll | 1000 | 1229 | 1193 | 1246 | 62.6 | 1002 |
| hwaro | 10 | 24 | 23 | 33 | 13.7 | 12 |
| hwaro | 100 | 46 | 46 | 46 | 21.4 | 102 |
| hwaro | 1000 | 345 | 341 | 345 | 52.2 | 1002 |
| eleventy | 10 | 439 | 428 | 445 | 53.0 | 12 |
| eleventy | 100 | 551 | 545 | 559 | 66.2 | 102 |
| eleventy | 1000 | 1479 | 1469 | 1497 | 145.2 | 1002 |
| pelican | 10 | 309 | 306 | 310 | 30.4 | 11 |
| pelican | 100 | 517 | 515 | 519 | 31.4 | 101 |
| pelican | 1000 | 2664 | 2627 | 2667 | 39.6 | 1001 |
| hexo | 10 | 405 | 404 | 408 | 41.9 | 12 |
| hexo | 100 | 641 | 639 | 642 | 69.7 | 102 |
| hexo | 1000 | 2468 | 2434 | 2484 | 208.5 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 68 | 67 | 75 | 23.1 | 24 |
| hugo | 100 | 241 | 233 | 253 | 40.1 | 123 |
| hugo | 1000 | 1838 | 1816 | 1922 | 155.3 | 1113 |
| zola | 10 | 310 | 308 | 370 | 133.9 | 25 |
| zola | 100 | 434 | 432 | 478 | 140.4 | 124 |
| zola | 1000 | 1654 | 1625 | 1803 | 210.6 | 1114 |
| jekyll | 10 | 587 | 579 | 593 | 39.5 | 22 |
| jekyll | 100 | 673 | 658 | 686 | 44.2 | 121 |
| jekyll | 1000 | 1530 | 1458 | 1553 | 81.5 | 1111 |
| hwaro | 10 | 37 | 37 | 37 | 18.0 | 23 |
| hwaro | 100 | 93 | 70 | 95 | 30.0 | 122 |
| hwaro | 1000 | 628 | 606 | 630 | 76.2 | 1112 |
| eleventy | 10 | 526 | 516 | 529 | 57.0 | 22 |
| eleventy | 100 | 704 | 697 | 715 | 86.4 | 121 |
| eleventy | 1000 | 2146 | 2099 | 2162 | 171.7 | 1111 |
| pelican | 10 | 438 | 436 | 445 | 32.2 | 21 |
| pelican | 100 | 997 | 996 | 1019 | 34.6 | 120 |
| pelican | 1000 | 6490 | 6338 | 6617 | 56.4 | 1110 |
| hexo | 10 | 618 | 615 | 624 | 65.4 | 22 |
| hexo | 100 | 959 | 958 | 974 | 103.7 | 121 |
| hexo | 1000 | 3954 | 3927 | 3982 | 374.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 74 | 70 | 82 | 25.3 | 24 |
| hugo | 100 | 255 | 251 | 262 | 40.2 | 123 |
| hugo | 1000 | 2571 | 2516 | 2618 | 174.4 | 1113 |
| zola | 10 | 336 | 326 | 340 | 139.9 | 25 |
| zola | 100 | 1358 | 1332 | 1370 | 193.8 | 124 |
| zola | 1000 | 106163 | 105151 | 107465 | 738.0 | 1114 |
| jekyll | 10 | 557 | 557 | 570 | 39.2 | 22 |
| jekyll | 100 | 707 | 706 | 717 | 44.2 | 121 |
| jekyll | 1000 | 2097 | 2054 | 2124 | 86.3 | 1111 |
| hwaro | 10 | 37 | 36 | 40 | 21.2 | 23 |
| hwaro | 100 | 91 | 86 | 91 | 30.7 | 122 |
| hwaro | 1000 | 2384 | 2369 | 2472 | 100.6 | 1112 |
| eleventy | 10 | 513 | 499 | 519 | 62.4 | 22 |
| eleventy | 100 | 720 | 717 | 725 | 86.5 | 121 |
| eleventy | 1000 | 2978 | 2950 | 3137 | 183.6 | 1111 |
| pelican | 10 | 432 | 432 | 434 | 32.3 | 21 |
| pelican | 100 | 1022 | 1022 | 1024 | 35.0 | 120 |
| pelican | 1000 | 6825 | 6751 | 7089 | 58.3 | 1110 |
| hexo | 10 | 606 | 602 | 612 | 68.4 | 22 |
| hexo | 100 | 983 | 974 | 988 | 106.3 | 121 |
| hexo | 1000 | 5569 | 5504 | 5595 | 391.7 | 1111 |

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
