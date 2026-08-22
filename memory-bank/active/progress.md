# Progress

Add a last-updated byline on blog posts, shown only when `last_modified` is newer than the publish date. Reuse existing collection date extraction. Placement still open among three operator-proposed options. Garden pages unchanged.

**Complexity:** Level 2

## 2026-08-22 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Validated intent: update byline on posts, hide unless newer than publish, garden unchanged
    - Classified as Level 2 (simple enhancement)
    - Wrote ephemeral memory-bank files
* Decisions made
    - Level 2: self-contained post-layout change; date source already exists; placement is a plan-time choice among three options
* Insights
    - `CollectionDatesGenerator` already sets `last_modified` on every collection document, including posts; garden already displays it as "Last tended"
    - Posts currently show only `page.date` in the header top-right
