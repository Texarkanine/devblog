---
task_id: 20261026-gh-pages-orphan
date: 2026-10-26
complexity_level: 2
---

# Reflection: gh-pages orphan deploys

## Summary

The deploy step now sets `force_orphan: true` on `peaceiris/actions-gh-pages@v3`, so the next run force-pushes a single commit to `gh-pages`. That is the change that was asked for.

## Requirements vs Outcome

Both acceptance criteria are met. The setting is on the step that publishes `./_site`, and that step is still what pushes `gh-pages`. Nothing was added to the workflow beyond that input. `actions/deploy-pages` stayed out, because a DigitalOcean webhook on `gh-pages` is the publish path.

## Plan Accuracy

The file list and the one-line edit were right the first time. The first preflight blocked because the plan recorded "no test" as an empty step. The operator then added two facts: this repository does not test workflow YAML, and pushes to `gh-pages` must continue. The second plan put the impossibility in the test plan as a decision. Preflight accepted that. The challenge that actually mattered was the webhook, which was not in the original brief.

## Build & QA Observations

The edit was one line. The local suite (12 tests) does not observe it. Ruby YAML confirmed `force_orphan` is boolean true. QA passed with no findings. Two advisories carry forward: a future probe could assert that `gh-pages` has one commit, and the first real deploy should be watched to see that the webhook fires on the force push.

## Insights

### Technical

- On the `v3` tag, `force_orphan` still runs `git push origin --force gh-pages`. An orphan deploy is a push. A webhook listening for pushes to that branch still has an event.

### Process

- For a workflow step that calls no local program, write the decision not to test as the test plan, including why a YAML assertion is a change-detector and that the operator already answered the stop-and-ask. An empty "no tests" step was blocked. The same facts, written as the decision, passed.

### Million-Dollar Question

The publish event is a push to `gh-pages`. One input on the existing step is the change that drops history without giving up that event. A Pages artifact deploy would be tidier only if nothing were listening for the branch.
