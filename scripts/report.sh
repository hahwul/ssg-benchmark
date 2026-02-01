#!/bin/bash
#
# SSG Benchmark - Report Generator
# Generates detailed reports and optional charts from benchmark results
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
RESULTS_DIR="${PROJECT_DIR}/results"

# Options
LATEST_ONLY=true
RESULTS_PATH=""
OUTPUT_FORMAT="markdown"
GENERATE_CHART=false
CHART_TYPE="bar"

log() {
    echo -e "${BLUE}[REPORT]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[REPORT]${NC} $1"
}

log_error() {
    echo -e "${RED}[REPORT]${NC} $1"
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -r, --results PATH     Path to results directory (default: latest)"
    echo "  -f, --format FORMAT    Output format: markdown, csv, json, html (default: markdown)"
    echo "  -c, --chart            Generate ASCII chart visualization"
    echo "  -t, --chart-type TYPE  Chart type: bar, line (default: bar)"
    echo "  -a, --all              Process all result sets, not just latest"
    echo "  -o, --output FILE      Output file path (default: stdout)"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                           # Show latest results as markdown"
    echo "  $0 --chart                   # Show results with ASCII chart"
    echo "  $0 -f json -o report.json    # Export as JSON"
    echo "  $0 -r results/20240101_120000"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--results)
            RESULTS_PATH="$2"
            LATEST_ONLY=false
            shift 2
            ;;
        -f|--format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -c|--chart)
            GENERATE_CHART=true
            shift
            ;;
        -t|--chart-type)
            CHART_TYPE="$2"
            shift 2
            ;;
        -a|--all)
            LATEST_ONLY=false
            shift
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
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

# Find results directory
find_results_dir() {
    if [ -n "$RESULTS_PATH" ]; then
        if [ -d "$RESULTS_PATH" ]; then
            echo "$RESULTS_PATH"
        elif [ -d "${RESULTS_DIR}/${RESULTS_PATH}" ]; then
            echo "${RESULTS_DIR}/${RESULTS_PATH}"
        else
            log_error "Results directory not found: $RESULTS_PATH"
            exit 1
        fi
    else
        # Find latest results
        local latest=$(ls -t "$RESULTS_DIR" 2>/dev/null | grep -v ".gitkeep" | head -1)
        if [ -z "$latest" ]; then
            log_error "No results found in $RESULTS_DIR"
            log_error "Run 'make benchmark' first to generate results."
            exit 1
        fi
        echo "${RESULTS_DIR}/${latest}"
    fi
}

# Parse CSV and calculate statistics
parse_results() {
    local csv_file="$1"

    if [ ! -f "$csv_file" ]; then
        log_error "Results file not found: $csv_file"
        exit 1
    fi

    # Skip header and output data
    tail -n +2 "$csv_file"
}

# Calculate statistics for a specific SSG and page count
calculate_stats() {
    local csv_file="$1"
    local ssg="$2"
    local page_count="$3"

    local data=$(grep "^${ssg},${page_count}," "$csv_file" | grep ",success$")

    if [ -z "$data" ]; then
        echo "N/A,N/A,N/A,N/A,0"
        return
    fi

    local times=$(echo "$data" | cut -d',' -f4)
    local memories=$(echo "$data" | cut -d',' -f5)
    local count=$(echo "$times" | wc -l | tr -d ' ')

    local avg_time=$(echo "$times" | awk '{sum+=$1} END {if(NR>0) printf "%.1f", sum/NR; else print "N/A"}')
    local min_time=$(echo "$times" | sort -n | head -1)
    local max_time=$(echo "$times" | sort -n | tail -1)
    local avg_memory=$(echo "$memories" | awk '{sum+=$1} END {if(NR>0) printf "%.0f", sum/NR; else print "N/A"}')

    # Calculate standard deviation
    local stddev=$(echo "$times" | awk -v avg="$avg_time" '{sum+=($1-avg)^2} END {if(NR>1) printf "%.1f", sqrt(sum/(NR-1)); else print "0"}')

    echo "${avg_time},${min_time},${max_time},${avg_memory},${stddev}"
}

# Get unique SSGs from results
get_ssgs() {
    local csv_file="$1"
    tail -n +2 "$csv_file" | cut -d',' -f1 | sort -u
}

