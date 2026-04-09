# Progress: Fix Garden Planted Date Computation

Fix the "planted" date on digital garden pages, which currently shows the build date instead of the git first-commit date.

**Complexity:** Level 1

## Phase History
- **Complexity Analysis** — Complete. Level 1 determined.
- **Build** — Complete. Root cause: Jekyll's `Document#date` lazily populates `data["date"]` with `site.time`, and other generators trigger this before our low-priority plugin runs. Fix: compare against `site.time` instead of just checking key existence.
- **QA** — PASS. Fix is minimal (one condition change), no debug artifacts, no regressions, correct logic verified via truth table and full site build.
