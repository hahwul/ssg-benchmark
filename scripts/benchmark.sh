#!/usr/bin/env bash
#
# SSG Benchmark - Main Benchmark Runner
# Measures build performance across multiple static site generators
#

# Don't use set -e to allow graceful error handling
# set -e

# Cross-platform millisecond timestamp function
get_timestamp_ms() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: use perl for millisecond precision
        perl -MTime::HiRes=time -e 'printf "%.0f", time * 1000'
    elif date +%s%3N 2>/dev/null | grep -qE '^[0-9]+$'; then
        # Linux with millisecond support
        date +%s%3N
    else
        # Fallback: seconds * 1000
        echo $(($(date +%s) * 1000))
    fi
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="${PROJECT_DIR}/results"
SITES_DIR="${PROJECT_DIR}/sites"
DOCKER_DIR="${PROJECT_DIR}/docker"

# Benchmark settings
DEFAULT_PAGE_COUNTS="10 100 1000 5000"
DEFAULT_ITERATIONS=3
DEFAULT_SSGS="hugo zola jekyll blades hwaro"

# Parse command line arguments
PAGE_COUNTS="${PAGE_COUNTS:-$DEFAULT_PAGE_COUNTS}"
ITERATIONS="${ITERATIONS:-$DEFAULT_ITERATIONS}"
SSGS="${SSGS:-$DEFAULT_SSGS}"
USE_DOCKER="${USE_DOCKER:-true}"
VERBOSE="${VERBOSE:-false}"

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --ssgs LIST          Comma-separated list of SSGs to benchmark"
    echo "                           (default: hugo,zola,jekyll,blades,hwaro)"
    echo "  -p, --pages LIST         Comma-separated list of page counts"
    echo "                           (default: 10,100,1000,5000)"
    echo "  -i, --iterations N       Number of iterations per benchmark (default: 3)"
    echo "  -d, --no-docker          Run benchmarks without Docker (requires local installs)"
    echo "  -v, --verbose            Enable verbose output"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  PAGE_COUNTS              Space-separated list of page counts"
    echo "  ITERATIONS               Number of iterations"
    echo "  SSGS                     Space-separated list of SSGs"
    echo "  USE_DOCKER               'true' or 'false'"
    echo ""
    echo "Examples:"
    echo "  $0 -s hugo,zola -p 100,1000 -i 5"
    echo "  $0 --no-docker --verbose"
}

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--ssgs)
            SSGS=$(echo "$2" | tr ',' ' ')
            shift 2
            ;;
        -p|--pages)
            PAGE_COUNTS=$(echo "$2" | tr ',' ' ')
            shift 2
            ;;
        -i|--iterations)
            ITERATIONS="$2"
            shift 2
            ;;
        -d|--no-docker)
            USE_DOCKER="false"
            shift
            ;;
        -v|--verbose)
            VERBOSE="true"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Create results directory with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BENCHMARK_RESULTS_DIR="${RESULTS_DIR}/${TIMESTAMP}"
mkdir -p "$BENCHMARK_RESULTS_DIR"

# Results file
RESULTS_FILE="${BENCHMARK_RESULTS_DIR}/results.csv"
SUMMARY_FILE="${BENCHMARK_RESULTS_DIR}/summary.md"

# Initialize results CSV
echo "ssg,page_count,iteration,build_time_ms,peak_memory_kb,cpu_percent,status" > "$RESULTS_FILE"

log "Starting SSG Benchmark"
log "Results will be saved to: ${BENCHMARK_RESULTS_DIR}"
log "SSGs: ${SSGS}"
log "Page counts: ${PAGE_COUNTS}"
log "Iterations: ${ITERATIONS}"
log "Using Docker: ${USE_DOCKER}"

# Check Docker availability if needed
if [ "$USE_DOCKER" = "true" ]; then
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        log_error "Please install Docker or use --no-docker flag"
        exit 1
    fi
    log "Docker version: $(docker --version)"
fi

