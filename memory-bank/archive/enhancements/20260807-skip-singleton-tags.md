---
task_id: skip-singleton-tags
complexity_level: 2
date: 2026-08-07
status: completed
---

# TASK ARCHIVE: Skip singleton tag archives and links (posts + garden)

## SUMMARY

Tags that appear on only one document (per collection) are no longer navigational: no per-tag archive page, no inline link on content pages, no entry on `/tags/` or `/garden/tags/`, and no matching jekyll-llms tag scope. Post and garden tags both use a ≥2 threshold. Draft PR: https://github.com/Texarkanine/devblog/pull/104

## REQUIREMENTS

- Navigational only if ≥2 documents in the same collection (posts vs garden)
- No singleton archive pages under `/tags/:name/` or `/garden/tags/:name/`
- Singleton tags render as plain text on post/garden layouts; multi-use stay linked
- Main tag indexes omit singletons
- Same rule for post tags and garden tags; categories out of scope

## IMPLEMENTATION

- Added `_plugins/navigational_tags.rb`: `NavigationalTags::MIN_DOCS = 2`, `keep?`, and a monkey-patch of `Jekyll::Archives::Archives#tags` (does not mutate `site.tags`)
- `_plugins/garden_archives.rb`: emit tag archives only when `type == "tags"` and `keep?` (categories unfiltered)
- `_plugins/20_llms_scope_builders.rb`: skip non-navigational taxonomy entries in `scopes_for_taxonomy`
- `_layouts/post.html` / `_layouts/garden.html`: link only when collection count ≥ 2
- `pages/tags.md` / `pages/garden/tags.md`: filter with `| plus: 0` count coercion
- Documented in `_plugins/README.md`

## TESTING

Automated tests waived (no harness; operator direction). Verification: `bundle exec jekyll build` + `_site` inspection — 32 post-tag archives (+ `llm-context-management` redirect), 8 garden-tag archives, filtered indexes, no dangling tag hrefs, no orphan `llms.txt`, categories unchanged. `/niko-qa` PASS.

## LESSONS LEARNED

- After Liquid `split: '#'`, counts are strings; compare only after `| plus: 0` (site already showed `(1 posts)` from the old idiom)
- Stock `jekyll-archives` has no min-count hook; overriding `#tags` is the smallest injection point when `site.tags` must stay intact for Liquid
- Threshold ended up in five places (one Ruby constant + four Liquid literals); changing `MIN_DOCS` alone would 404

## PROCESS IMPROVEMENTS

- Ask early when test infra is missing; record an explicit waiver rather than inventing a harness or skipping verification

## TECHNICAL IMPROVEMENTS

- Day-one elegant version: one shared “is this tag clickable?” source (site data or Liquid filter backed by `MIN_DOCS`) consumed by archives, llms, layouts, and indexes

## NEXT STEPS

- Optional: DRY the Liquid thresholds against `MIN_DOCS` so the constant is truly single-source
- Merge/mark ready: PR #104
