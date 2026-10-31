# Project Brief

## User Story

As the person who builds and publishes this blog, I want Dependabot watching the Ruby gems and the nginx-proxy image, so that known vulnerabilities show up as pull requests before they sit unpatched.

## Use-Case(s)

### Use-Case 1

A new gem release, including a security fix outside the current Gemfile range, arrives as a pull request against the lockfile. A release that still fits an existing `~>` range updates only `Gemfile.lock`. A release the range cannot accept also edits the Gemfile.

### Use-Case 2

A newer `nginx` tag with the `-alpine3.22` suffix, or a rebuild of the current tag, arrives as a pull request against `nginx-proxy/Dockerfile`. Merging that pull request on `main` can rebuild the image and redeploy the DigitalOcean app.

### Use-Case 3

GitHub opens advisory pull requests for known vulnerabilities. Dependabot alerts are already on. Dependabot security updates are off and need to be turned on.

## Requirements

1. Add `.github/dependabot.yml` with a weekly `bundler` entry on `/`, `versioning-strategy: increase-if-necessary`, and version bumps grouped into one pull request.
2. Add a weekly `docker` entry on `/nginx-proxy` in that same file.
3. Pin each currently unpinned direct gem to a `~>` constraint at the locked minor, in the same style as the pins already in the Gemfile: `bigdecimal` `~> 4.1`, `logger` `~> 1.7`, `jektex` `~> 0.2`, `jekyll-auto-authors` `~> 1.0`, `jekyll-feed` `~> 0.18`, `jekyll-loading-lazy` `~> 0.1`, `jekyll-paginate-v2` `~> 3.0`, `jekyll-redirect-from` `~> 0.17`, `jekyll-remote-theme` `~> 0.6`, `jekyll-seo-tag` `~> 2.9`, `jekyll-sitemap` `~> 1.4`. Leave gems that are already pinned unchanged.
4. Leave `Gemfile.lock` unchanged by the pin. Those ranges already allow the locked versions.
5. Pin `nginx:1.29.3-alpine3.22` in `nginx-proxy/Dockerfile` by its current digest, so Dependabot picks up rebuilds of that tag and still bumps the tag when a newer `-alpine3.22` tag exists.
6. Enable Dependabot security updates on the repository. That can open advisory pull requests immediately.

## Constraints

1. For `0.x` gems, `~> 0.18` still allows later `0.y` releases. That matches pins already in the Gemfile (`~> 0.3`, `~> 0.5`). Do not tighten those to patch-only.
2. `apk add gettext`, GitHub Actions, and pre-commit are out of scope.
3. Do not configure automerge.
4. Merging a Dockerfile change on `main` runs the proxy workflow and can redeploy DigitalOcean. Merging a lockfile change on `main` rebuilds and publishes the site.

## Acceptance Criteria

1. `.github/dependabot.yml` exists, with the bundler and docker entries described above.
2. Every direct gem in the Gemfile has a `~>` constraint. Already-pinned lines are unchanged. `Gemfile.lock` has no resolution change from the new pins.
3. `nginx-proxy/Dockerfile` pins `nginx:1.29.3-alpine3.22` by the digest that tag currently resolves to.
4. Dependabot security updates are enabled on the repository.
