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
