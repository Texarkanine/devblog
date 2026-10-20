# Task: pr-122-review-fixes

* Task ID: pr-122-review-fixes
* Complexity: Level 2
* Type: bug fix

Five review corrections on the open pull request: stop baking a cache interpreter into the pre-commit hook instructions, make the SVG stripper ignore tags inside comments and refuse files that do not parse, drop committed bytecode, run the unit tests in pull-request CI, and have a Claude Opus 5.5 subagent make a surgical edit to the reprint post's hook sentence.


## Test Plan (TDD)

### Behaviors to Verify

- Comment names a tag: a well-formed SVG whose comment contains the text `<metadata>` and `<sodipodi:namedview>`, and which also has real `metadata` and `sodipodi:namedview` elements → the comment text is unchanged, the real elements are gone, the `svg` root and the drawing element remain, and the result parses.
- Comment only: a well-formed SVG whose only `<metadata>` is inside a comment → `strip` returns the text unchanged.
- Unparsed file: that comment fixture with `&nbsp;` in a text node → `strip` raises `ValueError`; `main` returns 1 and the file bytes are unchanged.
- Empty input: `""` passed to `main` via a file → exit 1, file bytes unchanged.
- Regressions already covered: Inkscape fixture still loses editor metadata and keeps title, comment, and geometry; a strip that would leave invalid XML still raises; a refused file does not block a sibling that strips.

### Test Infrastructure

- Framework: `unittest` (`python -m unittest discover -s tests`)
- Test location: `tests/test_strip_svg_metadata.py`
- Conventions: `StripTests` for `strip`, `MainTests` for `main`, fixtures as module-level strings, temp directories for file writes
- New test files: none

## Implementation Plan

### 1. Stop tracking bytecode — prose/policy

- Files: `.gitignore`, `tests/__pycache__/test_strip_svg_metadata.cpython-311.pyc`, `tools/__pycache__/strip_svg_metadata.cpython-311.pyc`
- No tests: prose/policy artifact

1. Add `__pycache__/` and `*.pyc` to `.gitignore`.
2. `git rm` the two tracked bytecode files so later test runs cannot refresh them in the index.

### 2. Comment-safe stripper — executable

- Files: `tests/test_strip_svg_metadata.py`, `tools/strip_svg_metadata.py`

1. Stub tests: add empty `test_metadata_mentioned_in_a_comment_stays_in_the_comment`, `test_comment_only_mention_is_unchanged`, `test_unparsed_file_is_not_written`, and `test_empty_file_is_not_written` on the existing classes.
2. Stub interface: no new public signatures. `strip` and `main` stay as they are.
3. Write tests and run red: assert the four behaviors above against the current regex.
4. Write code and run green: `strip` raises `ValueError` when `_parses` is false, masks complete `<!-- -->` spans before the element and attribute substitutions, restores those spans, then keeps the existing "result would not parse" refusal. `main` already turns `ValueError` into exit 1 and skips the write.

### 3. Durable install instructions — prose/policy

- Files: `README.md`, `memory-bank/techContext.md`
- No tests: prose/policy artifact

1. Replace `uvx pre-commit install` with `uv tool install pre-commit` once per machine (or `pipx install pre-commit`), then `pre-commit install` once per clone.
2. Keep the Perl and `cpan` requirement and the "stage the rewritten files and commit again" note. State the suite command as `python3 -m unittest discover -s tests` as well as `python`, since the workflow will call `python3`.

### 4. Pull-request CI runs the suite — prose/policy

- Files: `.github/workflows/pr-check.yaml`
- No tests: prose/policy artifact

1. After checkout, run `python3 -m unittest discover -s tests`. No `setup-python`: the tests use the standard library, and `python3` is on the hosted runner. A test that the workflow file contains this string would only fail when someone edits that string.

### 5. Reprint post hook sentence — prose/policy

- Files: `blog/record/_posts/2026-10-20-do-i-need-to-reprint.md`
- No tests: prose/policy artifact

1. Spawn a Claude Opus 5.5 subagent (`claude-opus-5-5-xhigh`). It is a full shard and keeps its own memory.
2. It reads the blogging and revising rules, then makes a surgical edit of the step-4 hook sentence only.
3. The sentence tells the reader the hook is optional, and worth having when photos of a print come from a camera that records personal information, such as a phone. If they want it: copy `.pre-commit-config.yaml` and `tools/strip_svg_metadata.py`, run `pre-commit install`, and have Perl and `cpan` on `PATH`. Copying the two files alone leaves GPS in place.
4. The parent does not edit the post. If the diff reaches past that sentence, send it back to the same subagent.

## Technology Validation

No new technology - validation not required

## Dependencies

- Existing `unittest` suite and `tools/strip_svg_metadata.py`
- `python3` on the GitHub-hosted runner
- Claude Opus 5.5 subagent for the reprint sentence

## Challenges & Mitigations

- Comment masking could swallow the CDATA case that must stay a refusal: mask only `<!-- -->` spans, and leave the existing `ValueError` test unchanged.
- A placeholder token could collide with file text: use a token that includes a NUL and a fixed marker, and restore by exact replacement.
- Refusing every unparsed file is broader than the `&nbsp;` example: that is the rule the review asked for, and the new tests pin both the comment case and the refusal.
- Tracked `.pyc` files change when the suite runs: remove them from the index before the red run.
- `python` may be absent on `ubuntu-latest`: the workflow calls `python3`.
- The subagent may rewrite more than the hook sentence: the prompt limits the edit, and a wider diff goes back to that subagent rather than being rewritten here.

## Pre-Mortem

- The plan treats "do not write a file that did not parse" as a special case for `&nbsp;` inside one fixture, and some other non-XML file is still rewritten: the implementation refuses on `_parses` before any substitution, and the empty-file test locks that.
- The comment regex is greedy and deletes the root of a well-formed file: the well-formed comment test requires the comment text and the `svg` start tag both survive. Already the point of Challenge 1's test, and the test is the guard.
- The optional-hook framing drops the install and Perl/`cpan` facts, so the review item stays open: the subagent assignment states both the framing and those facts.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight
- [ ] Build
- [ ] QA
