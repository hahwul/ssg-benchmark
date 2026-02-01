# SSG Benchmark Makefile
# Provides convenient commands for running benchmarks

.PHONY: help build benchmark clean docker-build docker-clean \
        benchmark-hugo benchmark-zola benchmark-jekyll benchmark-blades benchmark-hwaro \
        generate-content quick-test full-test report install-deps

# Default target
help:
	@echo "SSG Benchmark - Static Site Generator Performance Testing"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Build Targets:"
	@echo "  docker-build      Build all Docker images for SSGs"
	@echo "  docker-clean      Remove all benchmark Docker images"
	@echo "  clean             Clean generated content and results"
	@echo ""
	@echo "Benchmark Targets:"
	@echo "  benchmark         Run full benchmark suite (all SSGs)"
	@echo "  quick-test        Quick test with 10 pages, 1 iteration"
	@echo "  full-test         Full benchmark with 10-5000 pages"
	@echo ""
	@echo "Individual SSG Benchmarks:"
	@echo "  benchmark-hugo    Benchmark Hugo only"
	@echo "  benchmark-zola    Benchmark Zola only"
	@echo "  benchmark-jekyll  Benchmark Jekyll only"
	@echo "  benchmark-blades  Benchmark Blades only"
	@echo "  benchmark-hwaro   Benchmark Hwaro only"
	@echo ""
	@echo "Utility Targets:"
	@echo "  generate-content  Generate test content for all SSGs"
	@echo "  report            Generate markdown report from latest results"
	@echo "  report-chart      Generate report with ASCII chart visualization"
	@echo "  report-json       Generate JSON report"
	@echo "  report-html       Generate HTML report"
	@echo "  report-all        Generate all report formats"
	@echo "  install-deps      Check and install dependencies"
	@echo ""
	@echo "Configuration (environment variables):"
	@echo "  PAGE_COUNTS       Page counts to test (default: '10 100 1000 5000')"
	@echo "  ITERATIONS        Iterations per test (default: 3)"
	@echo "  SSGS              SSGs to benchmark (default: 'hugo zola jekyll blades hwaro')"
	@echo "  USE_DOCKER        Use Docker containers (default: true)"
	@echo ""
	@echo "Examples:"
	@echo "  make benchmark"
	@echo "  make quick-test"
	@echo "  PAGE_COUNTS='100 500' ITERATIONS=5 make benchmark-hugo"

# Configuration with defaults
PAGE_COUNTS ?= 10 100 1000 5000
ITERATIONS ?= 3
# Default SSGs for benchmarking (blades excluded due to build issues)
SSGS ?= hugo zola jekyll hwaro
USE_DOCKER ?= true
VERBOSE ?= false

# Directory paths
SCRIPT_DIR := scripts
DOCKER_DIR := docker
SITES_DIR := sites
RESULTS_DIR := results

# Docker image prefix
DOCKER_PREFIX := ssg-benchmark

# Build all Docker images
docker-build:
	@echo "Building Docker images for all SSGs..."
	@for ssg in $(SSGS); do \
		if [ -f "$(DOCKER_DIR)/Dockerfile.$$ssg" ]; then \
			echo "Building image for $$ssg..."; \
			docker build -t $(DOCKER_PREFIX)-$$ssg -f $(DOCKER_DIR)/Dockerfile.$$ssg . || true; \
		fi \
	done
	@echo "Docker images built successfully!"

# Clean Docker images
docker-clean:
	@echo "Removing benchmark Docker images..."
	@for ssg in $(SSGS); do \
		docker rmi $(DOCKER_PREFIX)-$$ssg 2>/dev/null || true; \
	done
	@docker image prune -f
	@echo "Docker images cleaned!"

# Clean generated content and build outputs
clean:
	@echo "Cleaning generated content and build outputs..."
	@for ssg in $(SSGS); do \
		rm -rf $(SITES_DIR)/$$ssg/content/posts/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/_posts/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/public 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/_site 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/output 2>/dev/null || true; \
	done
	@echo "Cleaned!"

