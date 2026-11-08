---
task_id: garden-in-feed
date: 2026-11-07
complexity_level: 2
---

# Reflection: Garden pages in the main feed

## Summary

`/feed.xml` now lists garden pages beside posts, ordered by the date `jekyll-feed` already sorts on. The fixture suite and a full site build both show that.

## Requirements vs Outcome

The local prepend, the posts feed only, the existing gem, and `/feed.xml` all landed. The build does not abort when the gem's assignment line is missing. A config key for arbitrary collections, and a default author on garden entries, stayed out. The draft pull request is the remaining acceptance item.

## Plan Accuracy

The file list and the red-then-green order held. The surprise was the fixture: `BUNDLE_GEMFILE` makes Jekyll require every gem in the `jekyll_plugins` group unless `JEKYLL_NO_BUNDLER_REQUIRE=1`. Preflight named that before the first test run. The four inclusion cases failed on the stub, and the four guard cases were already green.

## Build & QA Observations

The first template concat made all eight tests pass. The full site build put three current garden pages in the newest ten feed entries. QA passed. It noted that `include?` duplicates what `String#sub` already does when the line is absent. That stays.

## Insights

### Technical

- A throwaway Jekyll source has no Gemfile. Pointing `BUNDLE_GEMFILE` at the repo Gemfile also turns on `Bundler.require(:jekyll_plugins)` unless `JEKYLL_NO_BUNDLER_REQUIRE=1` is set.

### Process

- Nothing notable

### Million-Dollar Question

A feed that had always been one chronology would be a `jekyll-feed` setting for several collections in one file. We don't own that gem. The prepend on `feed_template` is the seam this repo has, and it is the change we shipped.
