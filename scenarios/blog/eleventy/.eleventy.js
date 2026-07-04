// Eleventy — blog scenario: tag pages + pagination(10) + feed (limit 20)
// + build-time syntax highlighting (@11ty/eleventy-plugin-syntaxhighlight,
// Prism). The plugin is preinstalled globally in the Docker image (NODE_PATH
// is set there).
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");

module.exports = function(eleventyConfig) {
  eleventyConfig.addPlugin(syntaxHighlight);

  eleventyConfig.addFilter("dateFormat", function(date, fmt) {
    const d = new Date(date);
    if (fmt === "iso") return d.toISOString().slice(0, 10);
    return d.toLocaleDateString("en-US", { year: "numeric", month: "long", day: "numeric" });
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
