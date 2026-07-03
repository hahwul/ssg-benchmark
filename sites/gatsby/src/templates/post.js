import React from "react";
import { graphql } from "gatsby";

const PostTemplate = ({ data }) => {
  const post = data.markdownRemark;
  return (
    <html lang="en">
      <head>
        <meta charSet="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>{post.frontmatter.title} | SSG Benchmark Site</title>
      </head>
      <body>
        <header>
          <h1>SSG Benchmark Site</h1>
          <nav>
            <a href="/">Home</a>
          </nav>
        </header>
        <main>
          <article>
            <h1>{post.frontmatter.title}</h1>
            <time dateTime={post.frontmatter.date}>
              {post.frontmatter.date}
            </time>
            <div dangerouslySetInnerHTML={{ __html: post.html }} />
          </article>
        </main>
        <footer>
          <p>&copy; SSG Benchmark</p>
        </footer>
      </body>
    </html>
  );
};

export default PostTemplate;

export const query = graphql`
  query ($slug: String!) {
    markdownRemark(frontmatter: { slug: { eq: $slug } }) {
      html
      frontmatter {
        title
        date
      }
    }
  }
`;
