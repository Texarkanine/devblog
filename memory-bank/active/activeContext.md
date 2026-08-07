# Active Context

**Current Task:** Skip singleton tag archives and links (posts + garden)
**Phase:** PLAN - COMPLETE
**What Was Done:** Level 2 plan written. Operator waived automated tests; validation is `jekyll build` + spot-checks. Approach: shared `NavigationalTags` helper (min 2 docs); monkey-patch `Jekyll::Archives::Archives#tags` for posts; filter in `garden_archives#build_archives`; same threshold for llms tag scopes; Liquid conditionals in post/garden layouts and both tag indexes. Do not mutate `site.tags` / `site.garden_tags`.
**Next Step:** Preflight validation (subagent).
