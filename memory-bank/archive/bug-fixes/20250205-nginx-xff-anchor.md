# Bug Fix Archive: nginx X-Forwarded-For map regex anchoring

## METADATA
- **Task ID:** nginx-xff-anchor
- **Complexity:** Level 1
- **Date completed:** 2025-02-05

## CONTEXT
This task first added the `$block_spoofed_xff` map block in `nginx.conf.template` to block spoofed IPs in `X-Forwarded-For` (matching `127.0.0.1`, `localhost`, and `::1`). After opening a PR, we received feedback that the patterns were unanchored and could match substrings. We then updated the three patterns to anchor to token boundaries.

## SUMMARY
The nginx proxy map that blocks spoofed IPs in `X-Forwarded-For` was introduced in this task; it initially used unanchored regexes. PR feedback pointed out that those patterns could match substrings (e.g. `127.0.0.10`, `mylocalhost`). The three map patterns were updated to anchor to token boundaries so only whole comma-separated entries match.

## REQUIREMENTS
- Anchor the three map patterns to token boundaries (start-of-string or comma+optional-space before; end-of-string or comma after).
- Preserve case-insensitive matching (`~*`) and map name `$block_spoofed_xff`.

## IMPLEMENTATION
1. **Added the block:** The `map $http_x_forwarded_for $block_spoofed_xff { ... }` block was added to `nginx-proxy/nginx.conf.template` with unanchored patterns for `127.0.0.1`, `localhost`, and `::1`.
2. **Anchored after PR feedback:** Each map entry was then changed from an unanchored pattern to `"~*(?:^|,\s*)<token>(?:,|$)"`:
- `127\.0\.0\.1` → `(?:^|,\s*)127\.0\.0\.1(?:,|$)`
- `localhost` → `(?:^|,\s*)localhost(?:,|$)`
- `::1` → `(?:^|,\s*)::1(?:,|$)`

## FILES CHANGED
- `nginx-proxy/nginx.conf.template`

## TESTING
User confirmed the change worked. Manual validation of config syntax and blocking behavior. No automated tests.

## LESSONS LEARNED
- Unanchored regexes in security-sensitive headers can allow bypass or false positives via substring matches.
- Token-boundary pattern `(?:^|,\s*)` … `(?:,|$)` is reusable for other comma-separated header checks in nginx maps.
