# Progress

Keep a writing piece on its folder URL when front matter names another extension, normalize the slug the way Jekyll's title placeholder does, and stop the build when that slug is `index`.

**Complexity:** Level 1

## 2026-11-11 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Confirmed no task was in flight
    - Operator approved the writing-collection restatement
    - Recorded the brief and classified the task
* Decisions made
    - Level 3. The work spans the collection, indexes, layout, feed, author pages, sidecars, and seeds. The approach is settled, and the garden already established a parallel collection, so this is not a Level 4 redesign
* Insights
    - Jekyll sets a collection document's date from a `YYYY-MM-DD` filename and strips that prefix from the slug. `:path` keeps the prefix
    - A folder inside a collection is not a category. Blog categories are the directories above `_posts`
    - A tag on only one document does not get an archive page, so the seeds need one shared tag

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Mapped the writing collection across config, a `post_init` category hook, the feed concat, archives, layouts, author pages, LLM scopes, the homepage, and three seeds
    - Wrote the ordered TDD plan and the throwaway-Jekyll test map
* Decisions made
    - No creative phase. The approved brief fixed the product choices
    - Set categories at `post_init`, before anything can memoize `document.url`
    - Show Published and Updated on every writing page, including when the days match
    - Seeds share `verse` and `night`. `hearth` stays a singleton so the missing archive is visible
* Insights
    - `Jekyll::URL` squeezes a double slash, so a piece with no folder still has a clean URL
    - Upstream `no-style-please` renders the posts menu and then `{{ content }}`, so the writing block belongs in `pages/index.md` rather than in the posts menu

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Checked the plan against Jekyll 4.4.1, jekyll-feed 0.18, jekyll-archives 2.3, jekyll-llm-sidecars 0.3, the existing plugins, layouts, tests, and `REUSE.toml`
    - Ran a throwaway build to test the LLM category scope behavior
    - First line of `.preflight-status`: `FAIL (blocking)`
* Decisions made
    - No in-phase plan edits: no misordered tests and no change-detector steps
* Insights
    - `include_categories: true` in `llm_sidecars` emits `/categories/<folder>/llms.txt` for writing folders, so writing leaks into the posts category namespace
    - Unit 5 index pages are Liquid with logic and need tests
    - Writing archive pages need `exclude_paths` entries, and `_writing/**` needs the CC-BY-SA-4.0 REUSE annotation

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Replanned after the blocking preflight
    - Moved the writing index pages into their own executable unit, with tests for the section home, the tag and category indexes, the home block, `/all-posts.html`, and the garden index
    - Specified `include_categories: false`, explicit post and writing category scope builders, writing archive `exclude_paths`, and the CC-BY-SA-4.0 override for `_writing/**`
    - Updated brief acceptance criterion 1 to the piece URL `/writing/<folder>/<slug>` and the category archive `/writing/categories/<folder>/`
* Decisions made
    - The piece URL stays `/writing/<folder>/<slug>`. No page is added at the folder path
    - Seeds use the same CC-BY-SA-4.0 override as posts and the garden
    - The gem's category scopes are turned off. This site registers post category scopes and writing category scopes separately
    - The author-page fixture is a hand-written page, and the author record has no email
    - A config-list refactor of the collection-named plugins stays out of this task
* Insights
    - `include_categories` publishes every census category at `jekyll-archives.permalinks.category`, which is `/categories/:name/`
    - `scopes_for_taxonomy` drops a one-document term, so category builders cannot use it unchanged
    - The upstream home layout renders the posts menu and then `{{ content }}`. The throwaway fixture has to stub that layout because it does not fetch the remote theme

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Re-checked the replanned plan against the codebase, `jekyll-llm-sidecars` 0.3.0, `jekyll-archives` 2.3, and Jekyll 4.4.1
    - Ran a throwaway build to test how Jekyll treats a future-dated collection document
    - First line of `.preflight-status`: `FAIL (fixable)`
* Decisions made
    - No in-phase plan edits: no misordered tests and no change-detector steps
* Insights
    - The fixture writes its own config, so the production `_config.yaml` changes (permalink, defaults, archives, `include_categories`, `exclude_paths`) have no test that pins them. Unit 4's red and green expectations are incoherent without that
    - Jekyll lists a future-dated collection document in `site.<collection>` with a URL but does not write it, so the plan's "not skipped" premise is wrong and dead links are possible
    - Minor: `README.md` license line, the unit 5 fixture copy list, and the `writing_tags` guard

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Replanned after the fixable preflight
    - Writing tests now build with the repository `_config.yaml` plus an overlay that only replaces `url` and `plugins`
    - A future filename date is left unpublished in the category hook, before the collection accepts the document
    - Folded in the README license line, the `page.html` and `back_link.html` fixture copies, the empty-tag guard, and the reserved folder-name note
