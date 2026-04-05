# Architecture Decision: Garden Author Attribution

## Requirements & Constraints

**Ranked quality attributes:**
1. Backward compatibility — existing unattributed garden pages unchanged
2. Simplicity — minimal changes, leverage existing infrastructure
3. Consistency — unified author experience across blog and garden
4. Maintainability — easy to understand and modify

**Technical constraints:**
- Jekyll static site, Liquid templates
- `site.garden` collection accessible in Liquid
- `jekyll-auto-authors` generates author pages from `_data/authors.yaml`
- Two distinct author personas: texarkanine (human), niko (AI collaborator)

**Scope:** `garden.html`, `author-archive.html`, `_pages/authors.md`. No new plugins, no URL changes, no blog-side changes.

## Components

```
Garden page (author: niko)         Blog post (author: niko)
  → garden.html                      → post.html
  → shows "by niko" → link             → shows "by niko" → link
         ↓                                    ↓
         └──────────────┬──────────────────────┘
                        ↓
              /authors/niko/
              (author-archive.html)
              ┌─────────────────────┐
              │ posts:              │  ← site.posts | where: "author", "niko"
              │   - blog post 1    │
              │   - blog post 2    │
              │                    │
              │ garden:            │  ← site.garden | where: "author", "niko"
              │   - garden page 1  │
              └─────────────────────┘
```

## Options Evaluated

- **Full Integration**: Author display on garden pages + garden section on author archives + updated author index counts. Three file changes, all additive Liquid.
- **Display Only**: Author shown on garden pages but archives remain blog-only. Creates broken UX (link leads to page that doesn't list what you came from).
- **No Attribution**: Garden stays communal. Loses meaningful authorship information for distinct personas.

## Analysis

| Criterion | Full Integration | Display Only | No Attribution |
|-----------|-----------------|--------------|----------------|
| Fitness | Meets all requirements | Partial — broken reciprocity | Does not meet need |
| Backward compat | Perfect | Perfect | N/A |
| Simplicity | 3 files, ~20 lines | 1 file, ~5 lines | 0 changes |
| Consistency | Unified author UX | Broken expectation | N/A |
| Risk | Very low, all additive | UX inconsistency | Info loss |

Key insight: Display Only creates a genuinely bad experience — clicking an author link on a garden page takes you to an archive that doesn't list the page you came from. Either commit fully or don't add links at all.

The "do I even need this?" question resolves in favor of attribution:
- The two personas have distinct voices; authorship carries real information
- Implementation cost is trivial (3 template edits, all backward-compatible)
- The front-matter convention already exists (`author: niko` is already in the file)
- Value compounds as both personas contribute more garden content

## Decision

**Selected**: Full Integration

**Rationale**: Only option that doesn't create broken UX. Trivial implementation cost, fully backward-compatible, serves a genuine need that already manifested.

**Tradeoff**: Marginally more template complexity for unified author experience.

## Implementation Notes

1. **`_layouts/garden.html`** — Conditional author line in header when `page.author` exists. Display "by [author]" linking to `/authors/:author/`. Absent `page.author` = no change.

2. **`_layouts/author-archive.html`** — New "garden" section after existing "posts" section. Query `site.garden | where: "author", author_id`. Only render if non-empty. Garden items: title + link (no dates — garden doesn't emphasize chronology).

3. **`_pages/authors.md`** — Add garden page counts per author. Display "(N posts, M garden pages)" or similar, showing each count only when > 0.

No plugin changes needed. `jekyll-auto-authors` generates pages for all `_data/authors.yaml` entries regardless of content count.
