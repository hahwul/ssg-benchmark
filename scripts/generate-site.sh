#!/usr/bin/env bash
# Generate static site data from benchmark results
# Parses all results/*/results.csv files (both v1 and v2 schemas) and
# produces web/static/data.json.
#
# v1 schema: ssg,page_count,iteration,build_time_ms,peak_memory_kb,cpu_percent,status
#   -> tagged methodology 1, scenario "legacy", avg-based stats
# v2 schema: ssg,scenario,page_count,iteration,build_time_ms,peak_memory_kb,output_files,status
#   -> tagged methodology 2, median-based stats (in-container timing)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RESULTS_DIR="${PROJECT_DIR}/results"
STATIC_DIR="${PROJECT_DIR}/web/static"
OUTPUT_FILE="${STATIC_DIR}/data.json"

mkdir -p "$STATIC_DIR"

# Emits one JSON object per (ssg, scenario, page_count), sorted.
aggregate_csv() {
    local csv_file=$1
    awk -F',' '
    NR == 1 { v2 = ($2 == "scenario") ? 1 : 0; next }
    {
        if (v2) { ssg=$1; sc=$2; pc=$3+0; t=$5+0; mem=$6+0; files=$7+0; st=$8 }
        else    { ssg=$1; sc="legacy"; pc=$2+0; t=$4+0; mem=$5+0; files=0; st=$7 }
        if (st != "success") next
        key = ssg "|" sc "|" pc
        n[key]++
        times[key, n[key]] = t
        mems[key, n[key]] = mem
        fils[key, n[key]] = files
        pcs[key] = pc; ssgs[key] = ssg; scs[key] = sc
    }
    function med(arr, key, cnt,    i, j, tmp, vals) {
        for (i = 1; i <= cnt; i++) vals[i] = arr[key, i]
        for (i = 1; i <= cnt; i++)
            for (j = i + 1; j <= cnt; j++)
                if (vals[j] < vals[i]) { tmp = vals[i]; vals[i] = vals[j]; vals[j] = tmp }
        if (cnt % 2) return vals[(cnt + 1) / 2]
        return int((vals[cnt / 2] + vals[cnt / 2 + 1]) / 2)
    }
    END {
        for (key in n) {
            cnt = n[key]
            mn = times[key, 1]; mx = times[key, 1]
            for (i = 2; i <= cnt; i++) {
                if (times[key, i] < mn) mn = times[key, i]
                if (times[key, i] > mx) mx = times[key, i]
            }
            printf "%s|%s|%010d\t{\"ssg\": \"%s\", \"scenario\": \"%s\", \"page_count\": %d, \"avg_time_ms\": %d, \"min_time_ms\": %d, \"max_time_ms\": %d, \"peak_memory_kb\": %d, \"output_files\": %d}\n", \
                ssgs[key], scs[key], pcs[key], ssgs[key], scs[key], pcs[key], \
                med(times, key, cnt), mn, mx, med(mems, key, cnt), med(fils, key, cnt)
        }
    }' "$csv_file" | sort | cut -f2-
}

# Start JSON
{
    echo '{'
    echo "  \"generated\": \"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\","
    echo '  "runs": ['
} > "$OUTPUT_FILE"

first_run=true

for run_dir in $(ls -d "$RESULTS_DIR"/[0-9]*_[0-9]* 2>/dev/null | sort); do
    csv_file="$run_dir/results.csv"
    [ -f "$csv_file" ] || continue

    data_lines=$(tail -n +2 "$csv_file" | grep -c ',' 2>/dev/null || true)
    [ "$data_lines" -gt 0 ] || continue

    run_id=$(basename "$run_dir")
    run_date="${run_id:0:4}-${run_id:4:2}-${run_id:6:2}"

    if head -1 "$csv_file" | grep -q '^ssg,scenario,'; then
        methodology=2
    else
        methodology=1
    fi

    results=$(aggregate_csv "$csv_file")
    [ -n "$results" ] || continue

    if [ "$first_run" = true ]; then
        first_run=false
    else
        echo '    ,' >> "$OUTPUT_FILE"
    fi

    {
        echo '    {'
        echo "      \"id\": \"$run_id\","
        echo "      \"date\": \"$run_date\","
        echo "      \"methodology\": $methodology,"
        echo '      "results": ['
        echo "$results" | sed 's/^/        /' | sed '$!s/$/,/'
        echo '      ]'
        printf '    }'
    } >> "$OUTPUT_FILE"
done

{
    echo ''
    echo '  ]'
    echo '}'
} >> "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE"
python3 -c "import json; json.load(open('$OUTPUT_FILE')); print('data.json is valid JSON')" 2>/dev/null || echo "WARNING: data.json failed JSON validation"
