# SSG Benchmark Makefile
# Provides convenient commands for running benchmarks

.PHONY: help build benchmark clean docker-build docker-clean \
        benchmark-hugo benchmark-zola benchmark-jekyll benchmark-blades \
        benchmark-hwaro benchmark-hwaro-main benchmark-hwaro-versions \
        benchmark-eleventy benchmark-pelican benchmark-hexo benchmark-gatsby benchmark-astro benchmark-docusaurus \
        generate-content quick-test full-test report install-deps site

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
	@echo "  benchmark         Run full benchmark suite (all SSGs, all scenarios)"
	@echo "  quick-test        Quick test with 10 pages, 1 iteration"
	@echo "  full-test         Full benchmark sweep (10-10000 pages, all scenarios)"
	@echo ""
	@echo "Individual SSG Benchmarks:"
	@echo "  benchmark-hugo      Benchmark Hugo only"
	@echo "  benchmark-zola      Benchmark Zola only"
	@echo "  benchmark-jekyll    Benchmark Jekyll only"
	@echo "  benchmark-blades    Benchmark Blades only"
	@echo "  benchmark-hwaro     Benchmark Hwaro (pinned release) only"
	@echo ""
	@echo "Hwaro-vs-Hwaro (no other SSGs in the run):"
	@echo "  benchmark-hwaro-main     Pinned release vs. the main branch"
	@echo "  benchmark-hwaro-versions One row per git ref:"
	@echo "                           make benchmark-hwaro-versions HWARO_REFS=\"v0.18.0 main\""
	@echo ""
	@echo "Other SSGs:"
	@echo "  benchmark-eleventy  Benchmark Eleventy only"
	@echo "  benchmark-pelican   Benchmark Pelican only"
	@echo "  benchmark-hexo      Benchmark Hexo only"
	@echo "  benchmark-gatsby    Benchmark Gatsby only"
	@echo "  benchmark-astro     Benchmark Astro only"
	@echo "  benchmark-docusaurus Benchmark Docusaurus only"
	@echo ""
	@echo "Site Targets:"
	@echo "  site              Generate dashboard site from results"
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
	@echo "  PAGE_COUNTS       Page counts to test (default: '1000')"
	@echo "  ITERATIONS        Iterations per test (default: 3)"
	@echo "  SCENARIOS         Scenarios: minimal blog heavy (default: 'minimal blog heavy')"
	@echo "  WARMUP            Warmup builds per combination (default: 1)"
	@echo "  SSGS              SSGs to benchmark (default: 'hugo zola jekyll hwaro hwaro-main eleventy pelican hexo gatsby astro docusaurus')"
	@echo "  USE_DOCKER        Use Docker containers (default: true)"
	@echo ""
	@echo "Examples:"
	@echo "  make benchmark"
	@echo "  make quick-test"
	@echo "  PAGE_COUNTS='100 500' ITERATIONS=5 make benchmark-hugo"

# Configuration with defaults
PAGE_COUNTS ?= 1000
ITERATIONS ?= 3
SCENARIOS ?= minimal blog heavy
WARMUP ?= 1
# Default SSGs for benchmarking (blades excluded due to build issues)
SSGS ?= hugo zola jekyll hwaro hwaro-main eleventy pelican hexo gatsby astro docusaurus
USE_DOCKER ?= true
VERBOSE ?= false

# Directory paths
SCRIPT_DIR := scripts
DOCKER_DIR := docker
SITES_DIR := sites
RESULTS_DIR := results

# Docker image prefix
DOCKER_PREFIX := ssg-benchmark

# Pinned toolchain versions, passed to every image build (see docker/versions.env)
# The \# is escaped for make, which would otherwise start a comment there and
# swallow the rest of the $(shell ...) call.
# The --build-arg=K=V form (rather than two words) keeps each argument a single
# token, so a variant build below can drop one key with a plain substitution.
DOCKER_BUILD_ARGS := $(shell sed -e 's/\#.*//' -e '/^[[:space:]]*$$/d' $(DOCKER_DIR)/versions.env 2>/dev/null | sed 's/^/--build-arg=/' | tr '\n' ' ')

# The branch the hwaro-main variant builds from (see docker/Dockerfile.hwaro).
HWARO_MAIN_REF ?= $(shell sed -n 's/^HWARO_MAIN_REF=//p' $(DOCKER_DIR)/versions.env)

