# SSG Benchmark Results (methodology v2)

**Generated:** Sat Jul  4 02:09:16 KST 2026
**SSGs:** hugo zola hwaro jekyll eleventy pelican hexo
**Scenarios:** minimal blog heavy
**Page counts:** 10 100 1000
**Iterations:** 3 (+1 warmup, cold builds, median reported)
**Seed:** 42 | **Docker:** cpus=4 mem=4g

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 32 | 31 | 34 | 28.6 | 12 |
| hugo | 100 | 72 | 68 | 75 | 36.5 | 102 |
| hugo | 1000 | 500 | 494 | 503 | 90.7 | 1002 |
| zola | 10 | 15 | 14 | 16 | 16.5 | 13 |
| zola | 100 | 58 | 55 | 61 | 21.7 | 103 |
| zola | 1000 | 467 | 454 | 501 | 72.0 | 1003 |
| hwaro | 10 | 20 | 19 | 24 | 14.9 | 12 |
| hwaro | 100 | 67 | 64 | 68 | 24.6 | 102 |
| hwaro | 1000 | 565 | 457 | 819 | 56.7 | 1002 |
| jekyll | 10 | 225 | 224 | 249 | 41.3 | 12 |
| jekyll | 100 | 380 | 366 | 382 | 45.8 | 102 |
| jekyll | 1000 | 1660 | 1578 | 1716 | 76.2 | 1002 |
| eleventy | 10 | 215 | 211 | 238 | 69.8 | 12 |
| eleventy | 100 | 323 | 322 | 325 | 84.3 | 102 |
| eleventy | 1000 | 1220 | 1209 | 1230 | 153.8 | 1002 |
| pelican | 10 | 157 | 156 | 157 | 33.9 | 11 |
| pelican | 100 | 259 | 259 | 271 | 34.8 | 101 |
| pelican | 1000 | 1261 | 1231 | 1318 | 44.1 | 1001 |
| hexo | 10 | 277 | 268 | 280 | 47.6 | 12 |
| hexo | 100 | 423 | 417 | 428 | 75.2 | 102 |
| hexo | 1000 | 1382 | 1366 | 1395 | 190.4 | 1002 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 37 | 37 | 39 | 29.4 | 24 |
| hugo | 100 | 86 | 85 | 99 | 37.8 | 123 |
| hugo | 1000 | 534 | 529 | 546 | 96.9 | 1113 |
| zola | 10 | 20 | 19 | 20 | 18.0 | 25 |
| zola | 100 | 65 | 65 | 71 | 22.8 | 124 |
| zola | 1000 | 492 | 478 | 500 | 73.3 | 1114 |
| hwaro | 10 | 26 | 23 | 30 | 16.4 | 23 |
| hwaro | 100 | 72 | 70 | 74 | 29.0 | 122 |
| hwaro | 1000 | 482 | 480 | 490 | 67.3 | 1112 |
| jekyll | 10 | 259 | 258 | 261 | 44.3 | 22 |
| jekyll | 100 | 412 | 412 | 415 | 53.3 | 121 |
| jekyll | 1000 | 1745 | 1729 | 2008 | 79.5 | 1111 |
| eleventy | 10 | 236 | 229 | 245 | 73.4 | 22 |
| eleventy | 100 | 368 | 361 | 375 | 98.3 | 121 |
| eleventy | 1000 | 1375 | 1375 | 1386 | 162.6 | 1111 |
| pelican | 10 | 165 | 157 | 165 | 34.1 | 21 |
| pelican | 100 | 269 | 268 | 291 | 34.7 | 120 |
| pelican | 1000 | 1348 | 1309 | 1360 | 44.6 | 1110 |
| hexo | 10 | 374 | 371 | 374 | 65.0 | 22 |
| hexo | 100 | 537 | 532 | 539 | 92.1 | 121 |
| hexo | 1000 | 1846 | 1826 | 1847 | 213.1 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 10 | 45 | 44 | 47 | 36.8 | 24 |
| hugo | 100 | 149 | 143 | 157 | 51.7 | 123 |
| hugo | 1000 | 1084 | 1048 | 1173 | 172.5 | 1113 |
| zola | 10 | 174 | 166 | 185 | 137.0 | 25 |
| zola | 100 | 249 | 230 | 252 | 142.3 | 124 |
| zola | 1000 | 921 | 916 | 953 | 212.0 | 1114 |
| hwaro | 10 | 32 | 32 | 34 | 23.6 | 23 |
| hwaro | 100 | 88 | 82 | 90 | 31.8 | 122 |
| hwaro | 1000 | 574 | 560 | 579 | 71.5 | 1112 |
| jekyll | 10 | 354 | 353 | 380 | 62.3 | 22 |
| jekyll | 100 | 599 | 594 | 615 | 69.1 | 121 |
| jekyll | 1000 | 2901 | 2864 | 3016 | 101.8 | 1111 |
| eleventy | 10 | 280 | 277 | 282 | 75.3 | 22 |
| eleventy | 100 | 395 | 393 | 396 | 101.7 | 121 |
| eleventy | 1000 | 1565 | 1559 | 1575 | 184.6 | 1111 |
| pelican | 10 | 205 | 203 | 211 | 35.1 | 21 |
| pelican | 100 | 437 | 430 | 441 | 36.4 | 120 |
| pelican | 1000 | 2620 | 2609 | 2666 | 52.0 | 1110 |
| hexo | 10 | 406 | 399 | 423 | 73.2 | 22 |
| hexo | 100 | 585 | 578 | 595 | 104.9 | 121 |
| hexo | 1000 | 2104 | 2079 | 2163 | 304.7 | 1111 |

## Output parity check

Median HTML file counts per (scenario, page count). Large spreads mean
the SSGs are NOT doing comparable work — investigate before comparing times.

- minimal @ 10p: hugo=12 zola=13 hwaro=12 jekyll=12 eleventy=12 pelican=11 hexo=12 → OK
- minimal @ 100p: hugo=102 zola=103 hwaro=102 jekyll=102 eleventy=102 pelican=101 hexo=102 → OK
- minimal @ 1000p: hugo=1002 zola=1003 hwaro=1002 jekyll=1002 eleventy=1002 pelican=1001 hexo=1002 → OK
- blog @ 10p: hugo=24 zola=25 hwaro=23 jekyll=22 eleventy=22 pelican=21 hexo=22 → OK
- blog @ 100p: hugo=123 zola=124 hwaro=122 jekyll=121 eleventy=121 pelican=120 hexo=121 → OK
- blog @ 1000p: hugo=1113 zola=1114 hwaro=1112 jekyll=1111 eleventy=1111 pelican=1110 hexo=1111 → OK
- heavy @ 10p: hugo=24 zola=25 hwaro=23 jekyll=22 eleventy=22 pelican=21 hexo=22 → OK
- heavy @ 100p: hugo=123 zola=124 hwaro=122 jekyll=121 eleventy=121 pelican=120 hexo=121 → OK
- heavy @ 1000p: hugo=1113 zola=1114 hwaro=1112 jekyll=1111 eleventy=1111 pelican=1110 hexo=1111 → OK

## Raw Data

See `results.csv` (per-iteration) and `config.json` (run settings).
