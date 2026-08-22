# Project Brief

## User Story

As a reader of a blog post, I want to see when the post was last updated (when that date is newer than the publish date) so that I can tell the author has touched it since publication — a postscript, a fixed link, a small correction — without implying a re-thesis.

## Use-Case(s)

### Reader sees an update notice on a revised post

A post's `last_modified` date is later than its publish date. The reader sees an update byline on the post page.

### Reader does not see an update notice on an unchanged post

A post's `last_modified` is the same calendar day as (or earlier than) its publish date. The reader sees only the existing publish date, unchanged.

### Garden pages are unaffected

Garden pages keep planted / last tended as they are today.

## Requirements

1. Show an update byline on blog posts when `last_modified` is newer than the publish date.
2. Reuse the existing `last_modified` extraction from `collection_dates.rb` (same source the garden uses for "last tended").
3. Placement: both footer positions after tags — left-aligned `last updated YYYY-MM-DD` and right-aligned `last updated YYYY-MM-DD` (operator, 2026-08-22: wants to see both). Header date unchanged.

## Constraints

1. Do not show the update date unless it is newer than the publish date.
2. Do not change garden planted / last tended presentation.
3. Date format follows `site.theme_config.date_format` (default `%Y-%m-%d`), matching existing bylines.

## Acceptance Criteria

1. A post whose last-modified date is later than its publish date shows `last updated YYYY-MM-DD` after tags on the left and again on the right.
2. A post whose last-modified date is not later than its publish date does not show an update byline.
3. Garden pages still show planted / last tended as they do today.
4. Posts that have never been edited after publish look the same as they do now (header date unchanged).
5. Site-wide content edits (e.g. adding a summary) count as updates; git last-commit is the correct source.
