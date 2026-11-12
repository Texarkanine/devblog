# Active Context

## Current Task: Folder category pages
**Phase:** BUILD - IN-PROGRESS

## What Was Done
- Folder pages publish at `/writing/<path>/`. `categories` stays the folder segments. `writing_paths` holds the cumulative paths. Flat writing category archives are off. Generated pages set `llms: false`
- Piece category links iterate `page.writing_paths`. The label is the last segment. The `..` link is the plain parent directory
- Writing collection tests: 29, OK

## Next Step
- Category index links: list `site.data.writing_folders` at `/writing/<path>/`
