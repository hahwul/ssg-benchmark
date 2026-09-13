# SSG Benchmark Results (methodology v2)

**Generated:** Sun Sep 13 00:42:12 UTC 2026
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
| hugo | 10 | 45 | 43 | 46 | 15.4 | 12 |
| hugo | 100 | 68 | 67 | 74 | 23.3 | 102 |
| hugo | 1000 | 329 | 328 | 339 | 81.5 | 1002 |
| zola | 10 | 19 | 18 | 20 | 14.5 | 13 |
| zola | 100 | 45 | 44 | 47 | 19.7 | 103 |
| zola | 1000 | 322 | 320 | 325 | 70.5 | 1003 |
| jekyll | 10 | 522 | 515 | 543 | 36.1 | 12 |
| jekyll | 100 | 580 | 577 | 590 | 39.6 | 102 |
| jekyll | 1000 | 1214 | 1203 | 1230 | 62.6 | 1002 |
| hwaro | 10 | 25 | 25 | 26 | 13.2 | 12 |
| hwaro | 100 | 48 | 47 | 50 | 21.5 | 102 |
| hwaro | 1000 | 396 | 381 | 428 | 52.7 | 1002 |
| eleventy | 10 | 443 | 436 | 446 | 59.4 | 12 |
| eleventy | 100 | 549 | 542 | 551 | 66.2 | 102 |
| eleventy | 1000 | 1495 | 1484 | 1511 | 146.5 | 1002 |
| pelican | 10 | 322 | 316 | 327 | 30.5 | 11 |
| pelican | 100 | 537 | 536 | 546 | 31.3 | 101 |
| pelican | 1000 | 2724 | 2719 | 2776 | 39.8 | 1001 |
| hexo | 10 | 407 | 405 | 409 | 41.6 | 12 |
| hexo | 100 | 654 | 650 | 666 | 72.5 | 102 |
| hexo | 1000 | 2462 | 2428 | 2497 | 212.3 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 73 | 69 | 77 | 23.6 | 24 |
| hugo | 100 | 240 | 231 | 242 | 39.7 | 123 |
| hugo | 1000 | 1839 | 1817 | 2065 | 157.1 | 1113 |
| zola | 10 | 307 | 304 | 328 | 133.8 | 25 |
| zola | 100 | 428 | 424 | 428 | 140.4 | 124 |
| zola | 1000 | 1641 | 1635 | 1709 | 211.4 | 1114 |
| jekyll | 10 | 585 | 583 | 586 | 39.3 | 22 |
| jekyll | 100 | 671 | 668 | 677 | 44.2 | 121 |
| jekyll | 1000 | 1522 | 1503 | 1552 | 81.6 | 1111 |
| hwaro | 10 | 38 | 36 | 39 | 16.8 | 23 |
| hwaro | 100 | 71 | 71 | 77 | 29.8 | 122 |
| hwaro | 1000 | 629 | 507 | 653 | 79.3 | 1112 |
| eleventy | 10 | 520 | 520 | 521 | 56.9 | 22 |
| eleventy | 100 | 714 | 706 | 715 | 85.5 | 121 |
| eleventy | 1000 | 2192 | 2152 | 2193 | 174.7 | 1111 |
| pelican | 10 | 441 | 435 | 449 | 32.1 | 21 |
| pelican | 100 | 1014 | 1009 | 1027 | 34.6 | 120 |
| pelican | 1000 | 6624 | 6579 | 6677 | 56.3 | 1110 |
| hexo | 10 | 613 | 604 | 613 | 65.6 | 22 |
| hexo | 100 | 962 | 947 | 967 | 106.4 | 121 |
| hexo | 1000 | 3912 | 3898 | 3939 | 370.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 82 | 72 | 93 | 23.9 | 24 |
| hugo | 100 | 265 | 261 | 275 | 42.4 | 123 |
| hugo | 1000 | 2590 | 2575 | 2596 | 168.3 | 1113 |
| zola | 10 | 363 | 347 | 410 | 139.9 | 25 |
| zola | 100 | 1440 | 1393 | 1476 | 193.8 | 124 |
| zola | 1000 | 105784 | 104630 | 106445 | 737.0 | 1114 |
| jekyll | 10 | 600 | 572 | 602 | 39.3 | 22 |
| jekyll | 100 | 719 | 712 | 730 | 44.1 | 121 |
| jekyll | 1000 | 2087 | 2047 | 2093 | 86.4 | 1111 |
| hwaro | 10 | 39 | 36 | 40 | 21.3 | 23 |
| hwaro | 100 | 94 | 94 | 100 | 31.5 | 122 |
| hwaro | 1000 | 2373 | 2357 | 2393 | 98.8 | 1112 |
| eleventy | 10 | 526 | 513 | 530 | 58.8 | 22 |
| eleventy | 100 | 729 | 725 | 756 | 88.9 | 121 |
| eleventy | 1000 | 2967 | 2926 | 2985 | 182.0 | 1111 |
| pelican | 10 | 450 | 448 | 462 | 32.4 | 21 |
| pelican | 100 | 1065 | 1044 | 1083 | 34.9 | 120 |
| pelican | 1000 | 6982 | 6893 | 7014 | 58.3 | 1110 |
| hexo | 10 | 615 | 614 | 616 | 66.2 | 22 |
| hexo | 100 | 1009 | 997 | 1011 | 107.5 | 121 |
| hexo | 1000 | 5508 | 5501 | 5566 | 360.8 | 1111 |

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
