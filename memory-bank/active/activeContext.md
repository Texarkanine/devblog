# Active Context

## Current Task: Garden pages in the main feed
**Phase:** BUILD - COMPLETE

## What Was Done
- `_plugins/garden_in_feed.rb` prepends `JekyllFeed::Generator#feed_template` and concatenates `site.garden` into the posts feed when that collection exists.
- `tests/test_garden_feed.py` covers the eight planned feed behaviors. The fixture sets `BUNDLE_GEMFILE` and `JEKYLL_NO_BUNDLER_REQUIRE=1`, and lists `plugins: [jekyll-feed]`.
- `.github/workflows/pr-check.yaml` runs unittest after `bundle install`.
- `_plugins/README.md` notes the posts-feed behavior.
- `python3 -m unittest discover -s tests`: 20 tests, OK. `bundle exec jekyll build` exited 0. The built `/feed.xml` includes garden pages among the newest ten (cli-help-patterns, taxonomizing-ai-acceptance, taxonomizing-price-shocks).

## Next Step
- QA.
