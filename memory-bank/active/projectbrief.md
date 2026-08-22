# Project Brief

## User Story

As a reader, I want a post or garden page's last-updated / last-tended date to reflect when the **body copy** last changed, so that front-matter, tag, and summary-only git commits do not imply the prose was rewritten.

## Use-Case(s)

### Use-Case 1

A post was later given a page summary, tags, or other front-matter-only edits. The footer should not show `last updated` for those commits.

### Use-Case 2

A post's body was edited on a later calendar day than publish (postscript, rewrite, link fix in the prose). The footer should show `last updated` for that body-change day.

### Use-Case 3

A garden page's body was last changed earlier than a later front-matter-only commit. Last tended should be the body-change day. Last tended still displays even when that day matches Planted — garden is expected to show both.

### Use-Case 4

`last_modified` is still overridable in front matter.

## Requirements

1. Compute `last_modified` from the last git commit that changed the document **body** (content after YAML front matter), for both posts and garden.
2. Posts: keep the existing footer byline and calendar-day compare (`updated_day > published_day`). Last-updated is the exception; same-day body edits stay hidden.
3. Garden: keep showing Last tended whenever `last_modified` is set, including when it matches Planted.
4. Honor an explicit `last_modified` front-matter override.

## Constraints

1. Build remains static; no client-side JS for this.
2. No automated test suite. Verify by `jekyll build` + HTML inspect.
3. Do not change garden header layout (Planted / Last tended always shown). Do not add a same-day hide to garden.

## Acceptance Criteria

1. A later-day commit that touches only front matter does not advance `last_modified`.
2. A later-day commit that changes body copy does advance `last_modified` to that commit's date.
3. Posts whose latest body change is the same calendar day as publish hide the byline.
4. Garden pages still show Last tended when it matches Planted.
5. Front-matter `last_modified` still wins when set.
