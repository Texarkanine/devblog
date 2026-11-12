# Active Context

## Current Task: Folder category pages
**Phase:** BUILD - IN-PROGRESS

## What Was Done
- Folder pages publish at `/writing/<path>/`. `categories` stays the folder segments. `writing_paths` holds the cumulative paths. Flat writing category archives are off. Generated pages set `llms: false`
- Writing collection tests: 28, OK

## Next Step
- Piece links: iterate `page.writing_paths`, and let the plain parent link land on the folder page
