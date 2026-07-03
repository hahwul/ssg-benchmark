#!/usr/bin/env bash
#
# SSG Benchmark - Content Generator (v2)
#
# Generates a deterministic, seeded corpus of markdown bodies shared by ALL
# SSGs, then emits per-SSG files that differ only in front-matter format.
# This guarantees every SSG builds byte-identical content for a given
# (scenario, page index), and that runs are reproducible across machines.
#
# Scenarios:
#   minimal  - plain markdown body, no tags (no taxonomy work anywhere)
#   blog     - body + 2 tags per post from a fixed pool of 10
#   heavy    - blog + fenced code blocks in the body (syntax highlighting load)
#
# Compatible with macOS bash 3.2 (no associative arrays, no mapfile).

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

SSG=""
COUNT=100
OUTPUT_DIR=""
SCENARIO="${SCENARIO:-minimal}"
SEED="${SEED:-42}"
CORPUS_ROOT="${CORPUS_DIR:-${PROJECT_DIR}/.corpus}"

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -s, --ssg NAME        SSG name (hugo, zola, jekyll, blades, hwaro, eleventy, pelican, hexo, gatsby, astro, docusaurus)"
    echo "  -c, --count N         Number of pages to generate (default: 100)"
    echo "  -o, --output DIR      Output directory (site root)"
    echo "  -n, --scenario NAME   Scenario: minimal, blog, heavy (default: minimal)"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Environment variables: SEED (default 42), CORPUS_DIR (default .corpus/)"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--ssg) SSG="$2"; shift 2 ;;
        -c|--count) COUNT="$2"; shift 2 ;;
        -o|--output) OUTPUT_DIR="$2"; shift 2 ;;
        -n|--scenario) SCENARIO="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) log_error "Unknown option: $1"; usage; exit 1 ;;
    esac
done

[ -n "$SSG" ] || { log_error "SSG name is required"; usage; exit 1; }
[ -n "$OUTPUT_DIR" ] || { log_error "Output directory is required"; usage; exit 1; }

case $SCENARIO in
    minimal|blog|heavy) ;;
    *) log_error "Unknown scenario: ${SCENARIO} (expected minimal, blog, heavy)"; exit 1 ;;
esac

mkdir -p "$OUTPUT_DIR"

# =============================================================================
# Deterministic building blocks
# =============================================================================

PARAGRAPHS=(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
    "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
    "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem."
    "Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?"
    "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
    "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident."
)

TITLES=(
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

TAG_POOL=(performance tutorial webdev deployment markdown templates seo automation testing design)

CODE_LANGS=(javascript python rust go ruby crystal)
CODE_SNIPPETS=(
'function buildPages(pages) {
  const results = [];
  for (const page of pages) {
    const html = render(page.template, page.data);
    results.push({ path: page.path, html });
  }
  return results;
}

module.exports = { buildPages };'
'def build_pages(pages):
    results = []
    for page in pages:
        html = render(page["template"], page["data"])
        results.append({"path": page["path"], "html": html})
    return results


if __name__ == "__main__":
    print(len(build_pages(load_pages())))'
'pub fn build_pages(pages: &[Page]) -> Vec<Output> {
    pages
        .iter()
        .map(|page| Output {
            path: page.path.clone(),
            html: render(&page.template, &page.data),
        })
        .collect()
}'
'func BuildPages(pages []Page) []Output {
	outputs := make([]Output, 0, len(pages))
	for _, page := range pages {
		html := Render(page.Template, page.Data)
		outputs = append(outputs, Output{Path: page.Path, HTML: html})
	}
	return outputs
}'
'def build_pages(pages)
  pages.map do |page|
    html = render(page[:template], page[:data])
    { path: page[:path], html: html }
  end
end

puts build_pages(load_pages).size'
'def build_pages(pages : Array(Page)) : Array(Output)
  pages.map do |page|
    html = render(page.template, page.data)
    Output.new(path: page.path, html: html)
  end
end

puts build_pages(load_pages).size'
)

# Date derived purely from the page index: valid, unique-ish, reproducible.
page_date() {
    local i=$1
    local day=$((1 + (i % 28)))
    local month=$((1 + ((i / 28) % 12)))
    local year=$((2025 - (i / 336)))
    printf "%04d-%02d-%02d" "$year" "$month" "$day"
}

