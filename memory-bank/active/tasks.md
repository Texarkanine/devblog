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

1. Add exact-UA block map next to `$block_spoofed_xff`
   - Files: `nginx-proxy/nginx.conf.template`
   - Changes: `map $http_user_agent $block_stale_chrome { default 0; "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36" 1; }` (exact string match, not regex)
2. Wire 403 deny into proxied locations (same places as `$block_spoofed_xff`)
   - Files: `nginx-proxy/proxy.conf.template`
   - Changes: in each location that already has `if ($block_spoofed_xff)`, add `if ($block_stale_chrome) { return 403; }`. Do **not** add to `/health`.
3. Enrich JSON log format
   - Files: `nginx-proxy/nginx.conf.template`
   - Changes: append `"http_sec_ch_ua":"$http_sec_ch_ua"`, `"http_sec_fetch_site":"$http_sec_fetch_site"`, `"http_accept_language":"$http_accept_language"`, `"http_accept_encoding":"$http_accept_encoding"` to `log_format json_combined`
4. Eyeball verification
   - Files: n/a
   - Changes: review diff; rely on entrypoint `nginx -t` at deploy/start
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

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [ ] Preflight
- [ ] Build
- [ ] QA
