# Active Context

## Current Task: Folder category pages
**Phase:** BUILD - IN-PROGRESS

## What Was Done
- Folder pages publish at `/writing/<path>/`. `categories` stays the folder segments. `writing_paths` holds the cumulative paths. Flat writing category archives are off. Generated pages set `llms: false`
- Piece category links iterate `page.writing_paths`. The label is the last segment. The `..` link is the plain parent directory
- The category index lists `site.data.writing_folders` and links `/writing/<path>/`
- Writing collection tests: 29, OK

## Next Step
- Category scopes: group `writing_paths` and publish `/writing/<path>/llms.txt`
