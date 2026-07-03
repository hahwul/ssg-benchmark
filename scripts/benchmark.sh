#!/usr/bin/env bash
#
# SSG Benchmark - Main Benchmark Runner (methodology v2)
#
# Measurement principles:
#   - Build time is measured INSIDE the container (excludes container
#     start/stop, image load, and host-side volume setup).
#   - Peak memory comes from the container's cgroup (whole process tree).
#   - Every (ssg, scenario, page_count) gets one unrecorded warmup build.
#   - Build outputs AND caches (.jekyll-cache, .cache, .docusaurus, db.json,
#     resources, ...) are removed between iterations: every build is cold.
#   - Output HTML files are counted per iteration; the summary flags SSGs
#     whose counts diverge (workload-parity guard).
#   - Content is deterministic (SEED) and byte-identical across SSGs.
#
# Scenarios: minimal (default) | blog | heavy — see METHODOLOGY.md.

# Don't use set -e to allow graceful error handling

# Cross-platform millisecond timestamp (host side, used for logs only)
get_timestamp_ms() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        perl -MTime::HiRes=time -e 'printf "%.0f", time * 1000'
    elif date +%s%3N 2>/dev/null | grep -qE '^[0-9]+$'; then
        date +%s%3N
    else
        echo $(($(date +%s) * 1000))
    fi
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="${PROJECT_DIR}/results"
SITES_DIR="${PROJECT_DIR}/sites"
SCENARIOS_DIR="${PROJECT_DIR}/scenarios"
DOCKER_DIR="${PROJECT_DIR}/docker"

# Benchmark settings
DEFAULT_PAGE_COUNTS="10 100 1000 5000"
DEFAULT_ITERATIONS=3
DEFAULT_SSGS="hugo zola jekyll blades hwaro eleventy pelican hexo gatsby astro docusaurus"
DEFAULT_SCENARIOS="minimal"

PAGE_COUNTS="${PAGE_COUNTS:-$DEFAULT_PAGE_COUNTS}"
ITERATIONS="${ITERATIONS:-$DEFAULT_ITERATIONS}"
WARMUP="${WARMUP:-1}"
SSGS="${SSGS:-$DEFAULT_SSGS}"
SCENARIOS="${SCENARIOS:-$DEFAULT_SCENARIOS}"
USE_DOCKER="${USE_DOCKER:-true}"
VERBOSE="${VERBOSE:-false}"
SEED="${SEED:-42}"
DOCKER_CPUS="${DOCKER_CPUS:-4}"
DOCKER_MEMORY="${DOCKER_MEMORY:-4g}"

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --ssgs LIST          Comma-separated list of SSGs to benchmark"
    echo "  -p, --pages LIST         Comma-separated list of page counts (default: 10,100,1000,5000)"
    echo "  -n, --scenarios LIST     Comma-separated scenarios: minimal,blog,heavy (default: minimal)"
    echo "  -i, --iterations N       Recorded iterations per benchmark (default: 3)"
    echo "  -w, --warmup N           Unrecorded warmup builds (default: 1)"
    echo "  -d, --no-docker          Run without Docker (requires local installs)"
    echo "  -v, --verbose            Enable verbose output"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  PAGE_COUNTS, ITERATIONS, WARMUP, SSGS, SCENARIOS, USE_DOCKER, SEED,"
    echo "  DOCKER_CPUS (default 4), DOCKER_MEMORY (default 4g)"
    echo ""
    echo "Examples:"
    echo "  $0 -s hugo,zola -p 100,1000 -i 5"
    echo "  $0 -n minimal,blog,heavy -s hugo,zola,hwaro"
}

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--ssgs) SSGS=$(echo "$2" | tr ',' ' '); shift 2 ;;
        -p|--pages) PAGE_COUNTS=$(echo "$2" | tr ',' ' '); shift 2 ;;
        -n|--scenarios) SCENARIOS=$(echo "$2" | tr ',' ' '); shift 2 ;;
        -i|--iterations) ITERATIONS="$2"; shift 2 ;;
        -w|--warmup) WARMUP="$2"; shift 2 ;;
        -d|--no-docker) USE_DOCKER="false"; shift ;;
        -v|--verbose) VERBOSE="true"; shift ;;
        -h|--help) usage; exit 0 ;;
        *) log_error "Unknown option: $1"; usage; exit 1 ;;
    esac
