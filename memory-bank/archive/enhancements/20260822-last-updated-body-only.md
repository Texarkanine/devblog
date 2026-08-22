---
task_id: last-updated-body-only
complexity_level: 2
date: 2026-08-22
status: completed
---

# TASK ARCHIVE: Last-Updated Body-Only

## SUMMARY

`last_modified` is the last git commit that changed a document's markdown body (after YAML front matter), for posts and garden. The same Time is copied to `last_modified_at` so SEO and the sitemap match. Posts still hide the footer byline when the body day equals publish day. Garden still always shows Last tended. Layouts were not changed.

## REQUIREMENTS

- Advance last-updated / last-tended only when body copy changed, not on front-matter / tag / summary-only commits.
- Posts: last-updated is the exception (hide same calendar day as publish).
- Garden: Last tended always shown, including on plant day.
- Honor front-matter `last_modified` and `last_modified_at` overrides.
- Rework: emit `last_modified_at` on every post and garden page, including same-day as publish/planted.
- No test suite; verify by build + inspect.

## IMPLEMENTATION

Single plugin: `_plugins/collection_dates.rb`.

- `extract_markdown_body` — remainder after `\A---\s*\n.*?\n---\s*\n` /m, else the whole file. Exact string compare.
- `git_last_body_commit_date` — `git log --format="%H %ai"` newest-first, `git show` each revision, stop at the first older body that differs; that newer commit is last body change. Fallback: last commit, then `File.mtime`.
- `generate` sets `last_modified`, then copies it to `last_modified_at` unless already set.
- `DocumentDrop.data_delegators "last_modified_at"` so jekyll-sitemap's Liquid `doc.last_modified_at` resolves. jekyll-seo-tag already used `page["last_modified_at"]`.

`_layouts/post.html` and `_layouts/garden.html` unchanged.

Feasibility probe: 21/46 posts and 4/26 garden pages would move earlier. This build: 28/46 posts show the footer byline (was 37).

## TESTING

No automated suite (operator waived).

- Inspect-red: last-commit dates on named fixtures.
- Inspect-green after body walk: `you-cant-hide` byline gone; `stop-doing-agents` `2026-02-24`; Mechanicus still `2026-08-22`; seven-weeks / elgato still hidden; garden 1900s Last tended `2025-12-02`; stories still shows same-day Last tended.
- Rework inspect-green: sitemap `<lastmod>` and `article:modified_time` match body dates; seven-weeks SEO has a same-day modified time, footer still hidden.
- `/niko-preflight` PASS WITH ADVISORY. `/niko-qa` PASS.

Do not site-wide search for `last updated` (`love-when-useful-things-get-cheaper` quotes it). Inspect the post footer after `</article>`.

## LESSONS LEARNED

- Date source and display policy are different layers. One body-aware Time feeds two Liquid contracts and, after the rework, SEO/sitemap.
- Exact body-string compare after `---` fences is enough. Do not invent a "real edit" heuristic.
- Putting a key in `doc.data` is enough for jekyll-seo-tag and not enough for jekyll-sitemap (Liquid invoke_drop only sees DocumentDrop methods).
- Shipping last-commit dates first made the noise visible (37/46 bylines). The operator could then say what should count.

## PROCESS IMPROVEMENTS

Ask whether last-commit is too coarse before the first visible byline, or ship the coarse date and let the operator react. This task was the second path.

## TECHNICAL IMPROVEMENTS

The plan's YAML regex is stricter than Jekyll's (no `...` closer). Some old revisions compare as whole-file bodies; named dates still landed. Optional later: pin `timezone` in `_config.yaml` so calendar-day compare is identical on WSL, CI, and App Platform. Tag/author/archive pages were not dated.

## NEXT STEPS

None. Tag/author/archive lastmod left on their existing sitemap behavior.
