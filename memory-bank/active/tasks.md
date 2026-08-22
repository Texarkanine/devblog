# Task: last-updated-body-only

* Task ID: last-updated-body-only
* Complexity: Level 2
* Type: simple enhancement

Compute `last_modified` from the last git commit that changed the markdown **body** (everything after YAML front matter), not from the file's last commit. Applies to **posts and garden**.

Posts: footer byline and calendar-day compare unchanged — last-updated is the exception (hide when same day as publish). Garden: Last tended still always shown when `last_modified` is set, including when it matches Planted. Layouts unchanged.

Feasibility probe (2026-08-22): 46 posts, 21 dates would move earlier; 26 garden pages, 4 would move earlier; 0 errors; ~1.6s posts + ~1s garden.

## Test Plan (TDD)

### Behaviors to Verify

- Front-matter-only later commit → `last_modified` is the last body-change Time, not the last-commit Time
- Body edit on a later calendar day than publish → `last_modified` is that body-commit Time
- Posts: latest body change same calendar day as publish → footer byline hidden
- Garden: `last_modified` set and equal to planted day → Last tended still rendered
- Explicit `last_modified` in front matter → generator does not overwrite it
- No git / empty log → fall back to `File.mtime`
- File with no YAML front matter → entire file contents are treated as body

### Test Infrastructure

- Framework: none (operator: no suite for this; inspect only)
- Test location: n/a
- Conventions: `bundle exec jekyll build` + HTML inspect
- New test files: none

Inspect fixtures:

- `blog/fable/_posts/2025-12-07-you-cant-hide-what-you-want-seen.md` — last-commit `2026-06-21`, last-body `2025-12-07` (= publish) → byline **disappears**
- `blog/essay/_posts/2026-02-12-stop-doing-agents-md.md` — last-commit `2026-07-18`, last-body `2026-02-24` → byline stays, date **`2026-02-24`**
- `blog/guide/_posts/2026-03-14-adeptus-mechanicus-bootcamp-gentle-seduction.md` — both `2026-08-22` → byline still `last updated 2026-08-22`
- `blog/diary/_posts/2026-03-13-seven-weeks.md` / `elgato-alias` — still no byline
- `_garden/1900s-computer-gaming.md` — last-commit `2026-03-10`, last-body `2025-12-02` → Last tended **`2025-12-02`**, still shown
- A garden page whose body day equals Planted → Last tended still present (same-day OK)

Do not site-wide search for `last updated` (`love-when-useful-things-get-cheaper` quotes the phrase). Inspect the post footer after `</article>`, not `default.html`'s site footer.

## Implementation Plan

### 1. Body-aware last_modified — executable

- Files: `_plugins/collection_dates.rb`

1. Stub tests: none. Record inspect-red on the fixtures above against current last-commit dates before changing the generator.
2. Stub interface: add `extract_markdown_body(content)` (String → String) and `git_last_body_commit_date(file_path)` (path → Time or nil).
3. Write tests and run red: inspect-red is the current site. No automated red.
4. Write code and run green:
    - `extract_markdown_body`: if content matches Jekyll YAML front matter (`\A---\s*\n.*?\n---\s*\n` /m), return the remainder; else return the whole string. Compare bodies as exact strings (no whitespace normalize).
    - `git_last_body_commit_date`: `git log --format="%H %ai" -- #{escaped_path}`; walk **newest first**; `git show #{hash}:#{path}` each revision; stop at the first older revision whose body differs; that **newer** commit's date is last body change. If no revision differs, use the oldest commit (file add). Rescue → nil.
    - In `generate`: for every collection document without front-matter `last_modified`, set `git_last_body_commit_date || git_last_commit_date || File.mtime`. Posts and garden share this path.
    - Keep `git_last_commit_date` as fallback only.
    - Update the class/method comments (they still say mtime-only).
    - `_layouts/post.html` and `_layouts/garden.html` are unchanged.

### 2. Verify build + inspect — prose/policy

- Files: `_site/**` (generated, not committed)
- No tests: prose/policy artifact

1. `bundle exec jekyll build`
2. Inspect the fixtures listed in the Test Plan
3. Confirm garden Last tended still renders when it matches Planted

## Technology Validation

No new technology - validation not required. Feasibility shown by the in-tree probe.

## Dependencies

- Existing `git` + `CollectionDatesGenerator` shell-out pattern (`Shellwords`, `Time.parse`, `%ai`)
- Jekyll YAML front-matter convention (`---` fences)
- Existing Liquid in `_layouts/post.html` and `_layouts/garden.html`

## Challenges & Mitigations

- **No test infrastructure**: operator waived; inspect fixtures above.
- **Garden vs posts display**: same date source, different Liquid. Do not add a same-day hide to garden; do not remove the post hide.
- **What counts as body**: after the closing `---` only. Exact string compare. A trailing-newline-only body tweak would count — acceptable; no "real edit" heuristic.
- **Renames / `--follow`**: probe used current paths with 0 `git show` failures. Do not add `--follow` unless a file is renamed during this work.
- **Build cost**: on the order of 100+ `git show`s, a few seconds. Fine for this corpus.
- **Timezone / calendar day**: keep `Time.parse` of `%ai` and the existing Liquid `%Y-%m-%d` compare on posts.

## Pre-Mortem

- **We hide garden Last tended on plant day**: would break the "always tended" expectation. Layout stays as-is; only the date source changes.
- **We treat "body" as rendered HTML**: would miss source/Liquid edits. Body = raw file after YAML fences.
- **Operator expected summaries to still count**: this task reverses that. `you-cant-hide-what-you-want-seen` is the hide fixture.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [ ] Preflight
- [ ] Build
- [ ] QA
