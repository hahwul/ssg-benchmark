import React from "react";
import { graphql } from "gatsby";

const IndexPage = ({ data }) => {
  const posts = data.allMarkdownRemark.nodes;
  return (
    <html lang="en">
      <head>
        <meta charSet="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>SSG Benchmark Site</title>
      </head>
      <body>
        <header>
          <h1>SSG Benchmark Site</h1>
          <nav>
            <a href="/">Home</a>
          </nav>
        </header>
        <main>
          <h2>Recent Posts</h2>
          <ul>
            {posts.slice(0, 10).map((post) => (
              <li key={post.frontmatter.slug}>
                <a href={`/posts/${post.frontmatter.slug}/`}>
                  {post.frontmatter.title}
                </a>
                <time dateTime={post.frontmatter.date}>
                  {post.frontmatter.date}
                </time>
              </li>
            ))}
          </ul>
        </main>
        <footer>
          <p>&copy; SSG Benchmark</p>
        </footer>
      </body>
    </html>
  );
};

export default IndexPage;

export const query = graphql`
  {
    allMarkdownRemark(sort: { frontmatter: { date: DESC } }) {
      nodes {
        frontmatter {
          title
          date
          slug
        }
      }
    }
  }
`;
