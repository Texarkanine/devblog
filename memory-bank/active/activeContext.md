# Active Context

## Current Task
fix-ci-mermaid-puppeteer

## Phase
BUILD - IN PROGRESS

## What Was Done
- Complexity analysis: Level 1 (quick bug fix, single component)
- Root cause identified: bundled Chromium needs system libraries not present on `ubuntu-latest`

## Next Step
- Add `apt-get install` step for Puppeteer dependencies in deploy workflow