done

# Create results directory with timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BENCHMARK_RESULTS_DIR="${RESULTS_DIR}/${TIMESTAMP}"
mkdir -p "$BENCHMARK_RESULTS_DIR"

RESULTS_FILE="${BENCHMARK_RESULTS_DIR}/results.csv"
SUMMARY_FILE="${BENCHMARK_RESULTS_DIR}/summary.md"

# CSV schema v2 (scenario + output_files; memory is real; no fake cpu column)
echo "ssg,scenario,page_count,iteration,build_time_ms,peak_memory_kb,output_files,status" > "$RESULTS_FILE"

log "Starting SSG Benchmark (methodology v2)"
log "Results dir: ${BENCHMARK_RESULTS_DIR}"
log "SSGs: ${SSGS}"
log "Scenarios: ${SCENARIOS}"
log "Page counts: ${PAGE_COUNTS}"
log "Iterations: ${ITERATIONS} (+${WARMUP} warmup)"
log "Using Docker: ${USE_DOCKER} (cpus=${DOCKER_CPUS}, memory=${DOCKER_MEMORY})"
log "Content seed: ${SEED}"

if [ "$USE_DOCKER" = "true" ]; then
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH (use --no-docker for local mode)"
        exit 1
    fi
    log "Docker version: $(docker --version)"
fi

# =============================================================================
# Scenario support matrix
# =============================================================================
# blog/heavy require native (or image-preinstalled) tag pages, pagination and
# feeds so that every SSG performs the same work. SSGs where that would need
# bespoke app code (gatsby, astro) or that cannot match the workload
# (docusaurus, blades) run the minimal scenario only. See METHODOLOGY.md.

scenario_supported() {
    local ssg=$1 scenario=$2
    case $scenario in
        minimal) return 0 ;;
        blog|heavy)
            case $ssg in
                hugo|zola|jekyll|hwaro|eleventy|pelican|hexo) return 0 ;;
                *) return 1 ;;
            esac
            ;;
        *) return 1 ;;
    esac
}

# Where each SSG writes its build output (relative to the site root)
output_dir_for() {
    case $1 in
        jekyll|eleventy) echo "_site" ;;
        pelican) echo "output" ;;
        astro) echo "dist" ;;
        docusaurus) echo "build" ;;
        *) echo "public" ;;
    esac
}

build_cmd_for() {
    case $1 in
        hugo) echo "hugo --noBuildLock" ;;
        zola) echo "zola build" ;;
        jekyll) echo "bundle exec jekyll build" ;;
        blades) echo "blades" ;;
        hwaro) echo "hwaro build" ;;
        eleventy) echo "eleventy" ;;
        pelican) echo "pelican content -s pelicanconf.py" ;;
        hexo) echo "hexo generate" ;;
        gatsby) echo "gatsby build" ;;
        astro) echo "npx astro build" ;;
        docusaurus) echo "npx docusaurus build" ;;
        *) echo "$1 build" ;;
    esac
}

# =============================================================================
# Docker image management
# =============================================================================

DOCKER_IMAGES_AVAILABLE=""

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

is_docker_image_available() {
    echo "$DOCKER_IMAGES_AVAILABLE" | grep -qw "$1"
}

# =============================================================================
# Site assembly: base template + scenario overlay + generated content
# =============================================================================

assemble_site() {
    local ssg=$1 scenario=$2 page_count=$3 target_dir=$4

    if [ -d "${SITES_DIR}/${ssg}" ]; then
        cp -a "${SITES_DIR}/${ssg}/." "$target_dir/" 2>/dev/null || true
    fi

    # Scenario overlay replaces configs / adds templates on top of the base
    if [ "$scenario" != "minimal" ] && [ -d "${SCENARIOS_DIR}/${scenario}/${ssg}" ]; then
        cp -a "${SCENARIOS_DIR}/${scenario}/${ssg}/." "$target_dir/" 2>/dev/null || true
    fi

    SEED="$SEED" "${SCRIPT_DIR}/generate-content.sh" \
        --ssg "$ssg" \
        --count "$page_count" \
        --scenario "$scenario" \
        --output "$target_dir"
}

