# Project Brief: Fix CI Mermaid/Puppeteer Chrome Dependencies

## User Story

CI deployment fails because `mmdc` (mermaid-cli) cannot launch headless Chromium in the GitHub Actions runner. The recent commit `78927f9` removed the workaround that used the runner's pre-installed system Chrome (`/usr/bin/google-chrome-stable`) in favor of letting mermaid-cli use its bundled Chromium. However, the bundled Chromium requires system shared libraries that aren't present on `ubuntu-latest`.

## Requirements

- Fix the CI workflow so mermaid diagrams render correctly during builds
- Mermaid diagrams should appear on the live blog
- Continue using bundled Chromium (the intent of the recent change) rather than reverting to system Chrome

## Acceptance Criteria

- CI build succeeds with mermaid diagram rendering
- The fix installs the required system dependencies for Puppeteer's bundled Chromium