page_title() {
    local i=$1
    echo "${TITLES[$(((i - 1) % ${#TITLES[@]}))]} - Part ${i}"
}

# Two distinct tags from the pool, derived from the page index.
page_tags() {
    local i=$1
    local t1=$((i % 10))
    local t2=$(((i / 10 + i + 3) % 10))
    [ "$t1" -eq "$t2" ] && t2=$(((t2 + 1) % 10))
    echo "${TAG_POOL[$t1]} ${TAG_POOL[$t2]}"
}

# =============================================================================
# Corpus: shared markdown bodies, cached under .corpus/<class>/NNNNN.md
# =============================================================================

corpus_class() {
    case $SCENARIO in
        heavy) echo "code" ;;
        *) echo "plain" ;;
    esac
}

emit_paragraphs() {
    local n=$1
    local j
    for j in $(seq 1 "$n"); do
        echo "${PARAGRAPHS[$((RANDOM % ${#PARAGRAPHS[@]}))]}"
        echo ""
    done
}

emit_code_block() {
    local idx=$1
    echo '```'"${CODE_LANGS[$idx]}"
    echo "${CODE_SNIPPETS[$idx]}"
    echo '```'
    echo ""
}

generate_body() {
    local i=$1
    local class=$2
    local title
    title=$(page_title "$i")

    # Seed bash's PRNG per page: body depends only on (SEED, i), never on COUNT.
    RANDOM=$((SEED + i))

    echo "# ${title}"
    echo ""
    emit_paragraphs $((3 + RANDOM % 3))
    echo "## Section One"
    echo ""
    emit_paragraphs $((3 + RANDOM % 3))
    if [ "$class" = "code" ]; then emit_code_block $((i % 6)); fi
    echo "## Section Two"
    echo ""
    emit_paragraphs $((3 + RANDOM % 3))
    if [ "$class" = "code" ]; then emit_code_block $(((i + 2) % 6)); fi
    echo "## Conclusion"
    echo ""
    emit_paragraphs 1
    if [ "$class" = "code" ]; then emit_code_block $(((i + 4) % 6)); fi
}

ensure_corpus() {
    local class corpus_dir i body_file missing=0
    class=$(corpus_class)
    corpus_dir="${CORPUS_ROOT}/${class}"
    mkdir -p "$corpus_dir"

    for i in $(seq 1 "$COUNT"); do
        body_file="${corpus_dir}/$(printf "%05d" "$i").md"
        if [ ! -f "$body_file" ]; then
            generate_body "$i" "$class" > "$body_file"
            missing=$((missing + 1))
        fi
    done

    if [ "$missing" -gt 0 ]; then
        log "Corpus: generated ${missing} new bodies in ${corpus_dir}"
    fi
    CORPUS_DIR_RESOLVED="$corpus_dir"
}

corpus_file() {
    printf "%s/%05d.md" "$CORPUS_DIR_RESOLVED" "$1"
}

# =============================================================================
# Per-SSG emitters: front matter + shared body. Never overwrite existing
# non-content files (configs/templates come from sites/ and scenarios/).
# =============================================================================

with_tags() {
    # true when the scenario carries taxonomy metadata
    [ "$SCENARIO" != "minimal" ]
}

