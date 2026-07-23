# Task: Block Chrome/142 botnet UA at nginx

* Task ID: block-chrome142-bot-ua
* Complexity: Level 2
* Type: simple enhancement

Add a targeted nginx map+deny for the observed botnet User-Agent fingerprint, and enrich the JSON access log with a few client headers for future bot/human diagnosis. Changes stay in `nginx-proxy/`.

## Test Plan (TDD)

### Behaviors to Verify

- [Block matching UA]: request with exact botnet User-Agent → HTTP 403, not proxied upstream
- [Allow other UAs]: request with any other UA (including other Chrome/142 variants) → not denied by the new rule
- [Health exempt]: `GET /health` with the blocked UA → still 200
- [Both server blocks]: blocked UA denied in each proxied location that currently checks `$block_spoofed_xff`
- [Log fields present]: access log JSON includes `http_sec_ch_ua`, `http_sec_fetch_site`, `http_accept_language`, `http_accept_encoding` (empty when absent)
- [No XFF regression]: spoofed `X-Forwarded-For` still blocked as before

### Test Infrastructure

- Framework: none — operator directed **manual eyeball only** (same as `nginx-xff-anchor`)
- Test location: n/a
- Conventions: `nginx -t` via container entrypoint; visual review of map/`if`/log_format diffs
- New test files: none

## Implementation Plan

Operator waived automated tests — each unit uses eyeball assertion → implement → re-eyeball (TDD ordering with manual verification).

1. Exact-UA block map
   - Eyeball first: assert map will use plain (non-`~`) key equal to the full botnet UA; `$block_stale_chrome` default `0`
   - Files: `nginx-proxy/nginx.conf.template`
   - Implement: `map $http_user_agent $block_stale_chrome { default 0; "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36" 1; }` next to `$block_spoofed_xff`
   - Re-eyeball: string is exact; no regex; map name consistent
2. Wire 403 deny into proxied locations
   - Eyeball first: three locations already have `if ($block_spoofed_xff)` (site-2 `.php`, site-2 `/`, default `/`); `/health` must stay exempt
   - Files: `nginx-proxy/proxy.conf.template`
   - Implement: add `if ($block_stale_chrome) { return 403; }` in each of those three locations only
   - Re-eyeball: 403 (not 400); health untouched; all three sites covered
3. Enrich JSON log format
   - Eyeball first: `log_format json_combined` ends before `app` field; new keys must be valid JSON and use nginx `$http_*` vars (not envsubst placeholders)
   - Files: `nginx-proxy/nginx.conf.template`
   - Implement: append `"http_sec_ch_ua":"$http_sec_ch_ua"`, `"http_sec_fetch_site":"$http_sec_fetch_site"`, `"http_accept_language":"$http_accept_language"`, `"http_accept_encoding":"$http_accept_encoding"`
   - Re-eyeball: commas/braces intact; `envsubst` still only substitutes `${APP_NAME}`
4. Final eyeball + config syntax
   - Review full diff against behaviors list; rely on entrypoint `nginx -t` at container start/deploy
5. Draft PR after REFLECT (process step, not build)

## Technology Validation

No new technology - validation not required

## Dependencies

- Existing Docker nginx-proxy image / DigitalOcean App Platform deploy path (`.github/workflows/docker-nginx-proxy.yaml`)
- OpenSearch ingest must tolerate new JSON fields (additive; unused fields are harmless)

## Challenges & Mitigations

- **False positives**: Mitigated — exact full UA string match (operator choice).
- **Deny status code**: `403` for UA rule (operator choice); XFF spoof stays `400`.
- **nginx `if` is evil**: Keep the same narrow `if (…) { return …; }` pattern already used for `$block_spoofed_xff`.
- **No automated tests**: Operator accepted eyeball-only verification.

## Preflight Findings

- PASS: conventions match existing `$block_spoofed_xff` map + location `if` pattern
- PASS: TDD ordering encoded per unit via eyeball-first (operator waived automated tests)
- PASS: all brief requirements mapped to concrete steps
- ADVISORY: OpenSearch index mapping may treat new log fields as dynamic — additive and safe; if ingest pipeline uses a strict schema, may need a follow-up outside this task
- ADVISORY (out of scope): a reusable UA denylist file would help if more bots appear; not changing plan (scope creep)

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Preflight
- [x] Build
- [x] QA
