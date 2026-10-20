---
task_id: pr-122-review-fixes
complexity_level: 2
date: 2026-10-20
status: completed
---

# TASK ARCHIVE: pr-122-review-fixes

## SUMMARY

Five review items on pull request 122 are fixed. The SVG stripper ignores tags inside comments and refuses a file that does not parse. Committed bytecode is gone. Pull-request CI runs the unit tests. The README and tech context install pre-commit with a durable tool install. A Claude Opus 5.5 subagent rewrote the reprint post's hook sentence. QA passed.

## REQUIREMENTS

- Replace `uvx pre-commit install` in the README and tech context with `uv tool install pre-commit` or `pipx install pre-commit`, then `pre-commit install`.
- Ignore tags inside comments, and do not write a file that does not parse. Cover that with tests.
- Remove the two committed `.pyc` files and ignore `__pycache__/` and `*.pyc`.
- Run the unit tests from `.github/workflows/pr-check.yaml`.
- Change the reprint post's hook sentence only through a Claude Opus 5.5 subagent. The hook is optional, and worth having when a print photo comes from a camera that records personal information, such as a phone.

## IMPLEMENTATION

Bytecode left the index before the tests ran. `strip` raises when the original does not parse, masks complete `<!-- -->` spans, then keeps the existing refusal when the result would not parse. `main` already turns that into exit 1 and skips the write. CI calls `python3 -m unittest discover -s tests` because `python` is not guaranteed on the hosted runner. The reprint sentence is four sentences on one line, including a link to pre-commit.com on first mention. The parent did not edit that file.

Key files: `tools/strip_svg_metadata.py`, `tests/test_strip_svg_metadata.py`, `.gitignore`, `README.md`, `memory-bank/techContext.md`, `.github/workflows/pr-check.yaml`, `blog/record/_posts/2026-10-20-do-i-need-to-reprint.md`.

## TESTING

The new tests went red on the old stripper: a well-formed file whose comment names `<metadata>` was refused after the regex ate the root, an unparsed file was rewritten with exit 0, and an empty file exited 0. They then passed. The comment-only mention was already green, because the old regex needs a closing tag. The module ended at 12 tests OK. `bundle exec jekyll build` succeeded. `/niko-qa` passed with no rework. It noted a bare `ET.fromstring` fixture check, which was left as is.

## LESSONS LEARNED

A guard that only checks the stripped result never fires when the input itself does not parse. Refusal has to come before any substitution. A test that a comment mention is left alone stays green unless a real closing tag follows the mention. That later tag is what lets the regex eat the document.

## PROCESS IMPROVEMENTS

When a post tells readers to copy a file from another repository, fixing the copy in this repository does not fix what they copy. The port belongs in the repository the recipe names.

## TECHNICAL IMPROVEMENTS

The stripper would have one home, in the repository the recipe copies from, and this blog's hook would be that same file rather than a second copy that can drift. The fix in this repository is the right fix for this hook. It is not that single home.

## NEXT STEPS

After this task's reflection, the same stripper fix was ported to `Texarkanine/3d-models` as draft pull request 23. This archive does not include that port.
