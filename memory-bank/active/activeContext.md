# Active Context

## Current Task: Writing collection
**Phase:** PREFLIGHT - COMPLETE (FAIL (fixable))

## What Was Done
- Replanned after the blocking preflight
- Split the index pages into an executable unit. The seeds, the REUSE annotation, and the plugin note stay prose
- Category LLM scopes use `include_categories: false` plus explicit builders for post categories and writing categories
- Writing archive paths are added to `exclude_paths`
- `_writing/**` gets the same CC-BY-SA-4.0 override as posts and the garden
- The piece URL stays `/writing/<folder>/<slug>`. Brief acceptance criterion 1 now says that, and the category archive is `/writing/categories/<folder>/`

## Next Step
- Re-plan with `/niko-plan`: pin how the test fixture gets the production `_config.yaml`, and correct the future-dated filename premise (see `.preflight-status`)
