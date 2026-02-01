#!/bin/bash
#
# SSG Benchmark - Content Generator
# Generates test posts/pages for each SSG format
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default settings
SSG=""
COUNT=100
OUTPUT_DIR=""

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --ssg NAME        SSG name (hugo, zola, jekyll, blades, hwaro)"
    echo "  -c, --count N         Number of pages to generate (default: 100)"
    echo "  -o, --output DIR      Output directory for generated content"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --ssg hugo --count 1000 --output ./test-site"
    echo "  $0 -s zola -c 500 -o ./benchmark-site"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--ssg)
            SSG="$2"
            shift 2
            ;;
        -c|--count)
            COUNT="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
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

# Validate arguments
if [ -z "$SSG" ]; then
    log_error "SSG name is required"
    usage
    exit 1
fi

if [ -z "$OUTPUT_DIR" ]; then
    log_error "Output directory is required"
    usage
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Generate Lorem Ipsum-like content
generate_paragraph() {
    local paragraphs=(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
        "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
        "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem."
        "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?"
        "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
        "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident."
    )
    echo "${paragraphs[$((RANDOM % ${#paragraphs[@]}))]}"
}

generate_content() {
    local num_paragraphs=$((RANDOM % 5 + 3))
    local content=""
    for i in $(seq 1 $num_paragraphs); do
        content="${content}$(generate_paragraph)\n\n"
    done
    echo -e "$content"
}

generate_title() {
    local index=$1
    local titles=(
        "Getting Started with Static Sites"
        "Performance Optimization Tips"
        "Building Modern Websites"
        "Understanding Build Systems"
        "Content Management Strategies"
        "Web Development Best Practices"
        "Deployment Automation Guide"
        "Template Engine Comparison"
        "Asset Pipeline Configuration"
        "SEO for Static Sites"
    )
    local base_title="${titles[$((RANDOM % ${#titles[@]}))]}"
    echo "${base_title} - Part ${index}"
}

# Generate a date N days ago (cross-platform)
generate_date() {
    local days_ago=$1
    if date -v-${days_ago}d +%Y-%m-%d 2>/dev/null; then
        return
    elif date -d "${days_ago} days ago" +%Y-%m-%d 2>/dev/null; then
        return
    else
        # Fallback: calculate manually
        local year=2024
        local month=1
        local day=$((1 + (days_ago % 28)))
        printf "%04d-%02d-%02d" $year $month $day
    fi
}

# Generate content for Hugo
generate_hugo_content() {
    local content_dir="${OUTPUT_DIR}/content/posts"
    mkdir -p "$content_dir"

    log "Generating ${COUNT} Hugo posts..."

    for i in $(seq 1 $COUNT); do
        local date=$(generate_date $i)
        local title=$(generate_title $i)
        local slug="post-${i}"
        local filename="${content_dir}/${slug}.md"

        cat > "$filename" << EOF
---
title: "${title}"
date: ${date}
draft: false
tags: ["benchmark", "test", "post-${i}"]
categories: ["benchmark"]
---

# ${title}

$(generate_content)

## Section One

$(generate_content)

## Section Two

$(generate_content)

## Conclusion

$(generate_paragraph)
EOF
    done

    log_success "Generated ${COUNT} Hugo posts in ${content_dir}"
}

# Generate content for Zola
generate_zola_content() {
    local content_dir="${OUTPUT_DIR}/content/posts"
    mkdir -p "$content_dir"

    # Create section index
    cat > "${content_dir}/_index.md" << 'EOF'
+++
title = "Posts"
sort_by = "date"
template = "section.html"
page_template = "page.html"
+++
EOF

    log "Generating ${COUNT} Zola posts..."

    for i in $(seq 1 $COUNT); do
        local date=$(generate_date $i)
        local title=$(generate_title $i)
        local slug="post-${i}"
        local filename="${content_dir}/${slug}.md"

        cat > "$filename" << EOF
+++
title = "${title}"
date = ${date}
[taxonomies]
tags = ["benchmark", "test"]
+++

# ${title}

$(generate_content)

## Section One

$(generate_content)

## Section Two

$(generate_content)

## Conclusion

$(generate_paragraph)
EOF
    done

    log_success "Generated ${COUNT} Zola posts in ${content_dir}"
}

# Generate content for Jekyll
generate_jekyll_content() {
    local content_dir="${OUTPUT_DIR}/_posts"
    mkdir -p "$content_dir"

    log "Generating ${COUNT} Jekyll posts..."

    for i in $(seq 1 $COUNT); do
        local date=$(generate_date $i)
        local title=$(generate_title $i)
        local slug="post-${i}"
        local filename="${content_dir}/${date}-${slug}.md"

        cat > "$filename" << EOF
---
layout: post
title: "${title}"
date: ${date}
tags: [benchmark, test]
categories: benchmark
---

# ${title}

$(generate_content)

## Section One

$(generate_content)

## Section Two

$(generate_content)

## Conclusion

$(generate_paragraph)
EOF
    done

    # Create Gemfile if it doesn't exist
    if [ ! -f "${OUTPUT_DIR}/Gemfile" ]; then
        cat > "${OUTPUT_DIR}/Gemfile" << 'EOF'
source "https://rubygems.org"
gem "jekyll", "~> 4.3"
gem "webrick"
EOF
    fi

    log_success "Generated ${COUNT} Jekyll posts in ${content_dir}"
}

