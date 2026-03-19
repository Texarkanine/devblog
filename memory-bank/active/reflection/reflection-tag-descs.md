---
task_id: tag-descs
date: 2026-03-19
complexity_level: 2
---

# Reflection: Tag Descriptions on Archive Pages

## Summary

Added optional per-tag descriptions via `_data/tags.yaml`, rendered as body blurbs on tag archive pages and injected as plain-text SEO metadata via a Jekyll plugin. Both original build and rework (SEO) succeeded.

## Requirements vs Outcome

All original requirements plus the rework SEO requirement delivered. Scope expanded during initial build to cover garden tag archives (operator request). Rework added a new plugin for SEO injection.

## Plan Accuracy

Original plan was accurate. Rework plan was mostly accurate but missed a key detail: `Jekyll::Archives::Archive` objects store the tag name via a `title` method, not in `page.data['title']`. This required a debugging cycle during build. The plan should have investigated the Archive class's data model before coding.

## Build & QA Observations

- Original build was clean. Rework build required one debugging iteration to discover the `page.title` vs `page.data['title']` difference.
- The Kramdown → strip-HTML pipeline for plain-text SEO descriptions worked cleanly.
- QA found no issues in either pass.

## Insights

### Technical
- `Jekyll::Archives::Archive` stores page metadata (title, tag, type) as instance methods, not in the `page.data` hash. When writing hooks that target archive pages, always use `page.title` / `page.type` rather than `page.data['title']`. This is a gotcha that arises specifically from the `jekyll-archives` gem's class design and is not documented in the gem's README.

### Process
- When planning a hook that targets pages from a third-party generator, investigate the generated page class's data model before writing the implementation plan. A quick `Jekyll.logger.debug` pass listing available attributes would have caught the `page.data['title']` issue at plan time rather than build time.

### Million-Dollar Question
If tag descriptions had been a foundational assumption, the ideal design would be the same — `_data/tags.yaml` as the single source, with a pre-render hook injecting into `page.data['description']` for SEO and Liquid `markdownify` for the body. The only improvement would be to extract the tag lookup into a shared utility if more consumers emerge (e.g., a tags index page showing descriptions). For now, two independent access paths (Liquid and Ruby) is the right level of coupling.
