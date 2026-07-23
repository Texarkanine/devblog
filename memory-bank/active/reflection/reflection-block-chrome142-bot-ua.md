---
task_id: block-chrome142-bot-ua
date: 2026-07-23
complexity_level: 2
---

# Reflection: Block Chrome/142 botnet UA at nginx

## Summary

Added an exact User-Agent map deny (403) and four client-header fields to the nginx reverse proxy JSON logs. Delivered to plan after operator choices on match specificity, status code, and eyeball-only verification.

## Requirements vs Outcome

All brief requirements met: exact UA block at nginx, 403 on proxied locations, log enrichment, draft PR after reflect. Nothing descoped; no extras shipped.

## Plan Accuracy

Plan touchpoints and sequence were correct. Only surprise was no local Docker for `nginx -t` — mitigated by entrypoint validation on deploy. Blocking questions (tests, match specificity, status code) were the right pause; bare `Chrome/142` would have been a false-positive risk.

## Build & QA Observations

Build was a clean mechanical extension of `$block_spoofed_xff`. QA found nothing substantive.

## Insights

### Technical
- nginx `map` exact (non-`~`) keys are the right tool for full-UA fingerprint blocks; regex on version tokens is too coarse for real Chrome releases.

### Process
- Asking early about missing test infra avoided inventing a harness the operator did not want.

### Million-Dollar Question

A small UA denylist include (one map entry per fingerprint, shared deny `if`) would be the foundational shape if bot fingerprints were expected to accumulate — what we built is the first entry of that shape, inlined. Fine for a single offender.
