# Project Brief

## User Story

As the site operator, I want each `gh-pages` deploy to keep a single commit so that the deployment branch stops accumulating history.

## Use-Case(s)

### Publish the site

A push to `main` (or a manual workflow run) builds the site and publishes `_site` to the `gh-pages` branch. The published branch contains one commit: the files just built. Earlier deploy commits are no longer on the branch.

## Requirements

1. Set `force_orphan: true` on the existing `peaceiris/actions-gh-pages` step in `.github/workflows/deploy.yaml`.

## Constraints

1. The change is that setting. Do not add a separate history rewrite, a new deploy mechanism, or other workflow changes.
2. Existing `gh-pages` commits disappear the next time that workflow runs, not as a manual rewrite in this task.

## Acceptance Criteria

1. `.github/workflows/deploy.yaml` sets `force_orphan: true` on the `peaceiris/actions-gh-pages` step that publishes `./_site`.
