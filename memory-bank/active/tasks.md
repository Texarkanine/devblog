# Tasks: Fix Garden Planted Date Computation

## What Broke
Garden pages' "Planted" date showed today's build date instead of the git first-commit date.

## Why
Jekyll's `Document#date` lazily assigns `data["date"] = site.time` when accessed. Other generators (e.g. `jekyll-auto-authors`, `jekyll-paginate-v2`, `jekyll-archives`) call `doc.date` during their generate phase, which runs before `collection_dates.rb` (priority `:low`). By the time our plugin ran, `doc.data.key?("date")` was always true, so the git lookup was always skipped.

## Fix
Changed the guard from `unless doc.data.key?("date")` to `unless doc.data.key?("date") && doc.data["date"].to_i != site.time.to_i`. This treats a date equal to `site.time` as "not explicitly set" — the same heuristic Jekyll itself uses in `Document#modify_date`.

## Files Changed
- `_plugins/collection_dates.rb` — guard condition on line 25
