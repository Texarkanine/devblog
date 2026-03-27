---
task_id: nuclear-pyramid-docx-offload
complexity_level: 2
date: 2025-03-27
status: completed
---

# TASK ARCHIVE: nuclear-pyramid-docx-offload

## SUMMARY

The Nuclear Pyramid archive’s 13MB book download (`From Gravitons to Galaxies.docx`) was offloaded from the site’s nginx → static-site path to a [GitHub Release](https://github.com/Texarkanine/nuclear-pyramid-archive/releases/tag/2026-03-27) asset. The `nuclear-pyramid-archive` build pipeline now rewrites both docx `href`s in `index.php` during `transform_html`, so deploys stay reproducible. **Repository:** `Texarkanine/nuclear-pyramid-archive` (branch `fix-docx-download` at archive time).

## REQUIREMENTS

- Host the docx on a GitHub Release and point published HTML at that URL.
- Rewrite only the two `href='From Gravitons to Galaxies.docx'` occurrences (targeted change).
- Implement the rewrite in `lib/transform.rb` so `rake transform` regenerates correct output (no manual edits to `docs/site/`).
- Keep `archive.org/` Wayback sources unchanged.
- Document the behavior in the archive repo README.

## IMPLEMENTATION

- **`lib/transform.rb`:** Added `DOCX_RELEASE_URL` (release tag `2026-03-27`, asset name `From.Gravitons.to.Galaxies.docx` with dots in the URL path) and `rewrite_docx_link`, which uses `gsub` with a backreference so single- and double-quoted `href` values stay consistent. Wired into `transform_html` after `rewrite_links`, before `inject_about_nav`.
- **`docs/site/index.php`:** Regenerated; both book links now use the GitHub download URL.
- **`docs/site/about.php`:** Regenerated alongside transform; included a pre-existing `src/about.php` anchor-text tweak (“Internet Archive snapshot” → “this snapshot”).
- **`README.md`:** Describes docx offloading and nginx bypass rationale.

**Design context (from prior creative exploration):** Option B (“offload docx only”) was chosen over build separation + DO path routes because ~97% of asset bytes were one file; Option A remains a valid upgrade if image traffic or archive size grows.

## TESTING

- Formal automated tests were planned then **skipped per operator direction**.
- **Verification:** `bundle exec rake transform` and inspection of `docs/site/index.php` for both rewritten hrefs; README and QA semantic review (KISS/DRY/YAGNI/completeness).
- **QA:** PASS; trivial cleanup: removed empty `test/` directory left after cancelled test setup.

## LESSONS LEARNED

- GitHub Release asset URLs may use a normalized filename (e.g. dots instead of spaces in the path); source HTML can still use the original spaced filename—the constant holds the real download URL.
- For a tiny, static-archive pipeline change, **transform output + grep** is proportionate validation; full Minitest bootstrap was overkill for three lines of logic (operator correctly cut scope).

## PROCESS IMPROVEMENTS

- For similar “single href rewrite” tasks, default to verifying via `rake transform` and diffing `docs/site/` before investing in new test harness.

## TECHNICAL IMPROVEMENTS

- **Optional later:** If more assets move off-site, replace `rewrite_docx_link` with a small map of local names → URLs instead of one-off methods (only if needed—YAGNI today).

## NEXT STEPS

None for this task. Deploy `nuclear-pyramid-archive` when ready so production matches committed `docs/site/`.

---

## Inlined reflection (ephemeral file removed)

**Requirements vs outcome:** All planned requirements delivered; release created by operator; code was transform + docs only.

**Plan accuracy:** File list and order were right. Surprises: release asset used dotted filename in URL; re-transform surfaced unrelated `about.php` overlay diff. Original plan over-specified tests; operator shortened.

**Build & QA:** Regex backreference handled both quote styles; QA only flagged empty `test/` debris.

**Million-dollar question:** A generic “external asset URL table” would be the foundational design for many offloaded files; for one large asset, the dedicated method is appropriate.
