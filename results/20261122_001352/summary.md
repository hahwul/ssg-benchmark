# SSG Benchmark Results (methodology v2)

**Generated:** Sun Nov 22 00:27:14 UTC 2026
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
| hwaro | 1.0.0 | Debian GNU/Linux 13 (trixie) | native |
| jekyll | jekyll 4.4.1 | Debian GNU/Linux 12 (bookworm) | ruby 3.2.11 (2026-03-27 revision 5483bfc1ae) [x86_64-linux] |
| pelican | 4.12.0 | Debian GNU/Linux 12 (bookworm) | Python 3.12.16 |
| zola | zola 0.23.6 | Debian GNU/Linux 12 (bookworm) | native |

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 51 | 51 | 53 | 15.2 | 12 |
| hugo | 100 | 84 | 81 | 84 | 20.9 | 102 |
| hugo | 1000 | 378 | 361 | 419 | 73.4 | 1002 |
| zola | 10 | 30 | 29 | 31 | 15.9 | 13 |
| zola | 100 | 60 | 59 | 64 | 18.1 | 103 |
| zola | 1000 | 393 | 379 | 395 | 46.4 | 1003 |
| jekyll | 10 | 351 | 351 | 354 | 36.1 | 12 |
| jekyll | 100 | 399 | 399 | 404 | 39.4 | 102 |
| jekyll | 1000 | 987 | 964 | 1001 | 62.4 | 1002 |
| hwaro | 10 | 25 | 25 | 26 | 13.2 | 12 |
| hwaro | 100 | 43 | 42 | 44 | 23.2 | 102 |
| hwaro | 1000 | 260 | 247 | 266 | 120.9 | 1002 |
| eleventy | 10 | 312 | 305 | 313 | 53.6 | 12 |
| eleventy | 100 | 398 | 394 | 403 | 69.1 | 102 |
| eleventy | 1000 | 1189 | 1187 | 1203 | 156.8 | 1002 |
| pelican | 10 | 244 | 243 | 246 | 30.6 | 11 |
| pelican | 100 | 400 | 396 | 405 | 31.6 | 101 |
| pelican | 1000 | 1940 | 1921 | 1978 | 40.0 | 1001 |
| hexo | 10 | 299 | 297 | 308 | 44.0 | 12 |
| hexo | 100 | 431 | 431 | 443 | 68.8 | 102 |
| hexo | 1000 | 1404 | 1397 | 1490 | 210.2 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 88 | 82 | 91 | 29.2 | 24 |
| hugo | 100 | 251 | 244 | 258 | 47.2 | 123 |
| hugo | 1000 | 2000 | 1977 | 2079 | 176.0 | 1113 |
| zola | 10 | 185 | 177 | 191 | 67.8 | 25 |
| zola | 100 | 315 | 282 | 341 | 71.3 | 124 |
| zola | 1000 | 1453 | 1452 | 1458 | 123.5 | 1114 |
| jekyll | 10 | 402 | 393 | 404 | 39.6 | 22 |
| jekyll | 100 | 471 | 469 | 483 | 44.4 | 121 |
| jekyll | 1000 | 1189 | 1175 | 1261 | 81.9 | 1111 |
| hwaro | 10 | 39 | 38 | 39 | 16.7 | 23 |
| hwaro | 100 | 65 | 65 | 65 | 31.1 | 122 |
| hwaro | 1000 | 351 | 350 | 361 | 141.2 | 1112 |
| eleventy | 10 | 372 | 355 | 373 | 58.8 | 22 |
| eleventy | 100 | 520 | 518 | 524 | 87.6 | 121 |
| eleventy | 1000 | 1816 | 1815 | 1877 | 177.0 | 1111 |
| pelican | 10 | 338 | 332 | 347 | 32.6 | 21 |
| pelican | 100 | 742 | 735 | 743 | 35.1 | 120 |
| pelican | 1000 | 4728 | 4724 | 4763 | 57.1 | 1110 |
| hexo | 10 | 444 | 435 | 445 | 62.5 | 22 |
| hexo | 100 | 657 | 654 | 672 | 104.1 | 121 |
| hexo | 1000 | 2148 | 2143 | 2171 | 355.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 85 | 82 | 94 | 29.5 | 24 |
| hugo | 100 | 278 | 268 | 283 | 47.4 | 123 |
| hugo | 1000 | 2359 | 2318 | 2367 | 183.2 | 1113 |
| zola | 10 | 171 | 170 | 181 | 66.1 | 25 |
| zola | 100 | 288 | 285 | 295 | 71.3 | 124 |
| zola | 1000 | 1470 | 1458 | 1543 | 121.5 | 1114 |
| jekyll | 10 | 406 | 405 | 413 | 39.6 | 22 |
| jekyll | 100 | 512 | 511 | 517 | 44.3 | 121 |
| jekyll | 1000 | 1588 | 1571 | 1607 | 86.6 | 1111 |
| hwaro | 10 | 39 | 39 | 39 | 17.1 | 23 |
| hwaro | 100 | 69 | 67 | 71 | 34.2 | 122 |
| hwaro | 1000 | 445 | 440 | 454 | 236.9 | 1112 |
| eleventy | 10 | 370 | 360 | 379 | 62.8 | 22 |
| eleventy | 100 | 556 | 550 | 559 | 86.0 | 121 |
| eleventy | 1000 | 2398 | 2391 | 2430 | 181.6 | 1111 |
| pelican | 10 | 340 | 338 | 413 | 32.6 | 21 |
| pelican | 100 | 778 | 775 | 819 | 35.3 | 120 |
| pelican | 1000 | 5015 | 5000 | 5035 | 59.3 | 1110 |
| hexo | 10 | 445 | 440 | 447 | 64.2 | 22 |
| hexo | 100 | 694 | 685 | 700 | 106.7 | 121 |
| hexo | 1000 | 3409 | 3377 | 3425 | 381.2 | 1111 |

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
