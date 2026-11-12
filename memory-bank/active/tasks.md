# Task: Folder category pages

* Task ID: writing-collection
* Complexity: Level 3
* Type: enhancement

Each writing folder's URL is that folder's category page. A piece is a child of that page. `/writing/poetry/` lists poetry, including pieces in nested folders. `/writing/poetry/sonnets/` lists that nested folder. The flat pages at `/writing/categories/<name>/` go away. `/writing/categories/` stays the list of every category, and its links point at the folder pages.

## Pinned Info

### Folder path is the category page

`jekyll-archives` puts `:name` through `Jekyll::Utils.slugify`. The default mode turns a slash into a hyphen, so a permalink `/writing/:name/` cannot publish `/writing/poetry/sonnets/`. The page has to be created with the folder path itself.

```mermaid
graph TD
  piece["Piece /writing/poetry/sonnets/small-room.html"]
  poetry["Category /writing/poetry/"]
  sonnets["Category /writing/poetry/sonnets/"]
  piece --> sonnets
  sonnets --> poetry
  poetry --> home["Section /writing/"]
```

## Component Analysis

### Affected Components

- `_plugins/writing_categories.rb`: keeps `categories` as the folder segments. `:categories` in the piece permalink joins those segments, and cumulative paths in that array would publish `/writing/poetry/poetry/sonnets/<slug>.html`. The hook adds `writing_paths`, the cumulative paths, and leaves `categories` alone.
- `_plugins/garden_archives.rb`: builds `site.writing_categories` and the archive pages. The hash stays for segment keys. Writing category archive pages turn off, because those pages use the slugified `:name` permalink.
- New `_plugins/writing_folder_indexes.rb`: publishes one `writing-cat-archive` page per `writing_paths` entry and exposes those paths as `site.data.writing_folders`. Each generated page sets `llms: false`.
- `_config.yaml`: the writing archives block stops enabling categories and drops the `/writing/categories/:name/` permalink. The collection permalink stays `/writing/:categories/:title:output_ext`. No new exclude glob.
- `_layouts/writing.html`: category links and the `..` link. The visible label stays the last segment. The `..` link goes back to the plain parent directory, which is now the category page.
- `_layouts/writing-cat-archive.html`: unchanged. It already lists `page.posts` newest first.
- `pages/writing/categories.md`: lists `site.data.writing_folders` and links each one at `/writing/<path>/`.
- `_plugins/20_llms_scope_builders.rb`: the writing-category scope groups `writing_paths` and uses the raw path. It does not read `site.writing_categories` and it does not slugify the path.
- `tests/test_writing_collection.py`: the fixture copies the new plugin, and the category URL assertions move from `/writing/categories/<name>/` to the folder path.
- `_plugins/README.md`: the writing-category URL and the reserved-folder note.

### Cross-Module Dependencies

- `writing_categories.rb` runs at `post_init` and writes `categories` and `writing_paths`. The piece permalink reads `categories` only. The folder-index generator and the scope builder read `writing_paths`.
- `garden_archives` builds `site.writing_categories` from `categories` even when category archive pages are disabled. The category index stops reading that hash for links.
- The scope builder runs at `lowest`, after the hashes exist. It does not read the generated HTML page.
- The piece layout does not call the generator. It prints links from `page.writing_paths`.

### Boundary Changes

- A writing category's public URL changes from `/writing/categories/<name>/` to `/writing/<folder path>/`.
- `categories` stays the folder segments so the piece URL stays `/writing/<folder>/<slug>`. `writing_paths` is the new field, and it holds the cumulative paths. The visible label is the last segment.
- Post category URLs, writing tag URLs, and piece URLs stay as they are.
- This branch has not shipped the flat category URLs. No redirect is added.

### Invariants and Constraints

- A piece URL stays `/writing/<folder>/<slug>` with no date in the path.
- A piece in a nested folder is listed on every ancestor folder page and on its own folder page.
- A category used once still has a page. A tag used once still does not.
- `/writing/categories/` remains the list of categories. `/writing/tags/` remains the tag index.
- A top-level writing folder must not be named `tags` or `categories`, because those URLs are the index pages.
- The writing home, the piece sidecar, and the posts category scopes stay.
- `site.future` still drops a future filename before the collection accepts it, so a future piece does not grow a folder page.

