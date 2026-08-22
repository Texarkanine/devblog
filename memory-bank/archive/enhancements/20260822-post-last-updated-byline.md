---
task_id: post-last-updated-byline
complexity_level: 2
date: 2026-08-22
status: completed
---

# TASK ARCHIVE: Post Last-Updated Byline

## SUMMARY

Blog posts show a right-aligned footer byline `last updated YYYY-MM-DD` when `page.last_modified` is a later calendar day than the publish date. Garden planted / last tended is unchanged. Header publish date is unchanged. The byline is plain text, not a GitHub history link.

## REQUIREMENTS

- Surface that a post was touched after publish (postscript, link fix, summary add) without implying a re-thesis.
- Reuse `CollectionDatesGenerator`'s `last_modified` (git last-commit; front-matter override honored).
- Hide the byline unless the update calendar day is after the publish calendar day.
- Placement: footer, after tags, right-aligned. (Operator previewed left and right, then dropped the left copy.)
- Do not change garden.
- No test suite; verify by `jekyll build` + HTML inspect.

## IMPLEMENTATION

Single file: `_layouts/post.html`. After the tags block, if `page.last_modified` is set and `updated_day > published_day` (both formatted `%Y-%m-%d`), render:

```liquid
<p style="text-align: right;">last updated {{ page.last_modified | date: site.theme_config.date_format | default: "%Y-%m-%d" }}</p>
```

Calendar-day compare is required: Jekyll post `date` is midnight of the filename day; git last-commit is later that afternoon. A timestamp compare would mark almost every post updated on publish day.

`_layouts/garden.html` and `_plugins/collection_dates.rb` were not touched. `last_modified_at` for `jekyll-seo-tag` / `jekyll-sitemap` was left out of scope (preflight advisory).

This build: 37 of 46 dated posts showed the byline; 9 same-day posts did not. Operator confirmed site-wide content edits (e.g. #68 page summaries) count as updates.

## TESTING

No automated suite (operator waived; same convention as prior L2 layout work).

- Inspect-red: later-day fixture (Mechanicus) had no footer byline.
- Inspect-green after build: Mechanicus shows one right-aligned `last updated 2026-08-22`; seven-weeks / elgato-alias / not-a-nitpick show none; garden still Planted / Last tended.
- Earlier-day, missing `last_modified`, and untagged pages have no live fixtures; those behaviors are the Liquid guards.
- `/niko-preflight` PASS WITH ADVISORY. `/niko-qa` PASS.

Do not site-wide search for `last updated`: `love-when-useful-things-get-cheaper` quotes that phrase in the body. Inspect the footer after `</article>`, not `default.html`'s site footer (post pages have two `<footer>` elements).

## LESSONS LEARNED

- Ask whether git last-commit “noise” is acceptable before inventing opt-in front matter. Here a summary add is an edit.
- Previewing both footer placements, then keeping one, was cheaper than picking in the plan.
- `last updated` is a date, not a door: a GitHub commits URL would be true (the date comes from git) but would send readers to author-facing commit messages. Operator declined.

## PROCESS IMPROVEMENTS

For quiet chrome with two plausible placements, ship a short bake-off in the layout rather than forcing a plan-time pick.

## TECHNICAL IMPROVEMENTS

If post and garden date meta were designed together, they would share one include with collection-specific labels, and posts would print the update once. Optional later (not required): set `last_modified_at` from the same Time so SEO/sitemap match the footer; pin `timezone` in `_config.yaml` so calendar-day compare is identical on WSL, CI, and App Platform.

## NEXT STEPS

None. GitHub history link considered and declined.
