# Task: Garden pages in the main feed

* Task ID: garden-in-feed
* Complexity: Level 2
* Type: simple enhancement

Subscribers of `/feed.xml` also receive garden pages. A local plugin prepends `JekyllFeed::Generator#feed_template` and concatenates `site.garden` onto the posts feed. The `jekyll-feed` gem still generates `/feed.xml`. Membership stays document `date` and `feed.posts_limit`.


## Test Plan (TDD)

### Behaviors to Verify

- [Dated garden page joins the posts feed]: fixture with a post dated 2026-01-01, a garden page dated 2026-01-03, and a post dated 2026-01-02 → `/feed.xml` alternate links are garden, then the Jan 2 post, then the Jan 1 post.
- [Newest single slot]: `feed.posts_limit: 1`, post 2026-02-01, garden 2026-01-01 → the feed's only entry is the post. Swap the dates → the feed's only entry is the garden page.
- [Garden page alone]: fixture with one garden page and no posts → `/feed.xml` contains that garden link.
- [Draft flag still applies after concat]: garden page `draft: true` dated newest, plus one published post → the feed contains the post and omits the garden page.
- [Unpublished garden page]: garden page `published: false` → the feed omits it.
- [Empty garden]: garden collection configured, no garden files, one post → the feed contains the post and the build exits 0.
- [No garden collection]: config has no garden collection, one post → the build exits 0 and the feed contains the post.
- [Posts feed only]: config also sets `feed.collections.garden.path` to `/feed/garden.xml` → `/feed.xml` contains the post and the garden page, and `/feed/garden.xml` contains the garden page and omits the post.

### Test Infrastructure

- Framework: `unittest`, the suite CI already runs with `python3 -m unittest discover -s tests`
- Test location: `tests/`
- Conventions: one module per behavior area, `unittest.TestCase`, tempfile fixtures, assertions on parsed output. The existing module is `tests/test_strip_svg_metadata.py`. Plugin behavior has no Ruby runner.
- New test files: `tests/test_garden_feed.py`

The feed test builds a throwaway site with `bundle exec jekyll build`. CI currently runs unittest before Ruby is installed (`.github/workflows/pr-check.yaml`). The build step moves that unittest step to after `bundle install` so the same command runs in CI. The fixture copies `_plugins/garden_in_feed.rb` into the throwaway source. It does not load the rest of `_plugins/`.

## Implementation Plan

### 1. Posts feed includes garden — executable

- Files: `tests/test_garden_feed.py`, `_plugins/garden_in_feed.rb`, `.github/workflows/pr-check.yaml`

1. Stub tests: add `tests/test_garden_feed.py` with the eight cases above and empty method bodies.
2. Stub interface: add `_plugins/garden_in_feed.rb` that `require`s `jekyll-feed` and prepends `GardenInMainFeed#feed_template`, returning `super` unchanged.
3. Write tests and run red: implement the fixture builder and the eight assertions. Run `python3 -m unittest tests.test_garden_feed`. The dated-garden, limit, garden-alone, and posts-feed-only cases fail because the feed is posts-only.
4. Write code and run green: in `feed_template`, after `{% assign posts = site[page.collection] %}`, when `page.collection == "posts"` and `site.garden` is present, `concat` `site.garden`. Leave the template untouched when that assign line is absent. Move the `Unit tests` step in `.github/workflows/pr-check.yaml` to after `bundle install`. Re-run `python3 -m unittest tests.test_garden_feed`, then `python3 -m unittest discover -s tests`, then `bundle exec jekyll build`.

### 2. Plugin note — prose/policy

- Files: `_plugins/README.md`
- No tests: prose/policy artifact

1. Add a short section for `garden_in_feed.rb`: the posts feed also lists garden pages, ordered by the same `date` the feed already uses, and a garden collection feed is left alone.

## Technology Validation

No new technology - validation not required. `concat` is already `Liquid::StandardFilters#concat` in liquid 4.0.4. `jekyll-feed` 0.18.0 is already in the Gemfile.

## Dependencies

- `jekyll-feed` (~> 0.18), already installed
- Liquid `concat`, already installed
- `bundle exec jekyll` on PATH for the new unittest module
- Existing generator order: `collection_dates.rb` is `:low`, `jekyll-feed` is `:lowest`, so planted dates are set before the feed renders

## Challenges & Mitigations

- The gem template is minified before `feed_template` returns, and the posts assign is the single line `{% assign posts = site[page.collection] %}`. A later gem release can move that line and the prepend will no-op. The fixture feed goes red. The plugin does not abort the build on the missing line.
- `concat` raises `ArgumentError` unless the argument responds to `to_ary`. Guard with `site.garden` present so a site with no garden collection still builds. The "no garden collection" case covers that.
- `site.garden` on this site is the document array Jekyll already feeds to `site[page.collection]`. If `concat` rejects those drops, the fixture exits non-zero. Stop and merge the arrays in the generator before render, still inside `_plugins/garden_in_feed.rb`.
- The fixture does not load the other files in `_plugins/`. A clash with them shows up in `bundle exec jekyll build`, which stays in the green step and in CI.
- CI unittest runs before Ruby today. Until the step moves, CI would error in the fixture for lack of `jekyll`, which is a harness gap rather than a feed failure.

## Pre-Mortem

- The patch targets a template string and a gem bump ships posts-only feeds while the build stays green. The fixture assertions are the response. No source-text abort.
- The fixture's front-matter dates hide a production bug where garden dates are still `site.time` because `collection_dates` has not run. Existing priorities already put `collection_dates` first, and this plan does not change them. The full-site build confirms the plugin loads next to `collection_dates.rb`.
- Liquid `concat` cannot take the garden drop array. Covered by the third challenge: switch that one plugin to an in-generator merge.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight
- [x] Build
- [x] QA

## QA Results

- **Status:** PASS
- **Findings:**
  - **KISS / DRY (non-blocking):** In `_plugins/garden_in_feed.rb`, `return template unless template.include?(POSTS_ASSIGN)` is redundant with `template.sub(POSTS_ASSIGN, WITH_GARDEN)` (which returns `template` unchanged when `POSTS_ASSIGN` is absent), and `WITH_GARDEN` repeats the `POSTS_ASSIGN` string literal instead of interpolating `POSTS_ASSIGN`. Both are readable and harmless as written.
  - **Completeness / Regression (non-blocking):** All eight planned behaviors in `tests/test_garden_feed.py` and the CI step ordering in `.github/workflows/pr-check.yaml` match the plan and pass (`20 tests` in `unittest discover -s tests`). Garden feed entries inherit `date` and `last_modified_at` from `collection_dates.rb` (`:low` priority before `jekyll-feed`'s `:lowest`), and render `<author><name></name></author>` when `author` is unset on garden pages (already noted in preflight as outside scope).
  - **Documentation (non-blocking):** `_plugins/README.md` documents `garden_in_feed.rb` per the plan. Reflect updated `memory-bank/techContext.md` so Testing Process names the garden feed fixture.

