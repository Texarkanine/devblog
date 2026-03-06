---
task_id: heading-anchor-links
date: 2026-03-06
complexity_level: 2
---

# Reflection: Heading anchor links (hover-to-reveal icon)

## Summary

Build-time heading anchor links were added via a new Jekyll post_render plugin and minimal CSS. All requirements were met; build and QA were clean.

## Requirements vs Outcome

- Every heading with an `id` (Kramdown default) gets an anchor link; configurable icon via `heading_anchor_icon` (default `#`). Hover-to-reveal is CSS-only; no client-side JS. Documentation and config added. No requirements were dropped or added.

## Plan Accuracy

The plan’s sequence (config → plugin → CSS → docs) and file list were correct. No reordering or new steps. The main risk (theme CSS entry point) was resolved in preflight by pinning `assets/css/main.scss`. No surprises during build.

## Build & QA Observations

Build succeeded on first run; manual inspection of `_site` confirmed anchors in article headings. QA found no semantic or pattern issues. No rework.

## Insights

### Technical

- Using `Nokogiri::HTML.fragment` on full-page `document.output` and then assigning `doc.to_html` back to `document.output` works as expected; the full document is preserved and headings are modified in place. No need to restrict processing to `<article>` only for this use case.

### Process

- Nothing notable – plan and preflight were sufficient.

### Million-Dollar Question

If “every heading is linkable” had been a core assumption, the same design would still be appropriate: a single post_render plugin and shared CSS. The only possible refinement would be theme-level support for the anchor icon (e.g. in the theme’s layout or CSS), but for a remote theme, a local plugin and local CSS override remain the right place.