# Get unique page counts from results
get_page_counts() {
    local csv_file="$1"
    tail -n +2 "$csv_file" | cut -d',' -f2 | sort -nu
}

# Generate ASCII bar chart
generate_ascii_bar_chart() {
    local csv_file="$1"
    local metric="$2"  # time or memory
    local max_width=50

    echo ""
    echo "═══════════════════════════════════════════════════════════════════════"
    if [ "$metric" = "time" ]; then
        echo "                      BUILD TIME COMPARISON (ms)"
    else
        echo "                      MEMORY USAGE COMPARISON (KB)"
    fi
    echo "═══════════════════════════════════════════════════════════════════════"
    echo ""

    local ssgs=$(get_ssgs "$csv_file")
    local page_counts=$(get_page_counts "$csv_file")

    for page_count in $page_counts; do
        echo "┌─────────────────────────────────────────────────────────────────────┐"
        echo "│  ${page_count} Pages                                                         │"
        echo "├─────────────────────────────────────────────────────────────────────┤"

        # Find max value for scaling
        local max_val=0
        for ssg in $ssgs; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local val
            if [ "$metric" = "time" ]; then
                val=$(echo "$stats" | cut -d',' -f1)
            else
                val=$(echo "$stats" | cut -d',' -f4)
            fi
            if [ "$val" != "N/A" ] && [ -n "$val" ]; then
                if [ $(echo "$val > $max_val" | bc -l 2>/dev/null || echo "0") -eq 1 ]; then
                    max_val=$val
                fi
            fi
        done

        # Draw bars
        for ssg in $ssgs; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local val
            if [ "$metric" = "time" ]; then
                val=$(echo "$stats" | cut -d',' -f1)
            else
                val=$(echo "$stats" | cut -d',' -f4)
            fi

            if [ "$val" != "N/A" ] && [ -n "$val" ] && [ "$max_val" != "0" ]; then
                local bar_len=$(echo "$val / $max_val * $max_width" | bc -l 2>/dev/null | cut -d'.' -f1)
                [ -z "$bar_len" ] && bar_len=0
                [ "$bar_len" -lt 1 ] && bar_len=1

                local bar=""
                for ((i=0; i<bar_len; i++)); do
                    bar="${bar}█"
                done

                printf "│ %-8s %s %s\n" "$ssg" "$bar" "$val"
            else
                printf "│ %-8s (no data)\n" "$ssg"
            fi
        done

        echo "└─────────────────────────────────────────────────────────────────────┘"
        echo ""
    done
}

# Generate Markdown report
generate_markdown_report() {
    local results_dir="$1"
    local csv_file="${results_dir}/results.csv"

    local ssgs=$(get_ssgs "$csv_file")
    local page_counts=$(get_page_counts "$csv_file")
    local timestamp=$(basename "$results_dir")

    cat << EOF
# SSG Benchmark Report

**Generated:** $(date)
**Results ID:** ${timestamp}

## Summary

| SSG | Pages | Avg Time (ms) | Min (ms) | Max (ms) | Std Dev | Avg Memory (KB) |
|-----|-------|---------------|----------|----------|---------|-----------------|
EOF

    for ssg in $ssgs; do
        for page_count in $page_counts; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local avg_time=$(echo "$stats" | cut -d',' -f1)
            local min_time=$(echo "$stats" | cut -d',' -f2)
            local max_time=$(echo "$stats" | cut -d',' -f3)
            local avg_memory=$(echo "$stats" | cut -d',' -f4)
            local stddev=$(echo "$stats" | cut -d',' -f5)

            echo "| ${ssg} | ${page_count} | ${avg_time} | ${min_time} | ${max_time} | ${stddev} | ${avg_memory} |"
        done
    done

    echo ""
    echo "## Build Time by Page Count"
    echo ""

    for page_count in $page_counts; do
        echo "### ${page_count} Pages"
        echo ""
        echo "| SSG | Build Time (ms) | Memory (KB) |"
        echo "|-----|-----------------|-------------|"

        for ssg in $ssgs; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local avg_time=$(echo "$stats" | cut -d',' -f1)
            local avg_memory=$(echo "$stats" | cut -d',' -f4)
            echo "| ${ssg} | ${avg_time} | ${avg_memory} |"
        done
        echo ""
    done

    echo "## Scaling Analysis"
    echo ""
    echo "How build time scales with page count:"
    echo ""

    for ssg in $ssgs; do
        echo "### ${ssg}"
        echo ""
        echo "| Pages | Avg Time (ms) | Time per Page (ms) |"
        echo "|-------|---------------|-------------------|"

        for page_count in $page_counts; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local avg_time=$(echo "$stats" | cut -d',' -f1)

            if [ "$avg_time" != "N/A" ]; then
                local time_per_page=$(echo "scale=3; $avg_time / $page_count" | bc -l 2>/dev/null || echo "N/A")
                echo "| ${page_count} | ${avg_time} | ${time_per_page} |"
            else
                echo "| ${page_count} | N/A | N/A |"
            fi
        done
        echo ""
    done

    # Add chart if requested
    if [ "$GENERATE_CHART" = true ]; then
        echo "## Visual Comparison"
        echo ""
        echo '```'
        generate_ascii_bar_chart "$csv_file" "time"
        echo '```'
    fi

    echo "## Raw Data"
    echo ""
    echo "See \`results.csv\` for complete benchmark data."
}

