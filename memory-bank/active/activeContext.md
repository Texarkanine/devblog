# Active Context

## Current Task: tag-descriptions
**Phase:** PREFLIGHT - COMPLETE (PASS WITH ADVISORY)

## What Was Done
- Applied the disambiguation bar to combined ≥3 tags from `/tags/` and `/garden/tags/`.
- Yes-list locked: `cursor`, `jekyll`, `mermaid`, `harness-engineering`, `context-engineering`, `ai`. Draft copy in `tasks.md`, voice from `_garden/ai-horses.md` and house style (no em-dashes).
- Explicit nos: `bitcoin`, `claude-code`, `ruby`, garden buckets, the rest of the 6–3 tail. `agentic-engineering` left as the undescribed umbrella.
- TDD: prose-only; no test harness in this repo; verify with `jekyll build` + `_site` inspection.
- Only file to change: `_data/tags.yaml`.
- Preflight passed after adding explicit SEO metadata checks to build inspection; existing layouts and plugin require no changes.
- Advisory: `mermaid` is a defensible collision tag but the only non-operator-named stretch; QA may remove that key alone.

## Next Step
- Run `/niko-build`.
