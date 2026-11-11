# Progress

Add a writing collection beside posts and the garden: folder categories, filename publication dates, git update dates, dateless piece URLs, own indexes, layout, and LLM sidecars, included in the main feed, plus three seed pieces.

**Complexity:** Level 3

## 2026-11-11 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Confirmed no task was in flight
    - Operator approved the writing-collection restatement
    - Recorded the brief and classified the task
* Decisions made
    - Level 3. The work spans the collection, indexes, layout, feed, author pages, sidecars, and seeds. The approach is settled, and the garden already established a parallel collection, so this is not a Level 4 redesign
* Insights
    - Jekyll sets a collection document's date from a `YYYY-MM-DD` filename and strips that prefix from the slug. `:path` keeps the prefix
    - A folder inside a collection is not a category. Blog categories are the directories above `_posts`
    - A tag on only one document does not get an archive page, so the seeds need one shared tag