# Generate JSON report
generate_json_report() {
    local results_dir="$1"
    local csv_file="${results_dir}/results.csv"

    local ssgs=$(get_ssgs "$csv_file")
    local page_counts=$(get_page_counts "$csv_file")
    local timestamp=$(basename "$results_dir")

    echo "{"
    echo "  \"generated\": \"$(date -Iseconds 2>/dev/null || date)\","
    echo "  \"results_id\": \"${timestamp}\","
    echo "  \"benchmarks\": ["

    local first_ssg=true
    for ssg in $ssgs; do
        if [ "$first_ssg" = true ]; then
            first_ssg=false
        else
            echo ","
        fi

        echo "    {"
        echo "      \"ssg\": \"${ssg}\","
        echo "      \"results\": ["

        local first_count=true
        for page_count in $page_counts; do
            if [ "$first_count" = true ]; then
                first_count=false
            else
                echo ","
            fi

            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local avg_time=$(echo "$stats" | cut -d',' -f1)
            local min_time=$(echo "$stats" | cut -d',' -f2)
            local max_time=$(echo "$stats" | cut -d',' -f3)
            local avg_memory=$(echo "$stats" | cut -d',' -f4)
            local stddev=$(echo "$stats" | cut -d',' -f5)

            echo -n "        {"
            echo -n "\"page_count\": ${page_count}, "
            echo -n "\"avg_time_ms\": ${avg_time:-null}, "
            echo -n "\"min_time_ms\": ${min_time:-null}, "
            echo -n "\"max_time_ms\": ${max_time:-null}, "
            echo -n "\"std_dev\": ${stddev:-null}, "
            echo -n "\"avg_memory_kb\": ${avg_memory:-null}"
            echo -n "}"
        done

        echo ""
        echo "      ]"
        echo -n "    }"
    done

    echo ""
    echo "  ]"
    echo "}"
}

