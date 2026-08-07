# Project Brief

## User Story

As a reader browsing tags on the blog, I want every tag I can click to lead to at least two pieces of related content, so that following a tag always surfaces something new — and so the site doesn't generate and commit a pile of useless single-post tag archive pages.

## Requirements

1. **Threshold:** A tag is "navigational" only if it appears on **two or more** documents in its collection (posts for post tags; garden pages for garden tags).
2. **Archive pages:** Do not generate per-tag archive pages for singleton tags (post tags under `/tags/:name/` and garden tags under `/garden/tags/:name/`).
3. **Inline links:** On content pages that list tags, singleton tags are shown as plain text (not links). Navigational tags remain links to their archive pages.
4. **Index pages:** The main tag indexes (`/tags/` and `/garden/tags/`) list only navigational tags — omit singletons.
5. **Scope:** Apply the same rule to both **post tags** and **garden tags**.
