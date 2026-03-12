---
task_id: href-decorator-rules
date: 2026-03-12
complexity_level: 2
---

# Reflection: href_decorator rules-based config redesign

## Summary

Delivered a rules-based config for the href_decorator plugin (defaults + rules with match/collections/attrs) and limited decoration to links inside `<article>` using Nokogiri. All brief requirements were met; one behavioral refinement (article-only scope) was added during build after user feedback, then implemented with proper DOM parsing instead of regex.

## Requirements vs Outcome

- **Config schema:** Delivered. `defaults` (hash) and `rules` (array) with optional `match`, `collections`, `attrs`. Replaced the old properties/patterns array-of-hashes style.
- **Semantics:** Delivered. Filter-down for both `match` and `collections`; `attrs` merge with defaults; `false` disables a default; multiple rules merge (later wins).
- **Scope:** Plugin + _config only. No tests per user waiver.
- **Addition:** The brief said "links within blog post bodies" and "internal navigation … behaving normally" but did not spell out "only inside `<article>`." The first implementation decorated every link in the document, so nav/tags/footers got `target="_blank"`. User requested body-only; we scoped to `article a[href]` and switched from regex to Nokogiri for HTML handling.

## Plan Accuracy

The written plan in tasks.md was minimal (three steps). The real source of truth was the project brief and the config UX discussion. The plan did not explicitly call out body-only scope or DOM parsing; both came from user correction during build. No re-plan was needed—the fix was local (scope + Nokogiri). The main surprise was that "links in post body" had to be implemented as "links inside `<article>`" and that regex was unacceptable for HTML, which drove the Nokogiri change.

## Build & QA Observations

- Rules-based config and collection filtering went in cleanly. Build passed.
- User then reported nav/tags opening in new tabs. We first considered regex to find `<article>` boundaries; user correctly rejected parsing HTML with regex. We switched to Nokogiri and `doc.css('article a[href]')`, which fixed behavior and matched project norms.
- QA confirmed requirements, KISS/DRY/YAGNI, and alignment with system patterns. One trivial fix: memory-bank wording updated to state that decoration is limited to links inside `<article>`.

## Insights

### Technical

- **Use Nokogiri for HTML in Jekyll.** The site already depends on it. Any non-trivial HTML selection or mutation should go through the DOM (e.g. `doc.css('article a[href]')`) instead of regex. Avoids fragile parsing and matches user expectation.

- **Layout coupling is explicit.** Scoping to `<article>` assumes post and garden layouts wrap body content in that tag. systemPatterns already describes this (Layout → content, `{{ content }}` inside `<article>`). Documenting that the plugin targets `article` in the header keeps the contract clear.

### Process

- **Config UX iteration paid off.** Discussing "filter-down" semantics and rules-as-siblings made the YAML readable without reading the plugin source. Worth doing when the config is the main interface.

- **"Body only" needed to be concrete.** "Links within blog post bodies" was enough intent but not enough implementation detail; the first pass treated the whole document as body. Clarifying that only `<article>` content counts (and that we use the DOM to do it) closed the gap.

### Million-Dollar Question

If "decorate only body links with configurable rules" had been a core requirement from the start, the plugin would have been designed around: (1) parse output with Nokogiri, (2) select `article a[href]`, (3) apply rules. No full-document regex pass to throw away. The rules-based config would still be the same. So the main difference would have been avoiding the first implementation (full-document regex) and going straight to DOM + article scope—same end state, one less round-trip.
