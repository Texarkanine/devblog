# Tasks: fix-ci-mermaid-puppeteer

## What Broke
- CI build fails: `mmdc` (mermaid-cli) can't launch headless Chromium
- Error: "Puppeteer cannot launch headless Chrome"
- Caused by commit `78927f9` which removed `PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable`

## Root Cause
- NOT missing system libraries (CI confirmed all are "already the newest version")
- Ubuntu 24.04's AppArmor restricts unprivileged user namespaces (`apparmor_restrict_unprivileged_userns=1`)
- Puppeteer's bundled Chromium needs user namespaces for its sandbox
- The old `PUPPETEER_EXECUTABLE_PATH` workaround used the runner's system Chrome which handles sandboxing differently

## Fix
- `.github/workflows/deploy.yaml`: Replaced `apt-get install` step with `echo 0 | sudo tee /proc/sys/kernel/apparmor_restrict_unprivileged_userns`
- This disables the AppArmor restriction on unprivileged user namespaces, allowing Chromium's sandbox to work
- Referenced: https://github.com/puppeteer/puppeteer/issues/13595, https://github.com/actions/runner-images/pull/11489

## QA Result: PASS
