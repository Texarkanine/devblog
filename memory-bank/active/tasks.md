# Task: tag-descriptions

* Task ID: tag-descriptions
* Complexity: Level 2
* Type: simple enhancement (content)

Sparse blurbs in `_data/tags.yaml` for the high-count tags that actually collide with another meaning, written in this site's voice. Machinery already exists (`memory-bank/archive/features/20260319-tag-descs.md`). Popularity does not earn a description.

**Yes (write or rewrite):** `cursor`, `jekyll`, `mermaid`, `harness-engineering`, `context-engineering`, `ai`.

**No (leave absent):** `bitcoin` (known; the posts argue the thesis), `claude-code` (product name), `ruby` / `rubygem` / `open-source` / `economics` / `tools` / `agentic-engineering` / `software-engineering` / `productivity` / `debugging`, and every garden-only bucket (`spaceship`, `thoughts`, `links`, `sci-fi`, `research`, `archive`). `agentic-engineering` is the umbrella; the file exists to split harness from context, not to glossary the whole cluster.

**Voice:** first person where it fits, no em-dashes (current yaml uses them; rewrite), no "it's not X, it's Y." Collision tags name the referent in one or two sentences. Engineering tags take their sense from `_garden/ai-horses.md` (harness = tack / saddle-makers; context = horsemanship once the saddle is on) and may link that note.

**Intended copy** (build may tighten wording, not the yes-list):

- `cursor`: Anysphere's AI code editor ([cursor.com](https://cursor.com)). The mouse and the SQL kind can sit this one out.
- `jekyll`: The static-site generator this blog runs on. Stevenson already wrote the other Jekyll.
- `mermaid`: [Mermaid](https://mermaid.js.org/) diagrams, baked into pages here at build time.
- `ai`: Language models and the coding agents around them, as I actually use the stuff: harnesses, context, cost, the work.
- `harness-engineering`: The tack: Cursor, Claude Code, the loops and tools you wrap a model in so it can do a job. Making saddles. ([Horses](/garden/ai-horses.html).)
- `context-engineering`: What you put in the window, and what you keep out: rules, skills, prompts. Horsemanship, once the saddle is on. ([Horses](/garden/ai-horses.html).)

Drop `ai: test tag plz ignore`. Keep the file's header comments. Keys must match front-matter tag strings exactly.

## Test Plan (TDD)

### Behaviors to Verify

- Described tag archive → body contains the yaml blurb (markdown rendered) between `<h1>` and the post list
- Undescribed navigational tag (e.g. `ruby`, `bitcoin`) → archive HTML unchanged: heading then list, no extra `<p>` from `markdownify`
- Empty/absent key → same as undescribed (existing Liquid `!= blank`)
- Garden archive for a described tag that has a garden page (`ai`) → same blurb as the blog archive
- SEO: described tag pages get `page.data['description']` from `_plugins/tag_descriptions_seo.rb` (already implemented; do not regress)

### Test Infrastructure

- Framework: none. `memory-bank/techContext.md` and the skip-singleton-tags archive both record that this repo has no automated test harness; prior tag work was `jekyll build` plus `_site` inspection.
- Test location: N/A
- Conventions: N/A
- New test files: none. This is user-facing prose in a data file (`always-tdd.mdc` out of scope). Do not add change-detector tests that assert on blurb wording.

Verification during build: `bundle exec jekyll build`, then inspect the archive HTML listed in Implementation Plan step 2.

## Implementation Plan

1. [x] Replace `_data/tags.yaml` entries with the yes-list copy above; delete the `ai` stub; preserve header comments; use `>-` for each single-paragraph value; no em-dashes.
   - Files: `_data/tags.yaml`
   - Tests first: `N/A for prose & policy artifacts`
   - Changes: six keys only (`ai`, `context-engineering`, `cursor`, `harness-engineering`, `jekyll`, `mermaid`), alphabetized or grouped as the file already groups (comments then keys). Match existing comment contract.

2. [x] Build and inspect archives.
   - Files: `_site/tags/{ai,cursor,jekyll,mermaid,harness-engineering,context-engineering}/index.html`, `_site/garden/tags/ai/index.html`, plus negative controls `_site/tags/{ruby,bitcoin,claude-code}/index.html`
   - Tests first: `N/A for prose & policy artifacts`
   - Changes: none to code. Confirm blurbs render, negatives have no blurb, `test tag plz ignore` is gone, described archives expose the plain-text blurb in description/OG/JSON-LD metadata, and a negative control retains the site-default SEO description.

## Technology Validation

No new technology - validation not required

## Dependencies

- Existing tag-archive Liquid: `_layouts/tag-archive.html`, `_layouts/garden-tag-archive.html` (`site.data.tags[page.title]`)
- Existing SEO hook: `_plugins/tag_descriptions_seo.rb`
- Voice source: `_garden/ai-horses.md`, `.cursor/rules/blogging.mdc`

## Challenges & Mitigations

- **Voice slips into encyclopedia:** copy is drafted above from the corpus; build may tighten, not expand. One or two sentences.
- **`mermaid` was not operator-named:** same name-collision class as `jekyll` (syntax vs fish). If QA/operator calls it a stretch, delete that key only.
- **`bitcoin` omitted:** operator floated a maybe; the disambiguation bar says no. Override is adding one key, not replanning.
- **Em-dashes in current yaml:** rewrite both engineering blurbs; do not keep the generic encyclopedia sentences.
- **YAML key mismatch:** keys are exact front-matter slugs from the tag indexes (`cursor` not `Cursor`).

## Pre-Mortem

- **Filled the popularity list anyway:** already covered by the locked yes-list; preflight should FAIL if extra keys appear in the plan.
- **Blurbs too cute to disambiguate:** each collision blurb must still name the referent (editor, SSG, mermaid.js). If a joke swallows the meaning, rewrite in build.
- **Horses links 404 for readers who only hit `/tags/`:** links are site-relative to an existing garden note; if that feels inside-baseball, keep the sentence and drop the link, don't drop the blurb.

## Preflight Report

- **PASS - Prerequisites:** Level 2 planning is complete. No creative phase was required or flagged.
- **PASS - TDD encoding:** The only production edit is user-facing prose in `_data/tags.yaml`, which is outside `always-tdd.mdc`; the plan explicitly schedules no change-detector tests.
- **PASS - Conventions:** The one-file plan preserves the data file's header contract, uses exact front-matter tag slugs, uses `>-` block scalars, and relies on the existing global blog/garden lookup.
- **PASS - Dependencies:** Both archive layouts and the SEO hook are accounted for. Preflight amended build inspection to verify description, Open Graph, and JSON-LD output plus the undescribed default.
- **PASS - Conflicts:** Existing rendering and SEO machinery already provide everything required; the plan adds no duplicate implementation and changes no public interface.
- **PASS - Completeness:** The six-key yes-list, explicit no-list, stub removal, blog/garden checks, negative controls, and SEO checks map to every requirement and acceptance criterion.
- **ADVISORY - `mermaid`:** This is the only non-operator-named stretch. Retain it for build because it meets the same collision test as `jekyll` and appears on three posts; QA may remove that key alone if the blurb does not earn its place.
- **Radical innovation:** No new machinery is justified. The strongest structural improvement is the explicit positive/negative decision ledger already present in this plan; it makes the sparse editorial rule auditable without turning prose into a tested contract.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight - PASS WITH ADVISORY
- [x] Build
- [x] QA
