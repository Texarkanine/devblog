# Active Context

## Current Task: Writing collection
**Phase:** BUILD - IN-PROGRESS

## What Was Done
- Completed preflight validation of the revised plan
- Unit 1 is green. The `post_init` hook sets writing categories from folders under `_writing` and unpublishes a future filename date before `read`
- Folder, nested, and folderless URLs match the permalink. A future filename is absent from `site.writing`. Writing stays out of `site.posts`
- Unit 2 is green. The posts feed concatenates `site.garden` and `site.writing` only when each collection exists. Tag feeds and other collection feeds stay on their own lists
- Unit 3 is green. Writing pages show Published and Updated, link each folder to its category archive, and link a tag only when that writing tag is used at least twice. Author pages list writing pieces with posts, newest first
- The archive fixture copies `email_obfuscator.rb` so the author layout can parse. The author record still has no email, so the tag is not used
- Unit 4 is green. Writing documents have Markdown sidecars. Writing tag scopes drop a tag used once. Writing category scopes keep a category used once, at `/writing/categories/`. Post category scopes stay at `/categories/`. The gem's category scopes are off
- Unit 5 is green. `/writing/` lists pieces by date. The tag index keeps a tag used twice. The category index keeps a category used once. The home page lists writing under the posts menu. All-posts and the garden stay clear of writing
- Full suite: 52 tests, OK

## Next Step
- Unit 6: three seed pieces, the CC-BY-SA override, and the shared tag descriptions
