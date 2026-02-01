# SSG Benchmark Repository

This repository is for benchmarking Static Site Generators (SSGs), primarily to analyze and identify performance issues in my own SSG, [hwaro](https://github.com/hahwul/hwaro).

## Purpose

- **Focus on self-improvement**: Not for comparing with other SSGs, but to find hwaro's flaws (e.g., build speed, memory usage, scaling).
- **Use as an experimental space** to enhance hwaro.
- **Objectively assess** strengths and weaknesses via benchmarks.

## Benchmarks Measured

- Build time for various site sizes (10, 100, 1000, 5000+ pages)
- Memory/CPU usage
- Output file generation count

## Target SSGs

| SSG | Language | Description |
|-----|----------|-------------|
| [hwaro](https://github.com/hahwul/hwaro) | Lightweight and fast static site generator |  |
| [Hugo](https://gohugo.io/) | Go | The world's fastest framework for building websites |
| [Zola](https://www.getzola.org/) | Rust | A fast static site generator in a single binary |
| [Jekyll](https://jekyllrb.com/) | Ruby | Transform your plain text into static websites |
| [Blades](https://github.com/grego/blades) | Rust | A fast & flexible static site generator |

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

# Generate test content manually
./scripts/generate-content.sh --ssg hugo --count 1000 --output ./test-site

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
| `PAGE_COUNTS` | `10 100 1000 5000` | Space-separated list of page counts to test |
| `ITERATIONS` | `3` | Number of iterations per benchmark |
| `SSGS` | `hugo zola jekyll blades hwaro` | Space-separated list of SSGs to test |
| `USE_DOCKER` | `true` | Use Docker containers for isolation |
| `VERBOSE` | `false` | Enable verbose output |

### Example Configurations

```bash
# Test with large page counts
PAGE_COUNTS="1000 5000 10000" make benchmark

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
│   ├── Dockerfile.hugo
│   ├── Dockerfile.zola
│   ├── Dockerfile.jekyll
│   ├── Dockerfile.blades
│   └── Dockerfile.hwaro
├── scripts/                   # Benchmark scripts
│   ├── benchmark.sh           # Main benchmark runner
│   ├── benchmark-runner.sh    # Container benchmark helper
│   └── generate-content.sh    # Test content generator
├── sites/                     # Site templates for each SSG
│   ├── hugo/
│   ├── zola/
│   ├── jekyll/
│   ├── blades/
│   └── hwaro/
├── results/                   # Benchmark results (timestamped)
│   └── YYYYMMDD_HHMMSS/
│       ├── results.csv
│       └── summary.md
├── docker-compose.yml
├── Makefile
└── README.md
```

## Results Format

### CSV Output (`results.csv`)

```csv
ssg,page_count,iteration,build_time_ms,peak_memory_kb,cpu_percent,status
hugo,100,1,245,45000,85,success
zola,100,1,180,38000,90,success
...
```

### Summary Report (`summary.md`)

The benchmark generates a markdown summary with:
- Average build times
- Min/Max times
- Memory usage statistics
- Comparison tables

## Adding a New SSG

1. Create a Dockerfile in `docker/Dockerfile.<ssg-name>`
2. Create a site template in `sites/<ssg-name>/`
3. Add content generation logic in `scripts/generate-content.sh`
4. Add build command detection in `scripts/benchmark.sh`
5. Update `SSGS` variable or pass it as parameter

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
