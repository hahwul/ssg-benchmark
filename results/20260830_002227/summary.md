# SSG Benchmark Results (methodology v2)

**Generated:** Sun Aug 30 00:43:20 UTC 2026
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
| hugo | 10 | 41 | 40 | 42 | 14.7 | 12 |
| hugo | 100 | 74 | 71 | 79 | 23.8 | 102 |
| hugo | 1000 | 341 | 338 | 344 | 89.6 | 1002 |
| zola | 10 | 19 | 18 | 19 | 14.6 | 13 |
| zola | 100 | 45 | 44 | 45 | 19.7 | 103 |
| zola | 1000 | 328 | 324 | 358 | 71.8 | 1003 |
| jekyll | 10 | 515 | 507 | 519 | 35.9 | 12 |
| jekyll | 100 | 559 | 558 | 565 | 39.1 | 102 |
| jekyll | 1000 | 1260 | 1241 | 1284 | 62.9 | 1002 |
| hwaro | 10 | 29 | 25 | 29 | 13.0 | 12 |
| hwaro | 100 | 47 | 47 | 49 | 21.7 | 102 |
| hwaro | 1000 | 331 | 328 | 338 | 52.6 | 1002 |
| eleventy | 10 | 452 | 434 | 452 | 55.6 | 12 |
| eleventy | 100 | 548 | 547 | 548 | 70.3 | 102 |
| eleventy | 1000 | 1504 | 1502 | 1507 | 145.7 | 1002 |
| pelican | 10 | 340 | 336 | 342 | 32.0 | 11 |
| pelican | 100 | 555 | 554 | 555 | 33.0 | 101 |
| pelican | 1000 | 2771 | 2741 | 2813 | 41.2 | 1001 |
| hexo | 10 | 409 | 408 | 412 | 41.3 | 12 |
| hexo | 100 | 640 | 635 | 642 | 69.9 | 102 |
| hexo | 1000 | 2486 | 2472 | 2512 | 194.3 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 68 | 66 | 68 | 25.3 | 24 |
| hugo | 100 | 235 | 234 | 239 | 39.4 | 123 |
| hugo | 1000 | 1931 | 1870 | 1945 | 156.9 | 1113 |
| zola | 10 | 324 | 312 | 325 | 134.1 | 25 |
| zola | 100 | 435 | 428 | 498 | 140.6 | 124 |
| zola | 1000 | 1763 | 1667 | 1810 | 213.1 | 1114 |
| jekyll | 10 | 567 | 567 | 578 | 39.1 | 22 |
| jekyll | 100 | 668 | 656 | 679 | 44.3 | 121 |
| jekyll | 1000 | 1559 | 1495 | 1582 | 81.6 | 1111 |
| hwaro | 10 | 36 | 35 | 38 | 18.1 | 23 |
| hwaro | 100 | 75 | 72 | 95 | 29.9 | 122 |
| hwaro | 1000 | 649 | 474 | 656 | 76.6 | 1112 |
| eleventy | 10 | 511 | 508 | 518 | 57.6 | 22 |
| eleventy | 100 | 695 | 690 | 711 | 85.4 | 121 |
| eleventy | 1000 | 2234 | 2202 | 2311 | 176.2 | 1111 |
| pelican | 10 | 481 | 458 | 482 | 34.0 | 21 |
| pelican | 100 | 1041 | 1033 | 1056 | 36.3 | 120 |
| pelican | 1000 | 6947 | 6530 | 6973 | 58.3 | 1110 |
| hexo | 10 | 605 | 605 | 605 | 66.1 | 22 |
| hexo | 100 | 974 | 960 | 977 | 105.6 | 121 |
| hexo | 1000 | 4012 | 3994 | 4069 | 385.4 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 75 | 73 | 87 | 24.0 | 24 |
| hugo | 100 | 271 | 260 | 273 | 40.4 | 123 |
| hugo | 1000 | 2671 | 2636 | 2723 | 169.8 | 1113 |
| zola | 10 | 354 | 348 | 367 | 139.9 | 25 |
| zola | 100 | 1468 | 1467 | 1475 | 193.7 | 124 |
| zola | 1000 | 112746 | 110851 | 115271 | 736.9 | 1114 |
| jekyll | 10 | 618 | 616 | 624 | 39.1 | 22 |
| jekyll | 100 | 749 | 709 | 756 | 44.3 | 121 |
| jekyll | 1000 | 2095 | 2092 | 2098 | 86.6 | 1111 |
| hwaro | 10 | 40 | 39 | 40 | 21.5 | 23 |
| hwaro | 100 | 118 | 111 | 123 | 30.9 | 122 |
| hwaro | 1000 | 2461 | 2456 | 2523 | 101.2 | 1112 |
| eleventy | 10 | 531 | 529 | 546 | 60.8 | 22 |
| eleventy | 100 | 755 | 751 | 761 | 90.6 | 121 |
| eleventy | 1000 | 2989 | 2961 | 2990 | 183.7 | 1111 |
| pelican | 10 | 493 | 491 | 510 | 33.8 | 21 |
| pelican | 100 | 1117 | 1111 | 1117 | 36.6 | 120 |
| pelican | 1000 | 6916 | 6834 | 6989 | 60.0 | 1110 |
| hexo | 10 | 644 | 632 | 657 | 66.3 | 22 |
| hexo | 100 | 1023 | 1020 | 1040 | 106.8 | 121 |
| hexo | 1000 | 5602 | 5600 | 5624 | 406.7 | 1111 |

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
