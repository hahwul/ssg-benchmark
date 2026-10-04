# SSG Benchmark Results (methodology v2)

**Generated:** Sun Oct  4 01:22:16 UTC 2026
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
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.15 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 44 | 42 | 45 | 15.1 | 12 |
| hugo | 100 | 76 | 70 | 77 | 23.9 | 102 |
| hugo | 1000 | 370 | 366 | 391 | 81.3 | 1002 |
| zola | 10 | 19 | 19 | 20 | 14.8 | 13 |
| zola | 100 | 51 | 51 | 51 | 19.7 | 103 |
| zola | 1000 | 390 | 375 | 390 | 73.1 | 1003 |
| jekyll | 10 | 488 | 488 | 491 | 36.1 | 12 |
| jekyll | 100 | 563 | 561 | 563 | 39.2 | 102 |
| jekyll | 1000 | 1250 | 1236 | 1254 | 62.7 | 1002 |
| hwaro | 10 | 24 | 24 | 25 | 13.8 | 12 |
| hwaro | 100 | 54 | 54 | 55 | 21.3 | 102 |
| hwaro | 1000 | 425 | 402 | 430 | 52.1 | 1002 |
| eleventy | 10 | 439 | 429 | 439 | 57.3 | 12 |
| eleventy | 100 | 554 | 542 | 555 | 66.8 | 102 |
| eleventy | 1000 | 1505 | 1505 | 1525 | 146.7 | 1002 |
| pelican | 10 | 308 | 307 | 310 | 30.4 | 11 |
| pelican | 100 | 530 | 528 | 531 | 31.4 | 101 |
| pelican | 1000 | 2761 | 2738 | 2793 | 39.6 | 1001 |
| hexo | 10 | 395 | 389 | 399 | 41.3 | 12 |
| hexo | 100 | 631 | 630 | 644 | 70.0 | 102 |
| hexo | 1000 | 2452 | 2430 | 2493 | 213.0 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 73 | 72 | 75 | 24.0 | 24 |
| hugo | 100 | 238 | 237 | 243 | 39.3 | 123 |
| hugo | 1000 | 1871 | 1866 | 1872 | 155.2 | 1113 |
| zola | 10 | 394 | 325 | 397 | 134.0 | 25 |
| zola | 100 | 457 | 439 | 520 | 140.7 | 124 |
| zola | 1000 | 1737 | 1674 | 2131 | 213.6 | 1114 |
| jekyll | 10 | 561 | 550 | 563 | 39.5 | 22 |
| jekyll | 100 | 652 | 647 | 660 | 44.5 | 121 |
| jekyll | 1000 | 1512 | 1497 | 1529 | 82.0 | 1111 |
| hwaro | 10 | 38 | 36 | 40 | 17.5 | 23 |
| hwaro | 100 | 99 | 99 | 100 | 29.8 | 122 |
| hwaro | 1000 | 574 | 538 | 690 | 77.5 | 1112 |
| eleventy | 10 | 512 | 510 | 519 | 59.8 | 22 |
| eleventy | 100 | 700 | 692 | 702 | 91.3 | 121 |
| eleventy | 1000 | 2186 | 2180 | 2212 | 174.0 | 1111 |
| pelican | 10 | 439 | 437 | 439 | 32.3 | 21 |
| pelican | 100 | 1022 | 1018 | 1027 | 34.6 | 120 |
| pelican | 1000 | 6645 | 6577 | 6705 | 56.5 | 1110 |
| hexo | 10 | 600 | 598 | 603 | 65.3 | 22 |
| hexo | 100 | 948 | 934 | 950 | 104.3 | 121 |
| hexo | 1000 | 3844 | 3815 | 3879 | 383.7 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 74 | 74 | 99 | 25.3 | 24 |
| hugo | 100 | 267 | 262 | 275 | 40.0 | 123 |
| hugo | 1000 | 2684 | 2658 | 2804 | 172.0 | 1113 |
| zola | 10 | 351 | 341 | 354 | 139.7 | 25 |
| zola | 100 | 1436 | 1389 | 1484 | 193.7 | 124 |
| zola | 1000 | 107591 | 106691 | 108293 | 736.5 | 1114 |
| jekyll | 10 | 571 | 571 | 606 | 39.4 | 22 |
| jekyll | 100 | 707 | 704 | 719 | 44.0 | 121 |
| jekyll | 1000 | 2102 | 2092 | 2119 | 86.7 | 1111 |
| hwaro | 10 | 39 | 39 | 40 | 22.2 | 23 |
| hwaro | 100 | 102 | 99 | 109 | 30.8 | 122 |
| hwaro | 1000 | 2400 | 2373 | 2490 | 100.5 | 1112 |
| eleventy | 10 | 526 | 519 | 534 | 57.9 | 22 |
| eleventy | 100 | 742 | 725 | 745 | 87.2 | 121 |
| eleventy | 1000 | 2993 | 2991 | 3008 | 183.5 | 1111 |
| pelican | 10 | 456 | 450 | 459 | 32.4 | 21 |
| pelican | 100 | 1064 | 1056 | 1073 | 34.7 | 120 |
| pelican | 1000 | 7032 | 6949 | 7061 | 58.3 | 1110 |
| hexo | 10 | 607 | 605 | 616 | 66.8 | 22 |
| hexo | 100 | 980 | 980 | 993 | 106.5 | 121 |
| hexo | 1000 | 5562 | 5511 | 5568 | 392.4 | 1111 |

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
