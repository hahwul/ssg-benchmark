# SSG Benchmark Results (methodology v2)

**Generated:** Sun Nov  8 00:29:54 UTC 2026
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
| eleventy | 3.1.8 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| hexo | hexo-cli: 4.3.2 | Debian GNU/Linux 12 (bookworm) | v22.23.4 |
| hugo | hugo v0.169.0-1da10fc44701c566b1669cdb2d12638f155138bd linux/amd64 BuildDate=2026-10-27T14:52:20Z VendorInfo=gohugoio | Debian GNU/Linux 12 (bookworm) | native |
| hwaro | 0.22.1 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [x86_64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.16 |
| zola | zola 0.23.6 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 56 | 56 | 57 | 15.7 | 12 |
| hugo | 100 | 92 | 90 | 98 | 22.7 | 102 |
| hugo | 1000 | 378 | 377 | 394 | 72.9 | 1002 |
| zola | 10 | 38 | 37 | 39 | 15.7 | 13 |
| zola | 100 | 59 | 59 | 61 | 18.4 | 103 |
| zola | 1000 | 277 | 275 | 282 | 45.2 | 1003 |
| jekyll | 10 | 479 | 476 | 484 | 36.1 | 12 |
| jekyll | 100 | 544 | 543 | 546 | 39.4 | 102 |
| jekyll | 1000 | 1220 | 1216 | 1221 | 62.9 | 1002 |
| hwaro | 10 | 28 | 28 | 28 | 13.2 | 12 |
| hwaro | 100 | 63 | 63 | 64 | 24.1 | 102 |
| hwaro | 1000 | 416 | 406 | 422 | 132.9 | 1002 |
| eleventy | 10 | 427 | 420 | 466 | 52.7 | 12 |
| eleventy | 100 | 529 | 527 | 534 | 71.0 | 102 |
| eleventy | 1000 | 1508 | 1476 | 1547 | 161.1 | 1002 |
| pelican | 10 | 297 | 295 | 299 | 30.6 | 11 |
| pelican | 100 | 505 | 502 | 505 | 31.8 | 101 |
| pelican | 1000 | 2595 | 2548 | 2608 | 40.0 | 1001 |
| hexo | 10 | 416 | 412 | 419 | 43.3 | 12 |
| hexo | 100 | 603 | 596 | 616 | 68.0 | 102 |
| hexo | 1000 | 1974 | 1950 | 1976 | 210.0 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 92 | 91 | 93 | 27.7 | 24 |
| hugo | 100 | 271 | 270 | 276 | 49.5 | 123 |
| hugo | 1000 | 2145 | 2117 | 2153 | 167.5 | 1113 |
| zola | 10 | 267 | 216 | 271 | 66.3 | 25 |
| zola | 100 | 385 | 325 | 385 | 71.1 | 124 |
| zola | 1000 | 1491 | 1426 | 1512 | 121.4 | 1114 |
| jekyll | 10 | 548 | 537 | 558 | 39.6 | 22 |
| jekyll | 100 | 641 | 639 | 659 | 44.4 | 121 |
| jekyll | 1000 | 1480 | 1478 | 1512 | 81.9 | 1111 |
| hwaro | 10 | 41 | 41 | 42 | 16.9 | 23 |
| hwaro | 100 | 97 | 96 | 97 | 33.1 | 122 |
| hwaro | 1000 | 570 | 566 | 608 | 156.8 | 1112 |
| eleventy | 10 | 494 | 492 | 502 | 57.2 | 22 |
| eleventy | 100 | 685 | 679 | 732 | 87.7 | 121 |
| eleventy | 1000 | 2201 | 2180 | 2260 | 178.8 | 1111 |
| pelican | 10 | 423 | 422 | 426 | 32.6 | 21 |
| pelican | 100 | 969 | 968 | 970 | 35.3 | 120 |
| pelican | 1000 | 6468 | 6301 | 6488 | 57.3 | 1110 |
| hexo | 10 | 609 | 604 | 612 | 62.8 | 22 |
| hexo | 100 | 912 | 912 | 913 | 104.7 | 121 |
| hexo | 1000 | 2868 | 2866 | 2895 | 383.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 95 | 94 | 102 | 28.7 | 24 |
| hugo | 100 | 294 | 285 | 326 | 49.7 | 123 |
| hugo | 1000 | 2489 | 2420 | 2576 | 171.4 | 1113 |
| zola | 10 | 210 | 208 | 220 | 66.3 | 25 |
| zola | 100 | 341 | 320 | 379 | 71.3 | 124 |
| zola | 1000 | 1459 | 1432 | 1472 | 121.6 | 1114 |
| jekyll | 10 | 548 | 545 | 550 | 39.6 | 22 |
| jekyll | 100 | 680 | 679 | 681 | 44.1 | 121 |
| jekyll | 1000 | 2066 | 2025 | 2141 | 86.6 | 1111 |
| hwaro | 10 | 42 | 42 | 42 | 17.4 | 23 |
| hwaro | 100 | 99 | 98 | 100 | 36.7 | 122 |
| hwaro | 1000 | 692 | 689 | 703 | 270.4 | 1112 |
| eleventy | 10 | 491 | 487 | 491 | 59.7 | 22 |
| eleventy | 100 | 709 | 708 | 717 | 85.2 | 121 |
| eleventy | 1000 | 2971 | 2922 | 2990 | 182.3 | 1111 |
| pelican | 10 | 434 | 434 | 434 | 32.6 | 21 |
| pelican | 100 | 1013 | 1001 | 1016 | 35.3 | 120 |
| pelican | 1000 | 6812 | 6708 | 6838 | 59.2 | 1110 |
| hexo | 10 | 615 | 613 | 620 | 64.2 | 22 |
| hexo | 100 | 946 | 941 | 948 | 105.2 | 121 |
| hexo | 1000 | 4447 | 4411 | 4581 | 412.6 | 1111 |

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
