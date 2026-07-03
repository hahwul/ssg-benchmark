# Pelican — blog scenario: tag pages (simple theme) + pagination(10)
# + atom feed (limit 20).

AUTHOR = 'SSG Benchmark'
SITENAME = 'SSG Benchmark Site'
SITEURL = 'http://example.com'

PATH = 'content'
OUTPUT_PATH = 'output'

TIMEZONE = 'UTC'
DEFAULT_LANG = 'en'

THEME = 'theme'

DEFAULT_PAGINATION = 10

FEED_ALL_ATOM = 'feeds/all.atom.xml'
FEED_MAX_ITEMS = 20
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

RELATIVE_URLS = False

# Parity: only index + per-tag pages; no author/category archives.
DIRECT_TEMPLATES = ['index']
AUTHOR_SAVE_AS = ''
CATEGORY_SAVE_AS = ''
PAGINATED_TEMPLATES = {'index': None}
