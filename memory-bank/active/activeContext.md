# Active Context

## Current Task: tag-descriptions
**Phase:** BUILD - COMPLETE

## What Was Done
- Wrote six blurbs in `_data/tags.yaml` (`ai`, `context-engineering`, `cursor`, `harness-engineering`, `jekyll`, `mermaid`); dropped the `ai` stub; no em-dashes.
- `bundle exec jekyll build` succeeded. Described archives render the blurb in the body and in description / OG / JSON-LD. `ruby`, `bitcoin`, `claude-code` stay at the site-default SEO description with empty body-between-heading-and-list. Garden `/garden/tags/ai/` matches the blog `ai` blurb. Horses links resolve to `/garden/ai-horses.html`.
- Kept `mermaid` despite the preflight advisory (same collision class as `jekyll`).
- Files modified: `/home/mobaxterm/git/devblog/_data/tags.yaml`

## Next Step
- QA review (subagent).
