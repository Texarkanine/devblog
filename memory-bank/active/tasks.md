# Task: Piece URL and future dates

* Task ID: writing-collection
* Complexity: Level 2
* Type: bug fix

A writing piece URL keeps every folder segment, including a repeat. A `categories` or `permalink` key in front matter does not move the piece. A future filename stays out of `site.writing` when `future` is false, including when the file says `published: true`. The feed and the folder index read that collection, so they withhold the piece too. Last-segment labels and unencoded folder names stay as they are.

## Test Plan (TDD)

### Behaviors to Verify

- Two pieces with the same slug, `_writing/poetry/2026-11-11-porch-light.md` and `_writing/poetry/poetry/2026-11-11-porch-light.md` → both `/writing/poetry/porch-light.html` and `/writing/poetry/poetry/porch-light.html` exist, and `site.writing` lists both URLs.
- A poetry piece whose front matter sets `categories: [songs]` and `permalink: /elsewhere.html` → the file is `/writing/poetry/porch-light.html`. `/elsewhere.html` is absent. `/writing/poetry/songs/` and `/writing/songs/` are absent. The piece links `/writing/poetry/` and does not link `songs`.
- A future filename `2999-01-01-later.md` with `published: true`, beside a same-day piece → `site.writing` lists the same-day URL and omits `later`. No `later.html` is written.
- That same pair built with the folder index → `/writing/poetry/` exists, its HTML does not contain `later`, and no `later.html` is written.
- A posts feed that already contains one past writing piece, plus a future writing piece with `published: true` → the feed links the past piece and omits the future URL.
- Existing behavior that must keep passing: `poetry/sonnets` keeps both segments, a folderless piece stays `/writing/<slug>.html`, a future filename with no `published` key stays out of `site.writing`, and `published: false` stays out of the feed.

### Test Infrastructure

- Framework: `python3 -m unittest`
- Test location: `tests/test_writing_collection.py`, `tests/test_garden_feed.py`
- Conventions: one throwaway Jekyll build per test, assertions on the built files. Writing tests use the repository `_config.yaml` plus a plugin overlay. The feed tests use a minimal config and copy `writing_categories.rb` when the writing collection is on.
- New test files: none

## Implementation Plan

### 1. Repeated segment URL — executable

- Files: `_plugins/writing_categories.rb`, `tests/test_writing_collection.py`

1. Stub tests: add `test_repeated_folder_segment_keeps_its_own_file` with an empty body. The docstring says two pieces with one slug under `poetry` and `poetry/poetry` each keep a file, and the writing listing contains both URLs.
2. Stub interface: add `WritingCategories.apply(document)` with an empty body and a comment that it reapplies folder identity after front matter is merged. Register `:site, :post_read` to call it for each doc in `site.collections["writing"].docs`, iterating a duplicate of that array. Leave the `:documents, :post_init` hook in place.
3. Write tests and run red: `_prepare`, write both pieces, build. Assert both HTML files exist and the listing contains `/writing/poetry/porch-light.html` and `/writing/poetry/poetry/porch-light.html`. Run that test. It fails because `:categories` collapses the repeat.
4. Write code and run green: `apply` reads the folder segments from `relative_path` the same way `post_init` does. It sets `data["permalink"]` to `/writing/<segments joined>/<slug><output extension>`, with no `:categories` placeholder. Call `output_ext` before assigning `permalink`. Do not call `document.url`. Run the test. It passes. The existing nested-folder and folderless tests stay green.

### 2. Front matter does not move the piece — executable

- Files: `_plugins/writing_categories.rb`, `tests/test_writing_collection.py`

1. Stub tests: add `test_front_matter_does_not_move_the_piece` with an empty body. The docstring says `categories` and `permalink` in the file leave the piece at the folder URL, and they do not create a `songs` folder page.
2. Stub interface: none. Add an optional `extra` argument to `_write_piece`, appended inside the front matter, so a test can pass those keys.
3. Write tests and run red: `_prepare_archives`, write a poetry piece with `categories: [songs]` and `permalink: /elsewhere.html`. Assert `/writing/poetry/porch-light.html` exists, `/elsewhere.html` does not, `/writing/poetry/songs/` and `/writing/songs/` do not, the page links `/writing/poetry/`, and the page does not link `songs`. Run that test. It fails because merged categories add `songs` and a front-matter permalink wins.
4. Write code and run green: `apply` sets `categories` back to the folder segments and `writing_paths` back to the cumulative paths, then sets `permalink` as in unit 1, overwriting a permalink from the file. Run the test. It passes.

