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

## 2026-08-07 - PREFLIGHT - PASS WITH ADVISORY

* Work completed
    - Preflight subagent validated plan; amended steps 2, 5, 6, 7 in place
    - Status: `PASS WITH ADVISORY`
* Decisions made
    - Gate garden `build_archives` filter on `type == "tags"`
    - Coerce Liquid string counts with `| plus: 0` before comparison
    - Accept advisories as-is for build: per-collection threshold (no union rule); no curated-description exemption
* Insights
    - Baseline exact: 101→32 post tag dirs, 45→8 garden; existing pluralization bug is string-comparison

## 2026-08-07 - BUILD - COMPLETE

* Work completed
    - Added `_plugins/navigational_tags.rb` (`MIN_DOCS=2`, patch `Archives#tags`)
    - Filtered garden tag archives; aligned llms tag scopes; Liquid links/indexes
    - Documented in `_plugins/README.md`
    - Verified build: 32 post-tag archives (+ redirect), 8 garden; singletons plain text; no orphan llms
* Decisions made
    - Kept per-collection threshold; redirect page under `/tags/llm-context-management/` retained
    - Fixed index pluralization via `| plus: 0` coercion while filtering
* Insights
    - Plan's "32 dirs" counts archives only; redirect makes `find` show 33 under `_site/tags/`

## 2026-08-07 - PREFLIGHT - COMPLETE (PASS WITH ADVISORY)

* Work completed
    - Validated all 7 plan steps against the actual code: `jekyll-archives` 2.3.0 gem source, `garden_archives.rb`, `20_llms_scope_builders.rb`, both layouts, both index pages
    - Confirmed the four tag-linking templates are the complete set; menus link only to indexes
    - Reproduced the baseline exactly (69/101 singleton post tags, 37/45 singleton garden tags)
    - Amended steps 2, 5, 6, and 7 in `tasks.md`; closed the hardcoded-body-link challenge as a non-risk
    - Recorded advisory findings and the TDD-waiver rationale in `tasks.md`
* Decisions made
    - Garden `build_archives` filter must be gated on `type == "tags"` — the method is shared with categories, which are out of scope
    - Index filtering must coerce the split-derived count with `| plus: 0`; Liquid string/integer comparison either raises or silently mis-evaluates
    - Fixed findings by amending the plan rather than bouncing back to `/niko-plan`; all four are within L2 scope
    - Left the cross-taxonomy union idea as advisory only — it would redefine Requirement 1
* Insights
    - `/garden/tags/context-engineering/` is a singleton that carries one of only two curated `_data/tags.yaml` blurbs; suppressing it loses that content
    - The existing `(1 posts)` pluralization bug is proof that the `!= 1` string-vs-integer idiom in these templates is broken, and a trap for the implementer
    - Only one hardcoded tag link exists in the whole content tree, and it points at an 8-post tag — the 404 risk the plan worried about is nil
