# Tasks: fix-ci-mermaid-puppeteer

## What Broke
- CI build fails: `mmdc` (mermaid-cli) can't launch headless Chromium
- Error: "Puppeteer cannot launch headless Chrome" - missing system libraries
- Caused by commit `78927f9` which removed the `PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable` workaround

## Why
- Bundled Chromium (downloaded by Puppeteer during `npm install`) dynamically links against system shared libraries (`libgbm1`, `libnss3`, etc.)
- These libraries aren't pre-installed on `ubuntu-latest` GitHub Actions runners
- The previous workaround used the runner's pre-installed Chrome, which has its dependencies satisfied

## What Changed
- `.github/workflows/deploy.yaml`: Added "Install Puppeteer system dependencies" step with `apt-get install` for the required shared libraries, placed after mermaid-cli installation and before the Jekyll build
- Used Ubuntu 24.04 `t64`-suffixed package names where needed (libasound2t64, libatk1.0-0t64, libatk-bridge2.0-0t64, libcups2t64)

## QA Result: PASS
- Fixed package names for Ubuntu 24.04 compatibility (t64 suffix)
- All KISS/DRY/YAGNI/completeness checks pass
