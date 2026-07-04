// Eleventy — heavy scenario: blog features (tags, pagination, feed, Prism
// highlighting via @11ty/eleventy-plugin-syntaxhighlight, preinstalled
// globally in the Docker image with NODE_PATH set) + template-heavy layouts:
// sidebar include on every page (recent posts + tag cloud), breadcrumbs,
// prev/next post navigation.
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");

module.exports = function(eleventyConfig) {
  eleventyConfig.addPlugin(syntaxHighlight);

  eleventyConfig.addFilter("dateFormat", function(date, fmt) {
    const d = new Date(date);
    if (fmt === "iso") return d.toISOString().slice(0, 10);
    return d.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" });
  });

  // All content tags with post counts, for the sidebar tag cloud.
  eleventyConfig.addCollection("tagList", function(collectionApi) {
    const counts = new Map();
    for (const post of collectionApi.getFilteredByTag("post")) {
      for (const tag of post.data.tags || []) {
        if (tag === "post") continue;
        counts.set(tag, (counts.get(tag) || 0) + 1);
      }
    }
    return Array.from(counts.entries())
      .sort((a, b) => (a[0] < b[0] ? -1 : 1))
      .map(([name, count]) => ({ name, count }));
  });

  return {
    dir: {
      input: ".",
      includes: "_includes",
      output: "_site"
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk"
  };
};