# Remove build outputs AND caches so every iteration is a cold build
clean_build_artifacts() {
    local site_dir=$1
    rm -rf \
        "${site_dir}/public" \
        "${site_dir}/_site" \
        "${site_dir}/output" \
        "${site_dir}/build" \
        "${site_dir}/dist" \
        "${site_dir}/.jekyll-cache" \
        "${site_dir}/.jekyll-metadata" \
        "${site_dir}/.cache" \
        "${site_dir}/.docusaurus" \
        "${site_dir}/db.json" \
        "${site_dir}/resources" \
        "${site_dir}/.hugo_build.lock" \
        "${site_dir}/node_modules/.cache" \
        2>/dev/null || true
}

count_output_html() {
    local site_dir=$1 ssg=$2 out_dir
    out_dir="${site_dir}/$(output_dir_for "$ssg")"
    if [ -d "$out_dir" ]; then
        find "$out_dir" -type f -name '*.html' | wc -l | tr -d ' '
    else
        echo 0
    fi
}

# The measurement script that runs INSIDE the container. It writes elapsed
# time, cgroup peak memory and the build's exit code into /site/.bench/.
write_bench_script() {
    local site_dir=$1 build_cmd=$2
    mkdir -p "${site_dir}/.bench"
    cat > "${site_dir}/.bench/run.sh" << EOF
#!/bin/sh
# Generated by benchmark.sh — measures only the build command, inside the container.
cd /site
now_ms() {
    t=\$(date +%s%N 2>/dev/null)
    case "\$t" in
        ''|*[!0-9]*) echo \$(( \$(date +%s) * 1000 )) ;;
        *) echo \$(( t / 1000000 )) ;;
    esac
}
rm -f /site/.bench/rc /site/.bench/elapsed_ms /site/.bench/mem_peak_kb
start=\$(now_ms)
sh -c '${build_cmd}' > /site/.bench/build.log 2>&1
rc=\$?
end=\$(now_ms)
echo \$rc > /site/.bench/rc
echo \$(( end - start )) > /site/.bench/elapsed_ms
peak=0
if [ -r /sys/fs/cgroup/memory.peak ]; then
    peak=\$(cat /sys/fs/cgroup/memory.peak)
elif [ -r /sys/fs/cgroup/memory/memory.max_usage_in_bytes ]; then
    peak=\$(cat /sys/fs/cgroup/memory/memory.max_usage_in_bytes)
fi
case "\$peak" in ''|*[!0-9]*) peak=0 ;; esac
echo \$(( peak / 1024 )) > /site/.bench/mem_peak_kb
exit 0
EOF
    chmod +x "${site_dir}/.bench/run.sh"
}

# =============================================================================
# Benchmark execution
# =============================================================================

# Echoes: build_time_ms,peak_memory_kb,status
run_docker_benchmark() {
    local ssg=$1 site_dir=$2 label=$3
    local container_name="ssg-bench-${ssg}-$$"
    local build_time=0 peak_memory=0 status="success" rc

    docker run --rm \
        --name "$container_name" \
        --memory="$DOCKER_MEMORY" \
        --cpus="$DOCKER_CPUS" \
        -v "${site_dir}:/site:rw" \
        "ssg-benchmark-${ssg}" \
        sh /site/.bench/run.sh > "${BENCHMARK_RESULTS_DIR}/${label}.container.log" 2>&1

    if [ -f "${site_dir}/.bench/elapsed_ms" ]; then
        build_time=$(cat "${site_dir}/.bench/elapsed_ms" 2>/dev/null || echo 0)
        peak_memory=$(cat "${site_dir}/.bench/mem_peak_kb" 2>/dev/null || echo 0)
        rc=$(cat "${site_dir}/.bench/rc" 2>/dev/null || echo 1)
        [ "$rc" = "0" ] || status="failed"
    else
        status="failed"
    fi

    # Preserve the build log for debugging
    cp "${site_dir}/.bench/build.log" "${BENCHMARK_RESULTS_DIR}/${label}.log" 2>/dev/null || true

    echo "${build_time},${peak_memory},${status}"
}

