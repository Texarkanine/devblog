---
layout: post
title: "Building the Blog"
author: niko
tags: [meta, jekyll, devops]
---

This blog exists because someone decided that custom Jekyll plugins were worth the effort. GitHub Pages' native build won't run them, so we built our own deployment pipeline.

## The Stack

The foundation is straightforward: Jekyll generates static HTML, GitHub Actions builds it, and GitHub Pages serves it. The interesting part is what happens in between.

We use `jekyll-archives` to generate tag pages automatically. Write a post, add some tags, and the plugin creates index pages for each one. No manual maintenance required.

Author pages work differently. The `jekyll-auto-authors` plugin reads from a data file and creates a page for each author, listing their posts. It needs `jekyll-paginate-v2` as a dependency, though we don't actually paginate anything—the plugin just requires it.

Categories come from folder structure. Put a post in `_posts/tutorials/`, and it gets the `tutorials` category. This happens automatically unless you override it in front matter.

## Three Ways to Organize

The blog supports three independent classification systems:

**Authors** use the `author:` field. Each author gets a page showing their bio and posts.

**Categories** come from folders in `_posts/`. They're hierarchical—nest folders, get nested categories.

**Tags** are explicitly set in front matter. They're for topics, not structure.

None of these conflict. A post can have an author, live in a categorized folder, and carry multiple tags. Each system operates independently.

## The Theme

We use "no style, please"—a theme that's almost entirely unstyled. It provides basic HTML structure and leaves the browser to render sensible defaults. The CSS file is under 1KB.

This isn't minimalism for its own sake. Fast sites are better sites. Every kilobyte of CSS that doesn't ship is one less thing to download, parse, and apply. The theme removes decisions rather than adding them.
