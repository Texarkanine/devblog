# Active Context

## Current Task: post-last-updated-byline
**Phase:** QA - COMPLETE (PASS)

## What Was Done
- Inspect-red: later-day fixture had no footer byline.
- Added dual `last updated` row in `_layouts/post.html` after tags (flex `space-between`, left and right).
- Inspect-green: Mechanicus shows both copies (`2026-08-22`); seven-weeks / elgato-alias / not-a-nitpick show none; header dates unchanged; garden still Planted / Last tended.
- Corpus this build: 37 of 46 dated posts show the dual byline; 9 do not (same calendar day).
- Missing/`last_modified` earlier-day / no-tags: no live fixtures; guards are the `{% if page.last_modified %}` wrap, `updated_day > published_day`, and byline sibling after the tags `{% endif %}`.
- QA PASS: layout matches the plan; 37/46 posts show the dual footer byline; garden unchanged. Advisories only (missing live fixtures, unset timezone, body-text needle collision).

## Files modified
- `/home/mobaxterm/git/devblog/_layouts/post.html`

## Next Step
- Reflect.
