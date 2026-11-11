# Active Context

## Current Task: Writing collection
**Phase:** BUILD - IN-PROGRESS

## What Was Done
- Completed preflight validation of the revised plan
- Unit 1 is green. The `post_init` hook sets writing categories from folders under `_writing` and unpublishes a future filename date before `read`
- Folder, nested, and folderless URLs match the permalink. A future filename is absent from `site.writing`. Writing stays out of `site.posts`
- Full suite: 25 tests, OK

## Next Step
- Unit 2: concatenate `site.writing` into the posts feed
