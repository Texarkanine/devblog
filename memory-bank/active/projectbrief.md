# Project Brief

Lock in `tools/inline_once_anchors.py` with a unittest suite discovered the same way as `tests/test_strip_svg_metadata.py`.

## Requirements

- First test fails on the bug that blanked link text: a once-used reference whose visible text contains inline code, such as `` [`sys.mk`][id] ``, must keep that text when it becomes an inline link.
- Further tests, written red then green, lock the happy paths we rely on: a single-use reference becomes an inline link and its definition is removed; a label used more than once stays; footnotes stay.
- Fix only the blanking bug so those tests pass.
- Push the result, then archive the task.
