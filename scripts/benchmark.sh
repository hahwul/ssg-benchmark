#!/usr/bin/env bash
#
# SSG Benchmark - Main Benchmark Runner (methodology v2)
#
# Measurement principles:
#   - Build time is measured INSIDE the container (excludes container
#     start/stop, image load, and host-side volume setup).
#   - Peak memory comes from the container's cgroup (whole process tree).
#   - Every (ssg, scenario, page_count) gets one unrecorded warmup build.
#   - Iterations are interleaved round-robin across SSGs (EXEC_ORDER) so that
#     drift in host performance is shared rather than charged to one SSG.
#   - Build outputs AND caches (.jekyll-cache, .cache, .docusaurus, db.json,
#     resources, ...) are removed between iterations: every build is cold.
#   - Output HTML files are counted per iteration; the summary flags SSGs
#     whose counts diverge (workload-parity guard).
#   - Finished builds are inspected to confirm the scenario's features really
#     landed in the HTML (highlighting, tags, feed, pagination, sidebar).
#   - Content is deterministic (SEED) and byte-identical across SSGs.
#   - Timed builds run with --network=none and telemetry disabled, so no SSG
#     pays a variable network tax. Dependencies are resolved beforehand.
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
DEFAULT_PAGE_COUNTS="1000"
DEFAULT_ITERATIONS=3
DEFAULT_SSGS="hugo zola jekyll blades hwaro eleventy pelican hexo gatsby astro docusaurus"
DEFAULT_SCENARIOS="minimal blog heavy"

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
# Timed builds are network-isolated by default. Set BUILD_NETWORK=bridge only
# to debug a build that legitimately needs the network — results produced that
# way are not comparable with isolated ones.
BUILD_NETWORK="${BUILD_NETWORK:-none}"
# interleaved (default): round-robin one iteration per SSG, rotating the
# starting SSG each round, so host drift is shared evenly instead of landing on
# whoever ran during it. sequential: the old batched order — cheaper on disk,
# but reintroduces that bias.
EXEC_ORDER="${EXEC_ORDER:-interleaved}"
# Optional explicit CPU pinning, e.g. DOCKER_CPUSET=0-3. Pinning keeps every
# SSG on the same physical cores, which matters on hybrid (P/E core) hosts
# where the scheduler's choice can differ by more than the SSGs do.
DOCKER_CPUSET="${DOCKER_CPUSET:-}"
MEMORY_PRESSURE_WARNINGS=""
# Verify after building that the scenario's features are actually present in
# the output. Set STRICT_VERIFY=true to fail the run when they are not.
VERIFY_OUTPUT="${VERIFY_OUTPUT:-true}"
STRICT_VERIFY="${STRICT_VERIFY:-false}"
# Fail the run when the output-parity guard fires. Off by default so an
# exploratory run still produces its artifacts; on in CI, where a parity
# mismatch means the published comparison would be invalid.
STRICT_PARITY="${STRICT_PARITY:-false}"
PARITY_FAILED=0

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --ssgs LIST          Comma-separated list of SSGs to benchmark"
    echo "  -p, --pages LIST         Comma-separated list of page counts (default: 1000)"
    echo "  -n, --scenarios LIST     Comma-separated scenarios: minimal,blog,heavy (default: minimal,blog,heavy)"
    echo "  -i, --iterations N       Recorded iterations per benchmark (default: 3)"
    echo "  -w, --warmup N           Unrecorded warmup builds (default: 1)"
    echo "  -d, --no-docker          Run without Docker (requires local installs)"
    echo "  -v, --verbose            Enable verbose output"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  PAGE_COUNTS, ITERATIONS, WARMUP, SSGS, SCENARIOS, USE_DOCKER, SEED,"
    echo "  DOCKER_CPUS (default 4, clamped to host CPUs), DOCKER_MEMORY (default 4g),"
    echo "  DOCKER_CPUSET (optional CPU pinning, e.g. 0-3),"
    echo "  BUILD_NETWORK (default none — timed builds are network-isolated),"
    echo "  EXEC_ORDER (interleaved | sequential, default interleaved),"
    echo "  VERIFY_OUTPUT (default true), STRICT_VERIFY / STRICT_PARITY (default false)"
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

# CSV schema v2.1. post_files is appended *after* status so the column
# positions v2 readers rely on (status at field 8) are unchanged.
echo "ssg,scenario,page_count,iteration,build_time_ms,peak_memory_kb,output_files,status,post_files" > "$RESULTS_FILE"

log "Starting SSG Benchmark (methodology v2)"
log "Results dir: ${BENCHMARK_RESULTS_DIR}"
log "SSGs: ${SSGS}"
log "Scenarios: ${SCENARIOS}"
log "Page counts: ${PAGE_COUNTS}"
log "Iterations: ${ITERATIONS} (+${WARMUP} warmup)"
log "Using Docker: ${USE_DOCKER} (cpus=${DOCKER_CPUS}, memory=${DOCKER_MEMORY})"
log "Build network: ${BUILD_NETWORK}"
log "Execution order: ${EXEC_ORDER}"
log "Content seed: ${SEED}"

