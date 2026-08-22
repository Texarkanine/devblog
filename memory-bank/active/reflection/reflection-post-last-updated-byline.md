---
task_id: post-last-updated-byline
date: 2026-08-22
complexity_level: 2
---

# Reflection: post-last-updated-byline

## Summary

Blog posts now show `last updated YYYY-MM-DD` on both sides of the footer after tags, only when `last_modified` is a later calendar day than publish. Garden is unchanged. QA passed.

## Requirements vs Outcome

Delivered as specified after the operator revised placement to both footer positions. Git last-commit is the source (summaries count). No test suite; verified by build + HTML inspect. Nothing dropped. Did not add `last_modified_at` for SEO/sitemap (preflight advisory, out of plan).

## Plan Accuracy

File list and scope were right (`_layouts/post.html` only). Calendar-day compare was the load-bearing plan call; timestamp compare would have marked almost every post updated on publish day. The surprise was not the Liquid — it was that most posts already qualify, and that the operator considers that correct.

## Build & QA Observations

Build was one layout edit. Inspect-red/green worked once the check targeted the article-adjacent footer, not `default.html`'s site footer. QA found no product defects; advisories were missing live fixtures, unset timezone, and a body-text "Last updated:" quote in one essay.

## Insights

### Technical
- This site has two `<footer>` elements on post pages. Presence checks must use the footer after `</article>`, not the last footer in the file.
- A site-wide search for `last updated` is not a fixture: at least one post quotes that phrase in the body.

### Process
- Asking whether git last-commit noise was acceptable was the right pause. The operator's answer (a summary add is an edit) closed a false "opt-in vs auto" fork.

### Million-Dollar Question

If posts had always had an update byline, garden and posts would share one date-meta include with collection-specific labels, and posts would print the update once. Dual left-and-right copies are a visual bake-off the operator asked to see, not the long-term shape.
