# Project Brief

## User Story

Fix double-anchor on headings: the index page (and any page that is both a document and a page) shows two anchor links on the same heading (e.g. "Digital Garden 🌸"). Main page title correctly has no anchor (no id). Each heading with an id should have exactly one anchor.

## Requirements

1. No heading with an id may receive more than one `.heading-anchor` link.
2. Root cause: plugin registers for both `:documents` and `:pages`; index is in the pages collection so it is processed twice (as document and as page).
3. Fix: make the transform idempotent—skip adding an anchor if the heading already has a `.heading-anchor` descendant.

## Acceptance Criteria

- After rebuild, index.html (and any similar page) shows exactly one anchor per heading (e.g. "Digital Garden 🌸" has one `#` link).
- Layout headings without id (e.g. main title "🐶 Dog with a Dev Blog") remain unchanged.
