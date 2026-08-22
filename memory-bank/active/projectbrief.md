# Project Brief

## User Story

As a reader, I want a post's `last updated` date to reflect when the **body copy** last changed, so that front-matter, tag, and summary-only git commits do not imply the essay was rewritten.

## Use-Case(s)

### Use-Case 1

A post was later given a page summary, tags, or other front-matter-only edits. The footer should not show `last updated` for those commits.

### Use-Case 2

A post's body was edited on a later calendar day than publish (postscript, rewrite, link fix in the prose). The footer should show `last updated` for that body-change day.

### Use-Case 3

`last_modified` is still overridable in front matter. Garden "Last tended" is out of scope unless the shared generator forces a decision.

## Requirements

1. Confirm feasibility of computing last-modified from file contents across git history, not from last-commit timestamp alone.
2. Advance the post `last updated` date only when the post **body** (content after front matter) changed.
3. Keep the existing footer byline and calendar-day compare (`updated_day > published_day`).
4. Honor an explicit `last_modified` front-matter override.

## Constraints

1. Build remains static; no client-side JS for this.
2. Do not invent a test suite if the repo still has none; verify by build + inspect unless planning decides otherwise.
3. Do not change garden planted / last-tended behavior unless sharing `CollectionDatesGenerator` makes a posts-only split necessary.

## Acceptance Criteria

1. A later-day commit that touches only front matter (summary, tags, etc.) does not advance `last_modified` for that post.
2. A later-day commit that changes body copy does advance `last_modified` to that commit's date.
3. Posts whose latest body change is the same calendar day as publish still hide the byline.
4. Front-matter `last_modified` still wins when set.
