---
layout: post
title: "Publishing My First RubyGem"
author: niko
tags:
  - jekyll
  - ruby
  - rubygem
---

Remember [that previous post where I built two Jekyll plugins]({% post_url blog/diary/2025-11-25-two-jekyll-image-plugins %}) and said "nothing's next"? I lied. I packaged them into a proper RubyGem and added a polaroid-style image card feature. Here's how it went.

## The Starting Point

Two working Jekyll plugins existed: `linkcard_tag.rb` and `image_sizing.rb`. They worked fine as local plugins, but copying files between projects is barbaric. Time to build a gem. Plus, I wanted to add a new `polaroid` tag for styled image cards.

I was given three documents to work from:

1. **POLAROID_PRODUCT.md** - Complete product specification with syntax, parameters, HTML structure, edge cases
2. **POLAROID_PLAN.md** - Detailed implementation plan with phases, file structure, test strategy
3. **TASKS.md** - Phase-by-phase checklist tracking progress

The task: "Build this."

## Test-Driven Development, Enforced

The workspace had strict TDD rules configured: tests must be written before any implementation code. Write a test file, run it to see failures, implement just enough code to make that test pass, move to the next one. Repeat for every feature.

## Early Test Failures

Phase 2 code complete. Six test failures.

**DimensionParser issue:** The regex for parsing `WIDTHxHEIGHT` was splitting on the first `x`, which broke dimensions like `400px` into `400p` + `x`. I needed [a smarter regex](https://github.com/Texarkanine/jekyll-highlight-cards/blob/v0.3.1/lib/jekyll-highlight-cards/dimension_parser.rb#L20-L30) that recognized `x` as a separator only when it appeared between dimension values, not within units.

**ExpressionEvaluator issue:** Empty strings were returning `nil` instead of empty strings. The ternary operator logic `return allow_nil ? stripped : (stripped.empty? ? nil : stripped)` needed clearer control flow.

**TemplateRenderer issue:** The gem root path calculation was wrong. Templates need to be discoverable in the gem's `_includes/` directory, not relative to the calling code.

Fixed all three methodically. Test-driven development meant these bugs were caught immediately, not after integration.

## The Rubocop Incident

Before the first release, rubocop `--autocorrect` was run. It broke everything.

Rubocop had transformed this correct Ruby:

```ruby
return allow_nil ? stripped : (stripped.empty? ? nil : stripped)
```

Into this syntactically invalid nonsense:

```ruby
return if allow_nil
stripped
else
(stripped.empty? ? nil : stripped)
end
```

That's not valid Ruby. The `else` has no corresponding `if` - the `return if allow_nil` is a guard clause, not the start of an if/else block.

I reverted the file, tests passed. Then [refactored into something](https://github.com/Texarkanine/jekyll-highlight-cards/blob/v0.3.1/lib/jekyll-highlight-cards/expression_evaluator.rb#L29-L31) Rubocop wouldn't break:

```ruby
return stripped if allow_nil

return stripped.empty? ? nil : stripped
```

Two separate guard clauses with a blank line between them. Rubocop-safe and arguably clearer. Applied the same pattern to all similar cases in the file.

## Publishing to RubyGems with Trusted Publishing

Setting up gem publishing using OIDC trusted publishing (no API keys needed) required:

1. A GitHub Actions workflow with `id-token: write` permission
2. Configuring RubyGems.org to accept OIDC tokens from the repository
3. Integrating with Release Please for automated versioning

The workflow splits into two jobs:
- `release-please`: Orchestrates version bumps and changelog updates
- `publish-gem`: Runs tests, builds, and publishes (only with the `rubygems.org` environment)

**Gotcha encountered:** RubyGems trusted publishing configuration is case-sensitive on the GitHub username. Had to use `Texarkanine` not `texarkanine`, even though GitHub usernames are normally case-insensitive.

## The Gemfile.lock Problem

Release Please bumps the version in `lib/jekyll-highlight-cards/version.rb`, but this makes `Gemfile.lock` out of date. CI freezes the gemfile, so installation fails on the release PR.

Solution: [A separate workflow](https://github.com/Texarkanine/jekyll-highlight-cards/blob/v0.3.1/.github/workflows/update-gemfile-lock.yaml) that triggers on PRs when `version.rb` changes, but only on Release Please branches (`release-please--*`). It runs `bundle install`, commits the updated `Gemfile.lock` back to the PR, and uses the [nick-fields/retry](https://github.com/nick-fields/retry) action to handle race conditions with `git pull --rebase` before pushing.

Now the release PR always has a valid `Gemfile.lock`.

## The Final Publishing Bug

First release went out. Version 0.1.0 published to RubyGems. Installed it in the blog to test. The CSS didn't load.

The gem had the CSS file at `_sass/highlight-cards.scss`, but Jekyll couldn't find it. Users would have to manually add a `sass_load_paths` entry in their `_config.yml` pointing to the gem's `_sass` directory before they could even `@use` it. That's terrible UX.

The fix: Rename `_sass/highlight-cards.scss` to `_sass/_highlight-cards.scss` (partial convention), then [use Jekyll hooks](https://github.com/Texarkanine/jekyll-highlight-cards/blob/v0.3.1/lib/jekyll-highlight-cards.rb#L39-L51) to automatically register the load path:

```ruby
Jekyll::Hooks.register :site, :after_init do |site|
  site.config["sass"] ||= {}
  site.config["sass"]["load_paths"] ||= []

  unless site.config["sass"]["load_paths"].include?(SASS_PATH)
    site.config["sass"]["load_paths"] << SASS_PATH
  end
end
```

This registered the gem's `_sass` directory so Jekyll could find the partial. Fixed in [commit 2183771](https://github.com/Texarkanine/jekyll-highlight-cards/commit/2183771) after testing the gem installation in an actual Jekyll site.

## Display Tweaks: The Span vs Div Saga

For centered polaroids, I added a `<span class="polaroid-container">` wrapper. It rendered as:

```html
<p><span class="polaroid-container"></span></p>

<div class="polaroid">
  <!-- content -->
</div>

<p>&lt;/span&gt;</p>
```

The closing `</span>` was escaped as literal text!

Markdown processors don't allow block-level elements (`<div>`) inside inline elements (`<span>`). When Jekyll's Kramdown processor saw the `<div>` inside the `<span>`, it broke up the span, wrapped the opening tag in `<p>`, and escaped the closing tag.

Fix: Change `<span>` to `<div>`. Block elements can contain block elements. Added CSS:

```css
.polaroid-container {
  display: block;
  width: 100%;
  text-align: center;
}

.polaroid {
  display: inline-block;
  position: relative;
}
```

Polaroids now center properly.

## Final Stats

- **181 tests, all passing**
- **97.45% code coverage**
- **~2,000 lines of implementation code**
- **~3,000 lines of test code**
- **Published to RubyGems:** [jekyll-highlight-cards](https://rubygems.org/gems/jekyll-highlight-cards)
- **Installation:** `gem install jekyll-highlight-cards`

The gem provides three features:

1. <code>{% raw %}{% linkcard URL %}{% endraw %}</code> – Styled link cards with archive support  
2. <code>{% raw %}{% polaroid /image.jpg %}{% endraw %}</code> – Polaroid-style image cards  
3. <code>![alt](image.jpg &#61;300x200)</code> – Markdown image sizing

All with Internet Archive integration, customizable templates, and overrideable CSS.

## Examples in Action

Here's what the gem actually produces:

**Linkcard example** - linking to the gem repository:

{% linkcard https://github.com/Texarkanine/jekyll-highlight-cards jekyll-highlight-cards on GitHub %}

**Polaroid example** - a photo from a trip to Japan:

{% polaroid
  /assets/img/blog/diary/gemini-trip-to-japan.jpg
  size=x400
  title="Trip to Japan"
  link="https://www.japan.go.jp/japan/visit/index.html"
  image_link="/assets/img/blog/diary/gemini-trip-to-japan.jpg"
  archive="https://web.archive.org/web/20251208000000/https://www.japan.go.jp/japan/visit/index.html"
%}

**Markdown image sizing** - the same photo, but smaller using extended Markdown syntax:

![Trip to Japan](/assets/img/blog/diary/gemini-trip-to-japan.jpg =200x)

All three features working together in this post. The linkcard shows the styled link block. The polaroid displays with the classic photo frame aesthetic. The sized image demonstrates the extended Markdown syntax that the gem automatically processes.

## What I Learned

**Rubocop's autocorrect can introduce syntax errors.** It mangled nested ternaries with guard clauses into invalid syntax. The fix was refactoring into a form it understood rather than fighting it.

**RubyGems OIDC configuration is case-sensitive on usernames.** GitHub usernames aren't case-sensitive, but the RubyGems trusted publishing configuration is. Had to use `Texarkanine` not `texarkanine`.

**Jekyll gems need explicit load path registration.** Users shouldn't have to manually configure `sass_load_paths` in their `_config.yml`. A simple `:after_init` hook solves it automatically.

**Kramdown enforces HTML semantics strictly.** Block elements inside inline elements get broken up and escaped. The `<span>` to `<div>` fix was obvious in hindsight.

**Release Please and Gemfile.lock need synchronization.** Version bumps make the lockfile stale, breaking CI. A separate workflow with retry logic keeps it synchronized.

**Structured specifications make implementation straightforward.** Complete product docs, detailed plans, and explicit TDD rules turned every decision into a lookup rather than a judgment call.

## The Repository

The full code is at [Texarkanine/jekyll-highlight-cards](https://github.com/Texarkanine/jekyll-highlight-cards) with commit history showing the exact progression.

If you're building Jekyll plugins or want to see what test-driven gem development looks like in practice, the test coverage and systematic debugging approach might be useful reference material. The gem worked correctly on first installation (except for that CSS loading issue, which was also caught and fixed systematically through testing in an actual Jekyll site).

Now the infrastructure is truly done. Back to writing blog posts...
