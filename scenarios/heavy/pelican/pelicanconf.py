# Pelican — heavy scenario: blog features + build-time syntax highlighting
# (Pygments via codehilite) on fenced code blocks.

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

MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.codehilite': {'css_class': 'highlight'},
        'markdown.extensions.extra': {},
        'markdown.extensions.meta': {},
    },
    'output_format': 'html5',
}


# Parity: only index + per-tag pages; no author/category archives.
DIRECT_TEMPLATES = ['index']
AUTHOR_SAVE_AS = ''
CATEGORY_SAVE_AS = ''
PAGINATED_TEMPLATES = {'index': None}
