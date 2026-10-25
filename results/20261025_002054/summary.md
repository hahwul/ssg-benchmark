# SSG Benchmark Results (methodology v2)

**Generated:** Sun Oct 25 00:40:19 UTC 2026
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
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.15 |
| zola | zola 0.22.1 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 33 | 32 | 36 | 15.3 | 12 |
| hugo | 100 | 60 | 59 | 61 | 23.6 | 102 |
| hugo | 1000 | 342 | 333 | 349 | 87.3 | 1002 |
| zola | 10 | 18 | 18 | 19 | 14.7 | 13 |
| zola | 100 | 51 | 50 | 51 | 19.7 | 103 |
| zola | 1000 | 388 | 385 | 398 | 70.8 | 1003 |
| jekyll | 10 | 418 | 390 | 453 | 36.0 | 12 |
| jekyll | 100 | 484 | 463 | 495 | 39.2 | 102 |
| jekyll | 1000 | 1142 | 1038 | 1163 | 62.7 | 1002 |
| hwaro | 10 | 21 | 21 | 21 | 13.7 | 12 |
| hwaro | 100 | 51 | 51 | 61 | 21.4 | 102 |
| hwaro | 1000 | 409 | 379 | 493 | 53.8 | 1002 |
| eleventy | 10 | 335 | 333 | 407 | 57.3 | 12 |
| eleventy | 100 | 428 | 427 | 429 | 66.4 | 102 |
| eleventy | 1000 | 1226 | 1217 | 1253 | 154.8 | 1002 |
| pelican | 10 | 268 | 252 | 417 | 30.6 | 11 |
| pelican | 100 | 414 | 407 | 518 | 31.4 | 101 |
| pelican | 1000 | 2206 | 2083 | 2299 | 39.6 | 1001 |
| hexo | 10 | 307 | 306 | 359 | 41.1 | 12 |
| hexo | 100 | 500 | 484 | 634 | 72.8 | 102 |
| hexo | 1000 | 2065 | 1950 | 2070 | 215.6 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 54 | 54 | 56 | 23.6 | 24 |
| hugo | 100 | 201 | 191 | 211 | 39.8 | 123 |
| hugo | 1000 | 1687 | 1635 | 1688 | 157.3 | 1113 |
| zola | 10 | 269 | 264 | 324 | 133.8 | 25 |
| zola | 100 | 406 | 397 | 407 | 141.0 | 124 |
| zola | 1000 | 1494 | 1469 | 1637 | 211.0 | 1114 |
| jekyll | 10 | 488 | 476 | 491 | 39.6 | 22 |
| jekyll | 100 | 552 | 551 | 566 | 44.3 | 121 |
| jekyll | 1000 | 1408 | 1311 | 1493 | 82.0 | 1111 |
| hwaro | 10 | 34 | 33 | 36 | 18.1 | 23 |
| hwaro | 100 | 93 | 90 | 121 | 29.9 | 122 |
| hwaro | 1000 | 660 | 520 | 669 | 76.1 | 1112 |
| eleventy | 10 | 408 | 405 | 413 | 57.1 | 22 |
| eleventy | 100 | 561 | 552 | 583 | 88.9 | 121 |
| eleventy | 1000 | 1871 | 1772 | 1977 | 174.8 | 1111 |
| pelican | 10 | 358 | 354 | 404 | 32.4 | 21 |
| pelican | 100 | 795 | 781 | 845 | 35.0 | 120 |
| pelican | 1000 | 5287 | 5242 | 5404 | 57.0 | 1110 |
| hexo | 10 | 486 | 475 | 489 | 65.6 | 22 |
| hexo | 100 | 770 | 758 | 771 | 103.7 | 121 |
| hexo | 1000 | 3211 | 3161 | 3223 | 384.2 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 59 | 58 | 60 | 25.8 | 24 |
| hugo | 100 | 239 | 218 | 254 | 39.8 | 123 |
| hugo | 1000 | 2127 | 2113 | 2151 | 177.0 | 1113 |
| zola | 10 | 297 | 289 | 299 | 139.8 | 25 |
| zola | 100 | 1267 | 1179 | 1361 | 193.6 | 124 |
| zola | 1000 | 99472 | 99034 | 100346 | 737.7 | 1114 |
| jekyll | 10 | 499 | 495 | 500 | 39.3 | 22 |
| jekyll | 100 | 613 | 573 | 772 | 44.4 | 121 |
| jekyll | 1000 | 1714 | 1702 | 1746 | 86.7 | 1111 |
| hwaro | 10 | 36 | 36 | 38 | 22.3 | 23 |
| hwaro | 100 | 110 | 90 | 112 | 30.8 | 122 |
| hwaro | 1000 | 2078 | 2060 | 2125 | 101.8 | 1112 |
| eleventy | 10 | 406 | 401 | 408 | 61.6 | 22 |
| eleventy | 100 | 572 | 565 | 590 | 87.9 | 121 |
| eleventy | 1000 | 2378 | 2358 | 2448 | 186.8 | 1111 |
| pelican | 10 | 363 | 362 | 373 | 32.5 | 21 |
| pelican | 100 | 814 | 801 | 823 | 35.3 | 120 |
| pelican | 1000 | 5325 | 5301 | 5363 | 58.9 | 1110 |
| hexo | 10 | 486 | 478 | 487 | 66.2 | 22 |
| hexo | 100 | 783 | 767 | 784 | 107.1 | 121 |
| hexo | 1000 | 4220 | 4195 | 4398 | 415.5 | 1111 |

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
