---
task_id: tag-descriptions
date: 2026-08-13
complexity_level: 2
---

# Reflection: tag-descriptions

## Summary

Six sparse blurbs, then operator edits: harness/context restored to `main`; `agentic-engineering` added as the umbrella; `ai` / `jekyll` / `mermaid` copy tightened by the operator.

## Requirements vs Outcome

Delivered as briefed, with one operator correction after reflect: harness/context copy is restored verbatim from `main`. `cursor` and `jekyll` disambiguate; `ai` got a this-site summary; the stub is gone. `bitcoin` landed as no. `mermaid` was the one addition the operator did not name; QA judged it earned.

**Correction:** "Keep harness-engineering and context-engineering" meant keep the existing blurbs, not restyle them from Horses. The rewrite was unwanted.

## Plan Accuracy

The plan's file list (one yaml file), sequence, and verification (`jekyll build` plus `_site` inspection) were exact. Drafting copy in the plan meant build did not invent. The `mermaid` advisory was predicted; it did not force a replan.

## Build & QA Observations

Build was mechanical. Preflight's SEO check was the only plan amendment and it held. QA found no violations and retained `mermaid`.

## Insights

### Technical
- Nothing notable. The 2026-03-19 tag-desc machinery (Liquid lookup + SEO hook) already did the job; Kramdown smartquotes and HTML-stripped meta text are known behavior.

### Process
- For content-only L2, lock both the yes-list and the no-list in the plan. That replaced a creative phase: preflight and QA could audit the sparsity bar instead of arguing it during build.

### Million-Dollar Question
- Same shape as if this had been assumed from the start: optional keys in `_data/tags.yaml`, render if present. The tags index still does not show blurbs; that was already noted as a future consumer in the 2026-03-19 archive and is still YAGNI.
