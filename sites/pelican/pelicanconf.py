AUTHOR = 'SSG Benchmark'
SITENAME = 'SSG Benchmark Site'
SITEURL = ''

PATH = 'content'
OUTPUT_PATH = 'output'

TIMEZONE = 'UTC'
DEFAULT_LANG = 'en'

# Disable feeds for benchmarking
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Use simple theme
THEME = 'theme'

# Disable unnecessary features for benchmarking
RELATIVE_URLS = True
DEFAULT_PAGINATION = False

# Minimal-scenario parity: only the index aggregate page; no per-author,
# per-category, per-tag archive pages (other SSGs don't build these here).
DIRECT_TEMPLATES = ['index']
AUTHOR_SAVE_AS = ''
CATEGORY_SAVE_AS = ''
TAG_SAVE_AS = ''
