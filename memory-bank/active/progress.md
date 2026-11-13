# Progress

Add a unittest suite for `tools/inline_once_anchors.py`, prove the inline-code blanking bug red, lock the happy paths we use, fix that bug, push, and archive.

**Complexity:** Level 1

## 2026-11-13 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Classified the approved intent as Level 1
* Decisions made
    - Single script plus its tests; no plan or creative phase
* Insights
    - The blanking bug copies link text from the space-masked copy

## 2026-11-13 - BUILD - COMPLETE

* Work completed
    - Added `tests/test_inline_once_anchors.py`
    - Confirmed the inline-code test failed, then copied link text from the original string
    - Restored the OpenBSD link text in the Make essay to `mk`
    - Full suite: 24 tests OK
* Decisions made
    - Happy-path tests describe behavior the tool already had; only the blanking test went red
* Insights
    - Masking stays for finding matches inside code; the replacement must not read the mask
