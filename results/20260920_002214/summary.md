# SSG Benchmark Results (methodology v2)

**Generated:** Sun Sep 20 00:37:05 UTC 2026
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
| hugo | 10 | 28 | 26 | 31 | 14.6 | 12 |
| hugo | 100 | 44 | 44 | 45 | 24.0 | 102 |
| hugo | 1000 | 213 | 212 | 252 | 83.7 | 1002 |
| zola | 10 | 14 | 14 | 14 | 14.7 | 13 |
| zola | 100 | 32 | 31 | 33 | 19.7 | 103 |
| zola | 1000 | 241 | 239 | 262 | 71.0 | 1003 |
| jekyll | 10 | 351 | 349 | 361 | 36.2 | 12 |
| jekyll | 100 | 354 | 347 | 355 | 39.2 | 102 |
| jekyll | 1000 | 763 | 743 | 768 | 62.8 | 1002 |
| hwaro | 10 | 18 | 17 | 19 | 13.8 | 12 |
| hwaro | 100 | 33 | 33 | 38 | 21.8 | 102 |
| hwaro | 1000 | 214 | 207 | 233 | 52.5 | 1002 |
| eleventy | 10 | 276 | 275 | 279 | 53.9 | 12 |
| eleventy | 100 | 333 | 329 | 343 | 67.4 | 102 |
| eleventy | 1000 | 833 | 824 | 846 | 149.1 | 1002 |
| pelican | 10 | 224 | 212 | 234 | 30.2 | 11 |
| pelican | 100 | 315 | 311 | 334 | 31.6 | 101 |
| pelican | 1000 | 1582 | 1454 | 1630 | 39.6 | 1001 |
| hexo | 10 | 252 | 242 | 256 | 41.3 | 12 |
| hexo | 100 | 369 | 360 | 372 | 73.1 | 102 |
| hexo | 1000 | 1444 | 1389 | 1467 | 199.3 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 52 | 50 | 58 | 23.6 | 24 |
| hugo | 100 | 145 | 137 | 150 | 41.8 | 123 |
| hugo | 1000 | 1108 | 1080 | 1138 | 164.8 | 1113 |
| zola | 10 | 210 | 205 | 236 | 133.9 | 25 |
| zola | 100 | 285 | 271 | 308 | 140.5 | 124 |
| zola | 1000 | 991 | 991 | 1011 | 212.2 | 1114 |
| jekyll | 10 | 403 | 383 | 404 | 39.2 | 22 |
| jekyll | 100 | 420 | 381 | 461 | 44.2 | 121 |
| jekyll | 1000 | 839 | 832 | 840 | 81.8 | 1111 |
| hwaro | 10 | 28 | 26 | 29 | 18.2 | 23 |
| hwaro | 100 | 66 | 59 | 66 | 30.0 | 122 |
| hwaro | 1000 | 342 | 286 | 403 | 78.2 | 1112 |
| eleventy | 10 | 335 | 304 | 336 | 60.8 | 22 |
| eleventy | 100 | 433 | 384 | 461 | 85.9 | 121 |
| eleventy | 1000 | 1217 | 1138 | 1231 | 177.3 | 1111 |
| pelican | 10 | 281 | 272 | 306 | 32.2 | 21 |
| pelican | 100 | 593 | 570 | 656 | 34.5 | 120 |
| pelican | 1000 | 3502 | 3458 | 3514 | 56.4 | 1110 |
| hexo | 10 | 365 | 346 | 367 | 66.1 | 22 |
| hexo | 100 | 548 | 522 | 550 | 105.0 | 121 |
| hexo | 1000 | 2022 | 1976 | 2065 | 383.8 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 46 | 44 | 50 | 25.8 | 24 |
| hugo | 100 | 156 | 156 | 177 | 42.2 | 123 |
| hugo | 1000 | 1529 | 1491 | 1550 | 181.1 | 1113 |
| zola | 10 | 245 | 234 | 257 | 139.8 | 25 |
| zola | 100 | 1002 | 966 | 1014 | 193.7 | 124 |
| zola | 1000 | 85956 | 85908 | 86012 | 736.7 | 1114 |
| jekyll | 10 | 364 | 346 | 379 | 39.2 | 22 |
| jekyll | 100 | 434 | 422 | 441 | 44.2 | 121 |
| jekyll | 1000 | 1213 | 1132 | 1215 | 86.5 | 1111 |
| hwaro | 10 | 27 | 25 | 51 | 21.4 | 23 |
| hwaro | 100 | 74 | 60 | 79 | 30.4 | 122 |
| hwaro | 1000 | 1572 | 1444 | 1683 | 100.5 | 1112 |
| eleventy | 10 | 302 | 290 | 306 | 62.0 | 22 |
| eleventy | 100 | 415 | 402 | 427 | 88.1 | 121 |
| eleventy | 1000 | 1548 | 1507 | 1617 | 186.3 | 1111 |
| pelican | 10 | 263 | 262 | 266 | 32.4 | 21 |
| pelican | 100 | 578 | 576 | 601 | 35.1 | 120 |
| pelican | 1000 | 3629 | 3613 | 3707 | 58.3 | 1110 |
| hexo | 10 | 339 | 338 | 342 | 66.3 | 22 |
| hexo | 100 | 545 | 526 | 560 | 106.1 | 121 |
| hexo | 1000 | 2840 | 2830 | 2886 | 415.5 | 1111 |

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
