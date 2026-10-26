# Progress

Set `force_orphan: true` on the existing `peaceiris/actions-gh-pages` step so each deploy of `_site` leaves `gh-pages` as a single commit.

**Complexity:** Level 2

## 2026-10-26 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Confirmed no in-flight task and classified this change as Level 2
* Decisions made
    - Level 2: one setting in `.github/workflows/deploy.yaml`, approach already chosen
* Insights
    - `origin/gh-pages` is 229 commits and about 218 MB of git objects; the current commit is about 71 MB. `main` is about 1.8 MB because media is Git LFS, and `gh-pages` stores the expanded bytes
