# Tasks

## inline-once-anchors tests and blanking fix

- What broke: `blank_code` turns inline code into spaces, and the replacer copied the link text from that masked copy. `` [`sys.mk`][sysmk] `` became `[        ](url)`.
- Why: match indexes are shared on purpose, but the captured text is not the original.
- What changed: the visible text and the image marker are copied from the original string. Tests lock that case, a single-use inline, a repeated label, and footnotes.
- Files: `tools/inline_once_anchors.py`, `tests/test_inline_once_anchors.py`, `blog/essay/_posts/2026-11-13-make-make-better.md` (the damaged OpenBSD link text, restored to `mk`).


## QA Result

PASS. Fix is minimal and matches the plan; four required tests present; full suite 24 tests OK; no debris or blanked links remain in blog/. Advisory only: one long line, and three tests describe existing behavior by design.