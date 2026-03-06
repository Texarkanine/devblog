# Task: Heading anchor links (hover-to-reveal icon)

* Task ID: heading-anchor-links
* Complexity: Level 2
* Type: Simple enhancement

Add a build-time-only feature: each heading (h1–h6) in rendered post/article content gets an anchor link (configurable icon, default `#`) that is visible on hover. The link targets the heading’s fragment so readers can copy or open section URLs. No client-side JS; minimal CSS.

## Test Plan (TDD)

### Behaviors to Verify

- **Heading has id and anchor link**: For any post page, every h1–h6 in the main content has an `id` attribute and contains (or is followed by) an `<a href="#that-id">` whose visible text is the configured icon.
- **Configurable icon**: Setting `heading_anchor_icon: "¶"` in config and rebuilding produces anchor links showing `¶`; default when unset is `#`.
- **Hover reveals icon**: With the provided CSS, hovering the heading shows the anchor link (e.g. opacity transition); no JS required.
- **Fragment navigation**: Visiting `.../page#section-slug` scrolls to that heading (native browser behavior; no regression).
- **No IDs/anchors on non-content headings**: Layout headings (e.g. post title in header) are unchanged; only content inside the rendered Markdown body is processed.

### Test Infrastructure

- Framework: None (Jekyll site has no automated test suite).
- Test location: N/A.
- Conventions: Manual verification: `bundle exec jekyll build`, inspect built HTML under `_site/`, and confirm in browser (hover, click, copy link).
- New test files: None.

### Edge Cases

- Headings without IDs (e.g. if Kramdown config changed): Plugin only injects link when `id` is present; no-op for headings without id.
- Empty or HTML-entity icon config: Use config value as link text; if blank, default to `#`.
- Documents that are not HTML (e.g. feed): Plugin should only process output that looks like HTML (e.g. contains `</h1>` or similar) to avoid corrupting feeds.

## Implementation Plan

1. **Add config key and default**
   - Files: `_config.yaml`
   - Changes: Add `heading_anchor_icon: "#"` (or under a `heading_anchors:`/`anchor_heading:` key). Document in comments or README that it can be `#`, `¶`, link symbol, etc.

2. **Create Jekyll plugin to inject anchor links**
   - Files: `_plugins/heading_anchor_links.rb` (new)
   - Changes: Register `Jekyll::Hooks.register :documents, :post_render`. In the hook: skip unless `document.output` is HTML (e.g. contains `</h`). Parse with Nokogiri; find all `h1`–`h6` with an `id` attribute; for each, insert an anchor link (e.g. first child or after opening tag) with `href="#{id}"`, class `heading-anchor`, `aria-label="Link to this section"`, and text from `site.config['heading_anchor_icon'] || '#'`. Write back modified HTML to `document.output`. Use a plugin filename sort order so it runs after Markdown (e.g. `05_heading_anchor_links.rb` or `15_` to run after href_decorator).

3. **Add minimal CSS for hover-to-reveal**
   - Files: `assets/css/main.scss` (existing local SASS entry point; add rules at end or in a small block).
   - Changes: e.g. `.heading-anchor { opacity: 0; text-decoration: none; }` and `h1[id]:hover .heading-anchor, h2[id]:hover .heading-anchor, ... h6[id]:hover .heading-anchor, .heading-anchor:focus { opacity: 1; }`. Keep rules minimal.

4. **Ensure Kramdown emits heading IDs**
   - Files: `_config.yaml`
   - Changes: Confirm `kramdown: auto_ids: true` (default) or set explicitly; no change if already default.

5. **Documentation**
   - Files: `README.md` or `_plugins/README.md`
   - Changes: Short note that heading anchor links are enabled by default, config key `heading_anchor_icon`, and that the feature is build-time only with no JS.

## Technology Validation

No new technology. Nokogiri is already a Jekyll dependency (Gemfile.lock). Jekyll post_render hook and document.output pattern are used by existing plugins (`10_href_decorator.rb`, `00_image_paths.rb`). Validation: run `bundle exec jekyll build` after implementation and confirm no load errors.

## Dependencies

- Jekyll (existing)
- Nokogiri (existing, via Jekyll)
- Kramdown default `auto_ids` (existing)

## Challenges & Mitigations

- **Theme CSS entry point unknown**: If the remote theme doesn’t expose an obvious override file, add CSS via a new `_includes` partial included from `_layouts/default.html` (or the theme’s layout override) so our rules load after theme.
- **Plugin order**: Use numeric prefix (e.g. `05_`) so the plugin runs after Markdown and optionally after other post_render plugins; avoid running before Kramdown output is ready.
- **Feed/JSON output**: Check that `document.output` for feed pages is XML/JSON, not full HTML; skip modification when output doesn’t look like HTML (e.g. no `</h`), so we don’t corrupt feeds.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Preflight
- [x] Build
- [x] QA