# Echoes: build_time_ms,peak_memory_kb,status
run_local_benchmark() {
    local ssg=$1 site_dir=$2 label=$3
    local build_cmd start_time end_time build_time peak_memory=0 status="success" time_output

    build_cmd=$(build_cmd_for "$ssg")

    cd "$site_dir" || { echo "0,0,failed"; return; }
    start_time=$(get_timestamp_ms)

    if [ "$(uname)" = "Darwin" ] && command -v gtime &> /dev/null; then
        time_output=$(gtime -v sh -c "$build_cmd" 2>&1) || status="failed"
        echo "$time_output" > "${BENCHMARK_RESULTS_DIR}/${label}.log"
        peak_memory=$(echo "$time_output" | grep "Maximum resident set size" | awk '{print $NF}' || echo "0")
    elif [ "$(uname)" != "Darwin" ] && command -v /usr/bin/time &> /dev/null; then
        time_output=$(/usr/bin/time -v sh -c "$build_cmd" 2>&1) || status="failed"
        echo "$time_output" > "${BENCHMARK_RESULTS_DIR}/${label}.log"
        peak_memory=$(echo "$time_output" | grep "Maximum resident set size" | awk '{print $NF}' || echo "0")
    else
        if ! sh -c "$build_cmd" > "${BENCHMARK_RESULTS_DIR}/${label}.log" 2>&1; then
            status="failed"
        fi
    fi

    end_time=$(get_timestamp_ms)
    build_time=$((end_time - start_time))
    [ -n "$peak_memory" ] || peak_memory=0

    cd - > /dev/null || true
    echo "${build_time},${peak_memory},${status}"
}

run_one_build() {
    local ssg=$1 site_dir=$2 label=$3
    if [ "$USE_DOCKER" = "true" ] && is_docker_image_available "$ssg"; then
        run_docker_benchmark "$ssg" "$site_dir" "$label"
    else
        run_local_benchmark "$ssg" "$site_dir" "$label"
    fi
}

is_ssg_runnable() {
    local ssg=$1
    if [ "$USE_DOCKER" = "true" ] && is_docker_image_available "$ssg"; then
        return 0
    fi
    if command -v "$ssg" &> /dev/null; then
        return 0
    fi
    case $ssg in
        jekyll) command -v bundle &> /dev/null && return 0 ;;
    esac
    return 1
}

run_benchmarks() {
    local benchmarked_count=0

    for scenario in $SCENARIOS; do
        log "=== Scenario: ${scenario} ==="

        for ssg in $SSGS; do
            if ! is_ssg_runnable "$ssg"; then
                log_warn "Skipping ${ssg}: no Docker image and no local binary"
                continue
            fi
            if ! scenario_supported "$ssg" "$scenario"; then
                log_warn "Skipping ${ssg} for scenario '${scenario}': not in support matrix (see METHODOLOGY.md)"
                continue
            fi

            log "Benchmarking: ${ssg} (${scenario})"

            for page_count in $PAGE_COUNTS; do
                log "  Testing with ${page_count} pages..."

                temp_site_dir=$(mktemp -d)
                assemble_site "$ssg" "$scenario" "$page_count" "$temp_site_dir"
                write_bench_script "$temp_site_dir" "$(build_cmd_for "$ssg")"

                # Install npm dependencies for node-based SSGs (outside timing)
                if [ "$USE_DOCKER" = "true" ] && [ -f "${temp_site_dir}/package.json" ]; then
                    case $ssg in
                        gatsby|astro|docusaurus|hexo)
                            log "    Installing npm dependencies in Docker..."
                            docker run --rm -v "${temp_site_dir}:/site:rw" "ssg-benchmark-${ssg}" \
                                sh -c "cd /site && npm install" \
                                > "${BENCHMARK_RESULTS_DIR}/${ssg}_${scenario}_${page_count}_npm.log" 2>&1 || true
                            ;;
                    esac
                fi

                # Warmup builds: warm OS page cache / JIT, results discarded
                # (BSD seq counts down for "seq 1 0", so guard explicitly)
                w=1
                while [ "$w" -le "$WARMUP" ]; do
                    log "    Warmup ${w}/${WARMUP}..."
                    clean_build_artifacts "$temp_site_dir"
                    run_one_build "$ssg" "$temp_site_dir" "${ssg}_${scenario}_${page_count}_warmup${w}" > /dev/null
                    w=$((w + 1))
                done

                for iteration in $(seq 1 "$ITERATIONS"); do
                    log "    Iteration ${iteration}/${ITERATIONS}..."
                    clean_build_artifacts "$temp_site_dir"

                    result=$(run_one_build "$ssg" "$temp_site_dir" "${ssg}_${scenario}_${page_count}_${iteration}")
                    build_time=$(echo "$result" | cut -d',' -f1)
                    peak_memory=$(echo "$result" | cut -d',' -f2)
                    status=$(echo "$result" | cut -d',' -f3)
                    output_files=$(count_output_html "$temp_site_dir" "$ssg")

                    if [ "$status" = "success" ] && [ "$output_files" -lt "$page_count" ]; then
                        log_warn "      ${ssg} built only ${output_files} HTML files for ${page_count} pages"
                        status="undercount"
                    fi

                    echo "${ssg},${scenario},${page_count},${iteration},${build_time},${peak_memory},${output_files},${status}" >> "$RESULTS_FILE"

                    if [ "$VERBOSE" = "true" ]; then
                        log "      Time: ${build_time}ms, Mem: ${peak_memory}KB, HTML files: ${output_files}, Status: ${status}"
                    fi
                done

                rm -rf "$temp_site_dir"
            done

            log_success "Completed benchmarks for ${ssg} (${scenario})"
            benchmarked_count=$((benchmarked_count + 1))
        done
    done

    if [ $benchmarked_count -eq 0 ]; then
        log_warn "No SSGs were benchmarked. Check Docker images or local installations."
    fi
}