## Open Questions

None - implementation approach is clear. The flat `:name` permalink was inspected in `jekyll-archives` 2.3.0 and rejected because `slugify` destroys the slash.

## Test Plan (TDD)

### Behaviors to Verify

- A songs piece builds a page at `/writing/songs/` that links the piece, and `/writing/categories/songs/` is absent.
- A piece in `poetry/sonnets` builds `/writing/poetry/` and `/writing/poetry/sonnets/`. Both list the piece. The nested page's heading names `sonnets`.
- The poetry piece's category link and its `..` link are `/writing/poetry/`. Neither link is `/writing/categories/poetry/`.
- The nested piece links `/writing/poetry/` and `/writing/poetry/sonnets/`. Its `..` link is `/writing/poetry/sonnets/`.
- A folderless piece's `..` link is `/writing/`.
- `/writing/categories/` links `/writing/poetry/` and `/writing/songs/` and does not link `/writing/categories/poetry/`.
- One poetry piece publishes `/writing/poetry/llms.txt` and does not publish `/writing/categories/poetry/llms.txt`.
- A nested folder publishes `/writing/poetry/sonnets/llms.txt`.
- Root `/llms.txt` does not list the generated folder index under its pages section. The piece still gets `porch-light.md`.
- A writing folder still does not publish `/categories/poetry/llms.txt`. A post category still publishes `/categories/tools/llms.txt`.

### Test Infrastructure

- Framework: `python3 -m unittest`
- Test location: `tests/test_writing_collection.py`
- Conventions: one throwaway Jekyll build per test, repository `_config.yaml` plus a plugin overlay, assertions on the built files
- New test files: none

### Integration Tests

- The archives fixture covers the folder page, the piece links, and the missing flat archive together, because those are one build of the repo config.
- The sidecar fixture covers the scope path and the folder index staying out of root `/llms.txt` together.
- The section fixture covers the category index links.

## Implementation Plan

### 1. Folder pages — executable

- Files: `_plugins/writing_folder_indexes.rb`, `_plugins/writing_categories.rb`, `_config.yaml`, `tests/test_writing_collection.py`

1. Stub tests: replace `test_category_archive_exists_for_one_piece` with `test_folder_page_replaces_the_flat_category_archive`, and add `test_nested_folder_pages_list_the_piece`. Empty bodies. The old test asserts `/writing/categories/songs/index.html` and cannot stay beside the new one.
2. Stub interface: add `WritingFolderIndexes::Generator` with `generate(site)` and no body. Copy that file from `_prepare_archives`.
3. Write tests and run red: a songs piece writes `/writing/songs/index.html` containing the piece URL, and does not write `/writing/categories/songs/`. A `poetry/sonnets` piece writes both folder indexes, both contain the piece URL, and the nested heading says `sonnets`. The piece URL stays `/writing/poetry/sonnets/small-room.html`.
4. Write code and run green: keep `categories` as the folder segments. Set `writing_paths` to the cumulative paths in the same hook. Remove `categories` from the writing archives `enabled` list and remove the writing category permalink. Leave the collection permalink on `:categories`. The generator adds one page per `writing_paths` entry, layout `writing-cat-archive`, title the last segment, permalink `/writing/<path>/`, `posts` the documents whose paths include that entry, and `llms: false`. It also sets `site.data["writing_folders"]`.

### 2. Piece links — executable

- Files: `_layouts/writing.html`, `tests/test_writing_collection.py`

1. Stub tests: no new methods. The two existing link tests gain the new assertions in the red step.
2. Stub interface: none. The layout already has the link sites.
3. Write tests and run red: `test_writing_page_links_its_category_and_author_and_shows_both_dates` expects `href="/writing/poetry/"` on the category link and on `..`, and rejects `href="/writing/categories/poetry/"`. `test_nested_piece_links_each_category_segment` expects `/writing/poetry/` and `/writing/poetry/sonnets/`, with `..` on the nested path. Add `test_folderless_piece_parent_is_the_writing_home` expecting `href="/writing/">..</a>`.
4. Write code and run green: remove the `writing_back` special case. Iterate `page.writing_paths`. The href is `/writing/<path>/` and the label is the last segment. `page.categories` stays the segments and is not the link source. The plain parent-directory `..` link then lands on the folder page.

