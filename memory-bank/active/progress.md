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

## 2026-08-22 - PLAN - COMPLETE

* Work completed
    - Feasibility probe: 46 posts, 21 would change last-modified day, ~1.6s, 0 errors
    - Wrote implementation plan: body = raw markdown after YAML fences; posts-only; layout unchanged
* Decisions made
    - Algorithm: newest-first git walk, `git show`, stop at first older revision with a different body
    - Garden stays last-commit; do not add `--follow` or a test framework unless asked
* Insights
    - Same-day publish vs last-commit was already handled in Liquid; the remaining noise is later front-matter-only commits
    - Exact body-string compare is enough; no "is this a real edit" heuristic

## 2026-08-22 - PLAN - REVISED (operator)

* Work completed
    - Expanded scope to garden; 4/26 garden pages would change Last tended day
* Decisions made
    - Garden uses the same body-only `last_modified`; Last tended still always shown (including plant day)
    - Posts keep hiding same-day last-updated — last-modified is the exception
    - No test harness; inspect only
* Insights
    - Display policy is layout-level, not date-source-level: one generator, two Liquid contracts