# Build all Docker images
#
# A variant SSG ("<family>-<variant>", e.g. hwaro-main) has no Dockerfile of its
# own on purpose — it builds from its family's, with one pinned key replaced, so
# the two images cannot differ in anything but the source ref. The key is
# *replaced* rather than appended, so the result does not depend on the docker
# CLI's last-one-wins rule. --no-cache because the variant's ref moves while its
# name does not; benchmark.sh does the cheaper thing and keys the layer on the
# ref's resolved SHA, but this target has no run to hang that resolution on.
docker-build:
	@echo "Building Docker images for all SSGs..."
	@for ssg in $(SSGS); do \
		dockerfile=$(DOCKER_DIR)/Dockerfile.$$ssg; \
		[ -f "$$dockerfile" ] || dockerfile=$(DOCKER_DIR)/Dockerfile.$${ssg%%-*}; \
		[ -f "$$dockerfile" ] || continue; \
		args="$(DOCKER_BUILD_ARGS)"; \
		case $$ssg in \
			hwaro-main) ref="$(HWARO_MAIN_REF)" ;; \
			hwaro-*)    ref="$${ssg#hwaro-}" ;; \
			*)          ref="" ;; \
		esac; \
		[ -z "$$ref" ] || args="$$(echo "$$args" | sed 's|--build-arg=HWARO_VERSION=[^ ]*||') --build-arg=HWARO_VERSION=$$ref --no-cache"; \
		echo "Building image for $$ssg..."; \
		docker build $$args -t $(DOCKER_PREFIX)-$$ssg -f $$dockerfile . || true; \
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
		rm -rf $(SITES_DIR)/$$ssg/content/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/_posts/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/posts/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/source/_posts/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/src/posts/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/blog/*.md 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/public 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/_site 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/output 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/dist 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/build 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/db.json 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/.cache 2>/dev/null || true; \
		rm -rf $(SITES_DIR)/$$ssg/src/pages/posts/*.md 2>/dev/null || true; \
	done
	@echo "Cleaned!"

# Remove the cached deterministic corpus
clean-corpus:
	@rm -rf .corpus
	@echo "Corpus cache cleaned!"

# Deep clean including results
clean-all: clean clean-corpus
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
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
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
	SCENARIOS="minimal" \
	WARMUP=0 \
	SSGS="hugo zola jekyll hwaro hwaro-main eleventy pelican hexo gatsby astro docusaurus" \
	VERBOSE=true \
	./$(SCRIPT_DIR)/benchmark.sh

# Full test - comprehensive benchmark
full-test: docker-build
	@echo "Running full benchmark suite..."
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="10 100 1000 5000 10000" \
	ITERATIONS=5 \
	SCENARIOS="minimal blog heavy" \
	WARMUP=1 \
	SSGS="$(SSGS)" \
	./$(SCRIPT_DIR)/benchmark.sh

# Individual SSG benchmarks
benchmark-hugo:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="hugo" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-zola:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="zola" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-jekyll:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="jekyll" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-blades:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="blades" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-hwaro:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="hwaro" \
	./$(SCRIPT_DIR)/benchmark.sh

# hwaro against itself: one row per git ref, nothing else in the run.
#
#   make benchmark-hwaro-versions                                # pinned vs main
#   make benchmark-hwaro-versions HWARO_REFS="v0.18.0 v0.18.1"   # tag vs tag
#   make benchmark-hwaro-versions HWARO_REFS="v0.18.1 main my-branch"
#
# Each row is named for the ref it was built from, so the results say which
# build they describe instead of leaving that to the argument order. All rows
# come from docker/Dockerfile.hwaro, and running them together means they share
# the same host conditions — which is what makes the numbers comparable.
#
# A ref has to be spellable in a docker image name (lowercase, no slashes).
# For anything else, point HWARO_MAIN_REF at it and use the hwaro-main row.
HWARO_PINNED_REF := $(shell sed -n 's/^HWARO_VERSION=//p' $(DOCKER_DIR)/versions.env)
HWARO_REFS ?= $(HWARO_PINNED_REF) $(HWARO_MAIN_REF)

benchmark-hwaro-versions:
	@chmod +x $(SCRIPT_DIR)/*.sh
	@echo "Comparing hwaro refs: $(HWARO_REFS)"
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	VERBOSE=$(VERBOSE) \
	SSGS="$(foreach r,$(HWARO_REFS),hwaro-$(r))" \
	./$(SCRIPT_DIR)/benchmark.sh

# The common case as a fixed pair: the pinned release row exactly as the
# cross-SSG comparison builds it, against main.
benchmark-hwaro-main:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="hwaro hwaro-main" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-eleventy:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="eleventy" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-pelican:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="pelican" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-hexo:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="hexo" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-gatsby:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="gatsby" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-astro:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="astro" \
	./$(SCRIPT_DIR)/benchmark.sh

benchmark-docusaurus:
	@chmod +x $(SCRIPT_DIR)/*.sh
	USE_DOCKER=$(USE_DOCKER) \
	PAGE_COUNTS="$(PAGE_COUNTS)" \
	ITERATIONS=$(ITERATIONS) \
	SCENARIOS="$(SCENARIOS)" \
	WARMUP=$(WARMUP) \
	SSGS="docusaurus" \
	./$(SCRIPT_DIR)/benchmark.sh

# Generate test content for all SSGs
generate-content:
	@echo "Generating test content..."
	@chmod +x $(SCRIPT_DIR)/*.sh
	@for ssg in $(SSGS); do \
		ssg=$${ssg%%-*}; \
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
	@for ssg in hugo zola jekyll blades hwaro eleventy pelican hexo gatsby astro docusaurus; do \
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

# Generate dashboard site
site:
	@echo "Generating dashboard site..."
	@chmod +x $(SCRIPT_DIR)/generate-site.sh
	@./$(SCRIPT_DIR)/generate-site.sh
	@cd web && hwaro build
	@rm -rf site
	@mv web/public site
	@echo "Dashboard ready at site/index.html"

# Run with Docker Compose
compose-build:
	docker-compose build

compose-up:
	docker-compose up -d

compose-down:
	docker-compose down

compose-benchmark:
	docker-compose --profile benchmark up benchmark-runner
