# Task: Tag Descriptions — SEO Metadata (Rework)

* Task ID: tag-descs
* Complexity: Level 2
* Type: Simple Enhancement (rework)

Inject tag descriptions into `page.data['description']` via a Jekyll `:pages, :pre_render` hook so that `jekyll-seo-tag` includes them in `<meta name="description">`, `og:description`, and JSON-LD.

## Test Plan (TDD)

### Behaviors to Verify

- **SEO with description**: Tag page with a `_data/tags.yaml` entry → `<meta name="description">` contains the tag description, not the site description
- **SEO without description**: Tag page without an entry → `<meta name="description">` still shows the site description (no regression)
- **JSON-LD**: Tag page with entry → JSON-LD `description` field contains the tag description
- **og:description**: Tag page with entry → `og:description` contains the tag description
- **Garden tag SEO**: Garden tag page with entry → same SEO behavior as blog tag pages
- **Body description unchanged**: The existing `markdownify` blurb in the layout body continues to render correctly

### Test Infrastructure

- **Framework**: None (static site). Build with `bundle exec jekyll build`, inspect `_site/` HTML.

## Implementation Plan

1. **Create `_plugins/tag_descriptions_seo.rb`** — A `:pages, :pre_render` hook that checks the page layout, looks up the tag in `site.data['tags']`, and sets `page.data['description']` if present.
   - Files: `_plugins/tag_descriptions_seo.rb` (new)
   - Changes: New plugin file

2. **Verify** — Build site, inspect SEO meta tags in tag archive HTML for both blog and garden tags.

## Technology Validation

No new technology — uses built-in `Jekyll::Hooks.register` and `site.data` access, same patterns as existing plugins.

## Dependencies

- Depends on `jekyll-seo-tag` reading `page.description` / `page.data['description']` (confirmed via docs).
- Depends on `jekyll-archives` pages being processed by `:pages` hooks (they inherit from `Jekyll::Page`).

## Challenges & Mitigations

- **Hook ordering**: The `:pre_render` hook must fire before `jekyll-seo-tag` processes the page. Since `jekyll-seo-tag` runs as a Liquid tag during render (not as a hook), `:pre_render` is guaranteed to run first. No ordering issue.
- **Plain text vs Markdown**: `jekyll-seo-tag` expects a plain-text description for meta tags. The YAML values may contain Markdown/HTML. Mitigation: strip HTML tags and collapse whitespace when setting the SEO description, but leave the Liquid `markdownify` path untouched for the body blurb.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [ ] Preflight
- [ ] Build
- [ ] QA
