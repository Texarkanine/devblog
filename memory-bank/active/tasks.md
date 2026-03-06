# Current Task: Fix double heading anchor

**Complexity:** Level 1

## Implementation

1. In `_plugins/05_heading_anchor_links.rb`, before adding an anchor to a heading, skip if it already has a `.heading-anchor` descendant (e.g. `next if heading.at_css(".heading-anchor")`). This makes the transform idempotent so processing the same output twice (documents + pages) only adds one anchor per heading.

## Status

- [x] Complexity analysis
- [x] Build
- [x] QA