# Deep clean including results
clean-all: clean
	@echo "Cleaning all results..."
	@rm -rf $(RESULTS_DIR)/*
	@echo "All cleaned!"

# Run full benchmark suite
benchmark: docker-build
	@echo "Starting SSG Benchmark Suite..."
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SSGS="$(SSGS)" \
	VERBOSE=$(VERBOSE) \
	./$(SCRIPT_DIR)/benchmark.sh

# Quick test - minimal configuration for testing (uses stable SSGs only)
quick-test:
	@echo "Running quick benchmark test..."
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="10" \
	ITERATIONS=1 \
	SSGS="hugo zola jekyll hwaro" \
	VERBOSE=true \
	./$(SCRIPT_DIR)/benchmark.sh

# Full test - comprehensive benchmark
full-test: docker-build
	@echo "Running full benchmark suite..."
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="10 100 1000 5000 10000" \
	ITERATIONS=5 \
	SSGS="$(SSGS)" \
	./$(SCRIPT_DIR)/benchmark.sh

# Individual SSG benchmarks
benchmark-hugo:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SSGS="hugo" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-zola:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SSGS="zola" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-jekyll:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SSGS="jekyll" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-blades:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SSGS="blades" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-hwaro:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SSGS="hwaro" \
	./$(SCRIPT_DIR)/benchmark.sh

# Generate test content for all SSGs
generate-content:
	@echo "Generating test content..."
	@chmod +x $(SCRIPT_DIR)/*.sh
	@for ssg in $(SSGS); do \
		echo "Generating content for $$ssg..."; \
		./$(SCRIPT_DIR)/generate-content.sh \
			--ssg $$ssg \
			--count 100 \
			--output $(SITES_DIR)/$$ssg; \
	done
	@echo "Content generated!"

# Generate report from latest results
report:
	@echo "Generating report from latest results..."
	@chmod +x $(SCRIPT_DIR)/report.sh
	@./$(SCRIPT_DIR)/report.sh -f markdown

# Generate report with ASCII chart visualization
report-chart:
	@chmod +x $(SCRIPT_DIR)/report.sh
	@./$(SCRIPT_DIR)/report.sh -f markdown --chart

# Generate JSON report
report-json:
	@chmod +x $(SCRIPT_DIR)/report.sh
	@./$(SCRIPT_DIR)/report.sh -f json

# Generate HTML report
report-html:
	@chmod +x $(SCRIPT_DIR)/report.sh
	@mkdir -p $(RESULTS_DIR)
	@./$(SCRIPT_DIR)/report.sh -f html -o $(RESULTS_DIR)/latest-report.html
	@echo "HTML report saved to $(RESULTS_DIR)/latest-report.html"

# Export all report formats
report-all:
	@chmod +x $(SCRIPT_DIR)/report.sh
	@LATEST=$$(ls -t $(RESULTS_DIR) 2>/dev/null | grep -v ".gitkeep" | head -1); \
	if [ -n "$$LATEST" ]; then \
		./$(SCRIPT_DIR)/report.sh -r "$(RESULTS_DIR)/$$LATEST" -f markdown -o "$(RESULTS_DIR)/$$LATEST/report.md"; \
		./$(SCRIPT_DIR)/report.sh -r "$(RESULTS_DIR)/$$LATEST" -f json -o "$(RESULTS_DIR)/$$LATEST/report.json"; \
		./$(SCRIPT_DIR)/report.sh -r "$(RESULTS_DIR)/$$LATEST" -f html -o "$(RESULTS_DIR)/$$LATEST/report.html"; \
		echo "All reports generated in $(RESULTS_DIR)/$$LATEST/"; \
	else \
		echo "No results found. Run 'make benchmark' first."; \
	fi

# Check and display dependency status
install-deps:
	@echo "Checking dependencies..."
	@echo ""
	@echo "Docker:"
	@if command -v docker >/dev/null 2>&1; then \
		echo "  ✓ Docker installed: $$(docker --version)"; \
	else \
		echo "  ✗ Docker not found - required for containerized benchmarks"; \
	fi
	@echo ""
	@echo "Local SSGs (optional, for --no-docker mode):"
	@for ssg in hugo zola jekyll blades hwaro; do \
		if command -v $$ssg >/dev/null 2>&1; then \
			echo "  ✓ $$ssg installed"; \
		else \
			echo "  - $$ssg not found (will use Docker)"; \
		fi \
	done
	@echo ""
	@echo "Shell utilities:"
	@for util in bash awk sed grep date; do \
		if command -v $$util >/dev/null 2>&1; then \
			echo "  ✓ $$util"; \
		else \
			echo "  ✗ $$util not found"; \
		fi \
	done

# Run with Docker Compose
compose-build:
	docker-compose build

compose-up:
	docker-compose up -d

compose-down:
	docker-compose down

compose-benchmark:
	docker-compose --profile benchmark up benchmark-runner
