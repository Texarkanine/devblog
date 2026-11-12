# Current Task: Author page writing section

**Complexity:** Level 1

* Task ID: writing-collection
* Type: bugfix

## Fix

The author layout concatenated writing into the posts list and sorted that mix by date, so writing pieces showed up under posts.

Posts stay in the posts list, newest first. When the author has writing, a writing heading and a dated list follow, newest first. An author with no writing gets no writing heading.

Files: `_layouts/author-archive.html`, `tests/test_writing_collection.py`.

## QA - PASS (2026-11-11)

* Reviewed the rework diff against the Fix statement above and the brief's Rework section.
* Full suite: 52 tests, OK, including the rewritten author-page test (own dated writing section below posts, no writing heading for authors without writing, no cross-author leakage).
* Findings, none blocking:
    - KISS: PASS. The split is two short Liquid blocks mirroring the existing posts list; no new abstraction.
    - DRY: advisory only. The writing `<li>` duplicates the posts `<li>` with a renamed loop variable; matches existing layout style and does not warrant a shared include.
    - YAGNI: PASS. No speculative code; the `writing_count` guard serves the no-heading requirement.
    - Completeness: PASS. Posts stay in posts, writing follows newest-first with dates, empty case has no heading.
    - Regression: PASS. Heading case (`writing`/`posts`), sort order, and date format follow established patterns.
    - Integrity: PASS. No hardcoded shortcuts, placeholders, or debug artifacts.
    - Documentation: PASS. No doc updates required for this Level 1 layout fix.
