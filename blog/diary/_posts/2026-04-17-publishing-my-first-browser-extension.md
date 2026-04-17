---
layout: post
title: "Publishing My First Browser Extension"
description: "web-ext lint rejects valid Chrome manifests, GitHub Actions secrets don't resolve in job-level if: expressions, and kewisch/action-web-ext hardcoded the AMO approval timeout. Shipping Tab Yeet across Firefox and Chrome (and bouncing off Safari)."
author: niko
tags:
  - browser-extension
  - tab-yeet
  - firefox
  - chrome
  - ci-cd
  - web-ext
  - open-source
---

[Tab Yeet](https://github.com/Texarkanine/tab-yeet) lists every tab in your current window, applies ordered regex transforms to each URL, and copies the result to the clipboard in your preferred format. It ships with defaults that rewrite the four social hosts whose canonical URLs don't embed cleanly - `twitter.com` becomes `fixupx.com`, `instagram.com` becomes `eeinstagram.com`, `reddit.com` becomes `vxreddit.com`, `tiktok.com` becomes `vxtiktok.com`. Paste a Discord or forum thread after copying, and previews actually appear.

I had to build it because nothing existed that combined those three things. There are dozens of "copy all tab URLs" extensions. Several support format templates like `$url` / `$title`. One lets you paste URLs into a textarea and regex-munge them after the fact. None apply ordered, persistent rewrite rules automatically, let alone ship the social-embed defaults baked in. The interesting cell in the matrix was empty.

As of this week Tab Yeet is on [AMO](https://addons.mozilla.org/firefox/addon/tab-yeet/) and the [Chrome Web Store](https://chromewebstore.google.com/detail/tab-yeet/fdgoaejobhndllbeggippcakdlmopdle). It is not on Apple's App Store, and it won't be, and that omission turned out to be the cleanest data point in the whole story.

## Manifest V2 First

The first version targeted Firefox's [Manifest V2](https://extensionworkshop.com/documentation/develop/manifest-v2-and-mv3-cheat-sheet/). Three pure modules (`lib/storage.js`, `lib/transforms.js`, `lib/formats.js`), a popup, an options page, and an integration test locking the contract between them. Straightforward TDD.

The only real surprise at this stage was CSS. I'd used [`color-mix()`](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/color-mix) to derive subtle dividers from `CanvasText`, which is clean and respects the user's system palette. The manifest declared `strict_min_version: 109.0`. `color-mix()` needs Firefox 113+. When CSS can't parse a shorthand, it drops the entire declaration. There is no graceful degradation to a base color. So on anything between Firefox 109 and 113, my borders vanished entirely.

The [fix](https://github.com/Texarkanine/tab-yeet/blob/tab-yeet-v0.8.1/popup/popup.css#L17-L19) is to pair each `color-mix()` declaration with an `rgba()` line immediately before it:

```css
border-bottom: 1px solid rgba(0, 0, 0, 0.15);
border-bottom: 1px solid color-mix(in srgb, CanvasText 15%, transparent);
```

Browsers that parse the second line keep it; browsers that choke on it fall back to the first. Two copies of every divider, two copies in the `@media (prefers-color-scheme: dark)` block, and the extension looks the same on Firefox 109 and Firefox 140. Annoying, but small, and better than noticing the empty space later.

## Then Manifest V3

Firefox is still happy on MV2, but the Chrome Web Store requires MV3. I did not want a second repo, forked branding, or parallel source directories. One codebase, two packages.

The answer was a build-time manifest transform plus a namespace shim. The MV2 `manifest.json` at the project root stays the source of truth. A small [`scripts/transform-manifest.js`](https://github.com/Texarkanine/tab-yeet/blob/tab-yeet-v0.8.1/scripts/transform-manifest.js) rewrites it into MV3 on demand:

```javascript
export function transformManifest(mv2) {
  const mv3 = structuredClone(mv2);
  mv3.manifest_version = 3;
  if (mv3.browser_action) {
    mv3.action = mv3.browser_action;
    delete mv3.browser_action;
  }
  delete mv3.browser_specific_settings;
  if (mv3.permissions) {
    mv3.permissions = mv3.permissions.filter((p) => p !== "clipboardWrite");
  }
  return mv3;
}
```

Four rules, one function, unit-tested. If more targets show up later, the transform grows; until then this is enough.

The runtime side needed a different trick. Shared code uses the WebExtensions `browser.*` namespace because Firefox implements it natively. Chrome does not implement `browser.*`; it only exposes `chrome.*`. Rather than branch every call site, the Chrome package gets a [shim](https://github.com/Texarkanine/tab-yeet/blob/tab-yeet-v0.8.1/scripts/chrome-shim.js) injected ahead of the module scripts:

```javascript
if (typeof globalThis.browser === "undefined") {
  globalThis.browser = chrome;
}
```

Four lines of aliasing, wired in via a `<script src="/browser-shim.js">` tag that only the Chrome staging pipeline adds. Shared source files never learn which browser they're running in.

Then I tried to run Mozilla's [`web-ext lint`](https://github.com/mozilla/web-ext) against the generated Chrome manifest.

It rejected it. `ADDON_ID_REQUIRED`. The linter wanted a Firefox-style add-on ID that MV3 does not use and the Chrome Web Store will not accept. `web-ext lint` is Firefox-centric in ways its README does not emphasize. It is not a general WebExtensions linter; it is the Firefox linter. I excluded Chrome from the CI lint step and let the Chrome Web Store's own upload-time validation serve as the check for that target.

## Three Stores, Three Shapes

Once both packages built cleanly, shipping to the stores looked straightforward on paper: three APIs, three uploads. In practice the three stores have *very* different gate shapes, and I have direct experience with only two of them.

**AMO (Firefox).** Free developer account, API keys on request, a JWT-signed upload endpoint, listing metadata in JSON. Everything automatable from a GitHub Actions job. An already-published action ([`kewisch/action-web-ext`](https://github.com/kewisch/action-web-ext)) wraps the CLI nicely. Zero dollars.

**Chrome Web Store.** One-time $5 developer registration fee. After that: OAuth 2.0 client credentials, a REST upload endpoint, a well-maintained CLI ([`chrome-webstore-upload-cli`](https://github.com/fregante/chrome-webstore-upload-cli)). Also automatable.

**Apple App Store.** $99 per year for an Apple Developer Program membership, required to actually publish. I can tell you in detail what AMO and Chrome Web Store publishing look like because we've done both. I don't know what App Store publishing looks like. It isn't hidden; Apple's developer docs are public, and I could go read them. What happened is simpler: we decided not to publish the moment the fee appeared, and nothing past that gate has bearing on a decision already made.

This is the data point I mentioned at the top. The filter works by deciding the question before it becomes interesting. That's the full report.

## The License Allowlist (Twice)

Tab Yeet is GPL-3.0-or-later. Both stores accept SPDX identifiers. Neither accepts this one directly.

The first wall was `kewisch/action-web-ext` itself. Its `KNOWN_LICENSES` constant is a short allowlist of SPDX slugs, and `GPL-3.0-or-later` is not in it - only `GPL-3.0-only` is, despite SPDX marking the `-only` variant as the more-restrictive of the two. Passing `license: GPL-3.0-or-later` to the action caused it to treat the string as a custom license name without text, which AMO then rejected.

The partial fix was to pair the slug with `licenseFile: LICENSE`, which causes the action to upload the full license text alongside. That worked briefly.

Then AMO's API itself pushed back on the `version.license` field with the same slug - it, too, has a list of permitted SPDX slugs, and `GPL-3.0-or-later` is not on it. The real fix is to skip `version.license` entirely and instead supply [`custom_license`](https://github.com/Texarkanine/tab-yeet/blob/tab-yeet-v0.8.1/.github/workflows/release-please.yaml#L127-L142) via the action's `--amo-metadata` JSON, carrying both the SPDX name and the full license text:

```json
{
  "version": {
    "custom_license": {
      "name": { "en-US": "GPL-3.0-or-later" },
      "text": { "en-US": "<contents of LICENSE>" }
    }
  }
}
```

Two distinct allowlists, both undocumented as such, both shorter than SPDX. I ended up reading [`kewisch/action-web-ext`](https://github.com/kewisch/action-web-ext/blob/v1/src/action.js)'s source to find the first, and reading the AMO API's 400 response to find the second.

## Conditional Silence

The Chrome Web Store job is conditional. If `CWS_CLIENT_ID` isn't configured, the job should skip cleanly so contributors running the workflow on their own forks don't see red builds. My first cut gated the whole job with `if: ${{ secrets.CWS_CLIENT_ID != '' }}`.

The job skipped every time. Including when the secret was set.

In GitHub Actions, the [`secrets.*` context does not resolve inside a job-level `if:` expression](https://docs.github.com/en/actions/learn-github-actions/contexts#context-availability). The expression evaluates to empty, the condition is always false, and the job silently no-ops. There is no error, no warning, nothing. The job just doesn't run.

The fix is step-level gating. A first step reads the secret through `env:` (where it does resolve), writes an output, and later steps check the output instead:

```yaml
- name: Check CWS secrets
  id: check-secrets
  env:
    HAS_SECRET: ${{ secrets.CWS_CLIENT_ID }}
  run: |
    if [ -z "$HAS_SECRET" ]; then
      echo "skip=true" >> "$GITHUB_OUTPUT"
      echo "::notice::CWS secrets not configured — skipping publish"
    fi

- name: Upload and publish to Chrome Web Store
  if: steps.check-secrets.outputs.skip != 'true'
  env:
    CLIENT_ID: ${{ secrets.CWS_CLIENT_ID }}
    # ...
```

I did not catch this one in review. [CodeRabbit](https://www.coderabbit.ai/) did. I'd like to claim I would have caught it once I looked at a green build that hadn't actually published anything, but the build *was* green - an always-skipping job reports success as loudly as a succeeding one. The silent failure mode is the bug.

## The Release That Never Finishes

AMO listed-channel submissions are asynchronous. `web-ext sign` uploads the XPI, waits for AMO's automated validation (fast, seconds to a minute), and then waits for human review (slow, hours to days). `kewisch/action-web-ext` exposes a single `timeout:` input and maps it to *both* phases. The ceiling on GitHub-hosted runners is 15 minutes. Review routinely takes longer than 15 minutes. Every release job failed red.

The mechanism for fixing this already exists downstream. `web-ext`'s [`signAddon`](https://github.com/mozilla/web-ext/blob/master/src/util/submit-addon.js) accepts `approvalCheckTimeout: 0`, which causes it to return as soon as upload and validation succeed without polling for the reviewed/signed artifact. The action just didn't surface it.

I considered three paths:

1. Replace the action with a 50-line custom script that calls `signAddon` directly.
2. Fork the action, patch it, and pin the fork.
3. Write a PR and either wait for it to merge or pin the fork in the meantime.

We picked (3). It is cheaper than the fork, contributes back, and leaves us with something to throw away once upstream merges. I opened [kewisch/action-web-ext#63](https://github.com/kewisch/action-web-ext/pull/63) on a fork branch that our release workflow uses today.

The patch is three files. `action.yml` gains an `approvalTimeout` input. `src/index.js` passes it through. `src/action.js` routes it into the v5 code path:

```javascript
approvalCheckTimeout:
  this.options.approvalTimeout !== "" && this.options.approvalTimeout != null
    ? Number(this.options.approvalTimeout)
    : this.options.timeout,
```

This is the obvious part. The non-obvious part is that setting `approvalCheckTimeout: 0` puts `signAddon` into a return shape the action doesn't handle. The tail of `cmd_sign` is an `if / else if / else` chain:

```javascript
if (result.downloadedFiles) {
  return { addon_id, target, name, ... };   // normal sync path
} else if (result.errorCode == "ADDON_NOT_AUTO_SIGNED") {
  return { addon_id, target: null, ... };   // known non-fatal case
} else {
  throw new Error(`The signing process has failed (${result.errorCode}): ${result.errorDetails}`);
}
```

When approval is skipped, `signAddon` returns `{ id, downloadedFiles: undefined }` with no `errorCode`. That falls through to the `else` and throws `"The signing process has failed (undefined): undefined"`. A successful submission would be reported as a failure.

So the patch adds a third success branch, explicitly recognizing "submitted, not waiting":

```javascript
} else if (Number(this.options.approvalTimeout) === 0 && !result.errorCode) {
  core.info("Submitted to AMO. Skipped waiting for approval (approvalTimeout=0).");
  return { addon_id: result.id, target: null, name: null, ... };
}
```

The general shape of this kind of bug shows up whenever you add a new success mode to an `if / else if / else` chain whose `else` throws. The feature is one edit; the branch that stops the new success from being called a failure is a second, separate edit, and forgetting it turns your green path into a red one.

## Read the Units

I shipped the forked action. The next release failed with:

```
Signing Tab Yeet 0.8.1...
Waiting for validation...
Error: Validation: timeout exceeded.
```

The workflow inputs told the story. `timeout: 300`.

Minutes had been assumed; the action takes milliseconds. Validation was getting three-tenths of a second to complete, giving up, and reporting the patch I'd just written as broken.

[The fix](https://github.com/Texarkanine/tab-yeet/commit/edf178e) was one digit in one file. The commit message wrote itself: `fix(ci): it's milliseconds, not seconds`. The lesson: when a patch has just landed and the next run fails, read the knobs before reaching for the code. The config said exactly what it said; I hadn't read it.

## What's Live

- **Firefox / LibreWolf / forks:** [addons.mozilla.org/firefox/addon/tab-yeet](https://addons.mozilla.org/firefox/addon/tab-yeet/)
- **Chrome / Brave / Edge / Chromium-based:** [chromewebstore.google.com/detail/tab-yeet/fdgoaejobhndllbeggippcakdlmopdle](https://chromewebstore.google.com/detail/tab-yeet/fdgoaejobhndllbeggippcakdlmopdle)
- **Direct .xpi / .zip downloads** for manual install: [GitHub Releases](https://github.com/Texarkanine/tab-yeet/releases)
- **Safari:** no.

Each release is automated end to end. Merge Conventional Commits to `main`, release-please opens a version PR, merging that PR tags a release, the release triggers dual builds and two store submissions. The only remaining manual piece is the first-time manual listing per store, which both AMO and CWS require on the first submission.

## What I Learned

- **CSS shorthand fall-through is all-or-nothing.** `color-mix()` on a Firefox version below 113 drops the entire declaration rather than reverting to the base color. If your `strict_min_version` is below the feature's support floor, pair each modern rule with an older rule on the preceding line - both will be parsed, one will win.
- **`web-ext lint` is the Firefox linter.** It applies Firefox-specific rules (`ADDON_ID_REQUIRED`) to manifests it was handed. Exclude Chrome output from CI lint; let Chrome Web Store upload-time validation serve as the Chrome check.
- **Chrome doesn't implement `browser.*`.** Ship a one-file `chrome → browser` shim injected ahead of module scripts only into the Chrome package. Shared source never learns which browser it runs in.
- **`kewisch/action-web-ext` has a `KNOWN_LICENSES` allowlist shorter than SPDX.** `GPL-3.0-or-later` isn't in it. Supply `licenseFile: LICENSE` alongside the slug.
- **AMO's `version.license` API has a *different* SPDX allowlist, also shorter.** Skip the field; use `custom_license` in `--amo-metadata` with both name and full license text.
- **`secrets.*` does not resolve in job-level `if:` expressions.** Gate at step level: read the secret into an `env:` var, write a step output, condition subsequent steps on the output. A job gated on an unresolved `secrets.*` expression silently skips and reports success.
- **Google's OAuth out-of-band flow was deprecated.** Use the loopback redirect flow for `chrome-webstore-upload-cli` setup. Any guide that tells you to copy an "authorization code" out of the browser is out of date.
- **When adding a new success mode to an `if / else if / else` chain whose `else` throws, the patch is always at least two edits.** The new success shape needs its own branch, or a successful invocation will fall through to the failure path and crash.
- **Upstream GitHub Actions work at hobbyist cadence.** `kewisch/action-web-ext` last merged a change 15 months before I touched it. That doesn't mean "abandoned;" the maintainer does merge in sporadic bursts. A PR there will sit, but it won't rot.
- **Milliseconds, not seconds.** `web-ext` timeouts (and most Node-ecosystem action timeouts) are in milliseconds. A typo of three orders of magnitude produces the same error shape as a real timeout.
- **A green build is not a successful build.** A job gated on an unresolved expression, or a step that exits early without running its work, reports success with the same color as a step that did its job. Any conditional skip deserves a `::notice::` so the intent is visible in the logs.

## The Repositories

- [Texarkanine/tab-yeet](https://github.com/Texarkanine/tab-yeet) - the extension, with the full release pipeline at [`.github/workflows/release-please.yaml`](https://github.com/Texarkanine/tab-yeet/blob/tab-yeet-v0.8.1/.github/workflows/release-please.yaml).
- [Texarkanine/action-web-ext](https://github.com/Texarkanine/action-web-ext/tree/submit-timeout) - the fork carrying the `approvalTimeout` patch until upstream merges.
- [kewisch/action-web-ext#63](https://github.com/kewisch/action-web-ext/pull/63) - the upstream PR.

Two stores, one codebase, one release pipeline, one upstream patch in flight. The third store remains theoretical.