if [ "$USE_DOCKER" != "true" ]; then
    log_warn "Local mode: builds are NOT network-isolated and share the host's"
    log_warn "installed toolchains. Use Docker mode for comparable numbers."
fi

if [ "$USE_DOCKER" = "true" ]; then
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH (use --no-docker for local mode)"
        exit 1
    fi
    log "Docker version: $(docker --version)"
fi

host_cpu_count() {
    if command -v nproc &>/dev/null; then
        nproc
    elif [ "$(uname)" = "Darwin" ]; then
        sysctl -n hw.ncpu 2>/dev/null || echo 0
    else
        echo 0
    fi
}

# "4g" / "512m" / "2048k" / plain bytes -> KB. 0 when unparseable.
mem_to_kb() {
    echo "$1" | awk '{
        v = $0
        unit = substr(v, length(v), 1)
        n = substr(v, 1, length(v) - 1) + 0
        if (unit == "g" || unit == "G") { print int(n * 1024 * 1024) }
        else if (unit == "m" || unit == "M") { print int(n * 1024) }
        else if (unit == "k" || unit == "K") { print int(n) }
        else if (v + 0 > 0) { print int((v + 0) / 1024) }
        else { print 0 }
    }'
}

# The requested limits are only meaningful if the host can actually supply
# them. Asking for --cpus=4 on a 2-core runner does not fail; it just silently
# gives the container everything, so config.json records a limit that was never
# enforced and two hosts' numbers look comparable when they are not.
resolve_resource_limits() {
    HOST_CPUS=$(host_cpu_count)
    DOCKER_MEMORY_KB=$(mem_to_kb "$DOCKER_MEMORY")
    DOCKER_CPUS_REQUESTED="$DOCKER_CPUS"

    if [ "$USE_DOCKER" != "true" ]; then
        DOCKER_MEMORY_KB=0
        return 0
    fi

    if [ "$HOST_CPUS" -gt 0 ] 2>/dev/null; then
        if awk -v a="$DOCKER_CPUS" -v b="$HOST_CPUS" 'BEGIN { exit !(a > b) }'; then
            log_warn "DOCKER_CPUS=${DOCKER_CPUS} exceeds the host's ${HOST_CPUS} CPUs;"
            log_warn "clamping to ${HOST_CPUS} so the recorded limit is the enforced one."
            DOCKER_CPUS="$HOST_CPUS"
        fi
    else
        log_warn "Could not determine host CPU count; --cpus=${DOCKER_CPUS} is unverified."
    fi

    log "Effective limits: cpus=${DOCKER_CPUS} (host ${HOST_CPUS}), memory=${DOCKER_MEMORY} (swap disabled)"
    [ -n "$DOCKER_CPUSET" ] && log "CPU pinning: ${DOCKER_CPUSET}"
    return 0
}

resolve_resource_limits

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

# What to run inside the SSG's own image to learn which build of it we are
# about to measure. Kept tolerant: a probe that fails records "unknown" rather
# than aborting the run.
version_cmd_for() {
    case $1 in
        hugo)       echo "hugo version" ;;
        zola)       echo "zola --version" ;;
        jekyll)     echo "jekyll --version" ;;
        blades)     echo "blades --version" ;;
        hwaro)      echo "hwaro --version" ;;
        eleventy)   echo "eleventy --version" ;;
        pelican)    echo "pelican --version" ;;
        hexo)       echo "hexo version" ;;
        gatsby)     echo "gatsby --version" ;;
        astro)      echo "astro --version" ;;
        # No global CLI: the pinned version lives in the site's package.json.
        docusaurus) echo "node -e \"process.stdout.write(require('/probe/package.json').dependencies['@docusaurus/core'])\"" ;;
        *)          echo "$1 --version" ;;
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
VERSIONS_ENV="${DOCKER_DIR}/versions.env"

# Every toolchain version lives in docker/versions.env and is passed to every
# image as a --build-arg. Dockerfiles carry the same values as ARG defaults, so
# a direct `docker build` still gets pinned versions; this just keeps one file
# authoritative.
docker_build_args() {
    [ -f "$VERSIONS_ENV" ] || return 0
    while IFS= read -r entry; do
        case "$entry" in
            ''|\#*) continue ;;
            *=*) printf ' --build-arg %s' "$entry" ;;
        esac
    done < "$VERSIONS_ENV"
}