# Generate content for Blades
generate_blades_content() {
    local content_dir="${OUTPUT_DIR}/content"
    mkdir -p "$content_dir"

    log "Generating ${COUNT} Blades pages..."

    for i in $(seq 1 $COUNT); do
        local date=$(generate_date $i)
        local title=$(generate_title $i)
        local slug="post-${i}"
        local filename="${content_dir}/${slug}.md"

        cat > "$filename" << EOF
+++
title = "${title}"
date = "${date}"
[taxonomies]
tags = ["benchmark", "test"]
categories = ["benchmark"]
+++

# ${title}

$(generate_content)

## Section One

$(generate_content)

## Section Two

$(generate_content)

## Conclusion

$(generate_paragraph)
EOF
    done

    # Create minimal template if needed
    local template_dir="${OUTPUT_DIR}/templates"
    mkdir -p "$template_dir"

    if [ ! -f "${template_dir}/page.html" ]; then
        cat > "${template_dir}/page.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>{{ page.title }}</title>
</head>
<body>
    <h1>{{ page.title }}</h1>
    {{ page.content }}
</body>
</html>
EOF
    fi

    log_success "Generated ${COUNT} Blades pages in ${content_dir}"
}

# Generate content for Hwaro
generate_hwaro_content() {
    local content_dir="${OUTPUT_DIR}/content/posts"
    mkdir -p "$content_dir"

    log "Generating ${COUNT} Hwaro posts..."

    # Create hwaro config if not exists (use config.toml, not hwaro.toml)
    if [ ! -f "${OUTPUT_DIR}/config.toml" ]; then
        cat > "${OUTPUT_DIR}/config.toml" << 'EOF'
title = "SSG Benchmark Site"
description = "Benchmark test site"
base_url = ""

[plugins]
processors = ["markdown"]

[highlight]
enabled = false

[search]
enabled = false

[pagination]
enabled = false

[[taxonomies]]
name = "tags"
feed = false
sitemap = false

[sitemap]
enabled = false

[robots]
enabled = false

[llms]
enabled = false

[feeds]
enabled = false

[markdown]
safe = false

[auto_includes]
enabled = false
EOF
    fi

    for i in $(seq 1 $COUNT); do
        local date=$(generate_date $i)
        local title=$(generate_title $i)
        local slug="post-${i}"
        local filename="${content_dir}/${slug}.md"

        # Hwaro uses TOML front matter with +++ delimiters
        cat > "$filename" << EOF
+++
title = "${title}"
date = "${date}"

[taxonomies]
tags = ["benchmark", "test"]
+++

# ${title}

$(generate_content)

## Section One

$(generate_content)

## Section Two

$(generate_content)

## Conclusion

$(generate_paragraph)
EOF
    done

    # Create minimal template structure for Hwaro
    local template_dir="${OUTPUT_DIR}/templates"
    mkdir -p "$template_dir"

    if [ ! -f "${template_dir}/page.html" ]; then
        cat > "${template_dir}/page.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ page.title }} | {{ site.title }}</title>
</head>
<body>
    <article>
        <h1>{{ page.title }}</h1>
        {{ content }}
    </article>
</body>
</html>
EOF
    fi

    if [ ! -f "${template_dir}/index.html" ]; then
        cat > "${template_dir}/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ site.title }}</title>
</head>
<body>
    <h1>{{ site.title }}</h1>
    <ul>
    {% for page in pages %}
        <li><a href="{{ page.permalink }}">{{ page.title }}</a></li>
    {% endfor %}
    </ul>
</body>
</html>
EOF
    fi

    if [ ! -f "${template_dir}/section.html" ]; then
        cat > "${template_dir}/section.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ section.title }} | {{ site.title }}</title>
</head>
<body>
    <h1>{{ section.title }}</h1>
    <ul>
    {% for page in section.pages %}
        <li><a href="{{ page.permalink }}">{{ page.title }}</a></li>
    {% endfor %}
    </ul>
</body>
</html>
EOF
    fi

    log_success "Generated ${COUNT} Hwaro posts in ${content_dir}"
}

# Main execution
main() {
    log "Content Generator for SSG Benchmark"
    log "SSG: ${SSG}"
    log "Count: ${COUNT}"
    log "Output: ${OUTPUT_DIR}"

    case $SSG in
        hugo)
            generate_hugo_content
            ;;
        zola)
            generate_zola_content
            ;;
        jekyll)
            generate_jekyll_content
            ;;
        blades)
            generate_blades_content
            ;;
        hwaro)
            generate_hwaro_content
            ;;
        *)
            log_error "Unknown SSG: ${SSG}"
            log_error "Supported SSGs: hugo, zola, jekyll, blades, hwaro"
            exit 1
            ;;
    esac

    log_success "Content generation complete!"
}

main "$@"
