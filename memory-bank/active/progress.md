# Progress

Compute post `last_modified` from the last git commit that changed the post **body**, not from the file's last commit, so the footer byline does not fire on front-matter / tag / summary-only edits.

**Complexity:** Level 2

## 2026-08-22 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Validated intent: body-only last-updated, feasibility then implement
    - Classified as Level 2
* Decisions made
    - Level 2: enhancement to existing `last_modified` computation; self-contained; layout already in place
* Insights
    - Prior task (`post-last-updated-byline`) treated summary adds as real edits; this reverses that for the date source
    - Garden shares `CollectionDatesGenerator`; posts-only body inspection may need a collection split
