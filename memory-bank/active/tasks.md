# Task: 3D Modelling Blog Slate

* Task ID: 3d-modelling-slate
* Complexity: Level 3
* Type: editorial (research, post design, then drafting)

Research the `3d-models` work (two rescued operator models, two Niko-designed bulb models, the GitHub-to-Cults3D pipeline) and propose Niko-authored blog posts with a beat sheet each. The operator, as editor, picks the set. Drafting the picked posts is the build.

## Component Analysis

### Affected Components

- `memory-bank/active/creative/research-*.md`: source digests (one per session cluster) and `research-index.md` (the map). Already written.
- `memory-bank/active/creative/creative-post-slate.md`: the candidate posts and beat sheets. The decision document for the open question below.
- `blog/<shape>/_posts/2026-MM-DD-<slug>.md`: the picked posts, `author: niko`, one per pick (build phase).
- `assets/img/...` (or the convention the drafting phase confirms): print photos copied from the public `3d-models` repo, if a post embeds them via `{% polaroid %}`.
- `_data/tags.yaml`: only if a picked post introduces a tag that needs a description (the `3d-printing` tag already exists).

### Cross-Module Dependencies

- Posts depend on the digests for facts and citations; drafts must re-verify any number or quote against the transcript dumps in `.scratch/3d-research/transcripts/` before it ships.
- Series posts link to each other; publish order decides which links can be written as live links.

### Boundary Changes

- None. No layout, plugin, or config changes are planned.

## Invariants & Constraints

- Every factual claim in a post traces to a transcript, the public repo, or the operator's own words in this task.
- The blog's security and privacy rules hold: no local paths, real name, client ids, household roster or vehicle; operator-private material stays out entirely (see `research-index.md`, Local-only notes).
- Posts follow `.cursor/rules/blogging.mdc` and `.cursor/rules/revising.mdc` (shape named up front, no emdashes, no "it's not X, it's Y", earned headings, claim-then-proof).
- Non-goal: no changes to the `3d-models` repo from this task.

## Open Questions

- [ ] **Which posts, in which shapes, in what order?** Multiple viable posts exist with overlapping material; the choice depends on the editor's priorities (audience, series fit, how many posts). Constraints: Niko authors; overlap must be assigned so no two posts tell the same story beat; privacy rules above. → Unresolved, awaiting operator input (see `memory-bank/active/creative/creative-post-slate.md`).

## Test Plan (TDD)

No new executable behavior. Posts are prose; verification is editorial (fact-check against sources, privacy sweep, local `bundle exec jekyll build` to confirm the posts render).

## Implementation Plan

Pending the editor's picks. Each picked post becomes one prose/policy step: re-read its beat sheet and source digests, re-verify facts against transcripts, draft, self-revise against `revising.mdc`, privacy sweep, build locally.

## Status

- [x] Component analysis complete
- [ ] Open questions resolved (awaiting operator)
- [x] Test planning complete (no executable behavior)
- [ ] Implementation plan complete
- [x] Technology validation complete (no new technology)
- [ ] Pre-Mortem complete
- [ ] Preflight
- [ ] Build
- [ ] QA
