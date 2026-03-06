# Project Brief

## User Story

As a reader of the blog, I want to see a small link icon when I hover over a heading so that I can copy or open a URL that jumps directly to that section.

## Use-Case(s)

### Use-Case 1

Reader hovers over a heading (e.g. "Software Has No Characteristic Specificity") and a configurable icon (e.g. `#`) appears; clicking it or copying the link gives a fragment URL (e.g. `.../pink-margarine#software-has-no-characteristic-specificity`) for sharing or bookmarking.

### Use-Case 2

Site owner configures which icon to show (pound sign, paragraph sign, link glyph, etc.) via site config; default is `#`.

## Requirements

1. Headings in rendered Jekyll output must have stable `id` attributes (anchor targets).
2. Each heading must have an associated link whose `href` is the heading’s `id` fragment.
3. The link must be visible on hover (e.g. icon only); minimal client-side CSS allowed, no client-side JS.
4. Icon/label is configurable (e.g. `#`, `¶`, link glyph); default `#`.
5. All behavior is implemented at build time (Liquid, plugin, or post-process); no runtime JavaScript for this feature.

## Constraints

1. No client-side JavaScript for anchor links.
2. Client-side CSS is acceptable but should be kept minimal.
3. Must work with existing Kramdown/Jekyll pipeline and remote theme.

## Acceptance Criteria

1. On the built site, every heading (h1–h6) in post/article content has an `id` and a same-page anchor link.
2. The anchor link is shown on hover (or always, if that’s the chosen minimal design) and uses the configured icon.
3. Visiting `.../page#heading-slug` scrolls to that heading.
4. Config change (e.g. `anchor_icon: "¶"`) updates the icon site-wide after rebuild.
