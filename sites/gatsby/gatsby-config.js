/**
 * Gatsby Configuration for SSG Benchmark
 */
module.exports = {
  siteMetadata: {
    title: "SSG Benchmark Site",
    description: "Benchmark site for testing SSG performance",
    siteUrl: "http://example.com",
  },
  plugins: [
    {
      resolve: "gatsby-source-filesystem",
      options: {
        name: "posts",
        path: `${__dirname}/src/posts`,
      },
    },
    "gatsby-transformer-remark",
  ],
};