generate_hugo_content() {
    local dir="${OUTPUT_DIR}/content/posts" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "---"
            echo "title: \"${title}\""
            echo "date: ${date}"
            echo "draft: false"
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "tags: [\"${t1}\", \"${t2}\"]"
            fi
            echo "---"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_zola_content() {
    local dir="${OUTPUT_DIR}/content/posts" i date title tags t1 t2
    mkdir -p "$dir"
    if [ ! -f "${dir}/_index.md" ]; then
        cat > "${dir}/_index.md" << 'EOF'
+++
title = "Posts"
sort_by = "date"
template = "section.html"
page_template = "page.html"
+++
EOF
    fi
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "+++"
            echo "title = \"${title}\""
            echo "date = ${date}"
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "[taxonomies]"
                echo "tags = [\"${t1}\", \"${t2}\"]"
            fi
            echo "+++"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_jekyll_content() {
    local dir="${OUTPUT_DIR}/_posts" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "---"
            echo "title: \"${title}\""
            echo "date: ${date}"
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "tags: [${t1}, ${t2}]"
            fi
            echo "---"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/${date}-post-${i}.md"
    done
}

generate_blades_content() {
    local dir="${OUTPUT_DIR}/content" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "+++"
            echo "title = \"${title}\""
            echo "date = \"${date}\""
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "[taxonomies]"
                echo "tags = [\"${t1}\", \"${t2}\"]"
            fi
            echo "+++"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_hwaro_content() {
    local dir="${OUTPUT_DIR}/content/posts" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "+++"
            echo "title = \"${title}\""
            echo "date = \"${date}\""
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo ""
                echo "[taxonomies]"
                echo "tags = [\"${t1}\", \"${t2}\"]"
            fi
            echo "+++"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_eleventy_content() {
    local dir="${OUTPUT_DIR}/posts" i date title tags t1 t2
    mkdir -p "$dir"
    # Directory data: layout + the "post" collection tag for every post.
    if [ ! -f "${dir}/posts.json" ]; then
        cat > "${dir}/posts.json" << 'EOF'
{
  "layout": "post.njk",
  "tags": "post"
}
EOF
    fi
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "---"
            echo "title: \"${title}\""
            echo "date: ${date}"
            if with_tags; then
                # Front-matter tags replace directory-data tags, so keep "post".
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "tags: [\"post\", \"${t1}\", \"${t2}\"]"
            fi
            echo "---"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_pelican_content() {
    local dir="${OUTPUT_DIR}/content" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "Title: ${title}"
            echo "Date: ${date}"
            echo "Slug: post-${i}"
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "Tags: ${t1}, ${t2}"
            fi
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_hexo_content() {
    local dir="${OUTPUT_DIR}/source/_posts" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "---"
            echo "title: \"${title}\""
            echo "date: ${date}"
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "tags:"
                echo "  - ${t1}"
                echo "  - ${t2}"
            fi
            echo "---"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_gatsby_content() {
    local dir="${OUTPUT_DIR}/src/posts" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "---"
            echo "title: \"${title}\""
            echo "date: ${date}"
            echo "slug: \"post-${i}\""
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "tags: [\"${t1}\", \"${t2}\"]"
            fi
            echo "---"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_astro_content() {
    local dir="${OUTPUT_DIR}/src/pages/posts" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "---"
            echo "layout: ../../layouts/Base.astro"
            echo "title: \"${title}\""
            echo "date: ${date}"
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "tags: [\"${t1}\", \"${t2}\"]"
            fi
            echo "---"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/post-${i}.md"
    done
}

generate_docusaurus_content() {
    local dir="${OUTPUT_DIR}/blog" i date title tags t1 t2
    mkdir -p "$dir"
    for i in $(seq 1 "$COUNT"); do
        date=$(page_date "$i"); title=$(page_title "$i")
        {
            echo "---"
            echo "slug: post-${i}"
            echo "title: \"${title}\""
            echo "date: ${date}"
            if with_tags; then
                tags=$(page_tags "$i"); t1=${tags%% *}; t2=${tags##* }
                echo "tags: [${t1}, ${t2}]"
            fi
            echo "---"
            echo ""
            cat "$(corpus_file "$i")"
        } > "${dir}/${date}-post-${i}.md"
    done
}

# =============================================================================
# Main
# =============================================================================

main() {
    log "Content Generator (scenario=${SCENARIO}, seed=${SEED})"
    log "SSG: ${SSG} | Count: ${COUNT} | Output: ${OUTPUT_DIR}"

    ensure_corpus

    case $SSG in
        hugo) generate_hugo_content ;;
        zola) generate_zola_content ;;
        jekyll) generate_jekyll_content ;;
        blades) generate_blades_content ;;
        hwaro) generate_hwaro_content ;;
        eleventy) generate_eleventy_content ;;
        pelican) generate_pelican_content ;;
        hexo) generate_hexo_content ;;
        gatsby) generate_gatsby_content ;;
        astro) generate_astro_content ;;
        docusaurus) generate_docusaurus_content ;;
        *)
            log_error "Unknown SSG: ${SSG}"
            log_error "Supported: hugo, zola, jekyll, blades, hwaro, eleventy, pelican, hexo, gatsby, astro, docusaurus"
            exit 1
            ;;
    esac

    log_success "Generated ${COUNT} pages for ${SSG} (${SCENARIO})"
}

main "$@"