* Decisions made
    - The overlay does not restate permalinks, defaults, archives, or `llm_sidecars`
    - The feed fixture keeps its own minimal config, because that behavior lives in the copied plugin
    - Future dates are filtered. Recording the dead link as a known limit was the other option, and the author workflow makes a future filename reachable
* Insights
    - Jekyll deep-merge keeps the earlier value when the later value is null, and it replaces arrays
    - `:documents, :post_init` runs before `read`, so the future check parses the filename. `data["date"]` does not exist yet
    - `Document#write?` already hides the future page. The dead link comes from the document staying in the collection

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Re-checked the twice-revised plan against Jekyll's `Document`, `Collection`, and `populate_title` source, the existing plugins, layouts, pages, and `tests/test_garden_feed.py`
    - First line of `.preflight-status`: `FAIL (fixable)`
* Decisions made
    - No in-phase plan edits: no misordered tests and no change-detector steps
* Insights
    - The `TAG_ARCHIVE_LAYOUTS` change and the writing tag description lookup are executable and have no test step
    - Minor: the unit 5 fixture's `pages/garden.md` needs `_garden/what-is-a-digital-garden.md`, the writing archive config needs `enabled` and `layouts`, and unit 1 needs a date-printing body and a stub layout

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Added a unit 3 case for the shared `verse` description: markdown in the archive body, plain text in `page.description`
    - Specified `enabled` and layouts on the writing archive block, category links as `/writing/categories/<slug>/` for every folder segment, and a date line in the unit 1 document body
    - Unit 5 writes its own `/garden/` page instead of copying `pages/garden.md`
    - Unit 6 adds `verse` and `night` to `_data/tags.yaml`
* Decisions made
    - The fixture default layout prints `page.description` so the SEO text is visible without the theme
    - `hearth` stays out of `_data/tags.yaml`
* Insights
    - `tag_descriptions_seo.rb` sets the plain description only when the layout name is in `TAG_ARCHIVE_LAYOUTS`. The body blurb is the layout's `markdownify`
    - `pages/garden.md` links a garden note that uses `linkcard`, so the omission test uses `garden_posts.html` directly

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Validated revised plan against codebase, Jekyll 4.4.1, jekyll-feed, jekyll-archives, and jekyll-llm-sidecars
    - Verified all prior preflight findings are resolved across units 1, 3, 5, and 6
    - First line of `.preflight-status`: `PASS WITH ADVISORY`
* Decisions made
    - Plan validated and approved for build; no blocking or fixable findings
* Insights
    - Test-driven structure across all 5 executable units cleanly isolates fixtures using repository `_config.yaml` with focused overlays

## 2026-11-11 - BUILD - COMPLETE

* Work completed
    - Added the writing collection: folder categories, filename publication dates, future filenames left unpublished, and dateless piece URLs
    - Joined writing to the posts feed, with its own layout, archives, author listings, LLM scopes, and section indexes
    - Seeded a poem, a song, and a story, and put `_writing/**` under the CC-BY-SA-4.0 override
    - Full suite: 52 tests, OK. A site build published the three seeds and kept `hearth` off the tag archives
* Decisions made
    - The archive fixture loads `email_obfuscator.rb` so Liquid can parse the author layout. The author record still has no email
    - Throwaway builds stub `default.html` and copy the layouts they render, because they do not fetch the remote theme
    - The writing tag index lists a tag used twice. It does not use the garden index's coin-flip sort
* Insights
    - Liquid parses `{% email %}` while it reads the author layout, even when that branch does not run
    - Archive HTML pages were already without `index.md` sidecars. The writing archive exclude globs are still in place
    - `jekyll-llm-sidecars` runs at priority `lowest`, after `garden_archives` has built `site.writing_tags` and `site.writing_categories`

## 2026-11-11 - QA - COMPLETE

