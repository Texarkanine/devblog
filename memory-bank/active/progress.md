# Progress

Compute `last_modified` from the last git commit that changed the document **body**, for posts and garden, so last-updated / last-tended do not fire on front-matter-only git commits.

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

## 2026-08-22 - PREFLIGHT - COMPLETE (PASS WITH ADVISORY)

* Work completed
    - Validated the body-only `last_modified` plan against `collection_dates.rb`, both layouts, collection config, and named inspect fixtures
    - Wrote `memory-bank/active/.preflight-status` with first line `PASS WITH ADVISORY`
* Decisions made
    - Inspect-red before write-code satisfies TDD encoding given the operator's no-suite constraint; did not invent a harness
    - No in-phase TDD swap or change-detector strike
* Insights
    - Named fixtures match git history. Garden same-day inspect has four unnamed candidates; none of the four date-moving garden pages are same-day-as-planted
    - `last_modified_at` is still unset for SEO/sitemap — same deferred gap as the prior byline task
    - Named garden same-day inspect: `_garden/stories.md`

## 2026-08-22 - BUILD - COMPLETE

* Work completed
    - Inspect-red on named fixtures (last-commit dates)
    - Added `extract_markdown_body` and `git_last_body_commit_date` in `_plugins/collection_dates.rb`
    - Inspect-green: all named fixtures match the plan
* Decisions made
    - Did not set `last_modified_at` (preflight advisory; not in the brief)
    - Kept `git_last_commit_date` as fallback after the body walk
* Insights
    - This build: 28/46 dated posts show `last updated` (was 37). Garden 1900s Last tended moved to 2025-12-02; stories still shows same-day Last tended.

## 2026-08-22 - QA - COMPLETE (PASS)

* Work completed
    - Semantic review of `_plugins/collection_dates.rb` against the plan and brief
    - Independently replayed the named fixtures' git walks; last-body days match the plan
    - Wrote `memory-bank/active/.qa-validation-status` (`PASS`)
* Decisions made
    - PASS with advisories only; no build rework
* Insights
    - The plan's YAML regex is stricter than Jekyll's; some older revisions of the fixtures do not match and are compared as whole-file bodies, but the named last-body days still land correctly

## 2026-08-22 - REFLECT - COMPLETE

* Work completed
    - Wrote `memory-bank/active/reflection/reflection-last-updated-body-only.md`
    - Reconciled persistent memory-bank files (no updates)
* Decisions made
    - Persistent files left alone: date-source contract lives in the plugin comments, not briefing docs
* Insights
    - Display policy stays in Liquid; date source is one body-aware Time
    - Shipping last-commit first made the noise visible; this L2 is the correction
