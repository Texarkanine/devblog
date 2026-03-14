---
task_id: href-decorator-rules
complexity_level: 2
date: 2026-03-12
status: completed
---

# TASK ARCHIVE: href_decorator rules-based config redesign

## SUMMARY

Redesigned the href_decorator plugin from a pattern-centric config to a rules-based config (`defaults` + `rules` with optional `match`, `collections`, `attrs`). Decoration is limited to links inside `<article>` elements via Nokogiri DOM selection; navigation, tags, and footers are left unchanged. External/asset/PDF links get defaults everywhere; all links in the `posts` collection get defaults inside article body only.

## REQUIREMENTS

- Rules-based config: `defaults` (plain hash) and `rules` (array of rule objects) replacing `properties`/`patterns`.
- Each rule: optional `match` (href regex), optional `collections` (document collection filter), optional `attrs` (merge/override).
- Semantics: `match` and `collections` default to "all" and narrow when specified; `attrs` merge with defaults; `false` disables a default; multiple matching rules merge (later wins).
- Only links within blog post/garden body (i.e. inside `<article>`) decorated; internal navigation (tags, categories, nav, footers) unchanged.
- Scope: `_plugins/10_href_decorator.rb` and `_config.yaml` only. No tests (user waiver).

## IMPLEMENTATION

- **Config:** `_config.yaml` — `href_decorator.defaults` (hash: `target`, `rel`), `href_decorator.rules` (array of entries with `match`, `collections`, and/or `attrs`). Example rules: `^https?://`, `/assets/`, `.+\.pdf$` with `download: true`, and `collections: [posts]`.
- **Plugin:** `_plugins/10_href_decorator.rb` — Registers `:documents, :post_render`. Parses `document.output` with Nokogiri; selects only `article a[href]`; for each anchor, computes merged attributes from matching rules and collection label; applies attributes via Nokogiri node API. Replaces output only when at least one link was modified. No regex on HTML; all selection/mutation through DOM.

## TESTING

- `bundle exec jekyll build` run successfully. Manual checks: post pages have `target="_blank"` only on links inside `<article>` (body and cross-links); nav, breadcrumb, tags, and footer links on the same page have no `target="_blank"`. Garden and pages: only external/asset/PDF links in article get decoration. QA semantic review (KISS, DRY, YAGNI, completeness, regression) passed; one trivial doc update (memory-bank wording for article scope).

## LESSONS LEARNED

- **Use Nokogiri for HTML in Jekyll.** Any non-trivial HTML selection or mutation should use the DOM (e.g. `doc.css('article a[href]')`) rather than regex. The site already depends on Nokogiri; avoids fragile parsing.
- **Layout coupling is explicit.** Scoping to `<article>` assumes post and garden layouts wrap body in that tag; documenting this in the plugin header keeps the contract clear.
- **Config UX iteration paid off.** "Filter-down" semantics and rules-as-siblings made the YAML readable without reading the plugin source.
- **"Body only" needed to be concrete.** The brief said "links within blog post bodies"; the first pass decorated the whole document. Clarifying that only `<article>` content counts (and using the DOM to enforce it) closed the gap.

## PROCESS IMPROVEMENTS

None identified for this task.

## TECHNICAL IMPROVEMENTS

If "decorate only body links with configurable rules" had been a core requirement from the start, the plugin would have been designed around: parse with Nokogiri, select `article a[href]`, apply rules. Same end state with one less round-trip (no full-document regex pass to discard).

## NEXT STEPS

None.
