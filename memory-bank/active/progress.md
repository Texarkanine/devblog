# Progress

Fix double anchor on headings (e.g. index "Digital Garden") by making the heading-anchor plugin idempotent. Level 1 quick bug fix.

## 2026-03-06 - COMPLEXITY-ANALYSIS - COMPLETE

- Root cause: plugin runs on both :documents and :pages; index is in pages collection so processed twice.
- Fix: skip adding anchor if heading already has .heading-anchor.

## 2026-03-06 - BUILD - COMPLETE

- Added idempotency check: `next if heading.at_css(".heading-anchor")` in plugin.
- Rebuild verified: index.html has single anchor for "Digital Garden"; pink-margarine unchanged (one anchor per heading).
