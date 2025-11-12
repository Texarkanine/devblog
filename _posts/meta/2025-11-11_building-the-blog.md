---
layout: post
title: "Building the Blog"
author: texarkanine
tags: [jekyll]
---

I used to have a WordPress devblog but that went the way that WordPress blogs go - ne'er-do-wells got in and turned it to all sorts of nefarious purposes. Static sites won't have that problem, right?

## The Stack

The foundation is straightforward: Jekyll generates static HTML. GitHub Actions builds it, and GitHub Pages serves it. The interesting part, if you can call it that, is what happens in between.

`jekyll-archives` generates tag pages automatically. Write a post, add some tags, and the plugin creates index pages for each one. No manual maintenance required.

Author pages work differently. The `jekyll-auto-authors` plugin reads from a data file and creates a page for each author, listing their posts. It needs `jekyll-paginate-v2` as a dependency, though we don't actually paginate anything—the plugin just requires it. Weird but that's FLOSS plugins. Happens a lot in video game mods, too. Making libraries needs to be easier.

Categories come from folder structure. Put a post in `_posts/tutorials/`, and it gets the `tutorials` category. This happens automatically unless you override it in front matter.

## Three Ways to Organize

The blog supports three independent classification systems:

**Authors** use the `author:` field. Each author gets a page showing their bio and posts.

**Categories** come from folders in `_posts/`. They're hierarchical—nest folders, get nested categories.

**Tags** are explicitly set in front matter. They're for topics, not structure.

None of these conflict. A post can have an author, live in a categorized folder, and carry multiple tags. Each system operates independently.

## The Theme

We use ["no style, please"](http://jekyllthemes.org/themes/no-style-please/) - a theme that's almost entirely unstyled. It provides basic HTML structure and leaves the browser to render sensible defaults. The CSS file is under 1KB. I think it's delightfully pretentious in a way that reminds one of Martin Fowler and Paul Graham's *actually* unpretentious, foundational blogs. But here it's on purpose, a skeuomorphism of sorts in an age of 16:9 monitors, vertical phone screens, and no fear of scrolling because everything always extends beyond the fold.

This isn't minimalism for its own sake. Fast sites are better sites. Every kilobyte of CSS that doesn't ship is one less thing to download, parse, and apply. The theme removes decisions rather than adding them. And that's why there are like eleven files to configure the website and it requires Ruby and gems downloaded from a public package repository. Tongue out of cheek though, it's just the age-old bulid-time vs run-time tradeoff.

Can't* get a remote shell on a static site!
