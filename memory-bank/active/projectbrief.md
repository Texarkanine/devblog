# Project Brief

## User Story

As the operator of blog.cani.ne.jp, I want the nginx-proxy image pinned to nginx 1.31.9-alpine3.24 by its index digest so the proxy runs a build that includes the 18 Nov 2026 HTTP/2 fixes.

## Use-Case(s)

### Use-Case 1

Deploy the patched nginx image through the existing nginx-proxy Dockerfile and open a draft pull request.

## Requirements

1. Change `nginx-proxy/Dockerfile` from `nginx:1.29.3-alpine3.22` to `nginx:1.31.9-alpine3.24`, pinned by the image index digest.
2. Open a draft pull request for that change.

## Constraints

1. Stay on the official nginx library image and the mainline track.
2. Keep the existing digest-pin style.

## Acceptance Criteria

1. The Dockerfile `FROM` line is `nginx:1.31.9-alpine3.24@sha256:<index digest>` and that digest is the registry index digest for the tag.
2. A draft pull request is open.
