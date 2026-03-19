const path = require("path");

exports.createPages = async ({ graphql, actions }) => {
  const { createPage } = actions;
  const postTemplate = path.resolve("src/templates/post.js");

  const result = await graphql(`
    {
      allMarkdownRemark(sort: { frontmatter: { date: DESC } }) {
        nodes {
          frontmatter {
            slug
          }
        }
      }
    }
  `);

  if (result.errors) {
    throw result.errors;
  }

  result.data.allMarkdownRemark.nodes.forEach((node) => {
    createPage({
      path: `/posts/${node.frontmatter.slug}/`,
      component: postTemplate,
      context: {
        slug: node.frontmatter.slug,
      },
    });
  });
};
