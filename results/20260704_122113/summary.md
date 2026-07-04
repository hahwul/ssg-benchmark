# SSG Benchmark Results (methodology v2)

**Generated:** Sat Jul  4 12:31:07 KST 2026
**SSGs:** hugo zola jekyll hwaro eleventy pelican hexo gatsby astro docusaurus
**Scenarios:** minimal
**Page counts:** 1000
**Iterations:** 3 (+1 warmup, cold builds, median reported)
**Seed:** 42 | **Docker:** cpus=4 mem=4g

## Scenario: minimal

| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |
|-----|-------|-------------|-----|-----|----------------|------------|
| hugo | 1000 | 461 | 455 | 499 | 93.0 | 1002 |
| zola | 1000 | 440 | 432 | 461 | 72.5 | 1003 |
| jekyll | 1000 | 1978 | 1598 | 1985 | 75.6 | 1002 |
| hwaro | 1000 | 477 | 452 | 482 | 55.0 | 1002 |
| eleventy | 1000 | 1342 | 1341 | 1414 | 155.8 | 1002 |
| pelican | 1000 | 1390 | 1384 | 1513 | 43.8 | 1001 |
| hexo | 1000 | 1410 | 1389 | 1416 | 189.5 | 1002 |
| gatsby | 1000 | 27051 | 26853 | 27078 | 2565.9 | 1002 |
| astro | 1000 | 7691 | 7620 | 7698 | 762.8 | 1001 |
| docusaurus | 1000 | 38579 | 38577 | 40986 | 2732.3 | 1103 |

## Output parity check

Median HTML file counts per (scenario, page count). Large spreads mean
the SSGs are NOT doing comparable work — investigate before comparing times.

- minimal @ 1000p: hugo=1002 zola=1003 jekyll=1002 hwaro=1002 eleventy=1002 pelican=1001 hexo=1002 gatsby=1002 astro=1001 docusaurus=1103 → OK

## Raw Data

See `results.csv` (per-iteration) and `config.json` (run settings).
