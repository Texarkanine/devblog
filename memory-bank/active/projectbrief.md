# Project Brief

## User Story

As a reader landing on a tag archive, I want a short blurb only when the tag name could mean the wrong thing, so I know what this site means by it without being lectured on things I already know.

## Use-Case(s)

### Use-Case 1

A reader opens `/tags/cursor/` or `/tags/jekyll/` and sees a one-line disambiguation (the editor; the static-site generator) rather than guessing a mouse, a database cursor, or Mr Hyde.

### Use-Case 2

A reader opens `/tags/harness-engineering/` or `/tags/context-engineering/` and sees the site-specific distinction those tags were created to hold.

### Use-Case 3

A reader opens a high-count tag that is already unambiguous on this site (`ruby`, `open-source`, `thoughts`, …) and sees no blurb — the archive looks as it does today.

## Requirements

1. Populate `_data/tags.yaml` only for tags that fail a disambiguation test: a reasonably informed reader could take the label to mean something else.
2. Write blurbs in the site's existing voice, using the post/garden corpus as the reference — not generic encyclopedia copy.
3. Keep `harness-engineering` and `context-engineering` (the reason the file exists); rewrite them if the current copy is too generic.
4. Include `cursor` and `jekyll` (operator-named yeses).
5. Consider `ai` and `bitcoin` as maybes: a short this-site summary if one earns its keep, not a definition of the thing.
6. Candidate pool is high-count tags on `/tags/` and `/garden/tags/` (combined ≥3). Garden tags are in the pool on the same bar.
7. Remove the `ai: test tag plz ignore` stub.
8. Keys must exactly match front-matter tag strings. Values follow the file's existing comment contract (`>-` / `|`, Kramdown + inline HTML).

## Constraints

1. Content only — no new rendering machinery. Tag archives already look up `site.data.tags[page.title]` (`memory-bank/archive/features/20260319-tag-descs.md`).
2. Sparse by default: popularity does not earn a description.
3. Any commit lives on a feature branch (`tag-descriptions`).
4. Same description applies to blog and garden archives (global `_data/tags.yaml`).

## Acceptance Criteria

1. `_data/tags.yaml` contains descriptions only for tags that pass the disambiguation bar, plus the two engineering tags the file was built for.
2. `cursor` and `jekyll` have descriptions that name the software this site means.
3. No `test tag plz ignore` (or similar stub) remains.
4. Tags that do not merit a description have no key (or an empty key that renders unchanged).
5. A production build renders the blurbs on the corresponding tag archive pages and leaves undescribed tag archives unchanged.
