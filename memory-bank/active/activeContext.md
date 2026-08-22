# Active Context

## Current Task: last-updated-body-only
**Phase:** REFLECT COMPLETE (rework: last_modified_at wired)

## What Was Done
- Body-aware `last_modified` for posts and garden.
- Rework: same Time copied to `last_modified_at` on every collection doc, including same-day as publish/planted. `DocumentDrop` delegator so sitemap lastmod resolves. Footer hide unchanged.

## Next Step
- Run `/niko-archive` to archive and clear the memory bank.
