# Current Task: Patch nginx-proxy to 1.31.9

**Complexity:** Level 1

## Fix

- What was wrong: `nginx-proxy/Dockerfile` pinned `nginx:1.29.3-alpine3.22`. nginx.org lists 1.29.3 inside the vulnerable range for CVE-2026-123007 and CVE-2026-123633 (through 1.31.8; fixed in 1.30.7 and 1.31.9).
- What changed: the `FROM` line is now `nginx:1.31.9-alpine3.24`, pinned to the OCI image index digest `sha256:fb4658584bd9a916ffb6f6e365f97c25cfdb2923801f551ea08356e695f14ff7`.
- Files: `nginx-proxy/Dockerfile`, `tests/test_nginx_proxy_base_image.py`.

## QA Results

- **PASS** (2026-11-20). Findings in `memory-bank/active/.qa-validation-status`.
- Digest independently re-verified against Docker Hub: `1.31.9-alpine3.24` → `sha256:fb465858…14ff7`, content type `application/vnd.oci.image.index.v1+json`. Acceptance criterion 1 satisfied.
- Full suite re-run: 41 tests, OK.
- Advisory: acceptance criterion 2 (draft PR) still outstanding; per the Level 1 workflow it is handled outside the Build/QA loop, at wrap-up.
