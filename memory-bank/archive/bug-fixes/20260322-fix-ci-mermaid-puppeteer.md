---
task_id: fix-ci-mermaid-puppeteer
complexity_level: 1
date: 2026-03-22
status: completed
---

# TASK ARCHIVE: Fix CI Mermaid/Puppeteer Chrome Launch

## SUMMARY

CI deployment broke after switching from the GitHub Actions runner's system Chrome to Puppeteer's bundled Chromium for mermaid diagram rendering. The fix required two coordinated changes: (1) an AppArmor sysctl workaround in `deploy.yaml` to allow bundled Chromium to launch on Ubuntu 24.04, and (2) upgrading `jekyll-mermaid-prebuild` to 0.4.0, which adds `overflow_protection` and `text_centering` postprocessing to handle cross-environment text measurement differences. The gem version bump also required migrating config to the new `postprocessing:` key structure.

## REQUIREMENTS

- CI build must succeed with mermaid diagram rendering using Puppeteer's bundled Chromium (not the runner's system Chrome, which measures text 11-16% narrower)
- Mermaid diagrams must appear correctly on the live blog
- No regression in diagram rendering quality

## IMPLEMENTATION

- **`.github/workflows/deploy.yaml`**: Added `echo 0 | sudo tee /proc/sys/kernel/apparmor_restrict_unprivileged_userns` step to disable Ubuntu 24.04's AppArmor restriction on unprivileged user namespaces, which was preventing Puppeteer's bundled Chromium from creating its sandbox.
- **`Gemfile`**: Upgraded `jekyll-mermaid-prebuild` from `~> 0.3` to `~> 0.4` (0.4.0 adds default-on `overflow_protection` and `text_centering` postprocessing).
- **`_config.yaml`**: Migrated mermaid config to 0.4.0's `postprocessing:` key structure; added `edge_label_padding: 6`.

Prior commit `78927f9` (separate PR) had already removed `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD` and `PUPPETEER_EXECUTABLE_PATH` to switch to bundled Chromium.

## TESTING

- CI build on PR validated the fix (AppArmor sysctl + gem 0.4.0 + config migration)
- First iteration (apt-get install system libs) failed -- CI confirmed all packages were already installed, proving the diagnosis was wrong
- No automated tests for CI workflow YAML; the CI pipeline itself is the test

## LESSONS LEARNED

- **Ubuntu 24.04 AppArmor user namespace restriction** is a known CI-breaker for Puppeteer/Chromium (https://github.com/puppeteer/puppeteer/issues/13595). The runner's pre-installed system Chrome is unaffected; only bundled Chromium from Puppeteer needs the kernel feature.
- **"Missing system libraries" is a red herring on modern runners.** The `ubuntu-latest` image already ships all X11/GTK shared libraries. The gem's error message pattern-matches on "browser process" in stderr and assumes library issues, but the actual failure was sandbox-related.
- **Don't trust error messages at face value.** Should have checked `dpkg -l` or runner image docs before adding install steps. Would have saved one failed CI iteration.
- **Cross-repo dependencies:** The full solution spanned two repos. The CI workflow fix was necessary (Chrome launch) but not sufficient (rendering fidelity required gem 0.4.0's postprocessing).

## PROCESS IMPROVEMENTS

- For CI-only fixes with no local test path, consider reading the runner image's pre-installed software list before adding install steps.
- The gem's `MmdcWrapper#test_render` error detection could distinguish sandbox failures from library failures to provide more accurate guidance.

## TECHNICAL IMPROVEMENTS

- The gem could detect CI environments and optionally pass `--no-sandbox` to mmdc via a puppeteer config, but this crosses a security boundary -- the gem shouldn't assume it knows the deployment environment's posture.

## NEXT STEPS

- Merge the PR once CI is green.
- Consider improving the gem's error message to distinguish AppArmor/sandbox failures from missing library failures (separate gem issue).
