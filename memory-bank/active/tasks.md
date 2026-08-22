# Task: post-last-updated-byline

* Task ID: post-last-updated-byline
* Complexity: Level 2
* Type: simple enhancement

Add a last-updated byline on blog posts, shown only when `page.last_modified` is a later calendar day than `page.date`. Reuse `CollectionDatesGenerator`. Garden unchanged. Placement: both after-tags left and after-tags right (`last updated YYYY-MM-DD` in each). Operator waived a test suite; verify by `jekyll build` + HTML inspect.

## Test Plan (TDD)

### Behaviors to Verify

- Later calendar day: a post whose `last_modified` Y-M-D is after its publish Y-M-D → footer contains `last updated YYYY-MM-DD` (theme `date_format`) twice after tags: once left-aligned and once right-aligned
- Same calendar day: a post whose `last_modified` Y-M-D equals its publish Y-M-D → footer has no `last updated` text; header date unchanged
- Earlier calendar day: `last_modified` Y-M-D before publish Y-M-D (clock skew / override) → no `last updated` text
- Missing `last_modified` → no `last updated` text
- No tags: a post with an empty tag list still shows both bylines when the date rule matches (bylines are not nested inside the tags `<p>`)
- Garden regression: a garden page still shows `Planted:` / `Last tended:` and does not gain the posts `last updated` wording

### Test Infrastructure

- Framework: none. Operator (2026-08-22): no test suite; build+inspect is fine. Same convention as prior L2 layout work and nuclear-pyramid.
- Test location: generated site under `_site/` after `bundle exec jekyll build`
- Conventions: pick one same-day post and one later-day post; assert presence/absence of the byline string. Do not lock a specific post's date as a permanent fixture (that is a change-detector).
- New test files: none
- Fixture posts for this build (illustrative, not locked):
  - Same day: `blog/diary/_posts/2026-03-13-seven-weeks.md` → `_site/2026/03/13/seven-weeks.html`
  - Later day: `blog/guide/_posts/2026-03-14-adeptus-mechanicus-bootcamp-gentle-seduction.md`
  - Garden: any `_garden/*.md` page

## Implementation Plan

### 1. Post footer update byline — executable

- Files: `_layouts/post.html`

1. Stub tests: no suite (operator waived). Record the six behaviors above as the build-inspection checklist.
2. Stub interface: none. No new Ruby class or filter. Comparison stays in the post layout using existing `page.date` and `page.last_modified`.
3. Write tests and run red: `bundle exec jekyll build`; confirm current `_site` post HTML has no `last updated` string (red for the later-day presence case).
4. Write code and run green: in `_layouts/post.html` footer, after the tags block (not inside it):
   - Assign publish and update calendar days via `date: "%Y-%m-%d"` (ISO strings compare correctly; do **not** compare raw timestamps — Jekyll post `date` is midnight of the filename day, git last-commit is later that afternoon).
   - If `page.last_modified` is present and `updated_day > published_day`, render a full-width row (flex `space-between`, matching the existing post header) with `last updated {{ page.last_modified | date: site.theme_config.date_format | default: "%Y-%m-%d" }}` on the left and the same text on the right.
   - Leave the header date (`post-meta`) unchanged.
   - Do not touch `_layouts/garden.html` or `_plugins/collection_dates.rb`.

### 2. Memory-bank notes — prose/policy

- Files: `memory-bank/active/*` only as the workflow already requires
- No tests: prose/policy artifact

1. Keep placement and calendar-day decisions in `activeContext.md` / `progress.md` as they are made.

## Technology Validation

No new technology - validation not required

## Dependencies

- `_plugins/collection_dates.rb` already sets `last_modified` on every collection document (git last commit, else `File.mtime`; front-matter override honored)
- `_config.yaml` `theme_config.date_format` (`%Y-%m-%d`)

## Challenges & Mitigations

- **Same-day false positive:** filename `date` is midnight; git last-commit is hours later the same day. Mitigation: compare `%Y-%m-%d` strings, not Time objects.
- **Git last-commit marks most posts:** operator confirmed this is correct — a page summary is an edit.
- **Empty tags:** tags live in a conditional `<p>`. Mitigation: byline is a sibling after that block.
- **Asserting on a named post's date:** next edit flips the fixture. Mitigation: treat fixture posts as this-build examples; the assertion is presence/absence given computed days, not a locked date string in a committed test file.

## Pre-Mortem

- **Every brand-new post shows updated on publish day:** already covered by the same-day Challenge (calendar-day compare).
- **Header garden-style makes posts look like living notes:** placement is footer only, both left and right after tags; header unchanged.
- **Duplicate identical notices look like a layout bug:** operator asked to see both; ship both. Drop one later if they pick after looking.
- **We bootstrapped Minitest for four Liquid lines:** operator waived; verify via build + HTML inspection.

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

**Result:** PASS

- Implementation is the planned ten-line Liquid addition in `_layouts/post.html` only. Calendar-day ISO compare, dual after-tags bylines, header unchanged, garden and `collection_dates.rb` untouched. Does not block.
- Independent `_site` inspect: Mechanicus has two footer `last updated 2026-08-22` lines; seven-weeks / elgato-alias / not-a-nitpick have none; garden keeps Planted / Last tended. Corpus 37/46 dual byline, 9 none. Does not block.
- Earlier-day, missing `last_modified`, and untagged pages have no live fixtures; Liquid guards match the plan. Advisory, not blocking.
- Dual identical notices and unset `timezone` are known, in-scope-as-specified decisions. Do not block.
- One post body quotes "Last updated:" (`love-when-useful-things-get-cheaper`); inspect the post footer, not a site-wide needle. Advisory on verification, not a product defect.
