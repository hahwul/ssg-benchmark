# SSG Benchmark Results (methodology v2)

**Generated:** Sun Aug 16 00:26:46 UTC 2026
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
| hugo | 10 | 30 | 29 | 31 | 15.4 | 12 |
| hugo | 100 | 49 | 48 | 55 | 23.7 | 102 |
| hugo | 1000 | 283 | 244 | 363 | 81.5 | 1002 |
| zola | 10 | 13 | 12 | 13 | 14.9 | 13 |
| zola | 100 | 28 | 27 | 28 | 19.6 | 103 |
| zola | 1000 | 179 | 179 | 181 | 70.5 | 1003 |
| jekyll | 10 | 286 | 284 | 286 | 35.9 | 12 |
| jekyll | 100 | 315 | 312 | 316 | 39.4 | 102 |
| jekyll | 1000 | 753 | 646 | 789 | 62.9 | 1002 |
| hwaro | 10 | 20 | 18 | 20 | 13.9 | 12 |
| hwaro | 100 | 33 | 31 | 34 | 23.6 | 102 |
| hwaro | 1000 | 194 | 160 | 197 | 52.4 | 1002 |
| eleventy | 10 | 257 | 257 | 258 | 53.9 | 12 |
| eleventy | 100 | 316 | 314 | 327 | 71.3 | 102 |
| eleventy | 1000 | 905 | 805 | 914 | 150.7 | 1002 |
| pelican | 10 | 224 | 220 | 282 | 32.1 | 11 |
| pelican | 100 | 356 | 337 | 611 | 33.1 | 101 |
| pelican | 1000 | 1695 | 1545 | 2008 | 41.5 | 1001 |
| hexo | 10 | 235 | 233 | 240 | 41.3 | 12 |
| hexo | 100 | 373 | 365 | 379 | 71.9 | 102 |
| hexo | 1000 | 1555 | 1395 | 1818 | 211.1 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 54 | 53 | 56 | 23.7 | 24 |
| hugo | 100 | 175 | 171 | 289 | 41.3 | 123 |
| hugo | 1000 | 1248 | 1221 | 1378 | 157.4 | 1113 |
| zola | 10 | 225 | 223 | 237 | 133.8 | 25 |
| zola | 100 | 313 | 311 | 324 | 140.6 | 124 |
| zola | 1000 | 1202 | 1185 | 1315 | 211.0 | 1114 |
| jekyll | 10 | 323 | 321 | 323 | 39.7 | 22 |
| jekyll | 100 | 370 | 367 | 400 | 44.4 | 121 |
| jekyll | 1000 | 807 | 754 | 1095 | 81.8 | 1111 |
| hwaro | 10 | 26 | 26 | 27 | 18.1 | 23 |
| hwaro | 100 | 49 | 46 | 49 | 30.0 | 122 |
| hwaro | 1000 | 348 | 318 | 362 | 76.8 | 1112 |
| eleventy | 10 | 302 | 300 | 308 | 61.1 | 22 |
| eleventy | 100 | 440 | 429 | 492 | 86.4 | 121 |
| eleventy | 1000 | 1345 | 1324 | 1450 | 174.7 | 1111 |
| pelican | 10 | 340 | 294 | 537 | 33.8 | 21 |
| pelican | 100 | 630 | 626 | 631 | 36.3 | 120 |
| pelican | 1000 | 4041 | 3888 | 4314 | 58.2 | 1110 |
| hexo | 10 | 361 | 357 | 363 | 65.6 | 22 |
| hexo | 100 | 570 | 565 | 572 | 104.3 | 121 |
| hexo | 1000 | 2465 | 2422 | 2709 | 384.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 56 | 53 | 61 | 26.4 | 24 |
| hugo | 100 | 178 | 178 | 204 | 40.1 | 123 |
| hugo | 1000 | 1853 | 1824 | 2043 | 173.3 | 1113 |
| zola | 10 | 268 | 247 | 284 | 140.1 | 25 |
| zola | 100 | 1024 | 1018 | 1053 | 193.7 | 124 |
| zola | 1000 | 96938 | 95975 | 97498 | 738.8 | 1114 |
| jekyll | 10 | 328 | 327 | 329 | 39.4 | 22 |
| jekyll | 100 | 391 | 390 | 431 | 44.3 | 121 |
| jekyll | 1000 | 1377 | 1065 | 1406 | 86.3 | 1111 |
| hwaro | 10 | 32 | 30 | 34 | 21.5 | 23 |
| hwaro | 100 | 73 | 72 | 87 | 30.8 | 122 |
| hwaro | 1000 | 2396 | 1642 | 2620 | 103.4 | 1112 |
| eleventy | 10 | 316 | 301 | 331 | 61.3 | 22 |
| eleventy | 100 | 442 | 440 | 445 | 86.9 | 121 |
| eleventy | 1000 | 1830 | 1760 | 2120 | 182.9 | 1111 |
| pelican | 10 | 327 | 311 | 351 | 34.1 | 21 |
| pelican | 100 | 747 | 649 | 794 | 36.7 | 120 |
| pelican | 1000 | 4138 | 4128 | 4171 | 60.3 | 1110 |
| hexo | 10 | 362 | 360 | 393 | 66.8 | 22 |
| hexo | 100 | 587 | 585 | 669 | 108.4 | 121 |
| hexo | 1000 | 3589 | 3546 | 3637 | 415.3 | 1111 |

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
