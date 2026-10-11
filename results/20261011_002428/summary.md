# SSG Benchmark Results (methodology v2)

**Generated:** Sun Oct 11 00:45:17 UTC 2026
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
| hugo | 10 | 44 | 43 | 45 | 14.9 | 12 |
| hugo | 100 | 83 | 71 | 89 | 23.2 | 102 |
| hugo | 1000 | 394 | 388 | 423 | 81.3 | 1002 |
| zola | 10 | 21 | 20 | 21 | 14.7 | 13 |
| zola | 100 | 55 | 54 | 57 | 19.5 | 103 |
| zola | 1000 | 405 | 390 | 406 | 72.9 | 1003 |
| jekyll | 10 | 505 | 501 | 508 | 36.2 | 12 |
| jekyll | 100 | 571 | 569 | 573 | 39.3 | 102 |
| jekyll | 1000 | 1270 | 1263 | 1282 | 62.6 | 1002 |
| hwaro | 10 | 27 | 24 | 27 | 13.0 | 12 |
| hwaro | 100 | 57 | 56 | 63 | 21.8 | 102 |
| hwaro | 1000 | 411 | 398 | 414 | 53.5 | 1002 |
| eleventy | 10 | 447 | 440 | 458 | 53.6 | 12 |
| eleventy | 100 | 560 | 557 | 598 | 66.3 | 102 |
| eleventy | 1000 | 1548 | 1533 | 1589 | 152.4 | 1002 |
| pelican | 10 | 324 | 324 | 325 | 30.2 | 11 |
| pelican | 100 | 554 | 542 | 555 | 31.6 | 101 |
| pelican | 1000 | 2837 | 2811 | 2859 | 39.5 | 1001 |
| hexo | 10 | 402 | 401 | 412 | 41.3 | 12 |
| hexo | 100 | 664 | 653 | 683 | 73.3 | 102 |
| hexo | 1000 | 2525 | 2470 | 2555 | 194.2 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 72 | 69 | 74 | 24.5 | 24 |
| hugo | 100 | 255 | 250 | 262 | 40.3 | 123 |
| hugo | 1000 | 1921 | 1911 | 1966 | 151.0 | 1113 |
| zola | 10 | 334 | 331 | 411 | 133.8 | 25 |
| zola | 100 | 469 | 461 | 515 | 140.6 | 124 |
| zola | 1000 | 1741 | 1727 | 1797 | 210.2 | 1114 |
| jekyll | 10 | 577 | 567 | 585 | 39.5 | 22 |
| jekyll | 100 | 672 | 664 | 679 | 44.4 | 121 |
| jekyll | 1000 | 1563 | 1559 | 1571 | 81.8 | 1111 |
| hwaro | 10 | 41 | 40 | 42 | 17.5 | 23 |
| hwaro | 100 | 101 | 81 | 106 | 29.9 | 122 |
| hwaro | 1000 | 702 | 563 | 719 | 76.3 | 1112 |
| eleventy | 10 | 527 | 510 | 528 | 58.8 | 22 |
| eleventy | 100 | 713 | 707 | 714 | 87.6 | 121 |
| eleventy | 1000 | 2277 | 2236 | 2283 | 174.3 | 1111 |
| pelican | 10 | 452 | 449 | 468 | 32.4 | 21 |
| pelican | 100 | 1036 | 1031 | 1056 | 34.6 | 120 |
| pelican | 1000 | 6804 | 6776 | 6867 | 56.4 | 1110 |
| hexo | 10 | 608 | 606 | 610 | 66.3 | 22 |
| hexo | 100 | 962 | 952 | 964 | 103.9 | 121 |
| hexo | 1000 | 3977 | 3946 | 4005 | 384.2 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 78 | 72 | 95 | 25.5 | 24 |
| hugo | 100 | 273 | 269 | 277 | 42.0 | 123 |
| hugo | 1000 | 2713 | 2702 | 3149 | 171.9 | 1113 |
| zola | 10 | 358 | 355 | 427 | 139.9 | 25 |
| zola | 100 | 1417 | 1405 | 1464 | 193.6 | 124 |
| zola | 1000 | 112847 | 111824 | 112978 | 738.7 | 1114 |
| jekyll | 10 | 579 | 579 | 581 | 39.5 | 22 |
| jekyll | 100 | 720 | 716 | 743 | 44.2 | 121 |
| jekyll | 1000 | 2125 | 2114 | 2144 | 86.7 | 1111 |
| hwaro | 10 | 43 | 41 | 46 | 20.3 | 23 |
| hwaro | 100 | 107 | 100 | 130 | 32.5 | 122 |
| hwaro | 1000 | 2466 | 2447 | 2494 | 100.7 | 1112 |
| eleventy | 10 | 540 | 522 | 541 | 58.3 | 22 |
| eleventy | 100 | 748 | 741 | 753 | 87.2 | 121 |
| eleventy | 1000 | 3075 | 3057 | 3093 | 182.9 | 1111 |
| pelican | 10 | 467 | 456 | 468 | 32.4 | 21 |
| pelican | 100 | 1083 | 1078 | 1102 | 34.7 | 120 |
| pelican | 1000 | 7117 | 7059 | 7199 | 58.4 | 1110 |
| hexo | 10 | 620 | 618 | 622 | 66.1 | 22 |
| hexo | 100 | 1020 | 1012 | 1025 | 108.8 | 121 |
| hexo | 1000 | 5692 | 5587 | 5710 | 389.6 | 1111 |

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