* Work completed
    - Conducted comprehensive semantic review of the writing collection implementation against the plan, requirements, and acceptance criteria
    - Verified all 52 tests in the suite pass cleanly, covering unit, integration, regression, and sidecar behaviors
    - Checked KISS, DRY, YAGNI, Completeness, Regression, Integrity, and Documentation standards across all touched files
    - Evaluated absence of TODOs, debug artifacts, and unhandled edge cases
* Decisions made
    - QA status: PASS
* Insights
    - Clean separation of concerns between category path inference (`writing_categories.rb`) and scope generation (`20_llms_scope_builders.rb`) keeps individual plugins compact and maintainable
    - Reusing existing taxonomy filtering logic (`NavigationalTags.keep?`) ensures consistent thresholding behavior between HTML archives and LLM scopes

## 2026-11-11 - REFLECT - COMPLETE

* Work completed
    - Wrote `memory-bank/active/reflection/reflection-writing-collection.md`
    - Recorded the writing section in the product context, the folder-and-filename contract in system patterns, and the writing fixture in tech context
* Decisions made
    - No creative phase was needed, and that decision still holds
    - The email-tag fixture load and the archive exclude globs stay as built
* Insights
    - Liquid parses a tag inside a branch that does not run
    - A future-dated collection document stays listed until something unpublishes it before the collection accepts it
    - The gem's category LLM scopes always use the posts category permalink

## 2026-11-11 - REWORK - IN-PROGRESS

* Work completed
    - Initiated rework on writing-collection
    - Cleared the finished task list, active context, QA status, and preflight status
* Decisions made
    - Operator chose rework. The finished task stays unarchived
* Insights
    - The author page lists the three writing pieces under posts
    - The author LLM sidecar already puts those pieces in their own Writing section, and that shape is the one to keep
    - The author page should give writing its own dated section below posts

## 2026-11-11 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Classified the author-page rework
* Decisions made
    - Level 1. The posts list on the author page is the only wrong listing. The author LLM sidecar is already the shape to match, so this stays one component
* Insights
    - The original writing-collection work was Level 3. This rework does not reopen that scope

## 2026-11-11 - BUILD - COMPLETE

* Work completed
    - Stopped concatenating writing into the author posts list
    - Added a dated writing section below posts, shown only when that author has writing
    - Full suite: 52 tests, OK
* Decisions made
    - The section heading is `writing`, matching the existing `posts` heading
    - Each section sorts newest first on its own. A newer piece does not jump above the posts section
    - Authors with no writing do not get an empty writing heading
* Insights
    - A fixture dated after the build day never reaches the author page, because future writing filenames stay unpublished

## 2026-11-11 - QA - COMPLETE

* Work completed
    - Reviewed the author-page rework against the Fix statement and the brief's Rework section
    - Ran the author-page test (pass) and the full suite: 52 tests, OK
    - Wrote `memory-bank/active/.qa-validation-status` (PASS) and recorded findings in `tasks.md`
* Decisions made
    - QA status: PASS. One non-blocking advisory: the writing list item duplicates the posts list item, consistent with existing layout style
* Insights
    - Level 1 QA PASS is terminal: no reflect or archive phase follows

## 2026-11-11 - REWORK - IN-PROGRESS

* Work completed
    - Initiated another rework on writing-collection
    - Cleared the finished task list, active context, and QA status
* Decisions made
    - Operator chose rework. Each writing folder's own URL becomes that folder's category page
* Insights
    - A piece at `/writing/poetry/porch-light.html` is not a child of `/writing/categories/poetry/`
    - `/writing/poetry/` should be the poetry page, and `/writing/poetry/sonnets/` the nested folder's page
    - `/writing/categories/` stays the list of every category. The flat `/writing/categories/<name>/` pages go away
    - A folder must not be named `tags`
    - The piece parent link currently jumps to the flat category archive. The folder index replaces that jump

## 2026-11-11 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Classified the folder-category rework
* Decisions made
    - Level 3. The folder index changes the archive URL, the links on a piece, the category list, and the LLM scopes. The destination is settled, and the work still crosses those components
* Insights
    - A flat `/writing/:name/` permalink would publish a nested folder at `/writing/sonnets/` rather than `/writing/poetry/sonnets/`

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Mapped the folder page across the category hook, a new index generator, the piece links, the category list, and the LLM scopes
    - Wrote the ordered TDD plan
* Decisions made
    - No creative phase. The folder path is the page, and the archives permalink cannot represent a slash
    - Category values become cumulative folder paths. The visible label stays the last segment
    - Writing category archive pages turn off. `site.writing_categories` stays
    - No redirect from the flat URL. That URL has not shipped
