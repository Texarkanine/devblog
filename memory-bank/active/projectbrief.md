# Project Brief

## User Story

As a blog operator, I want to block a specific bot User-Agent at the nginx reverse proxy and enrich access logs with a few client headers, so that abusive traffic is rejected before it hits the static site and future bot diagnosis is easier.

## Use-Case(s)

### Use-Case 1

A request arrives with User-Agent containing `Chrome/142.0.0.0`. Nginx maps it to a block flag and returns 403 without proxying to the upstream static site.

### Use-Case 2

Legitimate (or other) traffic is logged with additional headers (`Sec-CH-UA`, `Sec-Fetch-Site`, `Accept-Language`, `Accept-Encoding`) in the JSON access log for OpenSearch analysis.

## Requirements

1. Add an nginx `map` that flags User-Agents matching `Chrome/142.0.0.0` (the observed botnet fingerprint).
2. Reject matching requests with HTTP 403 in the server/location path used by the reverse proxy.
3. Add the listed Client Hints / fetch / Accept headers to the existing JSON `log_format` so they appear in forwarded access logs.
4. Keep the change confined to the existing `nginx-proxy` (DigitalOcean App Platform reverse proxy in this repo).
5. After REFLECT, open a **draft** pull request.

## Constraints

1. Prefer a targeted UA rule for this bot — not a broad WAF rewrite.
2. Follow existing nginx map-block patterns in `nginx-proxy/nginx.conf.template` (e.g. `$block_spoofed_xff`).
3. Do not commit secrets or environment-specific identifying config.

## Acceptance Criteria

1. Requests with the specified Chrome/142 UA are denied with 403 at nginx.
2. Other User-Agents are unaffected by the new block rule.
3. JSON access logs include the four additional header fields (empty/absent when not sent).
4. Draft PR is opened after REFLECT.