# Track which Docker images are available (using simple variables instead of associative array for compatibility)
DOCKER_IMAGES_AVAILABLE=""

# Build Docker images if using Docker
build_docker_images() {
    log "Building Docker images..."
    for ssg in $SSGS; do
        dockerfile="${DOCKER_DIR}/Dockerfile.${ssg}"
        if [ -f "$dockerfile" ]; then
            log "Building image for ${ssg}..."
            if docker build -t "ssg-benchmark-${ssg}" -f "$dockerfile" "$PROJECT_DIR" > "${RESULTS_DIR}/docker_build_${ssg}.log" 2>&1; then
                log_success "Built image: ssg-benchmark-${ssg}"
                DOCKER_IMAGES_AVAILABLE="${DOCKER_IMAGES_AVAILABLE} ${ssg}"
            else
                log_warn "Failed to build image for ${ssg}, will try local binary..."
            fi
        else
            log_warn "No Dockerfile found for ${ssg} at ${dockerfile}"
        fi
    done
}

# Check if Docker image is available for SSG
is_docker_image_available() {
    local ssg=$1
    echo "$DOCKER_IMAGES_AVAILABLE" | grep -qw "$ssg"
}

# Check if SSG is available (either Docker image or local binary)
is_ssg_available() {
    local ssg=$1

    if [ "$USE_DOCKER" = "true" ] && is_docker_image_available "$ssg"; then
        return 0
    fi

    # Check for local binary
    if command -v "$ssg" &> /dev/null; then
        return 0
    fi

    # Special cases for command names
    case $ssg in
        jekyll)
            if command -v bundle &> /dev/null; then
                return 0
            fi
            ;;
    esac

    return 1
}

# Generate test content for an SSG
generate_content() {
    local ssg=$1
    local page_count=$2
    local target_dir=$3

    log "Generating ${page_count} pages for ${ssg}..."

    "${SCRIPT_DIR}/generate-content.sh" \
        --ssg "$ssg" \
        --count "$page_count" \
        --output "$target_dir"
}

# Run benchmark with Docker
run_docker_benchmark() {
    local ssg=$1
    local site_dir=$2
    local iteration=$3

    local container_name="ssg-bench-${ssg}-$$"
    local start_time
    local end_time
    local build_time
    local memory_stats
    local peak_memory=0
    local cpu_percent=0
    local status="success"

    # Build command based on SSG
    local build_cmd
    case $ssg in
        hugo)
            build_cmd="hugo --minify"
            ;;
        zola)
            build_cmd="zola build"
            ;;
        jekyll)
            build_cmd="bundle exec jekyll build"
            ;;
        blades)
            build_cmd="blades"
            ;;
        hwaro)
            build_cmd="hwaro build"
            ;;
        *)
            build_cmd="${ssg} build"
            ;;
    esac

    # Check if Docker image exists
    if ! docker image inspect "ssg-benchmark-${ssg}" &>/dev/null; then
        log_warn "Docker image for ${ssg} not available, trying local binary..."
        # Fall back to local benchmark
        result=$(run_local_benchmark "$ssg" "$site_dir" "$iteration")
        echo "$result"
        return
    fi

    # Run container with resource monitoring
    start_time=$(get_timestamp_ms)

    if docker run --rm \
        --name "$container_name" \
        --memory="4g" \
        --cpus="2" \
        -v "${site_dir}:/site:rw" \
        "ssg-benchmark-${ssg}" \
        sh -c "$build_cmd" > "${BENCHMARK_RESULTS_DIR}/${ssg}_${iteration}.log" 2>&1; then
        status="success"
    else
        status="failed"
    fi

    end_time=$(get_timestamp_ms)
    build_time=$((end_time - start_time))

    # Note: Getting accurate memory/CPU stats from Docker requires docker stats
    # which is complex for one-shot containers. For accurate stats, we'd need
    # to run the container in detached mode and poll docker stats.
    # This is a simplified version.

    echo "${build_time},${peak_memory},${cpu_percent},${status}"
}

