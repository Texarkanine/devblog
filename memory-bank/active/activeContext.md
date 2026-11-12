# Active Context

## Current Task: Folder category pages
**Phase:** BUILD - IN-PROGRESS

## What Was Done
- Folder pages publish at `/writing/<path>/`. `categories` stays the folder segments. `writing_paths` holds the cumulative paths. Flat writing category archives are off. Generated pages set `llms: false`
- Piece category links iterate `page.writing_paths`. The label is the last segment. The `..` link is the plain parent directory
- The category index lists `site.data.writing_folders` and links `/writing/<path>/`
- Writing category scopes group `writing_paths` and publish `/writing/<path>/llms.txt` without slugifying
- Writing collection tests: 30, OK

## Next Step
- Plugin note: record the folder-path category URL and the reserved top-level folder names
