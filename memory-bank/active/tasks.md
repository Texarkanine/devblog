# Task: Permalink extension, slug, and reserved index

* Task ID: writing-collection
* Complexity: Level 1
* Type: bug fix

## What broke

A front-matter permalink was still in `data` when `permalink_for` read `output_ext`. Jekyll caches that extension, so `permalink: /elsewhere.json` published the piece as `.json`.

The literal permalink used the raw filename slug. `porch:light` was then scanned as a `:light` placeholder and the build raised `NoMethodError`.

A slug of `index` published `index.html` in the folder, the same file as the folder page. Jekyll wrote the piece last and the build succeeded.

`test_writing_archive_pages_have_no_markdown_sidecar` asserted that `/writing/categories/poetry/index.md` was absent, and that the tag archive had no `index.md`. Those pages are HTML. The sidecar writer skips non-Markdown, so the test could not fail when the product broke.

## Why

`Renderer#output_ext` prefers the permalink extension and memoizes it. `Jekyll::URL` still scans a literal permalink for `:word`. `Site#each_site_file` writes pages before documents and does not stop on a destination conflict.

## What changed

`permalink_for` drops a front-matter permalink before reading `output_ext`. The slug is `Jekyll::Utils.slugify` in pretty mode with case kept, the same normalization as `:title`. The slug `index` aborts the build. The scope builder is unchanged: `writing_paths` is not post front matter.

The dead sidecar test is removed. Three tests cover the extension, the colon slug, and the `index` abort.

## Files

- `_plugins/writing_categories.rb`
- `_plugins/README.md`
- `tests/test_writing_collection.py`