# Generate HTML report
generate_html_report() {
    local results_dir="$1"
    local csv_file="${results_dir}/results.csv"

    local ssgs=$(get_ssgs "$csv_file")
    local page_counts=$(get_page_counts "$csv_file")
    local timestamp=$(basename "$results_dir")

    cat << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SSG Benchmark Report</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        h1, h2, h3 { color: #333; }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin: 20px 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th { background: #4a90d9; color: white; }
        tr:hover { background: #f0f7ff; }
        .bar-container {
            width: 100%;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
        }
        .bar {
            height: 24px;
            background: linear-gradient(90deg, #4a90d9, #67b26f);
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding-left: 8px;
            color: white;
            font-size: 12px;
        }
        .summary-card {
            background: white;
            padding: 20px;
            margin: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: inline-block;
            min-width: 200px;
        }
        .summary-card h3 { margin-top: 0; color: #4a90d9; }
        .metric { font-size: 2em; font-weight: bold; color: #333; }
    </style>
</head>
<body>
    <h1>🚀 SSG Benchmark Report</h1>
EOF

    echo "    <p><strong>Generated:</strong> $(date)</p>"
    echo "    <p><strong>Results ID:</strong> ${timestamp}</p>"

    echo "    <h2>📊 Summary</h2>"
    echo "    <table>"
    echo "        <tr><th>SSG</th><th>Pages</th><th>Avg Time (ms)</th><th>Min</th><th>Max</th><th>Memory (KB)</th><th>Visualization</th></tr>"

    # Find max time for scaling bars
    local max_time=0
    for ssg in $ssgs; do
        for page_count in $page_counts; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local avg=$(echo "$stats" | cut -d',' -f1)
            if [ "$avg" != "N/A" ] && [ -n "$avg" ]; then
                if [ $(echo "$avg > $max_time" | bc -l 2>/dev/null || echo "0") -eq 1 ]; then
                    max_time=$avg
                fi
            fi
        done
    done

    for ssg in $ssgs; do
        for page_count in $page_counts; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local avg_time=$(echo "$stats" | cut -d',' -f1)
            local min_time=$(echo "$stats" | cut -d',' -f2)
            local max_time_val=$(echo "$stats" | cut -d',' -f3)
            local avg_memory=$(echo "$stats" | cut -d',' -f4)

            local bar_width=0
            if [ "$avg_time" != "N/A" ] && [ "$max_time" != "0" ]; then
                bar_width=$(echo "scale=0; $avg_time * 100 / $max_time" | bc -l 2>/dev/null || echo "0")
            fi

            echo "        <tr>"
            echo "            <td><strong>${ssg}</strong></td>"
            echo "            <td>${page_count}</td>"
            echo "            <td>${avg_time}</td>"
            echo "            <td>${min_time}</td>"
            echo "            <td>${max_time_val}</td>"
            echo "            <td>${avg_memory}</td>"
            echo "            <td><div class=\"bar-container\"><div class=\"bar\" style=\"width: ${bar_width}%\">${avg_time}ms</div></div></td>"
            echo "        </tr>"
        done
    done

    echo "    </table>"

    cat << 'EOF'
    <h2>📈 Analysis</h2>
    <p>Lower build times indicate better performance. Memory usage should be considered alongside build time for overall efficiency.</p>

    <footer style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; color: #666;">
        <p>Generated by SSG Benchmark - <a href="https://github.com/hahwul/ssg-benchmark">GitHub</a></p>
    </footer>
</body>
</html>
EOF
}

# Generate CSV summary report
generate_csv_report() {
    local results_dir="$1"
    local csv_file="${results_dir}/results.csv"

    local ssgs=$(get_ssgs "$csv_file")
    local page_counts=$(get_page_counts "$csv_file")

    echo "ssg,page_count,avg_time_ms,min_time_ms,max_time_ms,std_dev,avg_memory_kb"

    for ssg in $ssgs; do
        for page_count in $page_counts; do
            local stats=$(calculate_stats "$csv_file" "$ssg" "$page_count")
            local avg_time=$(echo "$stats" | cut -d',' -f1)
            local min_time=$(echo "$stats" | cut -d',' -f2)
            local max_time=$(echo "$stats" | cut -d',' -f3)
            local avg_memory=$(echo "$stats" | cut -d',' -f4)
            local stddev=$(echo "$stats" | cut -d',' -f5)

            echo "${ssg},${page_count},${avg_time},${min_time},${max_time},${stddev},${avg_memory}"
        done
    done
}

# Main execution
main() {
    local results_dir=$(find_results_dir)
    log "Processing results from: ${results_dir}"

    local output=""

    case $OUTPUT_FORMAT in
        markdown|md)
            output=$(generate_markdown_report "$results_dir")
            ;;
        json)
            output=$(generate_json_report "$results_dir")
            ;;
        html)
            output=$(generate_html_report "$results_dir")
            ;;
        csv)
            output=$(generate_csv_report "$results_dir")
            ;;
        *)
            log_error "Unknown format: $OUTPUT_FORMAT"
            log_error "Supported formats: markdown, json, html, csv"
            exit 1
            ;;
    esac

    if [ -n "$OUTPUT_FILE" ]; then
        echo "$output" > "$OUTPUT_FILE"
        log_success "Report saved to: $OUTPUT_FILE"
    else
        echo "$output"
    fi
}

main "$@"
