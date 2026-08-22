---
task_id: last-updated-body-only
date: 2026-08-22
complexity_level: 2
---

# Reflection: last-updated-body-only

## Summary

`last_modified` now comes from the last git commit that changed a document's markdown body, for posts and garden. Layouts were left alone, so posts still hide same-day last-updated and garden still always shows Last tended. Inspect fixtures matched the plan; QA passed.

## Requirements vs Outcome

Delivered as asked after the operator revision (garden in, always show Last tended, no suite). Rework after reflect: wired `last_modified_at` for SEO/sitemap on every post and garden page, including when it matches publish/planted. Visible Liquid unchanged.

## Plan Accuracy

The sequence and file list were right: one plugin, layouts unchanged. The feasibility probe (21/46 posts, 4/26 garden) held up in the build (28/46 posts still show a byline). The only plan edit after preflight was naming `_garden/stories.md` as the same-day garden inspect.

## Build & QA Observations

Inspect-red then inspect-green was enough. Build time went from ~19.4s to ~21.7s. QA replayed the git walks independently and found no blockers; the YAML regex is stricter than Jekyll's on some old revisions, but named dates still land.

## Insights

### Technical
- Date source and display policy are different layers. One body-aware Time can feed both Liquid contracts: posts hide same-day, garden always shows.
- Walking newest-first and stopping at the first older different body is cheap on this corpus (~100 `git show`s). Exact string compare after `---` fences is enough; do not invent a "real edit" heuristic.

### Process
- Shipping last-commit dates first made the noise visible (37/46 bylines). The operator could then say what should count. Asking "is last-commit too coarse?" before the first byline would have collapsed two L2s into one — or hidden the question.

### Million-Dollar Question

If body-only had been the meaning of `last_modified` from the start, `CollectionDatesGenerator` would have walked bodies on day one, and the byline task would have been Liquid-only. The same Time now also sets `last_modified_at`, and `DocumentDrop` exposes it so sitemap lastmod and SEO `dateModified` match. That is the three-surface version.
