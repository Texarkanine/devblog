# Progress

Pin nginx-proxy to the patched mainline image `nginx:1.31.9-alpine3.24` by its index digest, then open a draft pull request.

**Complexity:** Level 1

## 2026-11-20 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Confirmed no in-flight task and classified this pin bump as Level 1
* Decisions made
    - Level 1: one component, target image already chosen (`nginx:1.31.9-alpine3.24`, digest-pinned)
* Insights
    - 1.29.3 sits in the vulnerable range for CVE-2026-123007 and CVE-2026-123633. This repo's listener does not enable HTTP/2. The pin still moves to the patched mainline build.

## 2026-11-20 - BUILD - COMPLETE

* Work completed
    - Test `tests/test_nginx_proxy_base_image.py` failed on `(1, 29, 3)`, then passed after the pin change
    - `nginx-proxy/Dockerfile` now uses `nginx:1.31.9-alpine3.24@sha256:fb4658584bd9a916ffb6f6e365f97c25cfdb2923801f551ea08356e695f14ff7`
    - Full unittest suite: 41 tests, OK
* Decisions made
    - Kept the pin on the official multi-arch index digest, content type `application/vnd.oci.image.index.v1+json`
    - The test checks the patched version floor (stable >= 1.30.7, mainline >= 1.31.9), an Alpine variant, and a sha256 pin. It does not freeze the Alpine point release.
* Insights
    - Docker Hub publishes 1.31.9 as `alpine3.24`, not `alpine3.22`
    - This machine has no Docker, so `nginx -t` against the new image was not run here
