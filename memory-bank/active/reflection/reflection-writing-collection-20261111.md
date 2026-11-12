---
task_id: writing-collection
date: 2026-11-11
complexity_level: 3
---

# Reflection: Writing collection

## Summary

A `writing` collection now sits beside posts and the garden: folder categories, filename publication dates, dateless piece URLs, its own indexes and LLM scopes, and three seeds. QA passed. The suite is 52 tests, and a site build published the seeds.

## Requirements vs Outcome

The brief's ten requirements and eight acceptance criteria are in the build. Nothing was dropped or reinterpreted. The piece URL stayed `/writing/<folder>/<slug>`, and the category archive stayed `/writing/categories/<folder>/`. The seeds are dated in the filename, authored by texarkanine, and share `verse` and `night`. `hearth` is used once and has no archive.

Two things were added inside the fixture, not in the product. The archive tests load `email_obfuscator.rb` so the author layout can be parsed. Throwaway builds stub `default.html` and copy the layouts they render, because they do not fetch the remote theme.

## Plan Accuracy

The seven-unit sequence held. Red runs failed where the plan said they would: missing folder URLs, a future filename still listed, writing absent from the feed, the shared `verse` description, and the writing LLM scopes landing in the wrong namespace.

Three plan expectations were off, and none of them changed the product:

- Liquid parses `{% email %}` while it reads the author layout, including a branch that does not run. "No email on the author record" did not mean the tag could stay unregistered.
- Writing archive pages did not get `index.md` sidecars before the new exclude globs. Their extension is HTML, and the sidecar writer skips non-Markdown. The globs were still added.
- Once the writing layout chained to `default`, every throwaway build that rendered a writing page needed the same default stub the plan had specified for the home page.

The challenges that were named in the plan showed up as designed: the URL is memoized if anything reads it too early, `scopes_for_taxonomy` drops a one-document term, and `include_categories` publishes every census category on the posts permalink.

## Creative Phase Review

There was no creative phase. The approved brief fixed the product choices, and those choices held through build and QA.

## Build & QA Observations

The folder hook, the feed concat, the layout dates, and the scope split went through red then green without a change of approach. The full suite stayed green at each unit boundary. A site build then confirmed the three seeds, the shared tag archives, the plain-text `hearth` tag, the feed, the author page, and the absence of the seeds from all-posts and the garden.

QA passed with no rework. It did not find a product defect the tests had missed.

## Cross-Phase Analysis

The four preflight rounds were the part that changed the build. They caught the future-dated document staying in the collection, the fixture restating production config so a bad permalink would stay green, and the missing test for the shared tag description. Those would have been wrong behavior or an untested flag, not a red test with an obvious fix.

The email-tag miss was the one assumption preflight did not catch, because the plan treated an unexecuted branch as an unloaded tag. It failed on the first archive build and stayed inside the fixture.

## Insights

### Technical

- Liquid parses every tag in a layout when that layout is rendered, including tags inside a branch that does not run.
- Jekyll leaves a future-dated collection document in the collection and only skips writing its page. Setting `published` false before `read` returns is what removes it from `site.writing`.
- `jekyll-llm-sidecars` category scopes use the posts category permalink for every category in the census. A second collection needs `include_categories: false` and its own builder, and that builder cannot use the tag threshold or a one-piece category loses its scope.

### Process

- The repeated preflight paid for itself. The build's surprises were fixture assumptions, and the product design did not move.
- Skipping the creative phase was the right call. The brief had already chosen the URLs, the date source, and the tag rules.
