# Task: gh-pages orphan deploys

* Task ID: 20261026-gh-pages-orphan
* Complexity: Level 2
* Type: simple enhancement

Each deploy that publishes `./_site` with `peaceiris/actions-gh-pages@v3` still pushes to `gh-pages`, and that push carries a single orphan commit.

## Test Plan (TDD)

### Behaviors to Verify

- Orphan publish: the step `uses: peaceiris/actions-gh-pages@v3` with `publish_dir: ./_site` is invoked with `force_orphan: true` → on the `v3` tag, `src/git-utils.ts` checks out an orphan branch and `push` runs `git push origin --force gh-pages`. The branch tip moves. History on the branch is that one commit.
- Publish path preserved: the same step remains the thing that updates `gh-pages`. A DigitalOcean webhook on pushes to that branch is what publishes the site (operator, 2026-10-26). `actions/deploy-pages` is out of scope because it would stop those pushes.

### Recorded decision: no test

This behavior cannot be tested in this repository, and the plan chooses not to add a test. That is the test plan, not a missing one.

- The behavior runs inside `peaceiris/actions-gh-pages` on a GitHub-hosted runner. This repository has no harness that executes workflow YAML. `tests/` contains `test_strip_svg_metadata.py` only, and `python3 -m unittest discover -s tests` exercises `tools/strip_svg_metadata.py`.
- This step calls no script and no other local program. The repository tests that kind of software when a workflow calls it. There is nothing here to put under `tests/`.
- A test that reads `.github/workflows/deploy.yaml` and asserts `force_orphan: true` goes red only when that line is edited, and stays green if the action stops pushing or the webhook stops deploying. `always-tdd` forbids that change-detector.
- The previous preflight stopped on `always-tdd`'s "if you cannot locate existing test infrastructure, stop and ask." The operator answered on 2026-10-26: workflow YAML is not tested; make that choice part of the record and judge it on the merits. Brief constraint 3 is that answer.

### Test Infrastructure

- Framework: Python `unittest`, `python3 -m unittest discover -s tests`
- Test location: `tests/test_strip_svg_metadata.py`
- Conventions: one `unittest` module per tool under `tests/`, exercises `tools/` code
- New test files: none

## Implementation Plan

### 1. Set force_orphan on the pages deploy — executable on GitHub, no local test

- Files: `.github/workflows/deploy.yaml`
- The ordered steps below are the test decision first, then the one-line production change. Do not add a YAML lockstep test. Do not replace the peaceiris step.

1. Test decision, survey: confirm the only local suite is `tests/test_strip_svg_metadata.py` and that this step's `run`/`uses` calls no file under `tools/` or `tests/`.
2. Test decision, reject the change-detector: do not add a test whose only failure mode is an edit to `force_orphan` in `.github/workflows/deploy.yaml`.
3. Test decision, record: the behavior under test is `git push origin --force gh-pages` inside the action. It cannot be executed here. No red test is possible. Proceed without one.
4. Production change: under the `with:` of the step `uses: peaceiris/actions-gh-pages@v3` that already sets `github_token` and `publish_dir: ./_site`, add `force_orphan: true`. Leave the token, the directory, and the step in place. Do not set `publish_branch` (the default is `gh-pages`). Do not run the workflow.

Done. `tests/` has only `test_strip_svg_metadata.py`. The deploy step calls `peaceiris/actions-gh-pages@v3`, not a local program. No YAML lock test was added. `force_orphan: true` is on that step. `python3 -m unittest discover -s tests` ran 12 tests, OK. Ruby `YAML.load_file` read the workflow: `force_orphan` is boolean true and `publish_dir` is `./_site`.

## Technology Validation

No new technology - validation not required.

`peaceiris/actions-gh-pages@v3` is already the deploy step. Its `action.yml` defines `force_orphan` (`required: false`, `default: 'false'`, description "Keep only the latest commit on a GitHub Pages branch"). On the `v3` tag, `src/git-utils.ts` function `push` runs `git push origin --force <branch>` when that input is set, after `git checkout --orphan`. That push is the event the DigitalOcean webhook listens for. No new dependency.

## Dependencies

- `peaceiris/actions-gh-pages@v3` (already pinned in `.github/workflows/deploy.yaml`)
- `GITHUB_TOKEN` with `contents: write` (already granted on that workflow)
- `gh-pages` is not a protected branch (GitHub API branch-protection returned 404 "Branch not protected" on 2026-10-26), so the action's `--force` push is not blocked by branch protection
- The workflow `concurrency` group `pages` already runs one deploy at a time
- A DigitalOcean webhook on `gh-pages` publishes the site. This plan does not change that subscription

## Challenges & Mitigations

- The action could have stopped updating the branch under `force_orphan`: on the pinned `v3` tag, `push` is `git push origin --force`. The branch name stays `gh-pages`. A force push is still a push.
- A mistyped input would be ignored or rejected by the runner: the input name is copied from the v3 `action.yml`.
- Replacing peaceiris with `actions/deploy-pages` would drop the `gh-pages` pushes the webhook needs: that alternative is rejected. The step stays.
- History disappears on the next workflow run, not in this task: brief constraint 2.

## Pre-Mortem

- The judge treats "no test file" as an automatic block and does not read the recorded decision: the previous failure already asked the operator, and the operator answered. This plan's test section is that answer. If preflight blocks again on the same sentence, stop and report it. Do not add a change-detector to get past the check.
- The next real deploy's force push does not wake DigitalOcean: the operator identified the webhook as a push listener, and the action's push is `git push origin --force gh-pages`. This task does not run that deploy. A missed deploy after the first orphan run would mean the webhook ignores force pushes, which is outside this change and would need the operator.
- Some other publisher keeps appending history, or this plan removes the only publisher: the only `gh-pages` / `peaceiris` reference in the repo is `.github/workflows/deploy.yaml`, and the production step keeps that reference.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight
- [x] Build
- [ ] QA
