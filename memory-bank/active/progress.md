# Progress

Turn on Dependabot for the Jekyll gems and the nginx-proxy image, pin the unpinned direct gems, pin the nginx image by digest, and enable Dependabot security updates.

**Complexity:** Level 2

## 2026-10-31 - COMPLEXITY-ANALYSIS - COMPLETE

* Work completed
    - Restated the supply-chain scope and got operator approval
    - Classified the task as Level 2
* Decisions made
    - Level 2: one contained enhancement (Dependabot config, Gemfile pins, an image digest, one repo setting). The approach was already chosen during intent clarification
* Insights
    - Readers hit nginx. Gems run at build and local serve, including CI
    - Dependabot alerts are already on. Dependabot security updates are off

## 2026-10-31 - PLAN - COMPLETE

* Work completed
    - Wrote the Level 2 plan in `memory-bank/active/tasks.md` for task `20261031-dependabot-gems-nginx`
* Decisions made
    - No new tests. File-text assertions on the Gemfile, Dependabot config, and Dockerfile would be change-detectors
    - Build order is Gemfile pins, then the nginx digest, then `dependabot.yml`, then the security-updates API call
    - Security updates stay enabled as a repo setting even though the first advisory pull requests will target `main` before this branch is merged
* Insights
    - `~> 4.1` allows the whole `4.x` line from `4.1` up. That matches the pins already in the Gemfile

## 2026-10-31 - PREFLIGHT - COMPLETE

* Work completed
    - Validated the plan against the Gemfile, lockfile, Dockerfile, workflows, REUSE config, and repo settings
    - `.preflight-status` first line: `FAIL (fixable)`
* Decisions made
    - Plan not edited (judge, do not fix)
* Insights
    - `bundle install` with the `~>` pins changes the lockfile `DEPENDENCIES` section (16 lines), so the "empty diff" check fails by design. CI runs in frozen mode, so the lockfile must be committed with the Gemfile

## 2026-10-31 - PLAN - COMPLETE

* Work completed
    - Re-planned after preflight `FAIL (fixable)`
    - Confirmed in a temp copy: `bundle _2.6.9_ lock` changes only `DEPENDENCIES`. The old lockfile with the new Gemfile exits 16 under `BUNDLE_FROZEN=true`. The updated lockfile exits 0
* Decisions made
    - Commit the `DEPENDENCIES` update with the Gemfile. Spec versions, platforms, and `BUNDLED WITH` must not change
    - Requirement 4 and acceptance criterion 2 in the brief now say that, instead of "lockfile unchanged"
* Insights
    - Frozen mode treats a newly constrained gem as deleted-and-readded. The lockfile has to name the constraint or CI will not install

## 2026-10-31 - BUILD - COMPLETE

* Work completed
    - Pinned 11 direct gems and committed the lockfile `DEPENDENCIES` change
    - Digest-pinned `nginx:1.29.3-alpine3.22` to its OCI image index
    - Added `.github/dependabot.yml`
    - Enabled Dependabot security updates (`enabled: true`)
    - `python3 -m unittest discover -s tests` (12 tests, OK), `reuse lint` (390/390), `bundle exec jekyll build` (exit 0)
* Decisions made
    - Security-update pull requests stay ungrouped. Version updates are the only group
    - Digest came from the registry HTTP API
* Insights
    - The index digest matches the one preflight recorded. The tag had not been rebuilt between the two lookups

## 2026-10-31 - PREFLIGHT - COMPLETE

* Work completed
    - Validated the revised plan against codebase reality: all 11 proposed `~>` constraints fit their locked versions, the 6 leave-alone pins match the Gemfile, both Ruby workflows run frozen mode, REUSE.toml's catch-all licenses the new `dependabot.yml`, `gh` auth works with security updates currently `enabled: false`, and `nginx:1.29.3-alpine3.22` resolves to a multi-arch OCI image index
    - `.preflight-status` first line: `PASS WITH ADVISORY`
* Decisions made
    - Plan not edited (judge, do not fix); no change-detector steps to strike and no TDD ordering to swap
* Insights
    - No docker/crane/skopeo in this environment; step 2's digest resolution works via the curl anonymous-token flow against registry-1.docker.io (probed during preflight)
    - Advisory recorded: adding `applies-to: security-updates` to the `ruby` group would batch the advisory PRs that fire when step 4 lands; left for the operator to weigh