# Run benchmark without Docker (local installation)
run_local_benchmark() {
    local ssg=$1
    local site_dir=$2
    local iteration=$3

    local start_time
    local end_time
    local build_time
    local peak_memory=0
    local cpu_percent=0
    local status="success"
    local time_output

    # Build command based on SSG
    local build_cmd
    case $ssg in
        hugo)
            build_cmd="hugo --minify"
            ;;
        zola)
            build_cmd="zola build"
            ;;
        jekyll)
            build_cmd="bundle exec jekyll build"
            ;;
        blades)
            build_cmd="blades"
            ;;
        hwaro)
            build_cmd="hwaro build"
            ;;
        *)
            build_cmd="${ssg} build"
            ;;
    esac

    cd "$site_dir"

    # Measure build time
    start_time=$(get_timestamp_ms)

    # Try to use gtime on macOS or /usr/bin/time on Linux for memory measurement
    if [ "$(uname)" = "Darwin" ] && command -v gtime &> /dev/null; then
        # macOS with GNU time installed (brew install gnu-time)
        time_output=$(gtime -v $build_cmd 2>&1 || echo "FAILED")
        if echo "$time_output" | grep -q "FAILED"; then
            status="failed"
        fi
        peak_memory=$(echo "$time_output" | grep "Maximum resident set size" | awk '{print $NF}' || echo "0")
    elif [ "$(uname)" != "Darwin" ] && command -v /usr/bin/time &> /dev/null; then
        # Linux with GNU time
        time_output=$(/usr/bin/time -v $build_cmd 2>&1 || echo "FAILED")
        if echo "$time_output" | grep -q "FAILED"; then
            status="failed"
        fi
        peak_memory=$(echo "$time_output" | grep "Maximum resident set size" | awk '{print $NF}' || echo "0")
    else
        # Fallback: just measure time without memory stats
        if ! $build_cmd > "${BENCHMARK_RESULTS_DIR}/${ssg}_${iteration}.log" 2>&1; then
            status="failed"
        fi
    fi

    end_time=$(get_timestamp_ms)
    build_time=$((end_time - start_time))

    cd - > /dev/null

    echo "${build_time},${peak_memory},${cpu_percent},${status}"
}

# Main benchmark loop
run_benchmarks() {
    local benchmarked_count=0

    for ssg in $SSGS; do
        log "Benchmarking: ${ssg}"

        # Check if SSG is available
        if [ "$USE_DOCKER" = "true" ]; then
            if ! is_docker_image_available "$ssg" && ! command -v "$ssg" &> /dev/null; then
                log_warn "Skipping ${ssg}: No Docker image and no local binary available"
                continue
            fi
        else
            if ! command -v "$ssg" &> /dev/null; then
                # Check special cases
                case $ssg in
                    jekyll)
                        if ! command -v bundle &> /dev/null; then
                            log_warn "Skipping ${ssg}: binary not found"
                            continue
                        fi
                        ;;
                    *)
                        log_warn "Skipping ${ssg}: binary not found"
                        continue
                        ;;
                esac
            fi
        fi

        for page_count in $PAGE_COUNTS; do
            log "  Testing with ${page_count} pages..."

            # Create temporary site directory
            temp_site_dir=$(mktemp -d)

            # Copy base site template
            if [ -d "${SITES_DIR}/${ssg}" ]; then
                cp -r "${SITES_DIR}/${ssg}/"* "$temp_site_dir/" 2>/dev/null || true
            fi

            # Generate content
            generate_content "$ssg" "$page_count" "$temp_site_dir"

            for iteration in $(seq 1 "$ITERATIONS"); do
                log "    Iteration ${iteration}/${ITERATIONS}..."

                # Clean previous build output
                rm -rf "${temp_site_dir}/public" "${temp_site_dir}/_site" "${temp_site_dir}/output" 2>/dev/null || true

                # Run benchmark
                if [ "$USE_DOCKER" = "true" ]; then
                    result=$(run_docker_benchmark "$ssg" "$temp_site_dir" "$iteration")
                else
                    result=$(run_local_benchmark "$ssg" "$temp_site_dir" "$iteration")
                fi

                # Parse result
                build_time=$(echo "$result" | cut -d',' -f1)
                peak_memory=$(echo "$result" | cut -d',' -f2)
                cpu_percent=$(echo "$result" | cut -d',' -f3)
                status=$(echo "$result" | cut -d',' -f4)

                # Record result
                echo "${ssg},${page_count},${iteration},${build_time},${peak_memory},${cpu_percent},${status}" >> "$RESULTS_FILE"

                if [ "$VERBOSE" = "true" ]; then
                    log "      Build time: ${build_time}ms, Memory: ${peak_memory}KB, Status: ${status}"
                fi
            done

            # Cleanup temporary directory
            rm -rf "$temp_site_dir"
        done

        log_success "Completed benchmarks for ${ssg}"
        benchmarked_count=$((benchmarked_count + 1))
    done

    if [ $benchmarked_count -eq 0 ]; then
        log_warn "No SSGs were benchmarked. Check Docker images or local installations."
    fi
}

