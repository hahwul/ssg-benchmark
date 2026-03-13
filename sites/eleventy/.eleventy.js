module.exports = function(eleventyConfig) {
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
