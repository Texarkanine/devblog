# Progress

Fill `_data/tags.yaml` with sparse, voice-matched disambiguation blurbs for the high-count tags that actually need them — not a glossary of popular tags.

**Complexity:** Level 2

## 2026-08-13 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Validated intent: disambiguation over encyclopedia; corpus voice; candidate pool is high-count tags on `/tags/` and `/garden/tags/`
    - Classified Level 2 (self-contained content enhancement of existing tag-archive lookup)
    - Created feature branch `tag-descriptions`
* Decisions made
    - Level 2: one data file, existing machinery (`tag-descs` archive 2026-03-19), no creative-phase overhead in the L2 workflow
    - Yeses already named by operator: `cursor`, `jekyll`; keep `harness-engineering`, `context-engineering`
    - Maybes: `ai`, `bitcoin`; everything else must earn a description or get none
* Insights
    - Combined ≥3 counts: `ai` 30, `cursor` 10, `jekyll` 9, `harness-engineering` 9, `context-engineering` 8, `claude-code` 7, then a 6–3 tail including garden-only `spaceship`/`thoughts`/`links`
    - Working tree already had a dirty `_data/tags.yaml` (`ai: test tag plz ignore` plus two engineering blurbs)

## 2026-08-13 - PLAN - COMPLETE

* Work completed
    - Ranked tags from both indexes; applied disambiguation bar; locked a six-tag yes-list with draft copy in `tasks.md`
    - Confirmed no test harness; verification is `jekyll build` plus `_site` inspection
* Decisions made
    - Yes: `cursor`, `jekyll`, `mermaid` (same collision class as jekyll), `harness-engineering`, `context-engineering`, `ai` (this-site summary, not a definition)
    - No: `bitcoin` (not a collision; posts already argue), `claude-code`, `ruby`, `agentic-engineering` (umbrella), garden buckets
    - Rewrite the two engineering blurbs from `_garden/ai-horses.md`; drop em-dashes and the encyclopedia sentences
    - `mermaid` is the one stretch: drop that key only if QA/operator objects
* Insights
    - Current yaml already had usable keys for harness/context but generic copy plus an `ai` test stub
    - Horses note is the canonical split: harness = making saddles; context = horsemanship once tacked

## 2026-08-13 - PREFLIGHT - COMPLETE (PASS WITH ADVISORY)

* Work completed
    - Validated the plan against the data contract, both archive layouts, the SEO hook, exact front-matter tag slugs, and the canonical Horses note
    - Confirmed the prose-only plan correctly excludes TDD and avoids change-detector tests
    - Amended build inspection to cover description, Open Graph, and JSON-LD metadata plus an undescribed SEO negative control
* Decisions made
    - Approved the six-key plan for build with no rendering, plugin, dependency, or public-interface changes
    - Carried `mermaid` as a non-blocking advisory because it meets the collision bar but was not operator-named
* Insights
    - Existing machinery fully covers the requested behavior; new automation or rendering code would violate the content-only constraint without improving the deliverable

## 2026-08-13 - BUILD - COMPLETE

* Work completed
    - Replaced `_data/tags.yaml` with the six yes-list blurbs; removed `ai: test tag plz ignore`
    - Built the site and inspected blog + garden archives plus SEO metadata and negative controls
* Decisions made
    - Kept drafted copy with no wording expansion
    - Kept `mermaid` (preflight advisory); QA may still drop that key alone
* Insights
    - Kramdown smartquotes turned `Anysphere's` into a curly apostrophe in HTML; SEO plain-text extraction still reads cleanly
    - Horses permalink `/garden/ai-horses.html` matches `_config.yaml` garden `:path:output_ext`

## 2026-08-13 - QA - COMPLETE

* Work completed
    - Reviewed `_data/tags.yaml` diff against project brief and tasks.
    - Verified all 6 keys (`ai`, `context-engineering`, `cursor`, `harness-engineering`, `jekyll`, `mermaid`) match the exact front-matter text and use the correct `>-` formatting.
    - Confirmed removal of any stubs and em-dashes.
* Decisions made
    - `mermaid` key retained: passes the disambiguation collision test (mythological creature vs diagram tool).
* Insights
    - Changes strictly followed the content-only constraint, correctly leveraging the existing Jekyll layout infrastructure.

## 2026-08-13 - REFLECT - COMPLETE

* Work completed
    - Wrote `memory-bank/active/reflection/reflection-tag-descriptions.md`
    - Reconciled persistent files: no updates
* Decisions made
    - `bitcoin` stays undescribed; `mermaid` stays
* Insights
    - Content-only L2: lock yes-list and no-list in the plan so sparsity is auditable without a creative phase

## 2026-08-13 - REWORK - OPERATOR COPY

* Work completed
    - Restored `harness-engineering` and `context-engineering` verbatim from `main`
* Decisions made
    - Those two were already the disambiguation the file existed for; do not voice-rewrite them
    - `ai`, `cursor`, `jekyll`, `mermaid` stay
* Insights
    - "Keep" meant keep the copy, not keep the keys and restyle them

## 2026-08-13 - REWORK - AGENTIC-ENGINEERING

* Work completed
    - Filled the empty `agentic-engineering` key
* Decisions made
    - Umbrella blurb: directing agents to ship; points at harness (loop) and context (what they can see) so the three tags don't collapse into each other

## 2026-08-13 - ARCHIVE - READY

* Work completed
    - Operator tightened `agentic-engineering`, `ai`, `jekyll`, and `mermaid` copy in `_data/tags.yaml`
    - Final keys: `agentic-engineering`, `ai`, `context-engineering`, `cursor`, `harness-engineering`, `jekyll`, `mermaid`
