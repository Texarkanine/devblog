# Active Context

## Current Task: Writing collection
**Phase:** BUILD - COMPLETE

## What Was Done
- The writing collection is built. Folders are categories, the filename is the publication date, a future filename stays unpublished, and the piece URL has no date
- Pieces join the main feed, use their own layout and archives, show up on author pages, and get their own LLM scopes. Post category scopes stay on `/categories/`
- `/writing/`, the tag index, the category index, and a home-page block are in place. All-posts and the garden do not list writing
- Three seeds, dated 2026-11-11: Porch Light, Kitchen Radio, and The Second Cup. `verse` and `night` are shared. `hearth` is used once
- Full suite: 52 tests, OK. A site build wrote the three piece URLs, their category archives, the `verse` and `night` archives, and left `hearth` without an archive
- The archive fixture copies `email_obfuscator.rb` so the author layout can parse. Throwaway builds stub `default.html` and copy the layouts they render. The writing tag index lists a repeated tag without the garden page's coin-flip sort

## Next Step
- QA review (`/niko-qa`)
