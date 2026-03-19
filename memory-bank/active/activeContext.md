# Active Context

## Current Task
Tag Descriptions on Archive Pages

## Phase
BUILD — COMPLETE

## What Was Done
- Created `_data/tags.yaml` with seed entry for `ai` tag
- Modified `_layouts/tag-archive.html` — conditional `markdownify` block between heading and post list
- Modified `_layouts/garden-tag-archive.html` — identical block between heading and notes list
- All 5 behaviors verified via site build: description rendered, no-desc unchanged, Markdown rendered, HTML passthrough, empty entry ignored
- No deviations from plan

## Files Modified
- `_data/tags.yaml` (new)
- `_layouts/tag-archive.html`
- `_layouts/garden-tag-archive.html`

## Next Step
QA phase.