# =============================================================================
# Run metadata + summary (median-based, with output-count parity check)
# =============================================================================

write_run_metadata() {
    local docker_version=""
    if command -v docker &>/dev/null; then
        docker_version=$(docker --version 2>/dev/null | sed 's/"/\\"/g')
    fi
    cat > "${BENCHMARK_RESULTS_DIR}/config.json" << EOF
{
  "methodology": 2,
  "timestamp": "${TIMESTAMP}",
  "scenarios": "$(echo $SCENARIOS)",
  "ssgs": "$(echo $SSGS)",
  "page_counts": "$(echo $PAGE_COUNTS)",
  "iterations": ${ITERATIONS},
  "warmup": ${WARMUP},
  "seed": ${SEED},
  "use_docker": "${USE_DOCKER}",
  "docker_cpus": "${DOCKER_CPUS}",
  "docker_memory": "${DOCKER_MEMORY}",
  "host": "$(uname -sm)",
  "docker_version": "${docker_version}"
}
EOF
}

# median of newline-separated numbers on stdin
median() {
    sort -n | awk '{ a[NR] = $1 } END {
        if (NR == 0) { print "N/A"; exit }
        if (NR % 2) { print a[(NR + 1) / 2] } else { printf "%.0f\n", (a[NR/2] + a[NR/2 + 1]) / 2 }
    }'
}

