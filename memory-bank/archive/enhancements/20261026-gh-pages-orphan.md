---
task_id: 20261026-gh-pages-orphan
complexity_level: 2
date: 2026-10-26
status: completed
---

# TASK ARCHIVE: gh-pages orphan deploys

## SUMMARY

The site deploy still pushes `_site` to `gh-pages`, and that push is now a single orphan commit. `.github/workflows/deploy.yaml` sets `force_orphan: true` on the existing `peaceiris/actions-gh-pages@v3` step. On the `v3` tag that input runs `git push origin --force gh-pages`. History already on the branch drops the next time this workflow runs, which is after the change is on `main`.

## REQUIREMENTS

- Set `force_orphan: true` on the step that publishes `./_site`.
- That step remains the publisher. A DigitalOcean webhook on pushes to `gh-pages` is what publishes the site. Do not switch to `actions/deploy-pages`.
- Do not rewrite `gh-pages` by hand in this task.
- Do not add a test that only locks the workflow file. This repository tests scripts a workflow calls. This step calls none.

## IMPLEMENTATION

One line in `.github/workflows/deploy.yaml`, under the existing `peaceiris/actions-gh-pages@v3` step: `force_orphan: true`. `github_token` and `publish_dir: ./_site` are unchanged. `publish_branch` is unset, so the action default `gh-pages` stands.

`gh-pages` is not a protected branch, so the force push is not blocked by branch protection. The workflow `concurrency` group `pages` already runs one deploy at a time.

The half-wired GitHub Pages artifact settings (`pages: write`, `id-token: write`, `environment.url` pointing at a `deployment` step that does not exist) were left in place. Replacing the push with `actions/deploy-pages` would stop the webhook.

## TESTING

No new test. A YAML assertion would go red only when the line is edited, which is a change-detector, and nothing in this repository executes the action.

- `python3 -m unittest discover -s tests`: 12 tests, OK. The suite covers the SVG metadata stripper and does not observe this workflow.
- Ruby YAML (and, in QA, Python YAML) parsed the workflow: `force_orphan` is boolean true and `publish_dir` is `./_site`.
- `/niko-qa` passed. The workflow file is the only `gh-pages` publisher in the repo.

The first deploy after this is on `main` should be watched to confirm the DigitalOcean webhook treats the force push as a publish.

## LESSONS LEARNED

On `peaceiris/actions-gh-pages` `v3`, `force_orphan` still pushes. An orphan deploy is `git push origin --force gh-pages`. A webhook listening for pushes to that branch still has an event.

The publish event for this site is that push. One input on the existing step drops history without giving it up.

## PROCESS IMPROVEMENTS

For a workflow step that calls no local program, write the decision not to test as the test plan: why a local run is impossible, why a YAML lock is a change-detector, and that the operator already answered the stop-and-ask. An empty "no tests" step was blocked. The same facts, written as the decision, passed preflight.

## TECHNICAL IMPROVEMENTS

None for this change. A later, separate probe could fetch `gh-pages` after a deploy and assert the tip has one commit. That was out of scope here. The dead `steps.deployment.outputs.page_url` reference was left alone for the same reason.

## NEXT STEPS

Watch the first deploy after this reaches `main`, and confirm the DigitalOcean webhook fires on the force push.
