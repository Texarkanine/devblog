---
task_id: writing-collection
date: 2026-11-12
complexity_level: 3
---

# Reflection: Folder category pages

## Summary

A writing piece is now a child of its folder. `/writing/poetry/` is the poetry page, and `/writing/poetry/sonnets/` is the nested folder's page. The flat `/writing/categories/<name>/` pages are gone. `/writing/categories/` still lists every category. QA passed. The suite is 55 tests, and a site build published the three seeds on those folder pages.

The 2026-11-11 reflection for the original writing collection is kept beside this one.

## Requirements vs Outcome

The rework asked for five things, and the build has all five. The folder path is the category page. A nested folder is the same kind of page. The flat per-name pages are gone. `/writing/categories/` remains the list, and its links point at the folder pages. The piece's `..` link is that parent folder. A top-level folder must not be named `tags` or `categories`. No redirect was added. The flat URL had not shipped.

Piece URLs stayed `/writing/<folder>/<slug>`. `categories` stayed the folder segments so a nested piece does not land at `/writing/poetry/poetry/sonnets/<slug>`. `writing_paths` is the cumulative paths the pages, the links, and the scopes read. That split was in the replanned plan. It is not an extra product feature.

The preflight advisory for a path-to-documents hash and for subfolder links on the category page was not built. The plan did not include it, and QA recorded the duplicated grouping as a non-blocking advisory.

Acceptance criterion 1 in the brief still names the old archive URL. The rework section is the requirement this build followed. That earlier sentence was left in place.

## Plan Accuracy

The four executable units ran in order: folder pages, piece links, category index, scopes, then the plugin note. Each red run failed on the old URL or the missing page, and the following green run made that unit's tests pass. The writing collection file stayed green at each unit boundary.

The challenges named in the plan showed up as specified. Slugify turns a slash into a hyphen, so the folder page is a generated page rather than a `:name` permalink. Putting the cumulative paths into `categories` would double a segment in the piece URL. The nested piece test guards that URL. An HTML index does not get an `index.md` sidecar, so the opt-out is `llms: false`, asserted on the root pages list.

One expectation was early. The folderless `..` link already pointed at `/writing/` before the layout change, because the special-case back href ran only when the piece had categories. The new test passed on the first run. The layout change left it green.

## Creative Phase Review

There was no creative phase. The operator had already chosen the URLs. Those URLs held through the preflight replan, the build, and QA.

## Build & QA Observations

The hook, the generator, the layout, the category index, and the scope builder each went red then green without a change of approach. A fresh site build then showed the three seeds on `/writing/poetry/`, `/writing/songs/`, and `/writing/stories/`, the category index linking those pages, and no flat archive. In the browser, Porch Light's parent link returned to the poetry page, the category index opened the songs page, and `/writing/categories/poetry/` was a 404.

The running `jekyll serve` kept serving the old archives. It had started before the new plugin existed, and it does not load a plugin added later. The fresh build was the one that matched the code.

QA passed and re-ran the suite: 55 tests, OK. It did not find a product defect. It noted the duplicated grouping, the unused archives layout key, and the unread `site.writing_categories` hash. The plan had directed the last two, and the build had already declined the shared hash.

## Cross-Phase Analysis

The first preflight of this rework failed because cumulative paths in `categories` double the piece URL. The replan split `categories` and `writing_paths`. The build followed that split, and the nested piece URL stayed `/writing/poetry/sonnets/small-room.html`. That catch would have been a wrong public URL, not a red test with an obvious local fix.

The second preflight passed and advised unifying the grouping. The build left the two loops separate. QA named the same duplication and did not treat it as a failure. The advisory did not become a defect, and taking it would have been scope the plan had not asked for.

No planning gap turned into a build failure. The red tests failed for the reasons the plan described.

## Insights

### Technical

- `Jekyll::Utils.slugify` in the default mode replaces a slash with a hyphen. A nested folder permalink has to be the raw path on a generated page.
- `Jekyll::Drops::UrlDrop#categories` joins every category with `/`. The permalink placeholder and a cumulative display path cannot share one array.
- A running `jekyll serve` does not load a plugin added after it started. A new `jekyll build` does.

### Process

- The fixable preflight on the doubled path is what made the plan buildable. The later passing advisory did not need to become scope.
- Skipping the creative phase was the right call. The operator had already chosen the page URLs.
