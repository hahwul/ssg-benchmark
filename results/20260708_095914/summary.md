# SSG Benchmark Results (methodology v2)

**Generated:** Wed Jul  8 10:15:53 KST 2026
**SSGs:** hugo zola jekyll hwaro eleventy pelican hexo gatsby astro docusaurus
**Scenarios:** minimal blog heavy
**Page counts:** 1000
**Iterations:** 3 (+1 warmup, cold builds, median reported)
**Seed:** 42 | **Docker:** cpus=4 mem=4g

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 506 | 497 | 567 | 92.5 | 1002 |
| zola | 1000 | 506 | 461 | 532 | 72.7 | 1003 |
| jekyll | 1000 | 1586 | 1570 | 1720 | 76.2 | 1002 |
| hwaro | 1000 | 486 | 476 | 488 | 69.2 | 1002 |
| eleventy | 1000 | 1231 | 1225 | 1291 | 156.8 | 1002 |
| pelican | 1000 | 1230 | 1223 | 1262 | 44.8 | 1001 |
| hexo | 1000 | 1333 | 1332 | 1374 | 185.2 | 1002 |
| gatsby | 1000 | 31507 | 31128 | 31815 | 3247.4 | 1002 |
| astro | 1000 | 7405 | 7138 | 7437 | 757.3 | 1001 |
| docusaurus | 1000 | 34135 | 34036 | 34155 | 3009.7 | 1103 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1124 | 1111 | 1158 | 170.7 | 1113 |
| zola | 1000 | 919 | 894 | 939 | 211.8 | 1114 |
| jekyll | 1000 | 2827 | 2811 | 2867 | 102.3 | 1111 |
| hwaro | 1000 | 599 | 571 | 666 | 71.7 | 1112 |
| eleventy | 1000 | 1556 | 1521 | 1602 | 184.6 | 1111 |
| pelican | 1000 | 2598 | 2547 | 2607 | 52.5 | 1110 |
| hexo | 1000 | 2047 | 2045 | 2071 | 315.1 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1304 | 1295 | 1355 | 182.5 | 1113 |
| zola | 1000 | 28123 | 27803 | 28249 | 1085.9 | 1114 |
| jekyll | 1000 | 3026 | 2969 | 3054 | 105.1 | 1111 |
| hwaro | 1000 | 1512 | 1490 | 1670 | 73.5 | 1112 |
| eleventy | 1000 | 2140 | 2064 | 2165 | 196.4 | 1111 |
| pelican | 1000 | 2647 | 2641 | 2658 | 52.6 | 1110 |
| hexo | 1000 | 2957 | 2843 | 3161 | 354.3 | 1111 |

## Output parity check

Median HTML file counts per (scenario, page count). Large spreads mean
the SSGs are NOT doing comparable work — investigate before comparing times.

- minimal @ 1000p: hugo=1002 zola=1003 jekyll=1002 hwaro=1002 eleventy=1002 pelican=1001 hexo=1002 gatsby=1002 astro=1001 docusaurus=1103 → OK
- blog @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK
- heavy @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK

## Raw Data

See `results.csv` (per-iteration) and `config.json` (run settings).
