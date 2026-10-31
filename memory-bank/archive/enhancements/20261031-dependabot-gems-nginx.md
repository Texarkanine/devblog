---
task_id: 20261031-dependabot-gems-nginx
complexity_level: 2
date: 2026-10-31
status: completed
---

# TASK ARCHIVE: Dependabot for gems and nginx

## SUMMARY

Dependabot watches the Jekyll gems and the nginx-proxy image. Every direct gem has a `~>` constraint, `Gemfile.lock` records those constraints in `DEPENDENCIES` only, and `nginx:1.29.3-alpine3.22` is pinned to its multi-arch index digest. Dependabot security updates are enabled on the repository. QA passed. Draft pull request: https://github.com/Texarkanine/devblog/pull/127

## REQUIREMENTS

- Weekly bundler updates on `/`, `versioning-strategy: increase-if-necessary`, version bumps grouped into one pull request.
- Weekly docker updates on `/nginx-proxy`.
- Pin the previously unpinned direct gems at the locked minor. Leave the six existing pins as they were.
- Commit the lockfile with the Gemfile. Only `DEPENDENCIES` may change. Spec versions, platforms, and `BUNDLED WITH` stay put.
- Pin the current nginx tag by its manifest-list digest.
- Enable Dependabot security updates. Security-update pull requests stay ungrouped.

## IMPLEMENTATION

`Gemfile` gained eleven `~>` lines (`bigdecimal` `~> 4.1`, `logger` `~> 1.7`, and the same two-component form for the unpinned plugins). `bundle _2.6.9_ lock` rewrote only `DEPENDENCIES` in `Gemfile.lock`. `nginx-proxy/Dockerfile` uses `nginx:1.29.3-alpine3.22@sha256:b3c656d55d7ad751196f21b7fd2e8d4da9cb430e32f646adcf92441b72f82b14`, an OCI image index. `.github/dependabot.yml` is the weekly config. Security updates were turned on with the repository API (`enabled: true`). That setting is not in the diff, and it was live before the branch merged.

The first plan said to leave the lockfile unchanged. That would fail CI. `ruby/setup-ruby` with `bundler-cache: true` installs frozen, and a Gemfile constraint Bundler has not recorded exits 16. The brief was corrected before build. Resolutions did not change.

## TESTING

`BUNDLE_FROZEN=true bundle _2.6.9_ install --local` exited 0. The lockfile diff was `DEPENDENCIES` only. Docker Hub's content type for the tag was `application/vnd.oci.image.index.v1+json`, and the digest matched the Dockerfile. Ruby parsed `dependabot.yml`. The security-updates GET returned `enabled: true`. `python3 -m unittest discover -s tests` ran 12 tests, OK. `reuse lint` was 390/390. `bundle exec jekyll build` exited 0. QA re-ran the lockfile, digest, YAML, and API checks and passed.

## LESSONS LEARNED

A new `~>` constraint rewrites `Gemfile.lock` `DEPENDENCIES` even when every locked version still fits. Frozen CI requires that rewrite to be committed. For a Bundler pin, run `bundle lock` in a temp copy while planning. "The version fits the range" does not mean the lockfile stays byte-for-byte the same.

Grouping security updates into the ruby group was considered and left off. One grouped advisory can hold a fix behind another update.

## PROCESS IMPROVEMENTS

Run the lockfile command during planning when the plan claims a Gemfile edit will not change `Gemfile.lock`. The first preflight caught the empty-diff check by doing that. The re-plan was the fix.

## TECHNICAL IMPROVEMENTS

None. The end state is the design: pessimistic direct gems, one Dependabot config, a digest on the base image, and security updates enabled.

## NEXT STEPS

Review and merge https://github.com/Texarkanine/devblog/pull/127. Advisory pull requests may already target `main`, because security updates were enabled before this branch landed. The first docker pull request may propose a tag whose suffix is not `-alpine3.22`. Add an ignore rule if it does.
