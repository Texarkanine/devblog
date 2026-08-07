# Progress

Suppress singleton (count = 1) tags from archive page generation, inline tag links, and the main tag indexes for both post tags and garden tags, so every clickable tag guarantees at least one other related document.

**Complexity:** Level 2

## 2026-08-07 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Clarified intent: singleton tags are non-navigational (no archive page, no inline link, omitted from `/tags/` and `/garden/tags/`)
    - Confirmed scope covers both post tags and garden tags
    - Determined complexity Level 2
* Decisions made
    - Level 2: enhancement to existing tagging subsystem; clear threshold (≥2); design choices exist but do not warrant L3 creative/architecture
* Insights
    - Surfaces already known: `jekyll-archives` (posts + garden via config), `_layouts/post.html` / `garden.html` for links, `pages/tags.md` / `pages/garden/tags.md` for indexes

## 2026-08-07 - PLAN - COMPLETE

* Work completed
    - Surveyed archive generation (stock `jekyll-archives` has no min-count; garden via `build_archives`)
    - Baseline `_site` counts: ~69 singleton post-tag pages, ~37 singleton garden-tag pages
    - Operator waived automated tests; recorded build/spot-check validation plan
    - Wrote linear 7-step implementation plan in `tasks.md`
* Decisions made
    - Shared `NavigationalTags::MIN_DOCS = 2`; patch `#tags` for posts; filter garden `build_archives`; align llms tag scopes; Liquid filters for links/indexes
    - Never mutate `site.tags` / `site.garden_tags` (needed for size checks)
    - Categories out of scope
* Insights
    - Filtering only at generation + templates avoids breaking plain-text singleton display
