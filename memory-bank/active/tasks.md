# Task: Tag Descriptions on Archive Pages

* Task ID: tag-descs
* Complexity: Level 2
* Type: Simple Enhancement

Add optional per-tag descriptions seeded in `_data/tags.yaml`. When rendering a tag archive page, if the tag has a description in the data file, display it as a rendered blurb between the heading and the post list.

## Test Plan (TDD)

### Behaviors to Verify

- **Description rendered**: Tag archive page for a tag with an entry in `_data/tags.yaml` → description appears as rendered HTML between the `<h1>` and the `<ul>`.
- **No description, no change**: Tag archive page for a tag without an entry → output identical to current behavior (no empty wrapper, no error).
- **Markdown rendered**: A description containing `**bold**` → output contains `<strong>bold</strong>`.
- **HTML passthrough**: A description containing `<b>bold</b>` → output contains `<b>bold</b>`.
- **Empty/blank entry**: A tag with an empty string value in the YAML → treated as "no description" (no empty wrapper).

### Test Infrastructure

- **Framework**: None (static site). Verified by building with `bundle exec jekyll build` and inspecting rendered HTML in `_site/`.
- **Test approach**: Build site, then check `_site/tags/*/index.html` and `_site/garden/tags/*/index.html` for expected output.

## Implementation Plan

1. **Create `_data/tags.yaml`** with seed entries for at least two existing tags (one with Markdown, one with HTML) plus a comment explaining the format.
   - Files: `_data/tags.yaml` (new)
   - Changes: New file with sample entries

2. **Modify `_layouts/tag-archive.html`** to conditionally render the tag description.
   - Files: `_layouts/tag-archive.html`
   - Changes: After the `<h1>`, add a Liquid block that looks up `site.data.tags[page.title]`, and if present and non-empty, renders it through `| markdownify`.

3. **Modify `_layouts/garden-tag-archive.html`** to conditionally render the tag description, same logic as step 2.
   - Files: `_layouts/garden-tag-archive.html`
   - Changes: After the `<h1>`, add the same Liquid lookup/render block. `_data/tags.yaml` is the single global source — same description applies to blog tags, garden tags, and any future tag archive.

4. **Verify** by building the site and inspecting output.

## Technology Validation

No new technology — validation not required. `markdownify` is a built-in Liquid filter provided by Jekyll/Kramdown (already the configured Markdown engine).

## Dependencies

- None. Uses only built-in Jekyll data files and Liquid filters.

## Challenges & Mitigations

- **Tag key matching**: YAML keys must exactly match the tag strings used in post front matter (e.g., `harness-engineering`, not `Harness Engineering`). Mitigation: use the exact tag strings observed in the codebase.
- **Markdown in YAML scalars**: YAML block scalars (`>-`) fold newlines into spaces, which may interfere with block-level Markdown (e.g., lists, paragraphs). Mitigation: document that `|` (literal block) should be used for multi-paragraph descriptions, `>-` for single-paragraph.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Preflight
- [x] Build
- [ ] QA
