---
task_id: heading-anchor-links
complexity_level: 2
date: 2026-03-06
status: completed
---

# TASK ARCHIVE: Heading anchor links (hover-to-reveal icon)

## SUMMARY

Added a build-time-only feature: each heading (h1–h6) with an `id` in rendered Jekyll output gets an anchor link (configurable icon, default `#`) placed after the heading text. The link is visible on hover via minimal CSS so readers can copy or open fragment URLs. No client-side JS. Spacing between title and anchor is configurable via CSS variable `--heading-anchor-gap`.

## REQUIREMENTS

- Headings have stable `id` attributes (Kramdown default).
- Each such heading has an associated link with `href="#id"`; link appears after the title text.
- Link visible on hover; minimal CSS only, no JS.
- Icon configurable in config (`heading_anchor_icon`), default `#`.
- All behavior at build time (post_render plugin).
- Spacing between title and anchor configurable via CSS (e.g. `--heading-anchor-gap`).

## IMPLEMENTATION

- **Config:** `_config.yaml` — `heading_anchor_icon: "#"`.
- **Plugin:** `_plugins/05_heading_anchor_links.rb` — Registers `:documents, :post_render`; parses output with Nokogiri; finds all `h1[id]`–`h6[id]`; appends an `<a href="#id" class="heading-anchor" aria-label="Link to this section">` with `add_child(anchor)` so the anchor comes after the heading text. Skips when output doesn’t look like HTML (`</h` check).
- **CSS:** `assets/css/main.scss` — `:root { --heading-anchor-gap: 0.25em; }`, `.heading-anchor { opacity: 0; margin-left: var(--heading-anchor-gap); }`, and hover/focus rules for h1–h6 to reveal the link.
- **Docs:** `_plugins/README.md` — Section for 05_heading_anchor_links with config and behavior.

## TESTING

- `bundle exec jekyll build` run successfully; manual inspection of `_site` (e.g. `_site/2026/03/01/pink-margarine.html`) confirmed anchor links after heading text with correct `#` fragment and class. QA semantic review (KISS, DRY, YAGNI, completeness) passed with no fixes.

## LESSONS LEARNED

- **Technical:** `Nokogiri::HTML.fragment(document.output)` with `doc.to_html` written back to `document.output` preserves the full document; headings are modified in place. In Nokogiri, use `add_child` (not `append_child`) to add a node as the last child.
- **Process:** Plan and preflight were sufficient; no rework. For Level 2, pinning the CSS entry point in preflight removed theme ambiguity.

## PROCESS IMPROVEMENTS

None identified for this task.

## TECHNICAL IMPROVEMENTS

If “every heading is linkable” were a core assumption from the start, the same design would apply: one post_render plugin and shared CSS. For a remote theme, local plugin + local CSS override remains the right place.

## NEXT STEPS

None.
