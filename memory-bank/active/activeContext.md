# Active Context

## Current Task: gh-pages orphan deploys
**Phase:** PREFLIGHT - COMPLETE (FAIL (blocking))

## What Was Done
- Level 2 plan: add `force_orphan: true` to the existing `peaceiris/actions-gh-pages@v3` step in `.github/workflows/deploy.yaml`.
- No new test. A YAML assertion would be a change-detector. v3 already documents `force_orphan` as "Keep only the latest commit on a GitHub Pages branch". `gh-pages` is not branch-protected.

## Operator decision (2026-10-26)

This repository does not test GitHub Actions workflow YAML. When a workflow calls a script or other software, that software is what gets tested. This change calls none. A local test of `force_orphan` is impossible, and a YAML lock would be a change-detector. The operator asked for that choice to be written into the plan and judged on the merits.

Publishing still requires a push to `gh-pages`. A DigitalOcean webhook on that branch is what publishes the site. `force_orphan` on `peaceiris/actions-gh-pages@v3` still runs `git push origin --force gh-pages`. Replacing that step with `actions/deploy-pages` would stop the pushes.

## Next Step
- Re-plan with that case in the record, then preflight again.