* Insights
    - `Jekyll::Utils.slugify` in default mode replaces a slash with a hyphen
    - `build_taxonomy_hashes` still runs when a collection's category archives are disabled

## 2026-11-11 - PLAN - COMPLETE

* Work completed
    - Replanned after the fixable preflight
    - Kept `categories` as folder segments so `:categories` still builds `/writing/poetry/sonnets/<slug>`
    - Added `writing_paths` for the folder pages, the category index, and the scopes
    - Replaced the contradictory archive test instead of adding a second one
    - Opted the generated pages out with `llms: false` and assert that on root `/llms.txt`
* Decisions made
    - No exclude glob. An HTML index never gets an `index.md`, so that absence does not prove the opt-out
    - The sidecar and section fixtures both copy the folder-index plugin
* Insights
    - `Jekyll::Drops::UrlDrop#categories` joins every category with `/`
    - `JekyllLlmSidecars::Census#opted_out?` honors `data["llms"] == false` before exclude globs

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Validated the folder-category plan against Jekyll 4.4.1 (`UrlDrop#categories` and `URL`), `jekyll-archives` 2.3.0, `jekyll-llm-sidecars` 0.3.0 (`Census` and `Manifest`), plugins, layouts, and `tests/test_writing_collection.py`
    - Ran throwaway Jekyll builds to verify `:categories` URL expansion with cumulative paths and `jekyll-llm-sidecars` census behavior on generated folder pages
    - First line of `.preflight-status`: `FAIL (fixable)`
* Decisions made
    - No in-phase plan edits: TDD step order is valid and no change-detectors are scheduled
* Insights
    - `Jekyll::Drops::UrlDrop#categories` joins every element of `document.data["categories"]` with `/`, so storing cumulative paths `["poetry", "poetry/sonnets"]` in `categories` turns `/writing/:categories/:title:output_ext` into `/writing/poetry/poetry/sonnets/<slug>.html` unless the piece permalink is set from `folder`
    - `test_category_archive_exists_for_one_piece` still asserts `/writing/categories/songs/index.html` exists and must be replaced rather than kept alongside `test_folder_page_replaces_the_flat_category_archive`
    - `JekyllLlmSidecars::Manifest` never writes `.md` sidecars for `.html` pages; excluding generated folder index pages keeps them out of `## Pages` in root `/llms.txt`, and `_prepare_sidecars` must copy `writing_folder_indexes.rb` to exercise that path

## 2026-11-11 - PREFLIGHT - COMPLETE

* Work completed
    - Re-validated the updated folder-category plan against Jekyll 4.4.1, `jekyll-archives` 2.3.0, `jekyll-llm-sidecars` 0.3.0, plugins, layouts, pages, and `tests/test_writing_collection.py`
    - Confirmed all three prior fixable findings are resolved across units 1 through 4
    - First line of `.preflight-status`: `PASS WITH ADVISORY`
* Decisions made
    - No in-phase plan edits required: TDD step order is valid across all four executable units and no change-detectors are scheduled
* Insights
    - Iterating `page.writing_paths` in `_layouts/writing.html` gives both the cumulative `/writing/<path>/` href and the last-segment label cleanly while leaving `page.categories` intact for `:categories` permalink expansion

## 2026-11-12 - BUILD - COMPLETE

* Work completed
    - Published one writing category page per folder path, including nested folders
    - Pointed piece links, the category index, and the LLM scopes at those paths
    - Removed the flat `/writing/categories/<name>/` archive pages
    - Full suite: 55 tests, OK. A fresh site build published the three seeds on the folder pages
* Decisions made
    - `site.data.writing_folders` is a sorted list of path strings
    - Scope titles use the last segment. The path is not slugified
    - The archives category layout key stays. The enabled flag and the flat permalink are what changed
    - The preflight advisory for a path-to-documents hash and subfolder links was not built
* Insights
    - The plain parent link of a piece URL is already the folder page, so the layout does not need a special back href
    - `llms: false` on the generated HTML page keeps it out of the root pages list. The old `/writing/categories/**/*` glob does not cover `/writing/<folder>/`
    - A running `jekyll serve` does not load a plugin added after it started

## 2026-11-12 - QA - COMPLETE

