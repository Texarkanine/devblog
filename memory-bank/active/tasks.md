# Task: Dependabot for gems and nginx

* Task ID: 20261031-dependabot-gems-nginx
* Complexity: Level 2
* Type: simple enhancement

Weekly Dependabot coverage for the Jekyll gems and the nginx-proxy image. Pin the unpinned direct gems with `~>`, pin the current nginx tag by its manifest-list digest, and turn on Dependabot security updates. No README or techContext edit: neither file states a dependency-update policy, and this work does not make them wrong.

## Test Plan (TDD)

### Behaviors to Verify

No new executable behavior. The site's unittest suite covers the SVG metadata stripper. A test that asserts the text of `Gemfile`, `dependabot.yml`, or the Dockerfile goes red only when those files are edited on purpose. That is a change-detector. Do not add one.

Build checks, not committed tests:

- After the new `~>` lines, `bundle _2.6.9_ lock` changes `Gemfile.lock` only in `DEPENDENCIES` (the 11 new constraints). Spec versions, platforms, and `BUNDLED WITH` stay the same. `BUNDLE_FROZEN=true bundle _2.6.9_ install --local` then exits 0.
- The digest written into `nginx-proxy/Dockerfile` is the manifest-list digest for `nginx:1.29.3-alpine3.22`, and the tag in that line stays `1.29.3-alpine3.22`.
- `.github/dependabot.yml` parses, with a weekly bundler entry on `/` using `increase-if-necessary` and a version-update group, and a weekly docker entry on `/nginx-proxy`.
- `GET repos/Texarkanine/devblog/automated-security-fixes` returns `enabled: true` after the enable call.

### Test Infrastructure

- Framework: Python unittest, used by the SVG stripper only
- Test location: `tests/test_strip_svg_metadata.py`
- Conventions: one module, `python3 -m unittest discover -s tests`
- New test files: none

## Implementation Plan

### 1. Pin unpinned direct gems — config [x]

- Files: `Gemfile`, `Gemfile.lock`
- No tests: configuration the build runs. A test that asserts file text is a change-detector. `pr-check.yaml` uses `bundler-cache: true`, which runs frozen mode and already fails when the Gemfile and lockfile disagree.

1. Add `~>` constraints on the unpinned direct gems only, at the locked minor: `bigdecimal` `~> 4.1`, `logger` `~> 1.7`, `jektex` `~> 0.2`, `jekyll-auto-authors` `~> 1.0`, `jekyll-feed` `~> 0.18`, `jekyll-loading-lazy` `~> 0.1`, `jekyll-paginate-v2` `~> 3.0`, `jekyll-redirect-from` `~> 0.17`, `jekyll-remote-theme` `~> 0.6`, `jekyll-seo-tag` `~> 2.9`, `jekyll-sitemap` `~> 1.4`.
2. Leave `jekyll` `~> 4.3`, `jekyll-archives` `~> 2.2`, `jekyll-auto-thumbnails` `~> 2.0`, `jekyll-highlight-cards` `~> 3.0`, `jekyll-mermaid-prebuild` `~> 0.5`, and `jekyll-llm-sidecars` `~> 0.3` as they are.
3. Run `bundle _2.6.9_ lock`. Commit `Gemfile.lock` with the Gemfile. The diff must be only the `DEPENDENCIES` lines for those 11 gems. If a spec version, platform, or `BUNDLED WITH` line changes, restore the lockfile and fix the constraint. Do not run `bundle update`.
4. Run `BUNDLE_FROZEN=true bundle _2.6.9_ install --local` and require exit 0.

### 2. Pin the nginx tag by manifest-list digest — config [x]

- Files: `nginx-proxy/Dockerfile`
- No tests: configuration the image build runs. A test that asserts the digest string is a change-detector. Re-resolve the digest at build time and require an image index.

1. Resolve `nginx:1.29.3-alpine3.22` from Docker Hub. Request a manifest list (`application/vnd.docker.distribution.manifest.list.v2+json` or `application/vnd.oci.image.index.v1+json`). Record the `Docker-Content-Digest` of that index.
2. If the response is a single-platform manifest, stop. Do not pin a platform blob.
3. Change the `FROM` line to `nginx:1.29.3-alpine3.22@sha256:<that digest>`. Leave the rest of the Dockerfile as it is.

### 3. Add Dependabot config — config [x]

- Files: `.github/dependabot.yml`
- No tests: configuration GitHub runs. A test that asserts the file text is a change-detector. The build check is a Ruby YAML parse of the keys below.

1. Write `version: 2` with two updates. Bundler: `directory: "/"`, `schedule.interval: weekly`, `versioning-strategy: increase-if-necessary`, and a group named `ruby` with `patterns: ["*"]` and `applies-to: version-updates`. Docker: `directory: "/nginx-proxy"`, `schedule.interval: weekly`.
2. Parse the file with Ruby's YAML library and check those keys. Do not add a schema gem.

### 4. Enable Dependabot security updates — config [x]

- Files: none in the repo
- No tests: a GitHub repository setting. The build check is a GET that returns `enabled: true`.

1. `PUT repos/Texarkanine/devblog/automated-security-fixes` with `gh`.
2. `GET` the same path and require `enabled: true`.
3. Do this last. Advisory pull requests target `main`, which will not have this branch's Gemfile pins or `dependabot.yml` until merge. That is expected. Security updates already run without the config file.

## Technology Validation

No new technology - validation not required

## Dependencies

- Bundler 2.6.9, already recorded in `Gemfile.lock`
- Network access to Docker Hub for the nginx manifest list
- `gh` authenticated against `Texarkanine/devblog`, already used to read the security-updates setting

## Challenges & Mitigations

- Bundler rewrites `DEPENDENCIES` when a Gemfile constraint changes, even when every locked version still fits. Commit that lockfile change. Restoring the old lockfile makes `pr-check` fail: `bundler-cache: true` sets frozen mode, and a mismatched lock exits 16. If a spec version, platform, or `BUNDLED WITH` line also changes, stop and fix the constraint. Do not run `bundle update`.
- Docker Hub returns a single-platform manifest, or a digest for one architecture. Refuse it. The `FROM` digest has to be the multi-arch index, or a build on another architecture pulls the wrong blob.
- Enabling security updates opens advisory pull requests against `main` immediately, using today's Gemfile. Enable last, and do not try to retarget those pull requests onto this branch.
- `apk add gettext` stays unpinned. Dependabot's docker ecosystem does not bump that line. Out of scope, already decided.

## Pre-Mortem

- The no-test call gets rejected and someone adds a unittest that snapshots `Gemfile` or `dependabot.yml`. Those tests fail on the next intentional edit and stay green when Dependabot is broken. The plan keeps the change-detector rule in the Test Plan so that rejection has an answer. Do not add the snapshot test.
- `~> 0.1` is misread as "only 0.1.x" and a gem whose locked version is `0.1.1` is given a constraint Bundler will not accept, which then changes a resolution. The pin list uses the two-component form already in the Gemfile (`~> 4.1` means `>= 4.1` and `< 5.0`). Step 1 catches that: spec versions must stay put, and the frozen install must exit 0.
- The `DEPENDENCIES` diff gets treated as noise and the old lockfile is restored. Frozen CI then fails on the pull request. Step 1 commits the lockfile and proves frozen mode before the pull request exists.
- Security-update enable is dropped because it is not a file change, so the acceptance criterion fails while the diff looks done. Step 4 is a required build step, last, with a GET that must show `enabled: true`.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight
- [x] Build
- [ ] QA
