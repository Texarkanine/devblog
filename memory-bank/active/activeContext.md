# Active Context

## Current Task: Piece URL and future dates
**Phase:** BUILD - COMPLETE

## What Was Done
- Set a literal piece permalink from the ordered folder segments in `:site, :post_read`
- Reapplied `categories` and `writing_paths` after front matter merges
- Removed a future filename from `site.writing` when `future` is false, including `published: true`
- Full suite: 60 tests, OK. A site build into a temp destination succeeded
- Files modified:
  - `/home/mobaxterm/worktrees/Texarkanine/devblog/devblog-creative-writing/_plugins/writing_categories.rb`
  - `/home/mobaxterm/worktrees/Texarkanine/devblog/devblog-creative-writing/_plugins/README.md`
  - `/home/mobaxterm/worktrees/Texarkanine/devblog/devblog-creative-writing/tests/test_writing_collection.py`
  - `/home/mobaxterm/worktrees/Texarkanine/devblog/devblog-creative-writing/tests/test_garden_feed.py`

## Key Decisions
- `folder_segments`, `permalink_for`, `writing_paths_for`, and `future_filename?` are shared by `post_init` and `post_read`. That is the preflight advisory
- The piece URL is `data["permalink"]`. The collection template stays `:categories`

## Deviations
- The front-matter test also sets `writing_paths` and prints `doc.categories`. After the literal permalink, `categories` and `permalink` alone no longer moved the file. `writing_paths` still replaced the folder list, and the merged category list still contained `songs`
- The category listing is asserted as rendered HTML. The page layout wraps the line in a paragraph

## Next Step
- QA
