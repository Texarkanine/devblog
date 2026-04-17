---
task_id: fix-garden-planted-date
complexity_level: 1
date: 2026-04-09
status: completed
---

# TASK ARCHIVE: Fix Garden "Planted" Date Computation

## SUMMARY

Digital garden pages showed the current build time for "planted" (creation) date instead of the file’s first git commit date. The fix was a one-line guard change in `CollectionDatesGenerator`: treat a `date` value equal to `site.time` as unset, matching Jekyll’s own lazy-date behavior when other generators call `Document#date` before this plugin runs (`priority :low`).

Merged as `7714b84` (“fix(garden): planted date was current time…”, PR #82).

## REQUIREMENTS

- Planted date reflects git first-commit date when available.
- Preserve fallback to filesystem ctime when git history is missing.
- Targeted change only (no scope creep).
- Blog posts and other collections must not regress.

## IMPLEMENTATION

- **`_plugins/collection_dates.rb`** — Replaced the guard  
  `unless doc.data.key?("date")`  
  with  
  `unless doc.data.key?("date") && doc.data["date"].to_i != site.time.to_i`  
  so that a date lazily filled with `site.time` is still overwritten with the git-derived creation date. Comment documents interaction with `Document#date` / `modify_date`.

**Root cause:** Jekyll’s `Document#date` assigns `data["date"] = site.time` when accessed. Plugins such as `jekyll-auto-authors`, `jekyll-paginate-v2`, and `jekyll-archives` call `doc.date` during their generate phase before `collection_dates.rb` runs, so `doc.data.key?("date")` was always true and the git lookup was skipped.

## TESTING

- **`/niko-qa`:** PASS (recorded in `memory-bank/active/.qa-validation-status`).
- Manual / build validation per progress notes: garden pages show correct planted dates; blog posts unaffected.

## LESSONS LEARNED

- **Lazy `Document#date` is order-sensitive.** Any code that touches `doc.date` before a custom generator runs can populate `data["date"]` with build time and defeat “only if not set” guards that only check key presence.
- **Align guards with Jekyll’s semantics.** Using the same “date equal to `site.time` means not really set” heuristic as `Document#modify_date` keeps behavior consistent with core Jekyll.

## PROCESS IMPROVEMENTS

- For Jekyll plugins that derive dates from git, document generate order and interactions with third-party generators in the plugin header (partially done via the new comment).

## TECHNICAL IMPROVEMENTS

- None required beyond the guard fix. A higher-priority generator could be considered, but it would risk fighting other plugins; the heuristic approach is minimal and localized.

## NEXT STEPS

- None.

---

## Ephemeral sources (inlined before delete of `memory-bank/active/`)

### From `tasks.md`

- **What broke:** Garden "Planted" date showed today's build date instead of git first-commit date.
- **Why:** Other generators called `doc.date` before `collection_dates.rb`, so `doc.data.key?("date")` was always true and git lookup was skipped.
- **Fix:** Guard compares stored date to `site.time` so build-time placeholders are replaced.

### From `projectbrief.md`

Problem: garden planted date showed build date. Hypothesis: something populated `date` before `collection_dates.rb`. Requirements: git-based planted date, ctime fallback, targeted fix.

### From `activeContext.md`

- Phase: BUILD — COMPLETE; next was QA (now done for archive).

### From `progress.md`

- **Complexity:** Level 1  
- Phases: Complexity analysis → Build complete → QA PASS.
