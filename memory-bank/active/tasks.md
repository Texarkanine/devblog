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
   - Changes: In `build_archives`, only emit `Jekyll::Archives::Archive` for terms where `NavigationalTags.keep?(tagged_docs)` — **gate the filter on `type == "tags"`**. `build_archives` is shared by tags and categories (see `SUPPORTED_TYPES`); an unconditional filter would also suppress singleton garden *categories*, which are out of scope (currently latent: `_config.yaml` enables only `tags` for the garden collection)

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
   - **Liquid type hazard (must handle):** after `split: '#'` the count is a **string**. `{% if tagitems[2] > 1 %}` raises a Liquid comparison error, and `{% if tagitems[2] != 1 %}` silently mis-evaluates — the existing pluralization on the same lines already has this bug (rendered output says `(1 posts)` 69 times). Coerce first: `{% assign tag_count = tagitems[2] | plus: 0 %}{% if tag_count > 1 %}` (post index; use `tagitems[1]` for the garden index).

6. Document the behavior
   - Files: `_plugins/README.md`
   - Tests first: N/A for prose & policy artifacts
   - Changes: Document that tag archives (posts via patch, garden via `build_archives`) and related llms scopes omit tags with fewer than 2 documents; layouts/indexes follow the same rule in Liquid.
   - Convention: the README is one `##` section per plugin file. Add a new `## navigational_tags.rb` section for the helper + `Jekyll::Archives::Archives#tags` patch, and make surgical additions to the existing `## garden_archives.rb` and `## 20_llms_scope_builders.rb` sections.

7. Build and spot-check
   - Files: `_site/` (generated only)
   - Tests first: N/A — waived
   - Changes: Run `bundle exec jekyll build`, then confirm against the measured baseline:
     - `_site/tags/` drops from 101 tag dirs to **32**; `_site/garden/tags/` drops from 45 to **8** (each plus its own `index.html`)
     - Both index pages render without a Liquid error and no longer contain `(1 post` / `(1 page`
     - A singleton-tagged post and garden page render their tags as plain text; a multi-use tag still renders `<a>`
     - No orphan `llms.txt` / `llms-full.txt` under a removed archive path
     - `_site/categories/` is unchanged

## Technology Validation

No new technology - validation not required (uses existing `jekyll-archives`, Liquid, and local plugins).

## Dependencies

- `jekyll-archives` (~> 2.2 / installed 2.3.0) — patch `#tags` only; no gem upgrade
- Existing `_plugins/garden_archives.rb` and `_plugins/20_llms_scope_builders.rb`
- Operator test waiver — verification is build + inspection

## Challenges & Mitigations

- **jekyll-archives has no config for min post count:** Mitigate by filtering in `#tags` override; keep patch minimal and documented in README.
- **Mutating `site.tags` would break Liquid size checks:** Never strip singletons from `site.tags` / `site.garden_tags`; filter only at archive/llms generation and in templates.
- **Hardcoded `/tags/<slug>/` links inside Markdown content:** ~~Risk~~ **closed at preflight.** The whole content tree contains exactly one such link (`/tags/context-engineering/` in `blog/essay/_posts/2026-03-09-context-to-ashes-skills-to-dust.md`), and that tag has 8 posts. The one `redirect_to` page (`pages/tags/llm-context-management.md`) also targets it. No 404s.
- **Plugin load order / patch timing:** Define the monkey-patch in a `_plugins/*.rb` file that loads after `jekyll-archives` is required (garden_archives already `require`s it; new file can `require "jekyll-archives"` then patch). Filename prefix e.g. `15_` or `25_` only if load order proves necessary.

## Pre-Mortem

- **Plan failed because we filtered `site.tags` globally and broke “show singleton as plain text” / counts:** Already covered by Challenge 2 — filter only generation + templates.
- **Plan failed because post archives were fixed but garden (or llms) still emitted singleton URLs:** Steps 2–3 explicitly mirror the threshold; build step counts both trees.
- **Plan failed by introducing a test harness after waiver, or by skipping verification entirely:** Waiver is recorded; step 7 is mandatory manual/build verification, not optional.
- **Plan failed by also changing category archives:** Scope is tags only; categories left untouched (call out in QA).

## Preflight Findings (2026-08-07)

**Verdict: PASS WITH ADVISORY.** Plan amended in place; no rearchitecture needed.

### Amended in plan

- **Step 2 — scope leak (medium):** `build_archives` serves tags *and* categories; the filter is now gated on `type == "tags"` so garden categories stay untouched.
- **Step 5 — Liquid type hazard (medium):** counts are strings after `split: '#'`; the plan now mandates `| plus: 0` coercion before comparison.
- **Step 6 — convention (low):** README is one `##` section per plugin file; the new helper gets its own section.
- **Step 7 — verification (low):** replaced vague spot-checks with measured expected counts (101 → 32 post tag dirs, 45 → 8 garden tag dirs).

### Verified sound

- `jekyll-archives` 2.3.0 `Archives#tags` is a one-line `@site.tags` reader consumed only by `read_tags`; nothing in the repo reads `site.config["archives"]`. Patch point confirmed, and no filename prefix is needed (all `_plugins/*.rb` load before generation; the only cross-file references are runtime).
- Templates that link tag archives are exactly the four the plan touches (`_layouts/post.html`, `_layouts/garden.html`, `pages/tags.md`, `pages/garden/tags.md`); menu entries point at the indexes only.
- `site.garden_tags` resolves in Liquid through `SiteDrop`'s `site.data` fallback, so the existing `| default: site.data.garden_tags` idiom keeps working.
- Baseline counts reproduce exactly: 69 of 101 post tags and 37 of 45 garden tags are singletons.

### Advisory — operator decision

- **Orphaned curated description:** `_data/tags.yaml` holds two tag blurbs. `context-engineering` has 8 posts but only **1 garden page**, so `/garden/tags/context-engineering/` and its blurb (rendered by `garden-tag-archive.html`) disappear. `harness-engineering` has no garden docs and is unaffected. Accept the loss, or exempt tags with a curated description from the threshold.
- **Cross-taxonomy asymmetry (radical-innovation candidate, not applied):** the same tag can be navigational as a post tag and a singleton as a garden tag. A union rule — navigational if ≥2 documents site-wide, with the inline link pointing at whichever archive exists — would keep `context-engineering` clickable from the garden note. Not applied: it redefines Requirement 1's per-collection threshold.
- **Brief motivation is factually off:** the user story cites committing archive pages, but `_site/` is gitignored — the pages are generated and deployed, never committed. The requirements themselves are unaffected.
- **Pre-existing bug left alone:** `{% if tagitems[N] != 1 %}` pluralization is wrong today ("1 posts"); filtering singletons hides it rather than fixing it. Trivial to fix alongside if desired.

### TDD gate

Passed **by recorded operator waiver** (2026-08-07), not by compliance. `always-tdd.mdc` directs stopping to ask when no test infrastructure exists; `techContext.md` confirms none does, and the operator answered "waive". The waiver is recorded per-unit and step 7 is a mandatory verification, so this is not implementation-first under a disclaimer. No change-detector tests are scheduled. Override this by adding a test harness and re-running preflight.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD) — waived; build/spot-check plan recorded
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight — PASS WITH ADVISORY
- [ ] Build
- [ ] QA
