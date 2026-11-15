# SSG Benchmark Results (methodology v2)

**Generated:** Sun Nov 15 00:28:01 UTC 2026
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
| eleventy | 3.1.8 | Debian GNU/Linux 12 (bookworm) | v22.23.5 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.5 |
| hugo | hugo v0.169.0-1da10fc44701c566b1669cdb2d12638f155138bd linux/amd64 BuildDate=2026-10-27T14:52:20Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 0.22.1 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [x86_64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.16 |
| zola | zola 0.23.6 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 46 | 44 | 47 | 15.2 | 12 |
| hugo | 100 | 77 | 72 | 79 | 21.9 | 102 |
| hugo | 1000 | 352 | 344 | 513 | 74.4 | 1002 |
| zola | 10 | 34 | 34 | 35 | 15.9 | 13 |
| zola | 100 | 56 | 56 | 58 | 18.2 | 103 |
| zola | 1000 | 297 | 296 | 302 | 45.9 | 1003 |
| jekyll | 10 | 421 | 420 | 424 | 36.1 | 12 |
| jekyll | 100 | 457 | 452 | 473 | 39.4 | 102 |
| jekyll | 1000 | 1088 | 1037 | 1186 | 62.8 | 1002 |
| hwaro | 10 | 25 | 25 | 26 | 13.2 | 12 |
| hwaro | 100 | 60 | 60 | 60 | 24.1 | 102 |
| hwaro | 1000 | 401 | 393 | 418 | 133.1 | 1002 |
| eleventy | 10 | 337 | 337 | 339 | 52.9 | 12 |
| eleventy | 100 | 430 | 419 | 439 | 65.3 | 102 |
| eleventy | 1000 | 1207 | 1191 | 1265 | 155.9 | 1002 |
| pelican | 10 | 252 | 248 | 260 | 30.8 | 11 |
| pelican | 100 | 417 | 412 | 424 | 31.8 | 101 |
| pelican | 1000 | 2085 | 2051 | 2190 | 39.8 | 1001 |
| hexo | 10 | 336 | 336 | 342 | 43.5 | 12 |
| hexo | 100 | 479 | 476 | 484 | 68.9 | 102 |
| hexo | 1000 | 1577 | 1560 | 1589 | 209.9 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 77 | 76 | 83 | 28.4 | 24 |
| hugo | 100 | 229 | 229 | 241 | 48.7 | 123 |
| hugo | 1000 | 1831 | 1810 | 1848 | 168.1 | 1113 |
| zola | 10 | 185 | 174 | 188 | 66.0 | 25 |
| zola | 100 | 338 | 267 | 368 | 71.3 | 124 |
| zola | 1000 | 1276 | 1236 | 1402 | 121.1 | 1114 |
| jekyll | 10 | 460 | 456 | 472 | 39.6 | 22 |
| jekyll | 100 | 544 | 539 | 559 | 44.4 | 121 |
| jekyll | 1000 | 1245 | 1224 | 1322 | 81.9 | 1111 |
| hwaro | 10 | 38 | 37 | 38 | 16.9 | 23 |
| hwaro | 100 | 88 | 87 | 90 | 33.6 | 122 |
| hwaro | 1000 | 499 | 487 | 589 | 156.1 | 1112 |
| eleventy | 10 | 392 | 384 | 394 | 57.6 | 22 |
| eleventy | 100 | 561 | 548 | 566 | 84.1 | 121 |
| eleventy | 1000 | 1752 | 1746 | 1766 | 175.2 | 1111 |
| pelican | 10 | 346 | 345 | 353 | 32.6 | 21 |
| pelican | 100 | 807 | 792 | 859 | 35.1 | 120 |
| pelican | 1000 | 5108 | 5097 | 5189 | 57.2 | 1110 |
| hexo | 10 | 485 | 484 | 491 | 62.6 | 22 |
| hexo | 100 | 735 | 729 | 738 | 104.8 | 121 |
| hexo | 1000 | 2343 | 2266 | 2555 | 352.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 85 | 77 | 86 | 29.2 | 24 |
| hugo | 100 | 240 | 237 | 261 | 50.4 | 123 |
| hugo | 1000 | 2101 | 2007 | 2378 | 170.6 | 1113 |
| zola | 10 | 176 | 172 | 220 | 66.2 | 25 |
| zola | 100 | 273 | 268 | 333 | 71.0 | 124 |
| zola | 1000 | 1268 | 1267 | 1285 | 121.6 | 1114 |
| jekyll | 10 | 475 | 473 | 489 | 39.6 | 22 |
| jekyll | 100 | 595 | 589 | 614 | 44.1 | 121 |
| jekyll | 1000 | 1854 | 1764 | 1878 | 86.6 | 1111 |
| hwaro | 10 | 39 | 39 | 40 | 17.4 | 23 |
| hwaro | 100 | 90 | 90 | 90 | 36.4 | 122 |
| hwaro | 1000 | 669 | 658 | 808 | 270.9 | 1112 |
| eleventy | 10 | 408 | 399 | 420 | 56.6 | 22 |
| eleventy | 100 | 571 | 566 | 577 | 85.9 | 121 |
| eleventy | 1000 | 2367 | 2353 | 2404 | 181.0 | 1111 |
| pelican | 10 | 357 | 356 | 374 | 32.6 | 21 |
| pelican | 100 | 811 | 809 | 814 | 35.6 | 120 |
| pelican | 1000 | 5297 | 5269 | 5335 | 59.1 | 1110 |
| hexo | 10 | 498 | 495 | 506 | 64.5 | 22 |
| hexo | 100 | 761 | 759 | 769 | 106.3 | 121 |
| hexo | 1000 | 3565 | 3512 | 4194 | 414.8 | 1111 |

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
