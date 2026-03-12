# Project Brief: href_decorator Rules-Based Config Redesign

## User Story

As a blog author, I want all links within blog post bodies to open in a new window (target="_blank", rel="noopener"), so that readers don't lose their place — while keeping internal navigation (tags, categories, garden pages, _pages) behaving normally.

## Requirements

1. **Redesign config schema** from pattern-centric to rules-based:
   - `defaults` (plain hash) replaces `properties` (array-of-hashes)
   - `rules` (array of rule objects) replaces `patterns`
   - Each rule has optional `match` (href regex), optional `collections` (scope filter), optional `attrs` (additional/override attributes)
2. **Semantics agreed with user**:
   - `collections`: defaults to ALL collections (no filter); when listed, narrows to those collections only
   - `match`: defaults to ALL hrefs (no filter); when specified, narrows to matching hrefs only
   - `attrs`: merges with `defaults`; `false` disables a default for that rule
   - Multiple matching rules merge; later rules win conflicts
   - If no rule matches a link, it's untouched
3. **Desired config**:
   ```yaml
   href_decorator:
     defaults:
       target: _blank
       rel: noopener
     rules:
       - match: '^https?://'
       - match: '/assets/'
       - match: '.+\.pdf$'
         attrs:
           download: true
       - collections: [posts]
   ```
4. **No tests** — user explicitly waived TDD for this change.
5. **Scope**: `_plugins/10_href_decorator.rb` and `_config.yaml` only.