build_docker_images() {
    local build_args
    build_args=$(docker_build_args)

    if [ -f "$VERSIONS_ENV" ]; then
        log "Using pinned toolchain versions from ${VERSIONS_ENV}"
    else
        log_warn "${VERSIONS_ENV} is missing — images will fall back to Dockerfile ARG defaults"
    fi

    log "Building Docker images..."
    for ssg in $SSGS; do
        dockerfile="${DOCKER_DIR}/Dockerfile.${ssg}"
        if [ -f "$dockerfile" ]; then
            log "Building image for ${ssg}..."
            # shellcheck disable=SC2086 # build_args is a deliberately split arg list
            if docker build $build_args -t "ssg-benchmark-${ssg}" -f "$dockerfile" "$PROJECT_DIR" \
                > "${BENCHMARK_RESULTS_DIR}/docker_build_${ssg}.log" 2>&1; then
                log_success "Built image: ssg-benchmark-${ssg}"
                DOCKER_IMAGES_AVAILABLE="${DOCKER_IMAGES_AVAILABLE} ${ssg}"
            else
                log_warn "Failed to build image for ${ssg}, will try local binary..."
                log_warn "  see ${BENCHMARK_RESULTS_DIR}/docker_build_${ssg}.log"
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
# Toolchain provenance
# =============================================================================
# A benchmark number is meaningless without the version it describes. Probe
# each image once, up front, and write the answers next to the results so a
# run stays interpretable years later — and so a mispinned image is visible
# instead of silently changing the comparison.

VERSIONS_FILE=""

# Collapse a probe's output to a single tidy line.
first_line() {
    tr -d '\r' | grep -v '^[[:space:]]*$' | head -1 | cut -c1-200 \
        | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/"/\\"/g'
}

probe_in_image() {
    local ssg=$1 cmd=$2 out
    out=$(docker run --rm \
            -v "${SITES_DIR}/${ssg}:/probe:ro" \
            "ssg-benchmark-${ssg}" sh -c "$cmd" 2>/dev/null | first_line)
    [ -n "$out" ] || out="unknown"
    echo "$out"
}

record_toolchain_versions() {
    VERSIONS_FILE="${BENCHMARK_RESULTS_DIR}/versions.json"
    log "Recording toolchain versions..."

    {
        echo '{'
        echo '  "note": "Versions actually present in the images/host used for this run.",'
        echo '  "pinned": {'
        if [ -f "$VERSIONS_ENV" ]; then
            sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$VERSIONS_ENV" \
                | awk -F'=' '{ printf "    \"%s\": \"%s\",\n", $1, $2 }' \
                | sed '$ s/,$//'
        fi
        echo '  },'
        echo '  "measured": {'
    } > "$VERSIONS_FILE"

    local first=true ssg ver os runtime
    for ssg in $SSGS; do
        if [ "$USE_DOCKER" = "true" ] && is_docker_image_available "$ssg"; then
            ver=$(probe_in_image "$ssg" "$(version_cmd_for "$ssg")")
            os=$(probe_in_image "$ssg" '. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME"')
            runtime=$(probe_in_image "$ssg" 'node --version 2>/dev/null || ruby --version 2>/dev/null || python3 --version 2>/dev/null || echo native')
        elif [ "$USE_DOCKER" != "true" ]; then
            ver=$(sh -c "$(version_cmd_for "$ssg")" 2>/dev/null | first_line)
            [ -n "$ver" ] || ver="unknown"
            os=$(uname -sr)
            runtime="local"
        else
            continue
        fi

        [ "$first" = true ] && first=false || echo ',' >> "$VERSIONS_FILE"
        printf '    "%s": {"version": "%s", "base_os": "%s", "runtime": "%s"}' \
            "$ssg" "$ver" "$os" "$runtime" >> "$VERSIONS_FILE"
        log "  ${ssg}: ${ver}"
    done

    {
        echo ''
        echo '  }'
        echo '}'
    } >> "$VERSIONS_FILE"

    log_success "Toolchain versions saved to: ${VERSIONS_FILE}"
}

# Renders the measured versions as a markdown table for summary.md.
versions_table() {
    [ -n "$VERSIONS_FILE" ] && [ -f "$VERSIONS_FILE" ] || return 0
    python3 - "$VERSIONS_FILE" <<'PY' 2>/dev/null || true
import json, sys
try:
    data = json.load(open(sys.argv[1]))
except Exception:
    sys.exit(0)
measured = data.get("measured") or {}
if not measured:
    sys.exit(0)
print("## Toolchain versions")
print()
print("Exactly what was measured. Timings from runs with different versions here")
print("are not comparable, however similar the methodology.")
print()
print("| SSG | Version | Base image OS | Runtime |")
print("|-----|---------|---------------|---------|")
for ssg, info in sorted(measured.items()):
    print("| {} | {} | {} | {} |".format(
        ssg, info.get("version", "?"), info.get("base_os", "?"), info.get("runtime", "?")))
print()
PY
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

# Digest of the exact markdown bodies every SSG was fed. Recorded per run so
# two result sets can be checked for identical input rather than merely
# identical settings.
CORPUS_DIGESTS=""

record_corpus_digest() {
    local scenario=$1 page_count=$2 class dir digest
    case $scenario in
        blog|heavy) class="code" ;;
        *) class="plain" ;;
    esac
    dir="${PROJECT_DIR}/.corpus/${class}"
    [ -d "$dir" ] || return 0

    digest=$(python3 - "$dir" "$page_count" <<'PY' 2>/dev/null
import hashlib, sys, os
d, n = sys.argv[1], int(sys.argv[2])
h = hashlib.sha256()
for i in range(1, n + 1):
    p = os.path.join(d, "%05d.md" % i)
    try:
        with open(p, "rb") as fh:
            h.update(fh.read())
    except OSError:
        print("incomplete")
        raise SystemExit
print(h.hexdigest()[:16])
PY
)
    [ -n "$digest" ] || digest="unavailable"
    case "$CORPUS_DIGESTS" in
        *"${scenario}@${page_count}="*) return 0 ;;
    esac
    CORPUS_DIGESTS="${CORPUS_DIGESTS}${scenario}@${page_count}=${digest} "
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

