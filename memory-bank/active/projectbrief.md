# Project Brief: Fix Garden "Planted" Date Computation

## Problem
Digital garden pages' "planted" (creation) date is showing today's build date instead of the file's original git commit date. This affects all garden pages.

## Root Cause Hypothesis
Something is populating `date` on collection documents before `collection_dates.rb` runs, causing its `unless doc.data.key?("date")` guard to always skip the git lookup.

## Requirements
- Fix the planted date to correctly reflect git first-commit date
- Preserve fall-back-to-ctime behavior for files without git history
- Targeted fix — no unnecessary scope expansion
