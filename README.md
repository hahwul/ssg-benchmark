# SSG Benchmark Repository

This repository is for benchmarking Static Site Generators (SSGs), primarily to analyze and identify performance issues in my own SSG, [hwaro](https://github.com/hahwul/hwaro).

## Purpose

- **Focus on self-improvement**: Not for comparing with other SSGs, but to find hwaro's flaws (e.g., build speed, memory usage, scaling).
- **Use as an experimental space** to enhance hwaro.
- **Objectively assess** strengths and weaknesses via benchmarks.

## Benchmarks Measured

- Build time for various site sizes (10, 100, 1000, 5000+ pages), measured
  **inside the container** (no Docker start/stop overhead), median of N cold builds
- Peak memory usage (container cgroup)
- Output HTML file count, with a cross-SSG **parity check** that flags runs
  where SSGs did different amounts of work

Three workload scenarios isolate different subsystems (see [METHODOLOGY.md](METHODOLOGY.md)):

| Scenario | Workload |
|----------|----------|
| `minimal` | Pure markdown → HTML pipeline, all extras off |
| `blog` | Realistic blog: tag pages, pagination (10/page), feed, build-time syntax highlighting |
| `heavy` | Blog + template-heavy layouts: sidebar on every page (recent posts + tag cloud), breadcrumbs, prev/next navigation |

All SSGs build **byte-identical markdown bodies** generated from a fixed seed,
so results are reproducible and directly comparable within a scenario.

## Target SSGs

| SSG | Language | Description |
|-----|----------|-------------|
| [hwaro](https://github.com/hahwul/hwaro) | Crystal| Lightweight and fast static site generator |
| [Hugo](https://gohugo.io/) | Go | The world's fastest framework for building websites |
| [Zola](https://www.getzola.org/) | Rust | A fast static site generator in a single binary |
| [Jekyll](https://jekyllrb.com/) | Ruby | Transform your plain text into static websites |
| [Blades](https://github.com/grego/blades) | Rust | A fast & flexible static site generator |
| [Astro](https://astro.build/) | JavaScript | The web framework for content-driven websites |
| [Docusaurus](https://docusaurus.io/) | JavaScript | A React-based static site generator by Meta |

## Requirements

- **Docker** (recommended) - For isolated, reproducible benchmark environments
- **Bash** - Shell script execution
- **Make** (optional) - For convenient command shortcuts

### Optional (for local benchmarks without Docker)

- Hugo
- Zola
- Jekyll (Ruby + Bundler)
- Blades
- Hwaro

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/hahwul/ssg-benchmark.git
cd ssg-benchmark
```

### 2. Check dependencies

```bash
make install-deps
```

### 3. Run a quick test

```bash
make quick-test
```

### 4. Run full benchmark

```bash
make benchmark
```

## Usage

### Using Make (Recommended)

```bash
# Show all available commands
make help

# Build Docker images for all SSGs
make docker-build

# Run benchmark with default settings
make benchmark

# Quick test (10 pages, 1 iteration)
make quick-test

# Full comprehensive test (10-10000 pages, 5 iterations)
make full-test

# Benchmark specific SSG
make benchmark-hugo
make benchmark-zola
make benchmark-jekyll
make benchmark-blades
make benchmark-hwaro

# Clean generated content
make clean

# View latest results
make report
```

### Using Shell Scripts Directly

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run benchmark with custom settings
PAGE_COUNTS="100 500 1000" \
ITERATIONS=5 \
SSGS="hugo zola" \
./scripts/benchmark.sh

# Run the blog and heavy scenarios (see METHODOLOGY.md)
./scripts/benchmark.sh -n blog,heavy -s hugo,zola,hwaro

# Generate test content manually (deterministic, seeded)
./scripts/generate-content.sh --ssg hugo --count 1000 --scenario blog --output ./test-site

# Run without Docker (requires local SSG installations)
USE_DOCKER=false ./scripts/benchmark.sh
```

### Using Docker Compose

```bash
# Build all images
docker-compose build

# Run specific SSG benchmark
docker-compose run hugo
docker-compose run zola

# Run full benchmark suite
docker-compose --profile benchmark up benchmark-runner
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PAGE_COUNTS` | `1000` | Space-separated list of page counts to test |
| `ITERATIONS` | `3` | Recorded iterations per benchmark (median reported) |
| `WARMUP` | `1` | Unrecorded warmup builds per combination |
| `SCENARIOS` | `minimal` | Scenarios to run: `minimal`, `blog`, `heavy` |
| `SSGS` | all supported | Space-separated list of SSGs to test |
| `SEED` | `42` | Content generation seed (determinism) |
| `USE_DOCKER` | `true` | Use Docker containers for isolation |
| `DOCKER_CPUS` | `4` | CPU limit per benchmark container |
| `DOCKER_MEMORY` | `4g` | Memory limit per benchmark container |
| `VERBOSE` | `false` | Enable verbose output |

### Example Configurations

```bash
# Test with large page counts
PAGE_COUNTS="1000 5000 10000" make benchmark

# Run all three scenarios
SCENARIOS="minimal blog heavy" make benchmark

# Test only Rust-based SSGs
SSGS="zola blades hwaro" make benchmark

# More iterations for statistical accuracy
ITERATIONS=10 make benchmark

# Local testing without Docker
USE_DOCKER=false make benchmark
```

## Project Structure

```
ssg-benchmark/
├── docker/                    # Dockerfiles for each SSG
├── scripts/                   # Benchmark scripts
│   ├── benchmark.sh           # Main benchmark runner (v2 methodology)
│   ├── generate-content.sh    # Deterministic content generator (seeded corpus)
│   ├── generate-site.sh       # Dashboard data.json generator
│   └── report.sh              # Report generator
├── sites/                     # Base site templates (minimal scenario)
│   ├── hugo/ zola/ jekyll/ hwaro/ ...
├── scenarios/                 # Scenario overlays (copied over the base)
│   ├── blog/<ssg>/            # tags + pagination + feed + syntax highlighting
│   └── heavy/<ssg>/           # blog + sidebar/breadcrumbs/prev-next templates
├── .corpus/                   # Cached deterministic markdown bodies (gitignored)
├── results/                   # Benchmark results (timestamped)
│   └── YYYYMMDD_HHMMSS/
│       ├── results.csv        # per-iteration data
│       ├── summary.md         # medians + output parity check
│       └── config.json        # run settings for reproducibility
├── METHODOLOGY.md             # Measurement methodology & known deviations
├── docker-compose.yml
├── Makefile
└── README.md
```

## Results Format

### CSV Output (`results.csv`)

```csv
ssg,scenario,page_count,iteration,build_time_ms,peak_memory_kb,output_files,status
hugo,blog,100,1,85,37812,123,success
zola,blog,100,1,66,23244,124,success
...
```

### Summary Report (`summary.md`)

The benchmark generates a markdown summary with:
- Median/min/max build times per scenario
- Peak memory statistics
- Output HTML counts and the cross-SSG parity check

Each run directory also contains `config.json` with every knob used for the
run (seed, iterations, Docker limits, host info) for reproducibility.

## Adding a New SSG

1. Create a Dockerfile in `docker/Dockerfile.<ssg-name>`
2. Create a site template in `sites/<ssg-name>/`
3. Add a front-matter emitter in `scripts/generate-content.sh` (bodies come
   from the shared corpus — do not generate your own)
4. Add the build command and output directory in `scripts/benchmark.sh`
5. To support `blog`/`heavy`, add overlays under `scenarios/{blog,heavy}/<ssg>/`
   and add the SSG to the support matrix in `scripts/benchmark.sh`
6. Run a small benchmark and check the output parity section in `summary.md` —
   the HTML count must line up with the other SSGs

## Interpreting Results

- **Build Time**: Lower is better. Measures total time to generate static files.
- **Memory Usage**: Lower is better. Peak memory during build process.
- **Scaling**: How build time increases with page count shows algorithmic efficiency.

### What to Look For

- Linear vs exponential growth in build time
- Memory spikes with large sites
- Consistent vs variable performance across iterations

## Contributing

Contributions or issues welcome for ideas!

### Ideas for Contribution

- Add more SSGs (11ty, Pelican, Gatsby, Next.js static, etc.)
- Improve measurement accuracy
- Add more metrics (incremental build time, watch mode performance)
- Visualization/charting of results
- CI/CD integration for automated benchmarking

## License

See [LICENSE](LICENSE) file.

## Related Projects

- [hwaro](https://github.com/hahwul/hwaro) - The SSG this benchmark aims to improve
- [Hugo](https://gohugo.io/)
- [Zola](https://www.getzola.org/)
- [Jekyll](https://jekyllrb.com/)
- [Blades](https://github.com/grego/blades)
