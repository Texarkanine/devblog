# Active Context

## Current Task
fix-ci-mermaid-puppeteer

## Phase
QA - PASS

## What Was Done
- First attempt (apt-get) failed: libraries were already present
- Correctly diagnosed: Ubuntu 24.04 AppArmor user namespace restriction prevents Chromium sandbox
- Fix: `echo 0 | sudo tee /proc/sys/kernel/apparmor_restrict_unprivileged_userns`

## Next Step
- Commit, push, verify CI
