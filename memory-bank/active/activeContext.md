# Active Context

## Current Task
Tag Descriptions on Archive Pages (Rework: SEO metadata)

## Phase
PLAN — COMPLETE

## What Was Done
- Rework classified as Level 2 (single plugin file, self-contained)
- Plan: add a `_plugins/tag_descriptions_seo.rb` hook that sets `page.data['description']` from `site.data['tags']` for tag archive layouts before render, so `jekyll-seo-tag` picks it up

## Next Step
Preflight, then build.
