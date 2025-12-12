---
layout: post
title: "Hook-Based Local Mode for ai-rizz"
author: niko
tags:
  - ai-rizz
  - cursor
  - git
  - pre-commit
  - tdd
---

Recent Cursor builds on Mac [ignore all git-ignored files](https://forum.cursor.com/t/cursor-2-1-50-ignores-rules-in-git-info-exclude-on-mac-not-on-windows-wsl/145695/4), including those in `.git/info/exclude`. This broke [ai-rizz](https://github.com/texarkanine/ai-rizz)'s local mode, which relies on `.git/info/exclude` to keep personal rules out of commits while making them visible to Cursor.

The fix: a `--hook-based-ignore` flag that uses a pre-commit hook instead of git excludes.

## The Problem

ai-rizz has two modes:
- **Local mode**: Personal rules in `.cursor/rules/local/`, git-ignored via `.git/info/exclude`
- **Commit mode**: Team rules in `.cursor/rules/shared/`, committed to the repository

The `.git/info/exclude` approach worked because it kept files out of commits without hiding them from Cursor. Mac Cursor's new behavior broke this assumption.

## The Solution

When initialized with `--hook-based-ignore`, local mode:
1. Skips adding files to `.git/info/exclude`
2. Installs a pre-commit hook that unstages local files before each commit
3. Leaves files visible to Cursor (and `git status`)

The hook reads the manifest dynamically to find which files to unstage:

```bash
# Find local manifest in repo root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
LOCAL_MANIFEST=""
for file in "$REPO_ROOT"/*.local.skbd; do
    [ -f "$file" ] && LOCAL_MANIFEST=$(basename "$file") && break
done
[ -z "$LOCAL_MANIFEST" ] && exit 0

# Parse target directory from manifest
MANIFEST_PATH="$REPO_ROOT/$LOCAL_MANIFEST"
TARGET_DIR=$(head -n1 "$MANIFEST_PATH" 2>/dev/null | cut -f2)
[ -z "$TARGET_DIR" ] && exit 0

# Unstage local files
git reset HEAD -- "$TARGET_DIR/local/" "$LOCAL_MANIFEST" 2>/dev/null || true
```

This works with custom manifest names and target directories since it reads from the manifest itself.

## Mode Switching

Users can switch between modes idempotently:

```bash
# Switch to hook-based
ai-rizz init --local --hook-based-ignore

# Switch back to regular
ai-rizz init --local
```

Switching from regular to hook-based removes `.git/info/exclude` entries and installs the hook. Switching back does the reverse.

## The Trade-off

Hook-based mode leaves a "dirty" `git status`:

```
$ git status
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .cursor/rules/local/
        ai-rizz.local.skbd
```

This may conflict with tooling that expects a clean status. But for Mac users whose Cursor can't see local rules otherwise, it's the only option until Cursor changes behavior.

## Implementation Details

The hook preserves existing user hooks by wrapping the ai-rizz section in `BEGIN`/`END` markers. On deinit, only the ai-rizz section is removed.

The `validate_git_exclude_state()` function now checks for hook presence before warning about missing git excludes - if the hook exists, files don't need to be in `.git/info/exclude`.

## Usage

```bash
# Initialize with hook-based mode
ai-rizz init https://github.com/user/rules.git --local --hook-based-ignore

# Add rules as normal
ai-rizz add rule my-rule.mdc --local

# Files remain visible to Cursor but won't be committed
```

The hook is harmless if files are already git-ignored (it becomes a no-op), so it could theoretically run in all local mode setups. For now, it's opt-in via the flag.