* Work completed
    - Reviewed the build against the plan: folder pages, piece links, category index links, category scopes, and the plugin note
    - Re-ran the full suite: 55 tests, OK
    - Grepped for stale `/writing/categories/<name>/` references and debris; remaining references are the index page, its links, the llms exclude glob, and README prose, all per plan
    - Wrote `memory-bank/active/.qa-validation-status` (PASS) and recorded findings in `tasks.md`
* Decisions made
    - QA status: PASS
    - One non-blocking advisory: the group-by-`writing_paths` logic is duplicated between the folder-index generator (Documents) and the scope builder (llms Entries); the build consciously deferred the shared-hash advisory
    - Two non-blocking observations the plan directed: the `writing-cat-archive` archives layout key and the `site.writing_categories` hash have no remaining readers
* Insights
    - Keeping `categories` as bare segments and adding `writing_paths` for the cumulative paths kept every consumer (permalink, links, index, scopes) on a single unambiguous source
    - The plain parent-directory `..` computation in `back_link.html` made the piece layout simpler than the special case it replaced

## 2026-11-12 - REFLECT - COMPLETE

* Work completed
    - Wrote `memory-bank/active/reflection/reflection-writing-collection.md` for the folder-category rework
    - Kept the 2026-11-11 reflection at `reflection-writing-collection-20261111.md`
    - Checked product context, system patterns, and tech context. None of them changed
* Decisions made
    - No persistent-file edits. The folder URL belongs with the writing plugins, not in the system briefing
    - The brief's original acceptance criterion 1 still names the old archive URL. The rework section is the requirement that shipped
* Insights
    - `:categories` joins every segment, so it cannot also hold cumulative paths
    - A running `jekyll serve` does not load a plugin added after it started

## 2026-11-12 - REWORK - IN-PROGRESS

* Work completed
    - Initiated rework on writing-collection
    - Cleared the finished task list, active context, QA status, and preflight status
* Decisions made
    - Operator chose rework from the pull request 133 review
    - Fix the repeated-segment piece URL, folder categories that survive front matter, and future filenames that say `published: true`
    - Keep last-segment category labels. Leave folder names unencoded. A `#` in a folder name is not a case this section will have
* Insights
    - `:categories` is uniqued and lowercased, so a repeated folder segment collapses in the piece URL while `writing_paths` keeps it
    - `post_init` runs before front matter is merged, so folder categories and `published: false` lose to keys in the file
    - A future date still skips the HTML file. `published: true` puts the document back into `site.writing`, and the feed and folder index read that collection

## 2026-11-12 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Classified the pull request 133 rework
* Decisions made
    - Level 2. The three holes are in the writing piece URL and in collection membership. `:categories` cannot keep a repeated segment, so the permalink has to be set another way. Folder pages, labels, scopes, and the category index stay
* Insights
    - This is past a one-line fix, and it does not reopen the folder-page design

## 2026-11-12 - PLAN - COMPLETE

* Work completed
    - Planned the repeated-segment permalink, the front-matter reset, and the future-date removal from `site.writing`
    - Mapped the tests onto `tests/test_writing_collection.py` and `tests/test_garden_feed.py`
* Decisions made
    - Set `data["permalink"]` after front matter merges. `:categories` stays the collection template and is not the piece URL
    - Keep the `post_init` hook for future files that never enter the collection. `:site, :post_read` handles the `published: true` case by deleting the document
    - No creative phase. The three outcomes are fixed, and the dismissed label and encoding items stay dismissed
* Insights
    - `Document#permalink` already prefers `data["permalink"]` over the collection template
    - `:site, :post_read` runs before generators, so the folder index and the feed see the pruned collection

## 2026-11-12 - PREFLIGHT - COMPLETE

* Work completed
    - Validated the piece URL and future dates rework plan against Jekyll 4.4.1 (`Document`, `Collection`, `Publisher`, and `Renderer`), `WritingFolderIndexes`, `GardenInMainFeed`, `20_llms_scope_builders.rb`, and test suites
    - Verified TDD plan encoding across all three executable units and confirmed Unit 4 is prose/policy
    - First line of `.preflight-status`: `PASS WITH ADVISORY`
* Decisions made
    - Plan validated and approved for build; no blocking or fixable findings
    - In-phase plan edits were not required: no change-detectors and no out-of-order test steps
* Insights
    - Setting `document.data["permalink"]` in `:site, :post_read` preserves repeated folder segments while leaving `:categories` intact for Jekyll's collection permalink configuration
    - Calling `output_ext` before assigning `data["permalink"]` evaluates the converter extension without memoizing `@url`
    - Pruning future-dated documents from `collection.docs` during `:site, :post_read` updates `site.writing` before generators run, keeping them out of folder pages and the feed