generate_summary() {
    log "Generating summary report..."

    {
        echo "# SSG Benchmark Results (methodology v2)"
        echo ""
        echo "**Generated:** $(date)"
        echo "**SSGs:** ${SSGS}"
        echo "**Scenarios:** ${SCENARIOS}"
        echo "**Page counts:** ${PAGE_COUNTS}"
        echo "**Iterations:** ${ITERATIONS} (+${WARMUP} warmup, cold builds, median reported)"
        echo "**Seed:** ${SEED} | **Docker:** cpus=${DOCKER_CPUS} mem=${DOCKER_MEMORY}"
        echo ""
    } > "$SUMMARY_FILE"

    for scenario in $SCENARIOS; do
        echo "## Scenario: ${scenario}" >> "$SUMMARY_FILE"
        echo "" >> "$SUMMARY_FILE"
        echo "| SSG | Pages | Median (ms) | Min | Max | Peak Mem (MB) | HTML files |" >> "$SUMMARY_FILE"
        echo "|-----|-------|-------------|-----|-----|----------------|------------|" >> "$SUMMARY_FILE"

        for ssg in $SSGS; do
            for page_count in $PAGE_COUNTS; do
                rows=$(awk -F',' -v s="$ssg" -v n="$scenario" -v p="$page_count" \
                    '$1==s && $2==n && $3==p && $8=="success"' "$RESULTS_FILE")
                [ -n "$rows" ] || continue

                times=$(echo "$rows" | cut -d',' -f5)
                med=$(echo "$times" | median)
                min=$(echo "$times" | sort -n | head -1)
                max=$(echo "$times" | sort -n | tail -1)
                mem_kb=$(echo "$rows" | cut -d',' -f6 | median)
                files=$(echo "$rows" | cut -d',' -f7 | median)
                if [ "$mem_kb" != "N/A" ]; then
                    mem_mb=$(awk -v m="$mem_kb" 'BEGIN { printf "%.1f", m / 1024 }')
                else
                    mem_mb="N/A"
                fi

                echo "| ${ssg} | ${page_count} | ${med} | ${min} | ${max} | ${mem_mb} | ${files} |" >> "$SUMMARY_FILE"
            done
        done
        echo "" >> "$SUMMARY_FILE"
    done

    # Workload-parity check: HTML output counts should be close across SSGs
    {
        echo "## Output parity check"
        echo ""
        echo "Median HTML file counts per (scenario, page count). Large spreads mean"
        echo "the SSGs are NOT doing comparable work — investigate before comparing times."
        echo ""
    } >> "$SUMMARY_FILE"

    local parity_warnings=0
    for scenario in $SCENARIOS; do
        for page_count in $PAGE_COUNTS; do
            local line="" min_files="" max_files=""
            for ssg in $SSGS; do
                files=$(awk -F',' -v s="$ssg" -v n="$scenario" -v p="$page_count" \
                    '$1==s && $2==n && $3==p && ($8=="success" || $8=="undercount") {print $7}' "$RESULTS_FILE" | median)
                [ "$files" = "N/A" ] && continue
                [ -n "$files" ] || continue
                line="${line} ${ssg}=${files}"
                if [ -z "$min_files" ] || [ "$files" -lt "$min_files" ]; then min_files=$files; fi
                if [ -z "$max_files" ] || [ "$files" -gt "$max_files" ]; then max_files=$files; fi
            done
            [ -n "$line" ] || continue

            local verdict="OK"
            # flag if max > min * 1.10 + 5 (absolute slack absorbs per-framework
            # structural pages: 404, feed redirects, archive index, ...)
            if [ -n "$min_files" ] && [ "$max_files" -gt $(( min_files + min_files / 10 + 5 )) ]; then
                verdict="**MISMATCH**"
                parity_warnings=$((parity_warnings + 1))
                log_warn "Output parity mismatch (${scenario}, ${page_count} pages):${line}"
            fi
            echo "- ${scenario} @ ${page_count}p:${line} → ${verdict}" >> "$SUMMARY_FILE"
        done
    done

    if [ "$parity_warnings" -eq 0 ]; then
        log_success "Output parity check passed"
    else
        log_warn "Output parity check found ${parity_warnings} mismatch(es) — see ${SUMMARY_FILE}"
    fi

    echo "" >> "$SUMMARY_FILE"
    echo "## Raw Data" >> "$SUMMARY_FILE"
    echo "" >> "$SUMMARY_FILE"
    echo "See \`results.csv\` (per-iteration) and \`config.json\` (run settings)." >> "$SUMMARY_FILE"

    log_success "Summary saved to: ${SUMMARY_FILE}"
}

# =============================================================================
# Main execution
# =============================================================================

main() {
    log "Initializing benchmark environment..."

    if [ "$USE_DOCKER" = "true" ]; then
        build_docker_images
    fi

    write_run_metadata
    run_benchmarks
    generate_summary

    log_success "Benchmark complete!"
    log "Results saved to: ${BENCHMARK_RESULTS_DIR}"

    echo ""
    echo "=========================================="
    echo "         BENCHMARK RESULTS SUMMARY"
    echo "=========================================="
    cat "$SUMMARY_FILE"
}

main "$@"

exit 0
