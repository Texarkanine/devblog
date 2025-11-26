---
layout: post
title: "Two Jekyll Image Plugins"
author: niko
tags: [jekyll, ruby, markdown]
---

Built two custom Jekyll plugins today to handle images in blog posts. What started as "I don't want to type the full path" turned into an exercise in keeping things simple.

## The Initial Problem

I had a post in `blog/record/_posts/` with an image reference:

```markdown
![Look at this dog](/blog/record/thisdog.jpg)
```

That `/blog/record/` path felt redundant - the post already lives in that directory. Why repeat myself? Plus, we had `jekyll-images-cdn` for prepending CDN URLs, which was working fine for local development with `/assets/img`. We had already shaved *that* prefix off, why couldn't we shave off the rest of the prefix?

## First Solution: image_paths.rb

Built a plugin that:
1. Extracts the post's directory from its path
2. Resolves relative image paths (like `thisdog.jpg`) to that directory
3. Applies CDN configuration from `_config.yaml`

So now I can write `![Dog](thisdog.jpg)` and get `/assets/img/blog/record/thisdog.jpg`. Perfect. Removed `jekyll-images-cdn` since we integrated that functionality directly.

## The Second Problem

I have a tall, narrow image that was filling 100% width and dominating the page. I wanted dimension control. Found that some Markdown processors support extended syntax like:

```markdown
![Image](photo.jpg =300x200)
```

Nice! Let's add that.

## One Plugin or Two?

Should this be in the same plugin or separate? I initially thought "they both process images, combine them!" But after thinking it through:

**Arguments for combining:**
- Same `<img>` target
- One regex pass
- Fewer files

**Arguments for separating:**
- Single Responsibility Principle
- Different concerns: functional (path resolution) vs presentational (styling)
- Different hook points (sizing needs pre_render to parse Markdown, paths work post_render on HTML)
- Different configs
- Independently useful

**Decision: Separate.** Path resolution is infrastructure; sizing is aesthetic preference. Keep 'em apart.

## Building image_sizing.rb

The implementation was... educational.

### Challenge 1: Comment Markers

The approach: parse `![alt](url =WIDTHxHEIGHT)` in `pre_render`, inject an HTML comment marker, then process it in `post_render`.

First attempt: Used `=WIDTHxHEIGHT` as the marker format.
Problem: Regex parsing got confused when splitting on 'x'.

Fixed: Changed to `:` separators in the comment: `<!-- IMG_SIZE:300:200:hr -->`

### Challenge 2: Paragraph Wrapping

Jekyll wraps some images in `<p>` tags, some not. The regex needed to handle both:

```ruby
/<p>)?<img\s+([^>]*)><!-- IMG_SIZE:... -->(<\/p>)?/
```

Capture the paragraph tags, preserve them in output.

### Challenge 3: Code Blocks

The plugin was processing image syntax everywhere, including inside code fences and inline code blocks. So examples like `![alt](url =300x200)` were getting transformed into `![alt](url)<!-- IMG_SIZE:... -->` in the rendered output, which I discovered when I wrote them for this post!

Fixed: Track code fence state line by line, and split each line by backticks to track inline code state. Only process image syntax when outside both.

The logic handles triple-backtick fences, tilde fences, and inline backticks. About 30 lines of careful state tracking, but now code examples stay untouched.

### Challenge 4: The Horizontal Rules Feature

Initial plan: When height is specified in pixels, wrap with `<hr>` tags for visual emphasis.

Implemented it. Worked great! Images with height got horizontal rules above and below.

Then realized: This only triggered when BOTH width and height were specified, not just height alone. The logic was getting complex. And honestly, did I really want automatic HRs?

**Decision: Kill the feature.** Let users add `---` in their Markdown if they want horizontal rules. Plugin should just do sizing.

Removed ~15 lines of HR logic. Much cleaner.

## The Final Result

Two plugins, each doing one thing well:

1. **image_paths.rb**: Resolves relative paths based on post location, applies CDN config
2. **image_sizing.rb**: Parses `=WIDTHxHEIGHT` syntax, applies dimensions

Usage:
```markdown
![Dog](thisdog.jpg =x400)
```

Output:
```html
<img src="/assets/img/blog/record/thisdog.jpg" alt="Dog" height="400">
```

Both plugins run independently in sequence. No coupling. No complexity.

## What I Learned

**Separate concerns early.** Even if plugins process the same elements, if they serve different purposes, split them.

**Feature creep is real.** The HR feature seemed cool but added complexity for marginal benefit. I can add `---` myself when I want horizontal rules.

**Debug output matters.** Added `puts` statements to see exactly what the regex was capturing. Crucial for debugging that `:` vs `x` separator issue.

**Test with real content.** Created test posts with all the edge cases (width only, height only, both, neither). Caught several regex bugs this way.

**HTML comments as data carriers work well.** Injecting structured comments in `pre_render` then parsing them in `post_render` bridged the Markdown→HTML transformation cleanly.

**Simple is better.** The final versions are ~50-75 lines each, well-documented, with no clever tricks. Exactly what I wanted.

## What's Next?

Nothing. These plugins are done. They solve the problems I had, nothing more. And that's exactly right.

Now back to writing actual blog posts instead of building infrastructure for them...
