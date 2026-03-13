#!/usr/bin/env bash
# Generate static site data from benchmark results
# Parses all results/*/results.csv files and produces public/data.json

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RESULTS_DIR="${PROJECT_DIR}/results"
STATIC_DIR="${PROJECT_DIR}/web/static"
OUTPUT_FILE="${STATIC_DIR}/data.json"

mkdir -p "$STATIC_DIR"

# Start JSON
echo '{' > "$OUTPUT_FILE"
echo "  \"generated\": \"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\"," >> "$OUTPUT_FILE"
echo '  "runs": [' >> "$OUTPUT_FILE"

first_run=true

# Process each results directory in chronological order
for run_dir in $(ls -d "$RESULTS_DIR"/[0-9]*_[0-9]* 2>/dev/null | sort); do
    csv_file="$run_dir/results.csv"
    [ -f "$csv_file" ] || continue

    # Skip if CSV has only header (no data rows)
    data_lines=$(tail -n +2 "$csv_file" | grep -c ',' 2>/dev/null || true)
    [ "$data_lines" -gt 0 ] || continue

    run_id=$(basename "$run_dir")
    # Extract date from directory name (YYYYMMDD_HHMMSS -> YYYY-MM-DD)
    run_date="${run_id:0:4}-${run_id:4:2}-${run_id:6:2}"

    if [ "$first_run" = true ]; then
        first_run=false
    else
        echo '    ,' >> "$OUTPUT_FILE"
    fi

    echo '    {' >> "$OUTPUT_FILE"
    echo "      \"id\": \"$run_id\"," >> "$OUTPUT_FILE"
    echo "      \"date\": \"$run_date\"," >> "$OUTPUT_FILE"
    echo '      "results": [' >> "$OUTPUT_FILE"

    first_result=true

    # Get unique SSG + page_count combinations, compute avg/min/max from successful runs
    while IFS='|' read -r ssg page_count; do
        # Extract build times for this SSG + page_count (only successful)
        times=$(awk -F',' -v s="$ssg" -v p="$page_count" \
            'NR>1 && $1==s && $2==p && $7=="success" {print $4}' "$csv_file")

        [ -z "$times" ] && continue

        # Calculate avg, min, max
        read -r avg_time min_time max_time <<< $(echo "$times" | awk '
            BEGIN { sum=0; count=0; min=999999999; max=0 }
            {
                sum += $1; count++
                if ($1 < min) min = $1
                if ($1 > max) max = $1
            }
            END {
                if (count > 0)
                    printf "%d %d %d", sum/count, min, max
                else
                    printf "0 0 0"
            }')

        if [ "$first_result" = true ]; then
            first_result=false
        else
            echo '        ,' >> "$OUTPUT_FILE"
        fi

        echo -n "        {\"ssg\": \"$ssg\", \"page_count\": $page_count, \"avg_time_ms\": $avg_time, \"min_time_ms\": $min_time, \"max_time_ms\": $max_time}" >> "$OUTPUT_FILE"

    done <<< "$(awk -F',' 'NR>1 && $7=="success" {print $1"|"$2}' "$csv_file" | sort -t'|' -k1,1 -k2,2n | uniq)"

    echo '' >> "$OUTPUT_FILE"
    echo '      ]' >> "$OUTPUT_FILE"
    echo -n '    }' >> "$OUTPUT_FILE"

done

echo '' >> "$OUTPUT_FILE"
echo '  ]' >> "$OUTPUT_FILE"
echo '}' >> "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE"