### 3. Future filename with published true — executable

- Files: `_plugins/writing_categories.rb`, `tests/test_writing_collection.py`, `tests/test_garden_feed.py`

1. Stub tests: add `test_future_filename_with_published_true_stays_out_of_the_collection` and `test_future_filename_with_published_true_stays_off_the_folder_page` in the writing suite, and `test_future_published_writing_piece_stays_out_of_the_feed` in `GardenFeedTests`. Empty bodies. The docstrings say a future filename with `published: true` stays out of `site.writing`, off the folder page, and out of the posts feed, while a piece that is due stays.
2. Stub interface: none.
3. Write tests and run red: the collection test uses `_prepare`, writes `2026-11-11-porch-light.md` and `2999-01-01-later.md` with `published: true`, and asserts the listing has `porch-light` and not `later`, and that no `later.html` exists. The folder test uses `_prepare_archives` with the same pair and asserts `/writing/poetry/index.html` exists, does not contain `later`, and no `later.html` exists. The feed test uses `_write_config(writing=True)`, one post, one past writing piece, and one `2999-01-01` writing piece with `published: true`, and asserts the feed links the post and the past piece only. Run those three tests. They fail because `published: true` puts the document back into the collection.
4. Write code and run green: when `site.future` is false and the filename date is after `site.time`, `apply` sets `published` to false and deletes that document from `collection.docs`. The `post_init` future check stays for files that never enter the collection. Run the three tests. They pass. The existing future-filename test and `test_unpublished_writing_piece_stays_out` stay green.

### 4. Plugin note — prose/policy

- Files: `_plugins/README.md`, `_plugins/writing_categories.rb`
- No tests: prose/policy artifact

1. Update the `writing_categories.rb` header and the README section. The piece permalink is the literal path set after front matter is merged. `:categories` remains the collection template and cannot keep a repeated segment.
2. Say that `categories` and `writing_paths` are set again after the merge, so a `categories` key in the file does not add a folder.
3. Say that a future filename is removed from `site.writing` when `future` is false, including when the file says `published: true`. The HTML file was already withheld.

## Technology Validation

No new technology - validation not required.

## Dependencies

- Jekyll 4.4.1: `Document#permalink` reads `data["permalink"]` and `URL` uses that string instead of `:categories`. `populate_categories` and `UrlDrop#categories` still dedupe. `:site, :post_read` runs after collection admission and before generators.
- jekyll-feed 0.18: the posts feed concatenates `site.writing` and filters drafts. It has no future-date filter.
- The feed fixture copies `writing_categories.rb`. The writing fixture loads it from `_plugins`.

## Challenges & Mitigations

- Resetting `categories` after the merge still goes through `UrlDrop`'s set, so the repeat collapses. Unit 1 sets a literal `permalink` and asserts both files.
- `published: false` after admission leaves the document in `site.writing`. Unit 3 deletes it from `collection.docs`, and the listing test reads `site.writing`.
- Iterating `docs` while deleting skips the next document. The hook iterates `docs.dup`.
- Calling `document.url` before `permalink` is set memoizes the collapsed URL. `apply` does not read `url`. `output_ext` is read first, while `permalink` is still empty, so it comes from the Markdown converter.
- `site.future` true must keep the future piece. Both the old hook and `apply` skip the future check in that case.
- A front-matter `writing_paths` array replaces the hook's array on merge. Unit 2 sets `writing_paths` again and asserts the `songs` folder page is absent.
- No other `:site, :post_read` hook exists in `_plugins`. Generators, including the folder index, run after this hook.

## Pre-Mortem

- The plan only resets `categories` and leaves the collection permalink on `:categories`. The repeated-segment test stays red. Unit 1's assertion is two output files, and the code step sets a literal permalink.
- The plan marks the future document unpublished and leaves it in the collection. The listing and the feed still show it. Unit 3 deletes the document, and those tests read the collection and the feed.
- The folder index is assumed to snapshot documents during `read`. It is a generator and runs after `:post_read`. The folder-page test covers a stale list.
- A file-level `permalink` is treated as out of scope, so unit 1 passes by setting `permalink` only when it is empty, and a file can still move the piece. Unit 2 writes `permalink: /elsewhere.html` and expects the folder URL.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight
- [ ] Build
- [ ] QA
