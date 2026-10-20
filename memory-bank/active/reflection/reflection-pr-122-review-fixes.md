---
task_id: pr-122-review-fixes
date: 2026-10-20
complexity_level: 2
---

# Reflection: pr-122-review-fixes

## Summary

The five pull-request 122 review items are fixed on this branch, and QA passed. The stripper now ignores tags inside comments and refuses files that do not parse; bytecode is untracked; CI runs the suite; the install docs no longer use `uvx`; a Claude Opus 5.5 subagent rewrote the reprint post's hook sentence.

## Requirements vs Outcome

All five requirements shipped. CI calls `python3` rather than the acceptance criterion's literal `python`, a deviation preflight flagged and the build accepted because `python` is not guaranteed on the hosted runner. The 3d-models copy of the stripper was left unfixed on purpose: the brief bounded the task to this repository. The reprint sentence also links pre-commit.com on first mention, which the blog's writing rules ask for and the brief did not forbid.

## Plan Accuracy

The plan's order held: bytecode left the index before the tests ran, the stripper's tests went red, then the implementation went green. The comment-only test was already green, because the old regex only eats a mention when a real closing tag follows it. The challenges that mattered were that one, and the subagent staying inside a single line. No step had to be reordered.

## Build & QA Observations

The red run failed in the shape the review described: a well-formed file with a comment was refused by the old guard, and an unparsed file was rewritten with exit 0. QA passed with no rework. It re-surfaced the cross-repo follow-up and noted that one test checks the fixture with a bare `ET.fromstring` rather than an assertion.

## Insights

### Technical

- A "refuse when the result would not parse" guard never fires when the input itself does not parse. Refusal has to come before any substitution.
- A test that a comment mention is left alone stays green unless a real closing tag follows the mention. That is the input that makes the regex eat the document.

### Process

- When a post tells readers to copy a file from another repository, fixing the copy in this repository does not fix what they copy. The follow-up is a port to `3d-models`.

### Million-Dollar Question

The stripper would have one home, in the repository the recipe copies from, and this blog's hook would be that same file rather than a second copy that can drift. What we built is the correct fix for this repository's hook. It is not that single home.