# Confirms the finished build actually contains the scenario's features
# (highlighting, tag pages, feed, pagination, sidebar, ...). See
# scripts/verify-output.py for why counting output files is not enough.
VERIFY_FAILURES=""

verify_scenario_features() {
    local ssg=$1 site_dir=$2 scenario=$3 page_count=$4
    local out_dir report failed

    [ "$VERIFY_OUTPUT" = "true" ] || return 0
    if ! command -v python3 &>/dev/null; then
        [ -n "$VERIFY_SKIPPED_WARNED" ] || {
            log_warn "python3 not found — scenario feature verification skipped."
            VERIFY_SKIPPED_WARNED=1
        }
        return 0
    fi

    out_dir="${site_dir}/$(output_dir_for "$ssg")"
    report="${BENCHMARK_RESULTS_DIR}/verify_${ssg}_${scenario}_${page_count}.json"

    python3 "${SCRIPT_DIR}/verify-output.py" \
        --ssg "$ssg" --scenario "$scenario" \
        --output-dir "$out_dir" --pages "$page_count" > "$report" 2>/dev/null

    failed=$(python3 -c '
import json, sys
try:
    print(" ".join(json.load(open(sys.argv[1]))["failed"]))
except Exception:
    print("report-unreadable")
' "$report")

    if [ -n "$failed" ]; then
        log_warn "  ${ssg} (${scenario}) failed feature checks: ${failed}"
        VERIFY_FAILURES="${VERIFY_FAILURES}${ssg}|${scenario}|${page_count}|${failed}
"
    elif [ "$VERBOSE" = "true" ]; then
        log "  ${ssg} (${scenario}) passed all feature checks"
    fi
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

# Post pages only — the pages that correspond 1:1 with the generated corpus.
#
# The total HTML count cannot answer "did this SSG render every post?", because
# index, tag, pagination and archive pages inflate it. An SSG that rendered 900
# of 1000 posts but emitted 200 aggregate pages still totals 1100 and passes an
# `output_files < page_count` test, having done 10% less of the work that
# actually scales.
count_post_html() {
    local site_dir=$1 ssg=$2 out_dir
    out_dir="${site_dir}/$(output_dir_for "$ssg")"
    if [ -d "$out_dir" ]; then
        find "$out_dir" -type f -name '*.html' \
            | grep -cE '/post-[0-9]+(/index)?\.html$' || echo 0
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

# Environment applied to every timed build, so no SSG pays a network tax the
# others don't. Several node-based generators phone home during `build`
# (analytics pings, update-notifier checks); the latency of those requests —
# and whether they time out at all — depends on the host's connectivity that
# minute, not on the generator's speed.
build_env_flags() {
    printf '%s' \
        "-e DO_NOT_TRACK=1 " \
        "-e GATSBY_TELEMETRY_DISABLED=1 " \
        "-e ASTRO_TELEMETRY_DISABLED=1 " \
        "-e NEXT_TELEMETRY_DISABLED=1 " \
        "-e NO_UPDATE_NOTIFIER=1 " \
        "-e NPM_CONFIG_UPDATE_NOTIFIER=false " \
        "-e NPM_CONFIG_FUND=false " \
        "-e NPM_CONFIG_AUDIT=false " \
        "-e NO_COLOR=1 "
}

cpuset_flag() {
    [ -n "$DOCKER_CPUSET" ] && printf ' --cpuset-cpus=%s' "$DOCKER_CPUSET"
}

# Echoes: build_time_ms,peak_memory_kb,status
run_docker_benchmark() {
    local ssg=$1 site_dir=$2 label=$3
    local container_name="ssg-bench-${ssg}-$$"
    local build_time=0 peak_memory=0 status="success" rc

    # --memory-swap equal to --memory disables swap for the container. Without
    # it Docker grants 2x memory as swap, so an SSG that overruns the limit gets
    # silently paged instead of failing — recorded as "just slower", at a
    # magnitude that depends entirely on the host's swap device.
    # shellcheck disable=SC2046 # deliberately split arg lists
    docker run --rm \
        --name "$container_name" \
        --memory="$DOCKER_MEMORY" \
        --memory-swap="$DOCKER_MEMORY" \
        --cpus="$DOCKER_CPUS" \
        $(cpuset_flag) \
        --network="$BUILD_NETWORK" \
        $(build_env_flags) \
        -v "${site_dir}:/site:rw" \
        "ssg-benchmark-${ssg}" \
        sh /site/.bench/run.sh > "${BENCHMARK_RESULTS_DIR}/${label}.container.log" 2>&1

    if [ -f "${site_dir}/.bench/elapsed_ms" ]; then
        build_time=$(cat "${site_dir}/.bench/elapsed_ms" 2>/dev/null || echo 0)
        peak_memory=$(cat "${site_dir}/.bench/mem_peak_kb" 2>/dev/null || echo 0)
        rc=$(cat "${site_dir}/.bench/rc" 2>/dev/null || echo 1)
        if [ "$rc" != "0" ]; then
            # 137 = SIGKILL, which under a memory cgroup means the OOM killer.
            # Distinguishing this matters: an OOM is the limit being too low for
            # that SSG, not the SSG being broken.
            if [ "$rc" = "137" ]; then
                status="oom"
                log_warn "      ${ssg} was OOM-killed at --memory=${DOCKER_MEMORY}"
            else
                status="failed"
            fi
        fi
    else
        status="failed"
    fi

    # A build that finishes just under the cap is fighting the allocator in a
    # way its rivals are not, so the timing is not comparable even though it
    # "succeeded".
    if [ "$status" = "success" ] && [ "$DOCKER_MEMORY_KB" -gt 0 ] \
       && [ "$peak_memory" -gt $(( DOCKER_MEMORY_KB * 90 / 100 )) ]; then
        log_warn "      ${ssg} peaked at ${peak_memory}KB, within 10% of the ${DOCKER_MEMORY} cap"
        MEMORY_PRESSURE_WARNINGS="${MEMORY_PRESSURE_WARNINGS} ${ssg}"
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

# Resolve every dependency the build will need, with the network still
# available and the clock not running. After this returns, the timed builds run
# with --network=none, so anything left unresolved fails loudly instead of
# quietly costing one SSG a few hundred milliseconds of socket timeouts.
prepare_dependencies() {
    local ssg=$1 site_dir=$2 label=$3

    [ "$USE_DOCKER" = "true" ] || return 0

    case $ssg in
        gatsby|astro|docusaurus|hexo)
            [ -f "${site_dir}/package.json" ] || return 0
            log "    Installing npm dependencies (outside timing)..."
            docker run --rm -v "${site_dir}:/site:rw" "ssg-benchmark-${ssg}" \
                sh -c "cd /site && npm install --no-audit --no-fund" \
                > "${BENCHMARK_RESULTS_DIR}/${label}_npm.log" 2>&1 \
                || log_warn "    npm install reported errors — see ${label}_npm.log"
            ;;
        jekyll)
            [ -f "${site_dir}/Gemfile" ] || return 0
            # Without a lockfile `bundle exec` resolves on every build, and on a
            # network-isolated build that resolution fails. Materialise the lock
            # here instead.
            log "    Resolving bundler dependencies (outside timing)..."
            docker run --rm -v "${site_dir}:/site:rw" "ssg-benchmark-jekyll" \
                sh -c "cd /site && bundle lock --local || bundle lock" \
                > "${BENCHMARK_RESULTS_DIR}/${label}_bundle.log" 2>&1 \
                || log_warn "    bundle lock reported errors — see ${label}_bundle.log"
            ;;
    esac
}

# One measured build + its CSV row.
record_iteration() {
    local ssg=$1 site_dir=$2 scenario=$3 page_count=$4 iteration=$5
    local result build_time peak_memory status output_files post_files

    clean_build_artifacts "$site_dir"
    result=$(run_one_build "$ssg" "$site_dir" "${ssg}_${scenario}_${page_count}_${iteration}")
    build_time=$(echo "$result" | cut -d',' -f1)
    peak_memory=$(echo "$result" | cut -d',' -f2)
    status=$(echo "$result" | cut -d',' -f3)
    output_files=$(count_output_html "$site_dir" "$ssg")
    post_files=$(count_post_html "$site_dir" "$ssg")

    if [ "$status" = "success" ] && [ "$post_files" -lt "$page_count" ]; then
        log_warn "      ${ssg} rendered only ${post_files} of ${page_count} posts (${output_files} HTML files total)"
        status="undercount"
    fi

    echo "${ssg},${scenario},${page_count},${iteration},${build_time},${peak_memory},${output_files},${status},${post_files}" >> "$RESULTS_FILE"

    if [ "$VERBOSE" = "true" ]; then
        log "      ${ssg}: ${build_time}ms, ${peak_memory}KB, ${output_files} HTML, ${status}"
    fi
}

# Benchmarks one (scenario, page_count) cell across every eligible SSG.
#
# Iterations are interleaved, not batched. Running all of hugo's iterations,
# then all of zola's, means a host that gets slower over the run — thermal
# throttling, a CI neighbour waking up, a background indexer — charges that
# slowdown entirely to whichever SSG happened to be running then. Since the SSG
# order was fixed, that bias was systematic across every run rather than
# averaging out. Round-robin rounds spread any drift evenly, and rotating the
# starting SSG each round keeps a fixed position within the round from mattering
# either.
#
# The cost is holding every SSG's site directory at once (node_modules
# dominates). EXEC_ORDER=sequential restores the old batched behaviour for
# disk-constrained hosts, at the price of reintroducing the bias.
run_group() {
    local scenario=$1 page_count=$2
    local ssg i n iteration offset idx dir
    local group_ssgs="" group_dirs=""

    for ssg in $SSGS; do
        if ! is_ssg_runnable "$ssg"; then
            log_warn "Skipping ${ssg}: no Docker image and no local binary"
            continue
        fi
        if ! scenario_supported "$ssg" "$scenario"; then
            log_warn "Skipping ${ssg} for '${scenario}': not in support matrix (see METHODOLOGY.md)"
            continue
        fi

        log "  Preparing ${ssg} (${scenario}, ${page_count} pages)..."
        dir=$(mktemp -d)
        assemble_site "$ssg" "$scenario" "$page_count" "$dir"
        write_bench_script "$dir" "$(build_cmd_for "$ssg")"
        prepare_dependencies "$ssg" "$dir" "${ssg}_${scenario}_${page_count}"

        group_ssgs="${group_ssgs} ${ssg}"
        group_dirs="${group_dirs} ${dir}"
        GROUP_TEMP_DIRS="${GROUP_TEMP_DIRS} ${dir}"
    done

    # shellcheck disable=SC2206 # deliberate word splitting into arrays
    local ssgs=($group_ssgs)
    # shellcheck disable=SC2206
    local dirs=($group_dirs)
    n=${#ssgs[@]}
    [ "$n" -gt 0 ] || { log_warn "  No SSGs eligible for ${scenario} @ ${page_count}p"; return 0; }
    record_corpus_digest "$scenario" "$page_count"

    # Warmups: warm OS page cache / JIT, results discarded.
    # (BSD seq counts down for "seq 1 0", so guard explicitly.)
    local w=1
    while [ "$w" -le "$WARMUP" ]; do
        log "  Warmup round ${w}/${WARMUP}..."
        for ((i = 0; i < n; i++)); do
            clean_build_artifacts "${dirs[$i]}"
            run_one_build "${ssgs[$i]}" "${dirs[$i]}" \
                "${ssgs[$i]}_${scenario}_${page_count}_warmup${w}" > /dev/null
        done
        w=$((w + 1))
    done

    for iteration in $(seq 1 "$ITERATIONS"); do
        log "  Iteration round ${iteration}/${ITERATIONS}..."
        offset=$(( (iteration - 1) % n ))
        for ((i = 0; i < n; i++)); do
            idx=$(( (i + offset) % n ))
            record_iteration "${ssgs[$idx]}" "${dirs[$idx]}" \
                "$scenario" "$page_count" "$iteration"
        done
    done

    for ((i = 0; i < n; i++)); do
        verify_scenario_features "${ssgs[$i]}" "${dirs[$i]}" "$scenario" "$page_count"
        rm -rf "${dirs[$i]}"
    done
    BENCHMARKED_CELLS=$((BENCHMARKED_CELLS + 1))
}

# Old behaviour: one SSG at a time, all of its iterations back to back.
run_group_sequential() {
    local scenario=$1 page_count=$2 ssg dir w iteration

    for ssg in $SSGS; do
        is_ssg_runnable "$ssg" || { log_warn "Skipping ${ssg}: not runnable"; continue; }
        scenario_supported "$ssg" "$scenario" || { log_warn "Skipping ${ssg} for '${scenario}'"; continue; }

        log "  Benchmarking ${ssg} (${scenario}, ${page_count} pages)..."
        dir=$(mktemp -d)
        GROUP_TEMP_DIRS="${GROUP_TEMP_DIRS} ${dir}"
        assemble_site "$ssg" "$scenario" "$page_count" "$dir"
        write_bench_script "$dir" "$(build_cmd_for "$ssg")"
        prepare_dependencies "$ssg" "$dir" "${ssg}_${scenario}_${page_count}"
        record_corpus_digest "$scenario" "$page_count"

        w=1
        while [ "$w" -le "$WARMUP" ]; do
            clean_build_artifacts "$dir"
            run_one_build "$ssg" "$dir" "${ssg}_${scenario}_${page_count}_warmup${w}" > /dev/null
            w=$((w + 1))
        done

        for iteration in $(seq 1 "$ITERATIONS"); do
            record_iteration "$ssg" "$dir" "$scenario" "$page_count" "$iteration"
        done

        verify_scenario_features "$ssg" "$dir" "$scenario" "$page_count"
        rm -rf "$dir"
        BENCHMARKED_CELLS=$((BENCHMARKED_CELLS + 1))
    done
}

BENCHMARKED_CELLS=0
GROUP_TEMP_DIRS=""

cleanup_temp_dirs() {
    local d
    for d in $GROUP_TEMP_DIRS; do
        [ -d "$d" ] && rm -rf "$d"
    done
}
trap cleanup_temp_dirs EXIT INT TERM

run_benchmarks() {
    local scenario page_count

    for scenario in $SCENARIOS; do
        log "=== Scenario: ${scenario} ==="
        for page_count in $PAGE_COUNTS; do
            log "  --- ${page_count} pages (order: ${EXEC_ORDER}) ---"
            if [ "$EXEC_ORDER" = "sequential" ]; then
                run_group_sequential "$scenario" "$page_count"
            else
                run_group "$scenario" "$page_count"
            fi
        done
    done

    if [ "$BENCHMARKED_CELLS" -eq 0 ]; then
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
  "corpus_digests": "$(echo $CORPUS_DIGESTS)",
  "use_docker": "${USE_DOCKER}",
  "docker_cpus_requested": "${DOCKER_CPUS_REQUESTED}",
  "docker_cpus_effective": "${DOCKER_CPUS}",
  "docker_cpuset": "${DOCKER_CPUSET}",
  "docker_memory": "${DOCKER_MEMORY}",
  "docker_swap": "disabled",
  "build_network": "${BUILD_NETWORK}",
  "exec_order": "${EXEC_ORDER}",
  "verify_output": "${VERIFY_OUTPUT}",
  "host": "$(uname -sm)",
  "host_cpus": "${HOST_CPUS}",
  "docker_version": "${docker_version}",
  "toolchain_versions": "versions.json"
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
        echo "**Execution order:** ${EXEC_ORDER} | **Build network:** ${BUILD_NETWORK}"
        echo "**Seed:** ${SEED} | **Docker:** cpus=${DOCKER_CPUS} mem=${DOCKER_MEMORY}"
        echo "**Corpus digest:** \`$(echo $CORPUS_DIGESTS)\` (same digest = same input bytes)"
        echo ""
        versions_table
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
                if [ -z "$rows" ]; then
                    # An SSG with zero usable iterations used to vanish from the
                    # table, so a total failure was indistinguishable from an SSG
                    # that was never asked to run. Say which happened.
                    local attempted
                    attempted=$(awk -F',' -v s="$ssg" -v n="$scenario" -v p="$page_count" \
                        '$1==s && $2==n && $3==p { c[$8]++ } END { for (k in c) printf "%s×%d ", k, c[k] }' "$RESULTS_FILE")
                    if [ -n "$attempted" ]; then
                        echo "| ${ssg} | ${page_count} | — | — | — | — | no usable iterations (${attempted}) |" >> "$SUMMARY_FILE"
                    fi
                    continue
                fi

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
        echo "\`UNDERCOUNT\` means an SSG rendered fewer post pages than the corpus"
        echo "contained, regardless of how many aggregate pages it emitted."
        echo "Machine-readable verdict: \`parity.json\`."
        echo ""
    } >> "$SUMMARY_FILE"

    # The verdict is also written to parity.json. It used to exist only as prose
    # in summary.md, so nothing downstream — the dashboard, CI, a reviewer's
    # script — could tell a clean run from one whose comparison the guard had
    # already declared invalid.
    local parity_json="${BENCHMARK_RESULTS_DIR}/parity.json"
    local parity_warnings=0 parity_first=true
    {
        echo '{'
        echo '  "rule": "mismatch when max_html_files > min * 1.10 + 5",'
        echo '  "cells": ['
    } > "$parity_json"

    for scenario in $SCENARIOS; do
        for page_count in $PAGE_COUNTS; do
            local line="" min_files="" max_files="" json_ssgs="" undercounts=""
            for ssg in $SSGS; do
                files=$(awk -F',' -v s="$ssg" -v n="$scenario" -v p="$page_count" \
                    '$1==s && $2==n && $3==p && ($8=="success" || $8=="undercount") {print $7}' "$RESULTS_FILE" | median)
                [ "$files" = "N/A" ] && continue
                [ -n "$files" ] || continue
                line="${line} ${ssg}=${files}"
                json_ssgs="${json_ssgs}${json_ssgs:+, }\"${ssg}\": ${files}"
                if [ -z "$min_files" ] || [ "$files" -lt "$min_files" ]; then min_files=$files; fi
                if [ -z "$max_files" ] || [ "$files" -gt "$max_files" ]; then max_files=$files; fi

                # A per-SSG undercount is a parity failure in its own right,
                # independent of the cross-SSG spread.
                if awk -F',' -v s="$ssg" -v n="$scenario" -v p="$page_count" \
                    '$1==s && $2==n && $3==p && $8=="undercount" { found=1 } END { exit !found }' "$RESULTS_FILE"; then
                    undercounts="${undercounts}${undercounts:+ }${ssg}"
                fi
            done
            [ -n "$line" ] || continue

            local verdict="OK" ok="true"
            # flag if max > min * 1.10 + 5 (absolute slack absorbs per-framework
            # structural pages: 404, feed redirects, archive index, ...)
            if [ -n "$min_files" ] && [ "$max_files" -gt $(( min_files + min_files / 10 + 5 )) ]; then
                verdict="**MISMATCH**"; ok="false"
                parity_warnings=$((parity_warnings + 1))
                log_warn "Output parity mismatch (${scenario}, ${page_count} pages):${line}"
            fi
            if [ -n "$undercounts" ]; then
                verdict="${verdict} — **UNDERCOUNT**: ${undercounts}"; ok="false"
                parity_warnings=$((parity_warnings + 1))
                log_warn "Undercount (${scenario}, ${page_count} pages): ${undercounts}"
            fi
            echo "- ${scenario} @ ${page_count}p:${line} → ${verdict}" >> "$SUMMARY_FILE"

            [ "$parity_first" = true ] && parity_first=false || echo ',' >> "$parity_json"
            printf '    {"scenario": "%s", "page_count": %s, "ok": %s, "undercount": "%s", "html_files": {%s}}' \
                "$scenario" "$page_count" "$ok" "$undercounts" "$json_ssgs" >> "$parity_json"
        done
    done

    {
        echo ''
        echo '  ],'
        echo "  \"ok\": $([ "$parity_warnings" -eq 0 ] && echo true || echo false)"
        echo '}'
    } >> "$parity_json"

    if [ "$parity_warnings" -eq 0 ]; then
        log_success "Output parity check passed"
    else
        log_warn "Output parity check found ${parity_warnings} problem(s) — see ${SUMMARY_FILE}"
        PARITY_FAILED=1
    fi

    # Scenario feature verification: did each SSG actually do the work the
    # scenario claims it did?
    if [ "$VERIFY_OUTPUT" = "true" ]; then
        {
            echo ""
            echo "## Scenario feature verification"
            echo ""
            echo "Confirms the features each scenario promises are present in the emitted"
            echo "HTML — highlighting, tag pages, feed, pagination, sidebar. An SSG that"
            echo "silently skips one of these is doing less work than its rivals, which the"
            echo "output-count parity check cannot detect. Per-SSG reports:"
            echo "\`verify_<ssg>_<scenario>_<pages>.json\`."
            echo ""
            if [ -n "$VERIFY_FAILURES" ]; then
                echo "| SSG | Scenario | Pages | Failed checks |"
                echo "|-----|----------|-------|---------------|"
                printf '%s' "$VERIFY_FAILURES" | while IFS='|' read -r v_ssg v_sc v_pc v_failed; do
                    [ -n "$v_ssg" ] || continue
                    echo "| ${v_ssg} | ${v_sc} | ${v_pc} | ${v_failed} |"
                done
                echo ""
                echo "**Timings involving these SSGs are not comparable** until the cause is"
                echo "fixed: they measure a smaller workload."
            else
                echo "All verified SSGs produced every feature their scenario requires."
            fi
        } >> "$SUMMARY_FILE"
    fi

    # Resource-limit incidents: builds that hit the memory cap are not
    # comparable with builds that had headroom, even when they "succeeded".
    local oom_rows
    oom_rows=$(awk -F',' '$8=="oom" { print "- " $1 " (" $2 " @ " $3 "p, iteration " $4 ")" }' "$RESULTS_FILE")
    if [ -n "$oom_rows" ] || [ -n "$MEMORY_PRESSURE_WARNINGS" ]; then
        {
            echo ""
            echo "## Resource limit incidents"
            echo ""
            echo "Builds run with \`--memory=${DOCKER_MEMORY}\` and swap disabled."
            echo ""
            if [ -n "$oom_rows" ]; then
                echo "**OOM-killed** (excluded from the timing tables):"
                echo ""
                echo "$oom_rows"
                echo ""
            fi
            if [ -n "$MEMORY_PRESSURE_WARNINGS" ]; then
                echo "**Within 10% of the memory cap** — these builds were fighting the"
                echo "allocator in a way the others were not, so their timings are"
                echo "suspect even though they succeeded:"
                echo ""
                echo "$(echo $MEMORY_PRESSURE_WARNINGS | tr ' ' '\n' | sort -u | sed 's/^/- /')"
                echo ""
            fi
            echo "Raise \`DOCKER_MEMORY\` and re-run if either list is non-empty."
        } >> "$SUMMARY_FILE"
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

    record_toolchain_versions
    write_run_metadata
    run_benchmarks
    generate_summary

    log_success "Benchmark complete!"
    log "Results saved to: ${BENCHMARK_RESULTS_DIR}"

    if [ -n "$VERIFY_FAILURES" ] && [ "$STRICT_VERIFY" = "true" ]; then
        log_error "STRICT_VERIFY: scenario feature checks failed — see ${SUMMARY_FILE}"
        EXIT_CODE=1
    fi
    if [ "$PARITY_FAILED" -ne 0 ] && [ "$STRICT_PARITY" = "true" ]; then
        log_error "STRICT_PARITY: output parity check failed — see ${SUMMARY_FILE}"
        EXIT_CODE=1
    fi

    echo ""
    echo "=========================================="
    echo "         BENCHMARK RESULTS SUMMARY"
    echo "=========================================="
    cat "$SUMMARY_FILE"
}

EXIT_CODE=0
main "$@"

exit "$EXIT_CODE"
