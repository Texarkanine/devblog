---
task_id: block-chrome142-bot-ua
complexity_level: 2
date: 2026-07-23
status: completed
---

# TASK ARCHIVE: Block Chrome/142 botnet UA at nginx

## SUMMARY

Blocked a fixed botnet User-Agent at the DigitalOcean nginx reverse proxy with an exact-string `map` (`$block_stale_chrome` → HTTP 403), and enriched JSON access logs with `Sec-CH-UA`, `Sec-Fetch-Site`, `Accept-Language`, and `Accept-Encoding` for future bot diagnosis. Draft PR: https://github.com/Texarkanine/devblog/pull/98

## REQUIREMENTS

- Exact match on the observed Mac Chrome/142.0.0.0 User-Agent (not a version-token regex)
- Return 403 on proxied locations; leave `/health` exempt
- Append four client header fields to `log_format json_combined`
- Stay in `nginx-proxy/`; follow existing `$block_spoofed_xff` map+`if` pattern
- Open a draft PR after REFLECT

## IMPLEMENTATION

1. Added `map $http_user_agent $block_stale_chrome` with a plain (non-`~`) key for the full UA string in `nginx-proxy/nginx.conf.template`
2. Appended the four `$http_*` fields to `log_format json_combined` in the same file
3. Added `if ($block_stale_chrome) { return 403; }` beside existing XFF checks in all three proxied locations in `nginx-proxy/proxy.conf.template`
4. Documented the nginx-proxy request-filter pattern in `memory-bank/systemPatterns.md`

## TESTING

No automated nginx-proxy suite (operator waived). Eyeball review of map/`if`/log_format diffs; `/niko-qa` semantic PASS. Local Docker unavailable for `nginx -t`; entrypoint still runs `nginx -t` on container start/deploy.

## LESSONS LEARNED

- Prefer nginx `map` exact keys for full-UA fingerprints; regex on `Chrome/142.0.0.0` alone risks false positives on real Chrome releases
- Asking early about missing test infra avoids inventing a harness the operator does not want

## PROCESS IMPROVEMENTS

Blocking questions mid-plan (tests, match specificity, status code) kept the build from shipping an over-broad UA rule.

## TECHNICAL IMPROVEMENTS

If more bot fingerprints accumulate, a small UA denylist (one map entry per fingerprint, shared deny `if`) would be the natural next shape. What shipped is that shape’s first entry, inlined.

## NEXT STEPS

- Merge/deploy PR #98 and confirm OpenSearch receives the new log fields (dynamic mapping should be fine; strict schemas may need a follow-up)
- None otherwise
