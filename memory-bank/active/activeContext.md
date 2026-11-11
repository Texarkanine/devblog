# Active Context

## Current Task: Writing collection
**Phase:** BUILD - IN-PROGRESS

## What Was Done
- Completed preflight validation of the revised plan
- Unit 1 is green. The `post_init` hook sets writing categories from folders under `_writing` and unpublishes a future filename date before `read`
- Folder, nested, and folderless URLs match the permalink. A future filename is absent from `site.writing`. Writing stays out of `site.posts`
- Unit 2 is green. The posts feed concatenates `site.garden` and `site.writing` only when each collection exists. Tag feeds and other collection feeds stay on their own lists
- Full suite: 30 tests, OK

## Next Step
- Unit 3: writing layout, archives, shared tag description, and author pages
