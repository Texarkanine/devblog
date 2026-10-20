# Project Brief

## User Story

As the author of this blog, I want the five review items on pull request 122 fixed so that the image-metadata hook, its install instructions, its tests, and the reprint post's recipe are safe to merge.

## Use-Case(s)

### Use-Case 1

A clone follows the README and installs the pre-commit hook with an interpreter that survives a uv cache clean.

### Use-Case 2

The SVG stripper leaves comments alone, and it does not write a file that did not parse.

### Use-Case 3

Python bytecode is not committed, and pull-request CI runs the stripper's unit tests.

### Use-Case 4

A reader of "Do I Need to Reprint?" can choose the photo-metadata hook, and understands it matters when a print photo comes from a camera that records personal information, such as a phone.

## Requirements

1. In `README.md` and `memory-bank/techContext.md`, replace `uvx pre-commit install` with a durable install (`uv tool install pre-commit` or `pipx install pre-commit`).
2. In the SVG stripper, ignore tags inside comments, and do not write a file that did not parse. Cover that with tests.
3. Remove the two committed `.pyc` files, and ignore `__pycache__/` and `*.pyc`.
4. Run `python -m unittest discover -s tests` in `.github/workflows/pr-check.yaml`.
5. Change the reprint post's pre-commit sentence only through a Claude Opus 5.5 subagent. The parent agent does not edit that post. The subagent recalls the writing style and guidelines and makes a surgical edit. The hook is optional, and worth having if photos of a print come from a camera that records personal information, such as a phone.

## Constraints

1. The reprint post is edited by a Claude Opus 5.5 subagent, which is a full shard and keeps its own memory.
2. The five items are the scope. The empty pull-request body is out of scope.
3. Executable behavior follows test-driven development.

## Acceptance Criteria

1. README and tech context no longer tell a clone to run `uvx pre-commit install`.
2. A comment that mentions `<metadata>` does not cause the stripper to delete markup outside that comment, and a file that does not parse is left unchanged with a non-zero exit.
3. The two `.pyc` files are gone from the tree, and `.gitignore` covers `__pycache__/` and `*.pyc`.
4. `pr-check.yaml` runs `python -m unittest discover -s tests`.
5. The reprint post's hook sentence is a surgical edit made by the Opus subagent, with the optional-hook framing above.
