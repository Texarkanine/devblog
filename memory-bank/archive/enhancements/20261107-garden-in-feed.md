---
task_id: garden-in-feed
complexity_level: 2
date: 2026-11-07
status: completed
---

# TASK ARCHIVE: Garden pages in the main feed

## SUMMARY

`/feed.xml` lists garden pages beside posts. A local plugin prepends `JekyllFeed::Generator#feed_template` and concatenates `site.garden` onto the posts feed. `jekyll-feed` still writes that file. Membership stays document `date` and the existing feed limit. Draft pull request: https://github.com/Texarkanine/devblog/pull/131

## REQUIREMENTS

- Subscribers of the existing feed receive a garden page when its planted date is among the newest entries.
- Patch from `_plugins` by prepending `feed_template`. Concatenate `site.garden` into the posts feed only.
- Leave the `jekyll-feed` gem and `/feed.xml` in place. Do not replace the feed with a source file that makes the generator skip it.
- Do not fail the build when a line in the gem template changes.
- Do not publish a new gem.

## IMPLEMENTATION

`_plugins/garden_in_feed.rb` requires `jekyll-feed` and prepends `GardenInMainFeed`. `feed_template` replaces `{% assign posts = site[page.collection] %}` with that assignment plus a concat of `site.garden` when the page is the posts feed and `site.garden` is present. A missing assignment leaves the gem template unchanged. Tag feeds and a garden collection feed keep their own lists.

`.github/workflows/pr-check.yaml` runs `python3 -m unittest discover -s tests` after `bundle install`. `_plugins/README.md` notes the behavior. `memory-bank/techContext.md` Testing Process names the garden feed fixture and the bundle it needs.

The fixture sets `BUNDLE_GEMFILE` to the repo Gemfile and `JEKYLL_NO_BUNDLER_REQUIRE=1`, and lists `plugins: [jekyll-feed]`. Without that env var, Jekyll loads every gem in the `jekyll_plugins` group.

## TESTING

`tests/test_garden_feed.py` builds a throwaway site and reads Atom links. With the plugin returning the gem template unchanged, four inclusion cases failed and four guard cases passed (8 tests, 4 failures). After the concat, 8 tests passed. `python3 -m unittest discover -s tests` then ran 20 tests, OK. `bundle exec jekyll build` exited 0. The built feed's newest ten included `cli-help-patterns`, `taxonomizing-ai-acceptance`, and `taxonomizing-price-shocks`.

QA passed. It noted that `include?` repeats what `String#sub` already does when the assignment line is absent. That check stays.

## LESSONS LEARNED

- A throwaway Jekyll source has no Gemfile. `BUNDLE_GEMFILE` also turns on `Bundler.require(:jekyll_plugins)` unless `JEKYLL_NO_BUNDLER_REQUIRE=1` is set.
- The signal that a gem bump dropped garden pages is a rendered feed missing a garden entry. A build failure keyed to the assignment line only watches source text, and the operator rejected it.
- `collection_dates.rb` (`:low`) still runs before `jekyll-feed` (`:lowest`), so garden `<published>` is the planted date and `<updated>` is `last_modified_at` with no extra wiring.

## PROCESS IMPROVEMENTS

Nothing notable. The plan's file list and red-then-green order held. Preflight named the fixture env gap before the first test run.

## TECHNICAL IMPROVEMENTS

A multi-collection feed would be a `jekyll-feed` setting. This repo does not own that gem. The prepend is the seam that shipped. A default author on garden entries, and a config list of extra collections, stayed out of scope. Garden entries with no `author` render an empty author name.

## NEXT STEPS

Draft pull request https://github.com/Texarkanine/devblog/pull/131 is open. Merge is the operator's call.
