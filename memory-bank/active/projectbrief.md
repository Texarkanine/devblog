# Project Brief

## User Story

As a subscriber to the blog's main feed, I want garden pages included in `/feed.xml` so that a new garden page reaches people who already follow the feed.

## Use-Case(s)

### Use-Case 1

A garden page whose planted date falls among the newest feed entries appears in `/feed.xml` alongside posts.

### Use-Case 2

Posts continue to appear in the same `/feed.xml`. The feed path and the `jekyll-feed` gem stay as they are.

## Requirements

1. Patch `jekyll-feed` from a local `_plugins` file by prepending `JekyllFeed::Generator#feed_template`.
2. Concatenate `site.garden` into the posts feed only.
3. Leave the `jekyll-feed` gem and `/feed.xml` in place.
4. Do not fail the build when a line in the gem's feed template changes.

## Constraints

1. Do this on a branch cut from updated `main`. `main` stays checked out in its own worktree.
2. Do not publish a new gem.
3. Do not replace `/feed.xml` with a source file that makes `jekyll-feed` skip generation.
4. Open a draft pull request when the change is ready.

## Acceptance Criteria

1. `/feed.xml` includes garden pages and posts.
2. Which entries appear is still decided by document `date` and the existing feed limit.
3. `jekyll-feed` still generates `/feed.xml`.
4. A draft pull request exists for the branch.
