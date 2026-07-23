# Active Context

## Current Task: block-chrome142-bot-ua
**Phase:** PLAN - IN-PROGRESS (blocked on operator input)

## What Was Done
- Intent approved; Level 2 classified
- Surveyed `nginx-proxy/`: map lives in `nginx.conf.template`; deny `if`s live in `proxy.conf.template` (same locations as `$block_spoofed_xff`); `/health` is exempt
- Drafted implementation + TDD behavior list
- Found **no** automated test infrastructure for nginx-proxy (prior art was manual + `nginx -t`)

## Decisions Needed From Operator
1. How to verify without inventing a new test stack (manual curl/`nginx -t` only, like `nginx-xff-anchor`, vs add a small test harness)?
2. Match **full** botnet UA string (safer) vs bare `Chrome/142.0.0.0` (Claude’s snippet; higher false-positive risk if 142 is real Chrome)?
3. Deny with **403** (brief) or **400** (match existing XFF block)?

## Next Step
- Await operator answers; then finish PLAN → preflight
