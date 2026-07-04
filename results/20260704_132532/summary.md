# SSG Benchmark Results (methodology v2)

**Generated:** Sat Jul  4 13:47:18 KST 2026
**SSGs:** hugo zola jekyll hwaro eleventy pelican hexo gatsby astro docusaurus
**Scenarios:** minimal blog heavy
**Page counts:** 1000
**Iterations:** 3 (+1 warmup, cold builds, median reported)
**Seed:** 42 | **Docker:** cpus=4 mem=4g

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 456 | 455 | 469 | 92.6 | 1002 |
| zola | 1000 | 421 | 420 | 421 | 72.3 | 1003 |
| jekyll | 1000 | 1603 | 1576 | 1748 | 76.0 | 1002 |
| hwaro | 1000 | 443 | 440 | 450 | 54.3 | 1002 |
| eleventy | 1000 | 1206 | 1199 | 1210 | 153.2 | 1002 |
| pelican | 1000 | 1226 | 1207 | 1252 | 44.2 | 1001 |
| hexo | 1000 | 1356 | 1355 | 1367 | 190.3 | 1002 |
| gatsby | 1000 | 27437 | 26875 | 27951 | 2634.2 | 1002 |
| astro | 1000 | 7622 | 7610 | 7662 | 754.7 | 1001 |
| docusaurus | 1000 | 36199 | 36011 | 36973 | 2705.2 | 1103 |

## Scenario: blog

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1110 | 1079 | 1168 | 170.9 | 1113 |
| zola | 1000 | 957 | 925 | 1195 | 211.9 | 1114 |
| jekyll | 1000 | 2897 | 2829 | 2991 | 102.4 | 1111 |
| hwaro | 1000 | 591 | 587 | 619 | 71.3 | 1112 |
| eleventy | 1000 | 1554 | 1540 | 1568 | 182.8 | 1111 |
| pelican | 1000 | 2620 | 2586 | 2626 | 51.7 | 1110 |
| hexo | 1000 | 2183 | 2131 | 2185 | 320.3 | 1111 |

## Scenario: heavy

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 1334 | 1207 | 1341 | 175.3 | 1113 |
| zola | 1000 | 28206 | 28104 | 28344 | 1085.3 | 1114 |
| jekyll | 1000 | 3124 | 3088 | 3150 | 104.4 | 1111 |
| hwaro | 1000 | 1503 | 1490 | 1537 | 71.8 | 1112 |
| eleventy | 1000 | 2149 | 2146 | 2167 | 196.6 | 1111 |
| pelican | 1000 | 2703 | 2679 | 2760 | 51.8 | 1110 |
| hexo | 1000 | 2948 | 2905 | 3014 | 352.0 | 1111 |

## Output parity check

Median HTML file counts per (scenario, page count). Large spreads mean
the SSGs are NOT doing comparable work — investigate before comparing times.

- minimal @ 1000p: hugo=1002 zola=1003 jekyll=1002 hwaro=1002 eleventy=1002 pelican=1001 hexo=1002 gatsby=1002 astro=1001 docusaurus=1103 → OK
- blog @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK
- heavy @ 1000p: hugo=1113 zola=1114 jekyll=1111 hwaro=1112 eleventy=1111 pelican=1110 hexo=1111 → OK

## Raw Data

See `results.csv` (per-iteration) and `config.json` (run settings).
