# Task: Block Chrome/142 botnet UA at nginx

* Task ID: block-chrome142-bot-ua
* Complexity: Level 2
* Type: simple enhancement

Add a targeted nginx map+deny for the observed botnet User-Agent fingerprint, and enrich the JSON access log with a few client headers for future bot/human diagnosis. Changes stay in `nginx-proxy/`.

## Test Plan (TDD)

### Behaviors to Verify

- [Block matching UA]: request with User-Agent containing the chosen fingerprint → HTTP 403 (or chosen deny code), not proxied upstream
- [Allow other UAs]: request with a normal/current Chrome UA (or empty UA) → not denied by the new rule; proxied as today
- [Health exempt]: `GET /health` with the blocked UA → still 200 (match existing pattern: health locations have no block `if`)
- [Both server blocks]: blocked UA against default_server blog path and against site-2 (`.php`) locations → denied in each proxied location that currently checks `$block_spoofed_xff`
- [Log fields present]: access log JSON includes `http_sec_ch_ua`, `http_sec_fetch_site`, `http_accept_language`, `http_accept_encoding` keys (empty string when header absent)
- [No XFF regression]: spoofed `X-Forwarded-For` still blocked as before

### Test Infrastructure

- Framework: **none found** for `nginx-proxy` (or the repo generally)
- Test location: n/a
- Conventions: prior nginx work (`nginx-xff-anchor`) used manual validation + `nginx -t` via container entrypoint; no automated suite
- New test files: **blocked — need operator decision** (see Status / blocking questions)

## Implementation Plan

1. Add UA block map next to `$block_spoofed_xff`
   - Files: `nginx-proxy/nginx.conf.template`
   - Changes: `map $http_user_agent $block_stale_chrome { default 0; "~…fingerprint…" 1; }` (exact pattern TBD — see Challenges)
2. Wire deny into proxied locations (same places as `$block_spoofed_xff`)
   - Files: `nginx-proxy/proxy.conf.template`
   - Changes: in each location that already has `if ($block_spoofed_xff)`, add `if ($block_stale_chrome) { return 403; }` (or combine — prefer separate `if` mirroring existing style). Do **not** add to `/health`.
3. Enrich JSON log format
   - Files: `nginx-proxy/nginx.conf.template`
   - Changes: append `"http_sec_ch_ua":"$http_sec_ch_ua"`, `"http_sec_fetch_site":"$http_sec_fetch_site"`, `"http_accept_language":"$http_accept_language"`, `"http_accept_encoding":"$http_accept_encoding"` to `log_format json_combined`
4. Manual / agreed verification
   - Files: n/a (or new tests if operator chooses to add infra)
   - Changes: `nginx -t` via image entrypoint path; curl against local container for allow/deny cases
5. Draft PR after REFLECT (process step, not build)

## Technology Validation

No new technology - validation not required

## Dependencies

- Existing Docker nginx-proxy image / DigitalOcean App Platform deploy path (`.github/workflows/docker-nginx-proxy.yaml`)
- OpenSearch ingest must tolerate new JSON fields (additive; unused fields are harmless)

## Challenges & Mitigations

- **False positives if matching only `Chrome/142.0.0.0`**: By mid-2026 that version string may be real Chrome. Prefer matching the full observed UA (or Mac `10_15_7` + `Chrome/142.0.0.0`) rather than the version token alone. **Needs operator choice before build.**
- **Deny status code**: Existing XFF spoof block returns `400`; brief asked for `403`. Plan uses `403` for the UA rule unless operator prefers consistency with `400`.
- **nginx `if` is evil**: Keep the same narrow `if (…) { return …; }` pattern already used for `$block_spoofed_xff` — do not introduce rewrite-based complexity.
- **No automated tests**: Blocking question below.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD) — infrastructure gap flagged
- [x] Implementation plan complete
- [x] Technology validation complete
- [ ] Preflight — blocked pending operator answers
- [ ] Build
- [ ] QA
