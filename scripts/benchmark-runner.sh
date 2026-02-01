#!/bin/bash
#
# SSG Benchmark Runner - Runs inside Docker container
# Measures build time, memory usage, and other metrics
#

set -e

# Configuration
SSG="${SSG:-unknown}"
OUTPUT_FILE="${OUTPUT_FILE:-/results/benchmark.json}"
BUILD_CMD="${BUILD_CMD:-}"
SITE_DIR="${SITE_DIR:-/site}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[RUNNER]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[RUNNER]${NC} $1"
}

log_error() {
    echo -e "${RED}[RUNNER]${NC} $1"
}

# Detect SSG and set build command
detect_build_command() {
    if [ -n "$BUILD_CMD" ]; then
        echo "$BUILD_CMD"
        return
    fi

    case "$SSG" in
        hugo)
            echo "hugo --minify"
            ;;
        zola)
            echo "zola build"
            ;;
        jekyll)
            echo "bundle exec jekyll build"
            ;;
        blades)
            echo "blades"
            ;;
        hwaro)
            echo "hwaro build"
            ;;
        *)
            # Try to auto-detect based on config files
            if [ -f "config.toml" ] || [ -f "config.yaml" ]; then
                if grep -q "baseURL" config.* 2>/dev/null; then
                    echo "hugo --minify"
                elif grep -q "base_url" config.toml 2>/dev/null; then
                    echo "zola build"
                fi
            elif [ -f "_config.yml" ]; then
                echo "bundle exec jekyll build"
            elif [ -f "Blades.toml" ]; then
                echo "blades"
            elif [ -f "hwaro.toml" ]; then
                echo "hwaro build"
            else
                log_error "Cannot detect SSG type"
                exit 1
            fi
            ;;
    esac
}

# Get memory usage (in KB)
get_memory_usage() {
    if [ -f /proc/meminfo ]; then
        # Linux
        local total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        echo $((total - available))
    else
        # Fallback
        echo "0"
    fi
}

# Run benchmark
run_benchmark() {
    local build_cmd="$1"
    local start_time
    local end_time
    local duration_ms
    local exit_code=0
    local memory_before
    local memory_after
    local peak_memory=0

    cd "$SITE_DIR"

    log "Starting benchmark for ${SSG}"
    log "Build command: ${build_cmd}"
    log "Working directory: $(pwd)"

    # Clean previous build output
    rm -rf public _site output build dist 2>/dev/null || true

    # Record memory before build
    memory_before=$(get_memory_usage)

    # Run build with timing
    start_time=$(date +%s%3N 2>/dev/null || echo $(($(date +%s) * 1000)))

    # Use /usr/bin/time if available for detailed stats
    if command -v /usr/bin/time &> /dev/null; then
        time_output=$(/usr/bin/time -v sh -c "$build_cmd" 2>&1) || exit_code=$?
        peak_memory=$(echo "$time_output" | grep "Maximum resident set size" | awk '{print $NF}' || echo "0")
    else
        eval "$build_cmd" > /tmp/build.log 2>&1 || exit_code=$?
    fi

    end_time=$(date +%s%3N 2>/dev/null || echo $(($(date +%s) * 1000)))

    # Calculate duration
    duration_ms=$((end_time - start_time))

    # Record memory after build
    memory_after=$(get_memory_usage)

    # Calculate memory used during build
    if [ "$peak_memory" = "0" ]; then
        peak_memory=$((memory_after - memory_before))
        if [ "$peak_memory" -lt 0 ]; then
            peak_memory=0
        fi
    fi

    # Count output files
    local output_dir=""
    for dir in public _site output build dist; do
        if [ -d "$dir" ]; then
            output_dir="$dir"
            break
        fi
    done

    local file_count=0
    if [ -n "$output_dir" ]; then
        file_count=$(find "$output_dir" -type f | wc -l)
    fi

    # Build result JSON
    local status="success"
    if [ $exit_code -ne 0 ]; then
        status="failed"
    fi

    local result_json=$(cat << EOF
{
    "ssg": "${SSG}",
    "build_time_ms": ${duration_ms},
    "peak_memory_kb": ${peak_memory},
    "output_files": ${file_count},
    "exit_code": ${exit_code},
    "status": "${status}",
    "timestamp": "$(date -Iseconds 2>/dev/null || date)",
    "build_command": "${build_cmd}"
}
EOF
)

    # Output results
    log "Build completed in ${duration_ms}ms"
    log "Peak memory: ${peak_memory}KB"
    log "Output files: ${file_count}"
    log "Status: ${status}"

    # Save to file if output path specified
    if [ -n "$OUTPUT_FILE" ]; then
        mkdir -p "$(dirname "$OUTPUT_FILE")" 2>/dev/null || true
        echo "$result_json" > "$OUTPUT_FILE"
        log "Results saved to ${OUTPUT_FILE}"
    fi

    # Also output to stdout for capture
    echo "---BENCHMARK_RESULT---"
    echo "$result_json"
    echo "---END_RESULT---"

    if [ $exit_code -ne 0 ]; then
        log_error "Build failed with exit code ${exit_code}"
        exit $exit_code
    fi

    log_success "Benchmark completed successfully!"
}

# Install dependencies if needed (for Jekyll)
install_dependencies() {
    if [ -f "$SITE_DIR/Gemfile" ]; then
        log "Installing Ruby dependencies..."
        cd "$SITE_DIR"
        bundle install --quiet 2>/dev/null || bundle install
    fi
}

# Main
main() {
    log "SSG Benchmark Runner"
    log "===================="

    # Install dependencies
    install_dependencies

    # Detect build command
    local build_cmd=$(detect_build_command)

    if [ -z "$build_cmd" ]; then
        log_error "No build command specified or detected"
        exit 1
    fi

    # Run benchmark
    run_benchmark "$build_cmd"
}

main "$@"
