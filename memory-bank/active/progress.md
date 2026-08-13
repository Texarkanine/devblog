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
