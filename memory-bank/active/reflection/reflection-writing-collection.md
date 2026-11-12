---
task_id: writing-collection
date: 2026-11-12
complexity_level: 2
---

# Reflection: Piece URL and future dates

## Summary

A writing piece URL now keeps every folder segment, including a repeat. Front matter cannot add a folder or move the file. A future filename stays out of `site.writing` even when the file says `published: true`. QA passed. The suite is 60 tests.

The folder-pages reflection is kept beside this one.

## Requirements vs Outcome

The rework asked for three fixes, and the build has all three. `poetry/<slug>` and `poetry/poetry/<slug>` are different files. A `categories`, `writing_paths`, or `permalink` key in the file leaves the piece on the folder URL and the folder category. A future filename with `published: true` stays out of the collection, off the folder page, and out of the feed.

The last-segment label and the unencoded folder name stayed dismissed, as the operator asked.

## Plan Accuracy

The four units ran in order: the literal permalink, the front-matter reset, the future-date removal, then the plugin note. Each new test went red for the behavior it named, then green.

One red premise was early. After the literal permalink, `categories` and `permalink` in the file no longer moved the HTML file. The test had to aim at `writing_paths`, which still replaced the folder list, and at the merged category list. The plan had named that `writing_paths` replacement as a challenge. It had not made it the failing assertion.

The challenges that mattered showed up as specified. `:categories` still drops a repeat, so the piece URL is a literal permalink. Setting `published` false after admission leaves the document in the collection, so the hook deletes it. Nothing reads `document.url` before that permalink is set.

## Build & QA Observations

The hook, the helpers, and the three tests went red then green without a change of approach. The full suite stayed at 60 tests, OK, and a site build succeeded. QA passed and re-ran the suite. It did not find a product defect. It noted that `apply` repeats the writing-collection guard, and left that guard in place.

## Insights

### Technical

- `UrlDrop#categories` is a set, and `populate_categories` uniques the list. A repeated folder segment cannot be a `:categories` permalink.
- `post_init` runs before front matter is merged. `published: true` and a `writing_paths` array replace what that hook wrote. `:site, :post_read` is after the merge and before generators. Documents have no hook between the end of `read` and collection admission, so a future file that got back in has to be deleted there.

### Process

- A later unit's red case has to be checked against what the earlier unit already made true. The plan's second test would have passed on the first unit's permalink.

### Million-Dollar Question

The piece URL should have been the folder path from the start, not `:categories`. One pass after front matter merges can own the path, the category list, and the future-date removal. That is what `:site, :post_read` does. `post_init` remains because a future file with no `published` key is kept out at admission, and Jekyll has no document hook in the gap between `read` and that decision.
