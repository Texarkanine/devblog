# Progress

Add a writing collection beside posts and the garden: folder categories, filename publication dates, git update dates, dateless piece URLs, own indexes, layout, and LLM sidecars, included in the main feed, plus three seed pieces.

**Complexity:** Level 3

## 2026-11-11 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Confirmed no task was in flight
    - Operator approved the writing-collection restatement
    - Recorded the brief and classified the task
* Decisions made
    - Level 3. The work spans the collection, indexes, layout, feed, author pages, sidecars, and seeds. The approach is settled, and the garden already established a parallel collection, so this is not a Level 4 redesign
* Insights
    - Jekyll sets a collection document's date from a `YYYY-MM-DD` filename and strips that prefix from the slug. `:path` keeps the prefix
    - A folder inside a collection is not a category. Blog categories are the directories above `_posts`
    - A tag on only one document does not get an archive page, so the seeds need one shared tag

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Mapped the writing collection across config, a `post_init` category hook, the feed concat, archives, layouts, author pages, LLM scopes, the homepage, and three seeds
    - Wrote the ordered TDD plan and the throwaway-Jekyll test map
* Decisions made
    - No creative phase. The approved brief fixed the product choices
    - Set categories at `post_init`, before anything can memoize `document.url`
    - Show Published and Updated on every writing page, including when the days match
    - Seeds share `verse` and `night`. `hearth` stays a singleton so the missing archive is visible
* Insights
    - `Jekyll::URL` squeezes a double slash, so a piece with no folder still has a clean URL
    - Upstream `no-style-please` renders the posts menu and then `{{ content }}`, so the writing block belongs in `pages/index.md` rather than in the posts menu

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Checked the plan against Jekyll 4.4.1, jekyll-feed 0.18, jekyll-archives 2.3, jekyll-llm-sidecars 0.3, the existing plugins, layouts, tests, and `REUSE.toml`
    - Ran a throwaway build to test the LLM category scope behavior
    - First line of `.preflight-status`: `FAIL (blocking)`
* Decisions made
    - No in-phase plan edits: no misordered tests and no change-detector steps
* Insights
    - `include_categories: true` in `llm_sidecars` emits `/categories/<folder>/llms.txt` for writing folders, so writing leaks into the posts category namespace
    - Unit 5 index pages are Liquid with logic and need tests
    - Writing archive pages need `exclude_paths` entries, and `_writing/**` needs the CC-BY-SA-4.0 REUSE annotation

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Replanned after the blocking preflight
    - Moved the writing index pages into their own executable unit, with tests for the section home, the tag and category indexes, the home block, `/all-posts.html`, and the garden index
    - Specified `include_categories: false`, explicit post and writing category scope builders, writing archive `exclude_paths`, and the CC-BY-SA-4.0 override for `_writing/**`
    - Updated brief acceptance criterion 1 to the piece URL `/writing/<folder>/<slug>` and the category archive `/writing/categories/<folder>/`
* Decisions made
    - The piece URL stays `/writing/<folder>/<slug>`. No page is added at the folder path
    - Seeds use the same CC-BY-SA-4.0 override as posts and the garden
    - The gem's category scopes are turned off. This site registers post category scopes and writing category scopes separately
    - The author-page fixture is a hand-written page, and the author record has no email
    - A config-list refactor of the collection-named plugins stays out of this task
* Insights
    - `include_categories` publishes every census category at `jekyll-archives.permalinks.category`, which is `/categories/:name/`
    - `scopes_for_taxonomy` drops a one-document term, so category builders cannot use it unchanged
    - The upstream home layout renders the posts menu and then `{{ content }}`. The throwaway fixture has to stub that layout because it does not fetch the remote theme

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Re-checked the replanned plan against the codebase, `jekyll-llm-sidecars` 0.3.0, `jekyll-archives` 2.3, and Jekyll 4.4.1
    - Ran a throwaway build to test how Jekyll treats a future-dated collection document
    - First line of `.preflight-status`: `FAIL (fixable)`
* Decisions made
    - No in-phase plan edits: no misordered tests and no change-detector steps
* Insights
    - The fixture writes its own config, so the production `_config.yaml` changes (permalink, defaults, archives, `include_categories`, `exclude_paths`) have no test that pins them. Unit 4's red and green expectations are incoherent without that
    - Jekyll lists a future-dated collection document in `site.<collection>` with a URL but does not write it, so the plan's "not skipped" premise is wrong and dead links are possible
    - Minor: `README.md` license line, the unit 5 fixture copy list, and the `writing_tags` guard

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Replanned after the fixable preflight
    - Writing tests now build with the repository `_config.yaml` plus an overlay that only replaces `url` and `plugins`
    - A future filename date is left unpublished in the category hook, before the collection accepts the document
    - Folded in the README license line, the `page.html` and `back_link.html` fixture copies, the empty-tag guard, and the reserved folder-name note
* Decisions made
    - The overlay does not restate permalinks, defaults, archives, or `llm_sidecars`
    - The feed fixture keeps its own minimal config, because that behavior lives in the copied plugin
    - Future dates are filtered. Recording the dead link as a known limit was the other option, and the author workflow makes a future filename reachable
* Insights
    - Jekyll deep-merge keeps the earlier value when the later value is null, and it replaces arrays
    - `:documents, :post_init` runs before `read`, so the future check parses the filename. `data["date"]` does not exist yet
    - `Document#write?` already hides the future page. The dead link comes from the document staying in the collection

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Re-checked the twice-revised plan against Jekyll's `Document`, `Collection`, and `populate_title` source, the existing plugins, layouts, pages, and `tests/test_garden_feed.py`
    - First line of `.preflight-status`: `FAIL (fixable)`
* Decisions made
    - No in-phase plan edits: no misordered tests and no change-detector steps
* Insights
    - The `TAG_ARCHIVE_LAYOUTS` change and the writing tag description lookup are executable and have no test step
    - Minor: the unit 5 fixture's `pages/garden.md` needs `_garden/what-is-a-digital-garden.md`, the writing archive config needs `enabled` and `layouts`, and unit 1 needs a date-printing body and a stub layout
