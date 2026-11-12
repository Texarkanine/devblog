# Active Context

## Current Task: Piece URL and future dates
**Phase:** PLAN - COMPLETE

## What Was Done
- Planned three executable units and a plugin-note update
- The piece URL becomes a literal permalink set from the folder path in `:site, :post_read`, because `:categories` drops a repeated segment
- That hook also puts the folder segments back into `categories` and `writing_paths`, and it removes a future filename from `site.writing` when the file says `published: true`

## Next Step
- Preflight
