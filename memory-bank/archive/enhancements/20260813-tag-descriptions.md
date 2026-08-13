---
task_id: tag-descriptions
complexity_level: 2
date: 2026-08-13
status: completed
---

# TASK ARCHIVE: Tag Descriptions for High-Count Tags

## SUMMARY

Populated `_data/tags.yaml` with sparse disambiguation blurbs for high-count tags that can mean the wrong thing. Existing tag-archive machinery (2026-03-19) was unchanged. Final keys: `agentic-engineering`, `ai`, `context-engineering`, `cursor`, `harness-engineering`, `jekyll`, `mermaid`. `bitcoin` and the rest of the popularity tail stay empty.

## REQUIREMENTS

- Describe a tag only when a reasonably informed reader could take the label to mean something else (or, for the engineering cluster, to tell sibling tags apart).
- Write in this site's voice. Popularity does not earn a blurb.
- Keep the existing `harness-engineering` and `context-engineering` copy (the reason the file exists).
- Include `cursor` and `jekyll`. Consider `ai` and `bitcoin`.
- Remove the `ai: test tag plz ignore` stub.
- Content only: no new rendering.

## IMPLEMENTATION

Single file: `_data/tags.yaml`. Layouts and `_plugins/tag_descriptions_seo.rb` already look up `site.data.tags[page.title]`.

Operator corrections after the first draft:

- Restored `harness-engineering` and `context-engineering` verbatim from `main`. "Keep" meant keep the blurbs, not restyle them from Horses.
- Added `agentic-engineering` as the umbrella (directing agents at altitude; harness is the loop, context is what they can see).
- Tightened `ai`, `jekyll`, and `mermaid` copy in-file.

`bitcoin` omitted: not a name collision; the posts already argue the thesis.

## TESTING

No automated harness (same as prior tag work). `bundle exec jekyll build`, then inspected:

- Body blurb + description / OG / JSON-LD on described archives (`ai`, `cursor`, `jekyll`, `mermaid`, `harness-engineering`, `context-engineering`; garden `/garden/tags/ai/`).
- Negative controls (`ruby`, `bitcoin`, `claude-code`): empty between heading and list, site-default SEO description.
- Stub gone.

`/niko-preflight` PASS WITH ADVISORY (`mermaid` was the only non-operator-named stretch). `/niko-qa` PASS; retained `mermaid`.

## LESSONS LEARNED

- "Keep harness-engineering and context-engineering" means keep the copy. Restyling them from a related garden note was unwanted.
- For content-only L2, lock both the yes-list and the no-list in the plan so sparsity is auditable without a creative phase.

## PROCESS IMPROVEMENTS

Content-only L2: draft the actual blurbs in the plan (not just the keys). Build then does not invent, and the operator can reject a rewrite before archive.

## TECHNICAL IMPROVEMENTS

None. The 2026-03-19 lookup and SEO hook already did the job. Tags index still does not show blurbs; still YAGNI.

## NEXT STEPS

None.
