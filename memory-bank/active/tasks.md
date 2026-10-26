# Task: gh-pages orphan deploys

* Task ID: 20261026-gh-pages-orphan
* Complexity: Level 2
* Type: simple enhancement

Each deploy that publishes `./_site` with `peaceiris/actions-gh-pages@v3` keeps only the latest commit on `gh-pages`.

## Test Plan (TDD)

### Behaviors to Verify

- Publish with orphan history: the `peaceiris/actions-gh-pages@v3` step whose `publish_dir` is `./_site` is invoked with `force_orphan: true` → that action's input keeps only the latest commit on the publish branch (v3 `action.yml`: "Keep only the latest commit on a GitHub Pages branch").

No local test for that behavior. A test that reads `.github/workflows/deploy.yaml` and asserts the key can go red only when someone edits that line. That is a change-detector, and `always-tdd` forbids scheduling one. The existing suite does not run GitHub Actions.

### Test Infrastructure

- Framework: Python `unittest`, `python3 -m unittest discover -s tests`
- Test location: `tests/test_strip_svg_metadata.py` (SVG metadata stripper only)
- Conventions: one `unittest` module per tool under `tests/`, exercises `tools/` code
- New test files: none

## Implementation Plan

### 1. Set force_orphan on the pages deploy — executable

- Files: `.github/workflows/deploy.yaml`

1. Stub tests: none. The only candidate asserts on `deploy.yaml` itself and is a change-detector.
2. Stub interface: none. The production change is an input on an action this repo already runs, not a new function.
3. Write tests and run red: no test to add. Do not add a YAML lockstep test.
4. Write code and run green: under the `with:` of the step `uses: peaceiris/actions-gh-pages@v3` that already sets `publish_dir: ./_site`, add `force_orphan: true`. Leave `github_token` and `publish_dir` as they are. Do not run the workflow.

## Technology Validation

No new technology - validation not required.

`peaceiris/actions-gh-pages@v3` is already the deploy step. Its `action.yml` defines `force_orphan` (`required: false`, `default: 'false'`, description "Keep only the latest commit on a GitHub Pages branch"). No new dependency and no proof-of-concept install.

## Dependencies

- `peaceiris/actions-gh-pages@v3` (already pinned in `.github/workflows/deploy.yaml`)
- `GITHUB_TOKEN` with `contents: write` (already granted on that workflow)
- `gh-pages` is not a protected branch (GitHub API branch-protection returned 404 "Branch not protected" on 2026-10-26), so the action's force-push is not blocked by branch protection
- The workflow `concurrency` group `pages` already runs one deploy at a time

## Challenges & Mitigations

- The only local assertion is a change-detector: do not add it. Acceptance of this task is the workflow input. The old commits leave the branch on the next workflow run, which the brief puts outside this task.
- A mistyped input would be ignored or rejected by the runner: the input name `force_orphan` is copied from the v3 `action.yml`.
- An orphan publish force-pushes `gh-pages`: the branch is unprotected, and the existing concurrency group keeps deploys serial.

## Pre-Mortem

- The flag is set and the next real deploy still stacks a child commit: the v3 input description is the evidence the flag means "latest commit only". This task does not run that deploy. If a later run still grows history, the premise is wrong and the task needs rework.
- Preflight treats step 1 as executable work with no legal test and returns FAIL (blocking): do not invent a change-detector to get past the check. Stop and report that result.
- Some other publisher keeps appending to `gh-pages`: the only `gh-pages` / `peaceiris` reference in the repo is `.github/workflows/deploy.yaml`.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [ ] Preflight
- [ ] Build
- [ ] QA
