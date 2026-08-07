---
task_id: skip-singleton-tags
date: 2026-08-07
complexity_level: 2
---

# Reflection: Skip singleton tag archives and links (posts + garden)

## Summary

Singleton tags (count &lt; 2) no longer get archive pages, inline links, index entries, or llms scopes for both posts and garden. Build and QA passed against the rendered site.

## Requirements vs Outcome

All five brief requirements delivered. Scope additions that stayed coherent: llms tag-scope alignment (avoids orphan URLs) and fixing the pre-existing string-comparison pluralization bug while coercing index counts. Categories left untouched. Preflight advisories (union threshold, curated-description exemption) accepted as-is.

## Plan Accuracy

Sequence and file list were right. Preflight caught the real landmines before build: gate garden `build_archives` on `type == "tags"`, and coerce Liquid counts after `split`. The “32 dirs” verification target undercounted the committed redirect page under `/tags/llm-context-management/` (33 dirs on disk = 32 archives + redirect).

## Build & QA Observations

Build was linear once the plan amendments landed. QA confirmed no dangling tag hrefs and no orphan `llms.txt`. Main advisory: threshold lives in one Ruby constant plus four Liquid literals — changing `MIN_DOCS` alone would 404.

## Insights

### Technical
- After `split: '#'`, Liquid counts are strings; `!= 1` / `> 1` without `| plus: 0` is a silent footgun (this site already rendered `(1 posts)`).
- Stock `jekyll-archives` has no min-count hook; overriding `#tags` is the smallest injection point if you must not mutate `site.tags`.

### Process
- Asking early about missing test infra (then recording a waiver) kept the plan honest without inventing a harness.

### Million-Dollar Question

If navigational tags had been assumed from day one, the threshold would be one shared site data structure (or a Liquid filter backed by `MIN_DOCS`) consumed by archives, llms, layouts, and indexes — not a Ruby constant plus four hardcoded `2`s. What we shipped is the proportional retrofit; the elegant version is a single source of truth for “is this tag clickable?”
