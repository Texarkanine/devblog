# Active Context

**Current Task:** Skip singleton tag archives and links (posts + garden)
**Phase:** QA - COMPLETE (PASS)
**What Was Done:** Implemented navigational-tag threshold (≥2) for post archives (monkey-patch), garden archives (type-gated), llms tag scopes, post/garden layouts, and both tag indexes. Documented in `_plugins/README.md`. Build verified: 32 navigational post-tag archives (+1 redirect dir), 8 garden-tag archives, singletons plain text, no orphan llms.
**Files created/modified:**
- `_plugins/navigational_tags.rb` (new)
- `_plugins/garden_archives.rb`
- `_plugins/20_llms_scope_builders.rb`
- `_plugins/README.md`
- `_layouts/post.html`
- `_layouts/garden.html`
- `pages/tags.md`
- `pages/garden/tags.md`
**Key decisions:** Accepted per-collection threshold (no union rule / curated-description exemption). Counted `llm-context-management` redirect as separate from archive target (33 dirs vs plan's 32 archives).
**QA result:** PASS — all five brief requirements verified in the rendered `_site` (32 post-tag archives, 8 garden-tag archives, filtered indexes, no dangling tag links, no orphan llms scopes, categories untouched). Four non-blocking advisories recorded in `tasks.md`, chief among them the threshold now living in five places (one Ruby constant plus four hardcoded Liquid literals).
**Next Step:** `/niko-reflect`.
