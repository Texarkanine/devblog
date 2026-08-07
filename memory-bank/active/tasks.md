# Task: Skip singleton tag archives and links (posts + garden)

* Task ID: skip-singleton-tags
* Complexity: Level 2
* Type: simple enhancement

Suppress tags that appear on only one document: no per-tag archive page, no inline link on content pages, and no entry on the main tag indexes. Same rule for post tags (`/tags/`) and garden tags (`/garden/tags/`). Threshold: **≥ 2** documents.

**Automated tests:** waived by operator (2026-08-07). Validation via `bundle exec jekyll build` and spot-checks on `_site` / rendered HTML.


## Test Plan (TDD)

### Behaviors to Verify

- [Post archive generation]: tag with 1 post → no `/tags/<slug>/` page in `_site`; tag with ≥2 posts → page still generated
- [Garden archive generation]: tag with 1 garden doc → no `/garden/tags/<slug>/` page; tag with ≥2 → page generated
- [Post inline tags]: singleton tag on a post → plain text (not `<a>`); navigational tag → `<a href="/tags/...">`
- [Garden inline tags]: same rule with `/garden/tags/` hrefs
- [Post index `/tags/`]: lists only tags with size ≥ 2
- [Garden index `/garden/tags/`]: lists only tags with size ≥ 2
- [Categories unchanged]: category archive generation and linking behavior unchanged
- [Edge — empty tags]: post/garden page with no tags → no tag footer (existing)
- [Edge — llms scopes]: singleton tags do not get scoped `llms.txt` at archive paths (keeps URLs consistent with missing archive pages)
- [Regression]: multi-use tags still link, index, and archive as today

### Test Infrastructure

- Framework: **none** (operator waiver)
- Validation: `bundle exec jekyll build`; compare tag-dir counts / spot-check HTML before vs after (baseline from current `_site`: ~69 singleton post-tag pages, ~37 singleton garden-tag pages)
- New test files: none

## Implementation Plan

1. Add shared navigational-tag helper + suppress singleton **post** tag archives
   - Files: `_plugins/navigational_tags.rb` (new)
   - Tests first: N/A — automated tests waived; verify in final build step
   - Changes:
     - Define `NavigationalTags::MIN_DOCS = 2` and `NavigationalTags.keep?(docs)` → `docs.size >= MIN_DOCS`
     - Monkey-patch `Jekyll::Archives::Archives#tags` to return only entries where `NavigationalTags.keep?(posts)` (stock gem has no min-count filter; `tags` is the injection point used by `read_tags`)
     - Do **not** mutate `site.tags` — Liquid still needs full counts for link/index decisions

2. Suppress singleton **garden** tag archives
   - Files: `_plugins/garden_archives.rb`
   - Tests first: N/A — waived
   - Changes: In `build_archives`, only emit `Jekyll::Archives::Archive` for terms where `NavigationalTags.keep?(tagged_docs)`

3. Align jekyll-llms tag scopes with the same threshold
   - Files: `_plugins/20_llms_scope_builders.rb`
   - Tests first: N/A — waived
   - Changes: In `scopes_for_taxonomy`, skip taxonomy entries where `!NavigationalTags.keep?(items)` so singleton tags do not get orphan `/tags/:name/llms.txt` (or garden equivalent) beside non-existent archive pages

4. Conditional inline tag links on content layouts
   - Files: `_layouts/post.html`, `_layouts/garden.html`
   - Tests first: N/A — waived
   - Changes: For each tag, if `site.tags[tag].size >= 2` (posts) or `site.garden_tags[tag].size >= 2` (garden, with existing `site.data.garden_tags` fallback if needed), render the current `<a>`; else render escaped plain text. Preserve lowercase_titles / comma separators.

5. Filter singleton tags from main indexes
   - Files: `pages/tags.md`, `pages/garden/tags.md`
   - Tests first: N/A — waived
   - Changes: When building the sorted list (or when emitting `<li>`), skip tags with size `< 2`. Prefer filtering at emit time so sort logic stays intact.

6. Document the behavior
   - Files: `_plugins/README.md` (garden_archives section; note shared helper / post-archive patch)
   - Tests first: N/A for prose & policy artifacts
   - Changes: Document that tag archives (posts via patch, garden via `build_archives`) and related llms scopes omit tags with fewer than 2 documents; layouts/indexes follow the same rule in Liquid.

7. Build and spot-check
   - Files: `_site/` (generated only)
   - Tests first: N/A — waived
   - Changes: Run `bundle exec jekyll build`. Confirm singleton tag dirs gone; multi-tag dirs remain; sample a singleton-tagged post/garden page for plain-text tags; sample indexes; spot-check a category archive still exists.

## Technology Validation

No new technology - validation not required (uses existing `jekyll-archives`, Liquid, and local plugins).

## Dependencies

- `jekyll-archives` (~> 2.2 / installed 2.3.0) — patch `#tags` only; no gem upgrade
- Existing `_plugins/garden_archives.rb` and `_plugins/20_llms_scope_builders.rb`
- Operator test waiver — verification is build + inspection

## Challenges & Mitigations

- **jekyll-archives has no config for min post count:** Mitigate by filtering in `#tags` override; keep patch minimal and documented in README.
- **Mutating `site.tags` would break Liquid size checks:** Never strip singletons from `site.tags` / `site.garden_tags`; filter only at archive/llms generation and in templates.
- **Hardcoded `/tags/<slug>/` links inside Markdown content:** Out of scope to rewrite body links; rare and usually multi-post tags. Note if a singleton target 404s after deploy.
- **Plugin load order / patch timing:** Define the monkey-patch in a `_plugins/*.rb` file that loads after `jekyll-archives` is required (garden_archives already `require`s it; new file can `require "jekyll-archives"` then patch). Filename prefix e.g. `15_` or `25_` only if load order proves necessary.

## Pre-Mortem

- **Plan failed because we filtered `site.tags` globally and broke “show singleton as plain text” / counts:** Already covered by Challenge 2 — filter only generation + templates.
- **Plan failed because post archives were fixed but garden (or llms) still emitted singleton URLs:** Steps 2–3 explicitly mirror the threshold; build step counts both trees.
- **Plan failed by introducing a test harness after waiver, or by skipping verification entirely:** Waiver is recorded; step 7 is mandatory manual/build verification, not optional.
- **Plan failed by also changing category archives:** Scope is tags only; categories left untouched (call out in QA).

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD) — waived; build/spot-check plan recorded
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [ ] Preflight
- [ ] Build
- [ ] QA