### 3. Category index links — executable

- Files: `pages/writing/categories.md`, `tests/test_writing_collection.py`

1. Stub tests: none new.
2. Stub interface: none.
3. Write tests and run red: `test_writing_category_index_links_a_category_used_once` expects `href="/writing/poetry/"` and `href="/writing/songs/"`, and rejects `href="/writing/categories/poetry/"`.
4. Write code and run green: the category index iterates `site.data.writing_folders` and links `/writing/<path>/` without slugifying. `_prepare_section` copies the folder-index plugin so that hash exists.

### 4. Category scopes — executable

- Files: `_plugins/20_llms_scope_builders.rb`, `_config.yaml`, `tests/test_writing_collection.py`

1. Stub tests: add `test_nested_folder_scope_publishes_llms_txt` with an empty body.
2. Stub interface: none. The writing-category scope builder already exists.
3. Write tests and run red: the poetry scope is `/writing/poetry/llms.txt` and not `/writing/categories/poetry/llms.txt`. The nested scope is `/writing/poetry/sonnets/llms.txt`. Root `/llms.txt` does not list `/writing/poetry/` as a page. `porch-light.md` is present. `_prepare_sidecars` copies the folder-index plugin. The post-category and writing-folder-is-not-a-post-category tests stay green.
4. Write code and run green: the writing-category builder groups `writing_paths` and sets `path_prefix` to `/writing/<path>/` from the raw path. The generated page's `llms: false` keeps it out of the root pages list. An HTML page never receives an `index.md` sidecar, so that absence is not the assertion.

### 5. Plugin note — prose/policy

- Files: `_plugins/README.md`
- No tests: prose/policy artifact

1. Record the category URL as `/writing/<folder path>/`, including a nested path.
2. Record that a top-level folder must not be named `tags` or `categories`, and that a nested folder no longer shares the flat archive URL.

## Technology Validation

No new technology - validation not required.

## Challenges & Mitigations

- Slugify destroys slashes. The folder page and the scope path use the raw `writing_paths` string. `categories` stays the segments because `:categories` joins that array with slashes.
- Putting the cumulative paths into `categories` publishes `/writing/poetry/poetry/sonnets/<slug>.html`. Unit 1 asserts the nested piece URL.
- The generator could overwrite `/writing/index.html` for a folderless piece. It only creates a page when the cumulative path is non-empty.
- A piece whose slug is `index` would occupy the same file as its folder page. The seeds do not do this. The plan does not add a second URL for that collision.
- Disabling category archives must keep `site.writing_categories`. `build_taxonomy_hashes` runs for the collection before it looks at `enabled`.
- A generated HTML index does not get an `index.md` sidecar even with no exclude glob, so that check would pass without the opt-out. Unit 4 asserts the root `/llms.txt` pages list instead. `llms: false` on the generated page is what keeps it out.
- The archives fixture copies plugins by name. Unit 1 adds the new file to that list, or the build never loads it.

## Pre-Mortem

- The plan is carried out as a permalink edit from `/writing/categories/:name/` to `/writing/:name/`, or by storing the cumulative path in `categories`. Nested pieces land at `/writing/poetry-sonnets/` or `/writing/poetry/poetry/sonnets/`. Unit 1 asserts `/writing/poetry/sonnets/small-room.html`, `categories` stays the segments, and the archives permalink key is removed rather than rewritten.
- Cumulative paths leak into the visible label, so the piece says `poetry/sonnets` instead of `sonnets`. Unit 2 asserts the label and the nested heading test asserts `sonnets`.
- The scope file stays under `/writing/categories/` while the HTML moves. Unit 4 asserts the new scope path and the absence of the old one.

## Status

- [x] Component analysis complete
- [x] Open questions resolved
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight
- [ ] Build
  - [x] Folder pages
  - [x] Piece links
  - [x] Category index links
  - [x] Category scopes
  - [ ] Plugin note
- [ ] QA
