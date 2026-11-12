# Active Context

## Current Task: Permalink extension, slug, and reserved index
**Phase:** QA - COMPLETE (PASS)

## What Was Done
- Dropped a front-matter permalink before reading the output extension
- Normalized the piece slug with Jekyll's pretty title slugify, case kept
- Aborted the build when that slug is `index`
- Removed the sidecar test that could not fail
- Left the writing-path scope builder unchanged
- Verified all semantic criteria and ran full suite: 62 tests, OK

## Next Step
- Done (Level 1 task complete)