# Generate summary report
generate_summary() {
    log "Generating summary report..."

    cat > "$SUMMARY_FILE" << 'EOF'
# SSG Benchmark Results

EOF

    echo "**Generated:** $(date)" >> "$SUMMARY_FILE"
    echo "**SSGs tested:** ${SSGS}" >> "$SUMMARY_FILE"
    echo "**Page counts:** ${PAGE_COUNTS}" >> "$SUMMARY_FILE"
    echo "**Iterations:** ${ITERATIONS}" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"

    echo "## Results Summary" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo "| SSG | Pages | Avg Build Time (ms) | Min | Max | Avg Memory (KB) |" >> "$SUMMARY_FILE"
    echo "|-----|-------|---------------------|-----|-----|-----------------|" >> "$SUMMARY_FILE"

    # Calculate averages from CSV
    for ssg in $SSGS; do
        for page_count in $PAGE_COUNTS; do
            # Extract matching rows and calculate stats
            rows=$(grep "^${ssg},${page_count}," "$RESULTS_FILE" | grep ",success$")
            if [ -n "$rows" ]; then
                times=$(echo "$rows" | cut -d',' -f4)
                memories=$(echo "$rows" | cut -d',' -f5)

                avg_time=$(echo "$times" | awk '{sum+=$1; count++} END {if(count>0) printf "%.0f", sum/count; else print "N/A"}')
                min_time=$(echo "$times" | sort -n | head -1)
                max_time=$(echo "$times" | sort -n | tail -1)
                avg_memory=$(echo "$memories" | awk '{sum+=$1; count++} END {if(count>0) printf "%.0f", sum/count; else print "N/A"}')

                echo "| ${ssg} | ${page_count} | ${avg_time} | ${min_time} | ${max_time} | ${avg_memory} |" >> "$SUMMARY_FILE"
            fi
        done
    done

    echo "" >> "$SUMMARY_FILE"
    echo "## Raw Data" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo "See \`results.csv\` for complete benchmark data." >> "$SUMMARY_FILE"

    log_success "Summary saved to: ${SUMMARY_FILE}"
}

# Main execution
main() {
    log "Initializing benchmark environment..."

    # Build Docker images if using Docker
    if [ "$USE_DOCKER" = "true" ]; then
        build_docker_images
    fi

    # Run benchmarks
    run_benchmarks

    # Generate summary
    generate_summary

    log_success "Benchmark complete!"
    log "Results saved to: ${BENCHMARK_RESULTS_DIR}"

    # Print quick summary
    echo ""
    echo "=========================================="
    echo "         BENCHMARK RESULTS SUMMARY"
    echo "=========================================="
    cat "$SUMMARY_FILE"
}

main "$@"

# Always exit successfully if we got this far
exit 0
