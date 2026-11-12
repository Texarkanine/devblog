# Active Context

## Current Task: Permalink extension, slug, and reserved index
**Phase:** BUILD - COMPLETE

## What Was Done
- Dropped a front-matter permalink before reading the output extension
- Normalized the piece slug with Jekyll's pretty title slugify, case kept
- Aborted the build when that slug is `index`
- Removed the sidecar test that could not fail
- Left the writing-path scope builder unchanged
- Full suite: 62 tests, OK

## Next Step
- Run QA