## 2026-11-12 - BUILD - COMPLETE

* Work completed
    - Set the piece permalink from the ordered folder path after front matter merges
    - Put folder categories and `writing_paths` back after that merge
    - Removed a future filename from `site.writing` when the file says `published: true`
    - Full suite: 60 tests, OK. A site build into a temp destination succeeded
* Decisions made
    - Shared `folder_segments`, `permalink_for`, `writing_paths_for`, and `future_filename?` between the two hooks, as the preflight advisory asked
    - Left the collection template on `:categories`. The literal permalink is the piece URL
* Insights
    - A literal permalink already stopped a front-matter `permalink` and a `categories` list from moving the file. A front-matter `writing_paths` array still replaced the folder list until `post_read` set it again
    - The category listing page renders the word inside a paragraph, so the assertion reads the HTML

## 2026-11-12 - QA - COMPLETE

* Work completed
    - Reviewed the build against the plan: the literal permalink, the front-matter reset of `categories` and `writing_paths`, the future-filename removal from `site.writing`, and the plugin note
    - Re-ran the full suite: 60 tests, OK
    - Grepped the plugin for debris (TODOs, debug output, placeholders); clean
    - Wrote `memory-bank/active/.qa-validation-status` (PASS) and recorded findings in `tasks.md`
* Decisions made
    - QA status: PASS
    - One non-blocking note: the `collection&.label == "writing"` guard in `apply` duplicates the hook's collection selection, kept for symmetry with `post_init`
* Insights
    - The preflight advisory paid off: shared helpers left both hooks as thin dispatchers, and the two hooks cannot drift apart on folder identity
    - The front-matter test's recorded deviation is the correct coverage: the literal permalink alone would have left `writing_paths` and the merged category list untested

## 2026-11-12 - REFLECT - COMPLETE

* Work completed
    - Wrote `memory-bank/active/reflection/reflection-writing-collection.md` for the piece URL and future-date rework
    - Kept the folder-pages reflection at `reflection-writing-collection-folder-pages.md`
    - Checked product context, system patterns, and tech context. None of them changed
* Decisions made
    - No persistent-file edits. The literal permalink and the future-date removal belong with the writing plugin, which already records them
* Insights
    - `:categories` cannot keep a repeated segment. The piece URL has to be set after front matter merges
    - A later test has to target the behavior the earlier unit did not already make true

## 2026-11-12 - REWORK - INITIATED

* Work completed
    - Operator chose rework over archive for the second review on pull request 133
* Decisions made
    - Leave the writing-path scope builder. `writing_paths` is plugin data on writing documents, not post front matter. A file in `_posts` or `_writing` does not put that key on a post
    - A front-matter permalink must not change the published extension
    - The piece slug uses Jekyll title normalization (pretty slugify, case kept). No special cases for filenames this section will not have
    - A piece slug of `index` aborts the build
    - Drop or rewrite any writing-suite assertion that cannot fail when the behavior it names breaks
* Insights
    - The seeds and the post defaults never contain `writing_paths`. The plugin writes that key after it reads the folder

## 2026-11-12 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Classified the permalink, slug, and reserved-index rework
* Decisions made
    - Level 1. The changes are bug fixes in `writing_categories.rb` and the writing tests. The scope builder stays as it is. The approaches are fixed
* Insights
    - This is one component. It does not reopen folder pages, scopes, or collection membership

## 2026-11-12 - BUILD - COMPLETE

* Work completed
    - Dropped a front-matter permalink before `output_ext`
    - Set the piece slug with pretty, case-kept slugify
    - Stopped the build when that slug is `index`
    - Removed `test_writing_archive_pages_have_no_markdown_sidecar`
    - Full suite: 62 tests, OK
* Decisions made
    - Left `scopes_for_writing_paths` unchanged. A post reaches a writing scope only when its own front matter contains `writing_paths`, and no post should carry that key
    - Used Jekyll's `:title` normalization. No extra filename cases
* Insights
    - `output_ext` memoizes the permalink extension, so the front-matter permalink has to be gone before that call
    - A literal permalink is still scanned for `:word`. Pretty slugify removes the colon before that scan
    - HTML archive pages do not get `index.md` sidecars, so an assertion that the file is absent does not protect them







