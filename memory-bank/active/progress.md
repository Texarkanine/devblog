# Progress

Add a last-updated byline on blog posts, shown only when `last_modified` is a later calendar day than the publish date. Reuse existing collection date extraction. Placement: both after-tags left and after-tags right. Garden pages unchanged.

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

## 2026-08-22 - PLAN - COMPLETE

* Work completed
    - Chose footer, left-aligned, after tags (option 3)
    - Specified calendar-day compare so same-day git commits do not show as updates
    - Mapped verification to `jekyll build` + HTML inspection (no test framework in repo)
* Decisions made
    - Do not mirror garden in the header: post updates are maintenance notes, not a living-doc identity
    - Do not add a Ruby filter or new plugin; keep the condition in `_layouts/post.html`
    - Do not change `collection_dates.rb` or garden
* Insights
    - ~40 of 46 posts currently have `last_modified` on a later calendar day than publish, often from site-wide chores (e.g. #68 page summaries). The byline will be common, not rare.
    - Jekyll post `date` is midnight of the filename day; git last-commit is later that day — timestamp compare would mark almost every post updated on publish day

## 2026-08-22 - PLAN - REVISED

* Work completed
    - Operator confirmed git last-commit (including page-summary adds) is a real edit
    - Operator waived a test suite; verification is `jekyll build` + HTML inspect
    - Placement revised to both footer positions after tags (left and right)
* Decisions made
    - Ship both left and right `last updated` notices in the footer so the operator can see both
    - Do not introduce Minitest or any test framework
    - Keep calendar-day compare and existing `last_modified` source

## 2026-08-22 - PREFLIGHT - COMPLETE (PASS WITH ADVISORY)

* Work completed
    - Validated the plan against `_layouts/post.html`, `_layouts/garden.html`, `collection_dates.rb`, and `_config.yaml`
    - Confirmed TDD encoding (inspect-red before production; suite waived), conventions, dependencies, conflicts, and requirement coverage
    - Wrote `memory-bank/active/.preflight-status` with first line `PASS WITH ADVISORY`
* Decisions made
    - Plan is acceptable as-is; advisories do not require a re-plan
    - Did not edit Implementation Plan units
* Insights
    - Named fixtures are valid this run (seven-weeks same day; mechanicus later day). Untagged / earlier-day / missing-`last_modified` pages do not exist in the live corpus
    - No `timezone` in config; calendar-day compare is environment-dependent
    - `jekyll-seo-tag` / `jekyll-sitemap` still only see publish date unless `last_modified_at` is set (advisory, not in plan)

