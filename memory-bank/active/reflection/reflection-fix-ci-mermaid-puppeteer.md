---
task_id: fix-ci-mermaid-puppeteer
date: 2026-03-22
complexity_level: 1
---

# Reflection: Fix CI Mermaid/Puppeteer Chrome Launch

## Summary

CI was broken after switching from system Chrome to Puppeteer's bundled Chromium. The fix required an AppArmor sysctl workaround in the CI workflow AND upgrading jekyll-mermaid-prebuild to 0.4.0 (which added overflow protection for cross-environment text measurement differences). Both changes were necessary.

## Requirements vs Outcome

The original brief framed this as "install missing system dependencies." The actual requirements were broader: (1) allow bundled Chromium to launch (AppArmor sandbox), and (2) handle cross-environment rendering differences (gem 0.4.0 postprocessing). The first was my fix; the second was a parallel fix in the gem that the user identified and applied. The acceptance criteria (CI builds, diagrams render on live blog) are now met.

## Plan Accuracy

The initial diagnosis (missing system libraries) was wrong -- CI proved every library was already installed. The corrected diagnosis (AppArmor user namespace restriction) was right but incomplete: it solved the "Chrome can't launch" problem but didn't account for the "Chrome renders differently" problem that motivated the bundled-Chromium switch in the first place. That was addressed by the gem's new `overflow_protection` and `text_centering` features in 0.4.0.

## Build & QA Observations

Build iteration 1 (apt-get) wasted a CI round-trip on a misdiagnosis. The error message from the gem ("missing system libraries") was misleading -- it pattern-matches on "browser process" in stderr and assumes system libraries, but the actual Puppeteer failure was sandbox-related. Build iteration 2 (AppArmor sysctl) was correct for the launch problem. The user then identified the remaining piece (gem 0.4.0 + config migration).

## Insights

### Technical
- **Ubuntu 24.04's AppArmor restriction on unprivileged user namespaces** is a known CI-breaker for Puppeteer/Chromium. The runner's pre-installed Chrome is unaffected because it has its own sandbox setup. Bundled Chromium from Puppeteer needs the kernel feature. This is documented at https://github.com/puppeteer/puppeteer/issues/13595.
- **"Missing system libraries" is a red herring on modern runners.** The `ubuntu-latest` runner already has all the X11/GTK shared libraries Chromium needs. The gem's error message could be improved to distinguish sandbox failures from library failures.
- **Cross-repo fixes:** The full solution spanned two repos (devblog CI workflow + jekyll-mermaid-prebuild gem). The CI fix was necessary but not sufficient; the gem's postprocessing was the other half.

### Process
- **Don't trust error messages at face value.** The gem's "missing system libraries" suggestion was helpful for WSL/local setups but misleading for CI. Should have investigated the actual Puppeteer stderr output earlier instead of taking the plugin's interpretation.
- **Check what's already installed before adding install steps.** A quick `dpkg -l | grep libgbm` on the runner (or reading the runner image docs) would have saved the first failed iteration.

### Million-Dollar Question

The most elegant solution would be for the gem to detect the sandbox failure distinctly from library failures and either (a) suggest the AppArmor workaround in its error message, or (b) pass `--no-sandbox` to mmdc via a puppeteer config when it detects a CI environment. But this crosses the gem/CI boundary -- the gem shouldn't assume it knows about the deployment environment's security posture.
