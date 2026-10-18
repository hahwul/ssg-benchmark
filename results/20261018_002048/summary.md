# SSG Benchmark Results (methodology v2)

**Generated:** Sun Oct 18 00:36:02 UTC 2026
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
| hugo | 10 | 31 | 27 | 34 | 15.3 | 12 |
| hugo | 100 | 53 | 49 | 54 | 23.5 | 102 |
| hugo | 1000 | 266 | 266 | 292 | 81.4 | 1002 |
| zola | 10 | 16 | 16 | 17 | 14.7 | 13 |
| zola | 100 | 44 | 44 | 49 | 19.7 | 103 |
| zola | 1000 | 358 | 343 | 369 | 71.0 | 1003 |
| jekyll | 10 | 336 | 336 | 337 | 36.0 | 12 |
| jekyll | 100 | 378 | 367 | 382 | 39.3 | 102 |
| jekyll | 1000 | 841 | 800 | 845 | 62.5 | 1002 |
| hwaro | 10 | 19 | 19 | 20 | 13.1 | 12 |
| hwaro | 100 | 45 | 43 | 50 | 21.5 | 102 |
| hwaro | 1000 | 331 | 297 | 345 | 52.5 | 1002 |
| eleventy | 10 | 265 | 252 | 282 | 54.6 | 12 |
| eleventy | 100 | 340 | 338 | 343 | 66.9 | 102 |
| eleventy | 1000 | 946 | 919 | 965 | 152.9 | 1002 |
| pelican | 10 | 212 | 208 | 222 | 30.6 | 11 |
| pelican | 100 | 339 | 332 | 349 | 31.7 | 101 |
| pelican | 1000 | 1551 | 1550 | 1627 | 39.7 | 1001 |
| hexo | 10 | 235 | 233 | 239 | 42.1 | 12 |
| hexo | 100 | 376 | 367 | 379 | 72.8 | 102 |
| hexo | 1000 | 1359 | 1294 | 1376 | 193.8 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 44 | 44 | 46 | 25.5 | 24 |
| hugo | 100 | 170 | 158 | 178 | 40.5 | 123 |
| hugo | 1000 | 1275 | 1273 | 1383 | 163.8 | 1113 |
| zola | 10 | 229 | 210 | 234 | 135.2 | 25 |
| zola | 100 | 303 | 301 | 353 | 140.5 | 124 |
| zola | 1000 | 1167 | 1158 | 1170 | 210.7 | 1114 |
| jekyll | 10 | 383 | 345 | 388 | 39.5 | 22 |
| jekyll | 100 | 413 | 412 | 422 | 44.5 | 121 |
| jekyll | 1000 | 947 | 937 | 961 | 81.8 | 1111 |
| hwaro | 10 | 27 | 27 | 31 | 18.3 | 23 |
| hwaro | 100 | 62 | 61 | 73 | 30.0 | 122 |
| hwaro | 1000 | 531 | 419 | 564 | 77.5 | 1112 |
| eleventy | 10 | 308 | 306 | 313 | 57.2 | 22 |
| eleventy | 100 | 419 | 416 | 427 | 85.8 | 121 |
| eleventy | 1000 | 1346 | 1304 | 1359 | 173.1 | 1111 |
| pelican | 10 | 289 | 271 | 290 | 32.6 | 21 |
| pelican | 100 | 604 | 602 | 604 | 35.2 | 120 |
| pelican | 1000 | 3841 | 3774 | 3934 | 57.2 | 1110 |
| hexo | 10 | 348 | 335 | 361 | 65.6 | 22 |
| hexo | 100 | 539 | 534 | 543 | 103.8 | 121 |
| hexo | 1000 | 2076 | 2074 | 2098 | 363.0 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 49 | 47 | 50 | 25.8 | 24 |
| hugo | 100 | 162 | 161 | 171 | 40.1 | 123 |
| hugo | 1000 | 1649 | 1635 | 1669 | 182.6 | 1113 |
| zola | 10 | 238 | 235 | 265 | 139.8 | 25 |
| zola | 100 | 1011 | 988 | 1034 | 193.8 | 124 |
| zola | 1000 | 90611 | 90050 | 90927 | 737.7 | 1114 |
| jekyll | 10 | 359 | 355 | 362 | 39.6 | 22 |
| jekyll | 100 | 463 | 436 | 470 | 44.0 | 121 |
| jekyll | 1000 | 1280 | 1249 | 1320 | 86.6 | 1111 |
| hwaro | 10 | 31 | 28 | 32 | 21.6 | 23 |
| hwaro | 100 | 72 | 70 | 90 | 30.7 | 122 |
| hwaro | 1000 | 1719 | 1701 | 1777 | 100.1 | 1112 |
| eleventy | 10 | 313 | 306 | 315 | 58.9 | 22 |
| eleventy | 100 | 435 | 427 | 505 | 89.2 | 121 |
| eleventy | 1000 | 1767 | 1725 | 1780 | 187.4 | 1111 |
| pelican | 10 | 285 | 280 | 295 | 32.7 | 21 |
| pelican | 100 | 622 | 617 | 626 | 35.1 | 120 |
| pelican | 1000 | 3988 | 3869 | 3993 | 58.9 | 1110 |
| hexo | 10 | 350 | 348 | 359 | 67.1 | 22 |
| hexo | 100 | 558 | 554 | 566 | 105.7 | 121 |
| hexo | 1000 | 3008 | 2984 | 3066 | 413.8 | 1111 |

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
