// @ts-check

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'SSG Benchmark Site',
  tagline: 'Benchmark site for testing SSG performance',
  url: 'http://example.com',
  baseUrl: '/',
  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: false,
        blog: {
          routeBasePath: '/posts',
          showReadingTime: false,
          blogSidebarCount: 0,
        },
        theme: {
          customCss: [],
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: 'SSG Benchmark Site',
        items: [
          { to: '/posts', label: 'Posts', position: 'left' },
        ],
      },
      footer: {
        style: 'dark',
        copyright: `&copy; SSG Benchmark`,
      },
    }),
};

module.exports = config;
