# Project Brief: Tag Descriptions on Archive Pages

## User Story

As a blog author, I want to seed optional summaries/descriptions for tags in `_data/tags.yaml` so that tag archive pages display a contextual blurb when one exists.

## Requirements

1. **Data file**: `_data/tags.yaml` — a flat mapping of tag slug to description string (YAML block scalar). Descriptions may contain HTML and/or Markdown.
2. **Layout change**: `_layouts/tag-archive.html` — if a description exists for the current tag in the data file, render it between the heading and the post list.
3. **Conditional**: Tags without an entry (or with an empty entry) in the data file should render exactly as they do today — no visible change.
4. **Rendering**: Descriptions should be processed through Kramdown (`| markdownify`) so both Markdown and inline HTML are supported.

## Acceptance Criteria

- Tag archive page for a tag **with** a description shows the blurb.
- Tag archive page for a tag **without** a description renders unchanged.
- HTML in descriptions passes through correctly.
- Markdown in descriptions is rendered to HTML.

## Rework

### New Requirement (Reviewer Feedback)

5. **SEO metadata**: Tag descriptions must also appear in the page's SEO metadata (`<meta name="description">`, `og:description`, JSON-LD `description`). This should flow through `jekyll-seo-tag` by setting `page.description` before render.

### Updated Acceptance Criteria

- Tag archive page for a tag **with** a description has that description in the `<meta name="description">` tag, `og:description`, and JSON-LD.
- Tag archive page for a tag **without** a description still uses the site-level description (current behavior, no regression).
