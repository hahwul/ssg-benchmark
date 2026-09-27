# SSG Benchmark Results (methodology v2)

**Generated:** Sun Sep 27 00:43:38 UTC 2026
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
| eleventy | 3.1.6 | Debian GNU/Linux 12 (bookworm) | v22.23.3 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.3 |
| hugo | hugo v0.145.0-666444f0a52132f9fec9f71cf25b441cc6a4f355 linux/amd64 BuildDate=2025-02-26T15:41:25Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 0.18.1 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [x86_64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.14 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 39 | 39 | 42 | 14.7 | 12 |
| hugo | 100 | 75 | 69 | 81 | 23.8 | 102 |
| hugo | 1000 | 366 | 364 | 448 | 83.3 | 1002 |
| zola | 10 | 18 | 18 | 19 | 14.7 | 13 |
| zola | 100 | 50 | 49 | 52 | 19.7 | 103 |
| zola | 1000 | 399 | 382 | 400 | 70.7 | 1003 |
| jekyll | 10 | 483 | 483 | 486 | 36.0 | 12 |
| jekyll | 100 | 556 | 554 | 559 | 39.2 | 102 |
| jekyll | 1000 | 1240 | 1212 | 1284 | 62.6 | 1002 |
| hwaro | 10 | 25 | 24 | 27 | 12.8 | 12 |
| hwaro | 100 | 54 | 54 | 55 | 21.5 | 102 |
| hwaro | 1000 | 403 | 398 | 412 | 52.3 | 1002 |
| eleventy | 10 | 435 | 431 | 442 | 58.1 | 12 |
| eleventy | 100 | 541 | 539 | 544 | 67.0 | 102 |
| eleventy | 1000 | 1501 | 1492 | 1512 | 147.2 | 1002 |
| pelican | 10 | 301 | 299 | 304 | 30.4 | 11 |
| pelican | 100 | 511 | 510 | 514 | 31.6 | 101 |
| pelican | 1000 | 2644 | 2632 | 2667 | 39.6 | 1001 |
| hexo | 10 | 394 | 390 | 398 | 41.7 | 12 |
| hexo | 100 | 626 | 624 | 631 | 73.1 | 102 |
| hexo | 1000 | 2422 | 2421 | 2434 | 209.2 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 84 | 74 | 87 | 25.3 | 24 |
| hugo | 100 | 247 | 240 | 255 | 38.8 | 123 |
| hugo | 1000 | 1839 | 1837 | 1876 | 153.1 | 1113 |
| zola | 10 | 321 | 301 | 338 | 133.9 | 25 |
| zola | 100 | 431 | 431 | 433 | 140.4 | 124 |
| zola | 1000 | 1672 | 1666 | 1761 | 211.1 | 1114 |
| jekyll | 10 | 547 | 542 | 549 | 39.4 | 22 |
| jekyll | 100 | 642 | 638 | 645 | 44.3 | 121 |
| jekyll | 1000 | 1503 | 1503 | 1518 | 82.0 | 1111 |
| hwaro | 10 | 37 | 36 | 37 | 18.4 | 23 |
| hwaro | 100 | 97 | 79 | 101 | 29.7 | 122 |
| hwaro | 1000 | 675 | 568 | 709 | 76.9 | 1112 |
| eleventy | 10 | 505 | 488 | 509 | 61.2 | 22 |
| eleventy | 100 | 684 | 684 | 698 | 88.0 | 121 |
| eleventy | 1000 | 2181 | 2167 | 2203 | 170.1 | 1111 |
| pelican | 10 | 428 | 427 | 437 | 32.4 | 21 |
| pelican | 100 | 986 | 986 | 995 | 34.7 | 120 |
| pelican | 1000 | 6508 | 6452 | 6509 | 56.5 | 1110 |
| hexo | 10 | 592 | 589 | 593 | 65.9 | 22 |
| hexo | 100 | 939 | 923 | 950 | 103.5 | 121 |
| hexo | 1000 | 3807 | 3792 | 3879 | 383.1 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 72 | 68 | 72 | 25.6 | 24 |
| hugo | 100 | 255 | 252 | 285 | 38.3 | 123 |
| hugo | 1000 | 2610 | 2603 | 3109 | 170.1 | 1113 |
| zola | 10 | 357 | 326 | 382 | 139.7 | 25 |
| zola | 100 | 1351 | 1347 | 1440 | 193.7 | 124 |
| zola | 1000 | 103240 | 101084 | 103551 | 736.8 | 1114 |
| jekyll | 10 | 559 | 558 | 561 | 39.4 | 22 |
| jekyll | 100 | 689 | 688 | 692 | 44.2 | 121 |
| jekyll | 1000 | 2067 | 2052 | 2076 | 86.6 | 1111 |
| hwaro | 10 | 39 | 39 | 42 | 21.5 | 23 |
| hwaro | 100 | 98 | 94 | 124 | 30.5 | 122 |
| hwaro | 1000 | 2355 | 2324 | 2441 | 100.0 | 1112 |
| eleventy | 10 | 515 | 497 | 521 | 59.4 | 22 |
| eleventy | 100 | 720 | 707 | 727 | 86.3 | 121 |
| eleventy | 1000 | 2974 | 2946 | 2977 | 181.5 | 1111 |
| pelican | 10 | 434 | 431 | 436 | 32.4 | 21 |
| pelican | 100 | 1021 | 1018 | 1033 | 35.1 | 120 |
| pelican | 1000 | 6743 | 6720 | 6839 | 58.4 | 1110 |
| hexo | 10 | 594 | 594 | 596 | 66.6 | 22 |
| hexo | 100 | 985 | 971 | 986 | 105.8 | 121 |
| hexo | 1000 | 5420 | 5407 | 5504 | 391.6 | 1111 |

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
