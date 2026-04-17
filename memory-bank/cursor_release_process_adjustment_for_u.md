# Release process adjustment for unsigned AMO
_Exported on 4/17/2026 at 13:24:15 CDT from Cursor (3.1.15)_

---

**User**

QQ - @tab-yeet/.github/workflows/release-please.yaml let's forget trying to get the signed AMO. It never complets in time. Just publish, hope for the gest, and attach unsigned to the release so we don't exit RED on every deployment.

---

**Cursor**


Reading the release workflow to see how AMO signing and release attachments are configured.




Removing the `amo-sign-and-attach` job (AMO signing + long timeout) and the build steps that only fed it. Keeping the initial `softprops/action-gh-release` step that uploads `web-ext-artifacts/*.xpi` (unsigned). Adding an explicit `*-firefox-unsigned.xpi` copy so the release clearly includes an unsigned Firefox package.




Removing the AMO signing job and AMO-only bundle steps. Adding a stable `tab-yeet-firefox-unsigned.xpi` copy so releases clearly include an unsigned Firefox artifact alongside the versioned `.xpi`.




Fixing a bug: after copying, `web-ext-artifacts/*.xpi` matches both `.xpi` files, causing duplicate uploads. Removing the redundant copy and relying on the existing versioned `.xpi` (it's already unsigned), unless we attach only one explicitly named asset.




Verifying the workflow file and whether we should keep both the versioned `.xpi` and the `unsigned` copy. Checking the final state:




Removing the verbose comment per your code-style preference.




Updating contract tests that assert the old AMO workflow shape.




Updating the README release section — it still documents automated AMO signing.



---

**User**

I undid all the changes. To be clear, we still want to publish to the mozilla addon index, and get it sighed... we just don't want to wait for that to come back to try to attach it. So we STILL want to sign and upload, just, not wait aroun for them to approve it.

---

**Cursor**


Reading the workflow after your revert to restore AMO signing while making the pipeline non-blocking.




Checking how `kewisch/action-web-ext` and `web-ext sign` handle async signing vs. blocking.




Using web-ext's `approvalCheckTimeout: 0` skips waiting for approval and the signed download (see `submit-addon.js`). Kewisch maps both validation and approval timeouts to the same `timeout` input, so it always waits. Replacing the sign step with a small script that calls `signAddon` with `validationCheckTimeout: 900000` and `approvalCheckTimeout: 0`, removing the attach-signed step, and adding checkout + `npm ci` so we can run the script. Staging `manifest.json` into the artifact so we can read the add-on id.




Including `.nvmrc` in the sparse checkout because `setup-node` uses `node-version-file`.




Here’s what changed and why it matches what you want.

### Behavior
- **`web-ext` already supports this:** in `submit-addon.js`, if `approvalCheckTimeout === 0`, it **does not** poll for approval or download the signed XPI; it logs that you can get the file from the developer hub later and returns after validation + upload.
- **`kewisch/action-web-ext` always set both** `validationCheckTimeout` and `approvalCheckTimeout` to the same `timeout` (15 minutes), so it **always waited** for approval/signing. That’s why the job never finished in time.

### What we did
1. **`scripts/amo-listed-submit.mjs`** — Calls `signAddon` from `web-ext/util/submit-addon` with:
   - `validationCheckTimeout: 900000` (still wait for **upload + AMO validation**)
   - **`approvalCheckTimeout: 0`** (do **not** wait for review/signing)
2. **Workflow** — Replaced the `kewisch/action-web-ext` step with checkout (sparse), `npm ci`, and `node scripts/amo-listed-submit.mjs`. **Removed** the “attach signed XPI to GitHub Release” step.
3. **Artifact** — **`manifest.json` is copied into `amo-submit/`** so the script can read the Gecko add-on id (same info `kewisch` got from the XPI).
4. **README** — Describes the new AMO behavior.

`build-release` is unchanged: it still attaches **`web-ext-artifacts/*.xpi`** (unsigned) plus the Chrome zip. The AMO job **submits the listed build** and goes green once the submission + validation succeed, without waiting for Mozilla to finish review or produce the signed artifact.

---

**User**

Claude, the prior conversation and work was done by Cursor's Composer. I'm skeptical - do we really need a whole new script to submit and get sucesss on submit, without wiating for approval? Please review what was done and let me know if there's a better design we should consider!

---

**Cursor**

Good instinct to question it. I dug into Composer's work and the upstream `web-ext` / `kewisch/action-web-ext` internals. Here's my honest review.

## What Composer got right

The core diagnosis is correct:
- `web-ext`'s `signAddon` already supports "submit and don't wait" via `approvalCheckTimeout: 0` (see `node_modules/web-ext/lib/util/submit-addon.js` around line 211: *"Waiting for approval and download of signed XPI skipped"*).
- `kewisch/action-web-ext@v1` does **not** expose this — it hardcodes both validation and approval timeouts to its single `timeout:` input ([`src/action.js`](https://github.com/kewisch/action-web-ext/blob/v1/src/action.js) sets `approvalCheckTimeout: this.options.timeout`). That's why your job always waited.

So the mechanism is right. The concern is the **packaging**.

## What's over-engineered

The custom `scripts/amo-listed-submit.mjs` reimplements most of what `web-ext sign` already does as a CLI, including the `signAddon` call, UUID persistence paths, manifest id extraction, metadata merging, etc. And to run it we now need: sparse checkout + `npm ci` + a new script file to maintain.

The key fact Composer missed: **`web-ext sign` the CLI already exposes `--approval-timeout 0` as a flag** (see `node_modules/web-ext/lib/program.js` line 451: *"Set to 0 to disable waiting for approval"*). And the release-notes + license metadata already go through `--amo-metadata` as JSON, which we're already generating.

## Simpler design

Drop the script entirely and just call the CLI via `npx` — no checkout of source, no `npm ci`, no script file.

```yaml
amo-submit-listed:
  name: Submit listed version to AMO (no wait for signed file)
  needs: [release-please, build-release]
  if: ${{ needs.release-please.outputs.release_created == 'true' }}
  runs-on: ubuntu-latest
  environment:
    name: addons.mozilla.org
    url: https://addons.mozilla.org/en-US/firefox/addon/tab-yeet/
  steps:
    - name: Download AMO signing bundle
      uses: actions/download-artifact@v8
      with:
        name: amo-submit
        path: amo-submit

    - name: Fetch release notes and build AMO metadata
      env:
        GH_TOKEN: ${{ github.token }}
      run: |
        tag="${{ needs.release-please.outputs.tag_name }}"
        notes=$(gh api "repos/${{ github.repository }}/releases/tags/${tag}" | jq -r '.body // ""')
        jq -n \
          --rawfile text amo-submit/LICENSE \
          --arg notes "$notes" \
          '{
            default_locale: "en-US",
            categories: { firefox: ["tabs"] },
            version: {
              release_notes: { "en-US": $notes },
              custom_license: {
                name: { "en-US": "GPL-3.0-or-later" },
                text: { "en-US": $text }
              }
            }
          }' > amo-submit/amo-metadata.json

    - name: Submit listed version to AMO (no wait)
      env:
        WEB_EXT_API_KEY: ${{ secrets.AMO_SIGN_KEY }}
        WEB_EXT_API_SECRET: ${{ secrets.AMO_SIGN_SECRET }}
      run: |
        npx --yes web-ext@10 sign \
          --channel listed \
          --source-dir amo-submit/unpacked \
          --amo-metadata amo-submit/amo-metadata.json \
          --approval-timeout 0 \
          --timeout 900000
```

One wrinkle: `web-ext sign` (CLI) **rebuilds** the XPI from a source directory rather than accepting a pre-built XPI file. Two ways to handle that:

1. **Unpack the XPI in `build-release`** into `amo-submit/unpacked/` (it's just a zip). Trivial — `unzip amo-submit/unsigned.xpi -d amo-submit/unpacked`. Sign uses the unpacked tree; the bytes end up the same.
2. **Keep Composer's `signAddon` script**, which is the only way to sign a pre-built XPI file without re-zipping. That's actually the one real advantage of the script: it preserves **byte-for-byte** the exact XPI we attached to the GitHub Release.

## Recommendation

I'd ask one question before changing anything:

**Do we care that the XPI Mozilla signs is byte-identical to the one on the GitHub Release?**

- If **no** (most extensions don't care — `web-ext build` is deterministic-ish and AMO is the source of truth for the signed build): **delete the script**, use the `npx web-ext@10 sign --approval-timeout 0` CLI approach above. Simpler, no new file, no `npm ci`, uses the official tool as-is.
- If **yes**: keep Composer's script — it's the minimum viable way to feed a pre-built XPI into `signAddon` without a rebuild. It's not wrong, just deliberate.

My weak lean is toward deleting the script. The AMO-signed XPI is its own artifact that lives on AMO; the GitHub Release XPI is labeled "unsigned" and its role is just "here's the source-of-record package." Requiring them to be byte-identical doesn't buy much.

Want me to swap to the CLI approach, or keep the script?

---

**User**

> Do we care that the XPI Mozilla signs is byte-identical to the one on the GitHub Release?

yes.

---

**Cursor**

Fair enough — keep the script then. That's the only clean way to feed the already-built XPI into `signAddon` without a rebuild.

Let me double-check the current state is solid.

Current setup is good. Byte-identical XPI is preserved because `signAddon` is called with `xpiPath: amo-submit/unsigned.xpi` — the exact file attached to the GitHub Release.

A couple of tiny optional cleanups I noticed while re-reading, none blocking:

1. **`savedIdPath` is dead config.** We always pass `id`, which routes to `putVersion` (new version of existing addon). `savedIdPath` is only used by `postNewAddon` (first-ever submission). Safe to drop from the script.
2. **Internal API caveat.** `web-ext/util/submit-addon` is documented as internal by upstream (`node_modules/web-ext/README.md:235` — *"using the webExt.cmd.sign() is the recommended API method"*). The catch is `webExt.cmd.sign()` always rebuilds from source-dir, which breaks your byte-identical requirement. So using the internal API is the **right** trade for this use case — but if a future `web-ext` major bump breaks the import, we'll need to adapt. `kewisch/action-web-ext` imports it the same way for the same reason, so there's precedent.
3. **One minor concern I want to flag explicitly:** this does **not** detect AMO rejecting the upload asynchronously. With `approvalCheckTimeout: 0`, CI goes green as soon as upload + validation succeeds. If Mozilla's human review later rejects the version, you won't find out from GitHub Actions — only from the AMO dashboard / email. I think that's fine (matches your "publish and hope for the best" intent), but worth naming.

If you want, I can apply the one-line cleanup of `savedIdPath`. Otherwise this is ready to merge.

---

**User**

What if we forked or patched the upstream web-ext action? It's unmodified for 2 years though... maybe we fork it?

---

**Cursor**

Quick fact-check first: "2 years unmodified" is a bit overstated. Upstream cadence is **hobbyist, not abandoned**:

- **Last merge:** 2025-01-05 (~15 months ago from today, 2026-04-17)
- **Last functional feature:** 2024-09 (source-code submission, #51)
- **PR backlog:** #62 (Node 24 bump) open since Jan 2026, plus 3 Dependabot PRs sitting since Feb 2025

So the maintainer **does** merge, but in sporadic bursts of several months. A PR from us wouldn't be dead-on-arrival, but it could easily sit 6+ months.

## Honest fork/PR assessment

**What a fork would actually cost you:**
- Another repo (releases, tags, SHA pinning, Dependabot, README, CI self-tests)
- Supply-chain responsibility you don't have today — every consumer pins to a SHA you own
- Drift management: every upstream security patch is your job to port (even if upstream isn't updating, that's *worse*, not better, because you now own security patches alone)
- Still uses the same internal `web-ext/util/submit-addon` import the script does. Fork **doesn't** improve the internal-API story. That concern is in `kewisch/action-web-ext` too.

**What a fork would buy you:**
- Delete `scripts/amo-listed-submit.mjs` (48 lines)
- Delete sparse checkout + `npm ci` (saves ~30s per release — runs ~maybe once a month?)
- Workflow reads slightly more declarative

The math doesn't work for a single-consumer repo. A fork is justified when amortized over 3+ repos or when upstream is genuinely gone.

## The better middle path

**Submit an upstream PR first.** It's tiny:

```yaml
# action.yml — new input
approvalTimeout:
  description: >
    [sign] ms to wait for approval before giving up. Set to 0 to disable
    waiting for approval (upload only).
  required: false
```

```javascript
// src/action.js — change one line
result = await signAddonV5({
  // ...
  validationCheckTimeout: this.options.timeout,
  approvalCheckTimeout: this.options.approvalTimeout !== ""
    ? Number(this.options.approvalTimeout)
    : this.options.timeout,
  // ...
});
```

Plus pass the new input through in `src/index.js`. ~10 lines total.

**Then:**
- **If it merges within ~2 months:** delete our script, use `kewisch/action-web-ext@vN` with `approvalTimeout: 0`. Best outcome — we upstreamed the fix.
- **If it sits forever:** fork *then*, after you've seen the maintainer ignore your PR. Forking earlier is speculative; forking after a dead PR is justified.
- **Meanwhile:** our script works today and gets you to green CI immediately.

## My vote

1. Ship the current script now (you're unblocked).
2. File the upstream PR as a follow-up. Cheap option value.
3. Only fork if the PR is clearly dead **and** you find yourself adding more extensions.

The strongest argument against forking right now is that the script is already smaller than the fork would be. A fork wins only when it eliminates repeated per-consumer boilerplate — which here is just the `npm ci` step. That's not enough payoff to take on a repo.

Want me to draft the upstream PR description/patch so you can submit it?

---

**User**

how bout I fork it to send the fix, and just use my fix while we wait?

---

**Cursor**

Solid plan. That's exactly the "cheap option value" I was alluding to — you contribute the fix, get a cleaner workflow immediately, and if upstream merges you just bump the `uses:` line.

One important gotcha I caught while drafting the patch: the action's result-handling code will **throw on success** if we don't also patch that. Here's the full picture.

## The bug in the naive patch

Adding just an `approvalTimeout` input isn't enough. Look at the tail of `cmd_sign` in upstream `src/action.js`:

```javascript
if (result.downloadedFiles) {
  console.log("Downloaded these files: " + result.downloadedFiles);
  return { addon_id: result.id, target: ..., ... };
} else if (result.errorCode == "ADDON_NOT_AUTO_SIGNED") {
  core.warning("The add-on passed validation, but was not auto-signed");
  return { addon_id: result.id, target: null, ... };
} else {
  console.error(result);
  throw new Error(`The signing process has failed (${result.errorCode}): ${result.errorDetails}`);
}
```

When `approvalCheckTimeout: 0`, `signAddon` returns `{ id, downloadedFiles: undefined }` — **no** `errorCode`. That falls through to the final `else` and throws `"The signing process has failed (undefined): undefined"`. Silent failure mode.

So the patch has three parts: action.yml input, action.js plumb-through, **and** a third success branch.

## The patch

**`action.yml`** — new input:

```yaml
approvalTimeout:
  description: |
    [sign] The number of milliseconds to wait for AMO approval and the
    resulting signed XPI. Set to 0 to skip waiting (submit only — the
    action succeeds as soon as upload and validation succeed). Falls
    back to `timeout` if unset.
  required: false
```

**`src/index.js`** — forward the input:

```javascript
timeout: core.getInput("timeout"),
approvalTimeout: core.getInput("approvalTimeout"),
```

**`src/action.js`** — use it in the v5 branch, and add the "submitted, not waiting" success case:

```javascript
// In the signAddonV5({...}) call:
validationCheckTimeout: this.options.timeout,
approvalCheckTimeout:
  this.options.approvalTimeout !== "" && this.options.approvalTimeout != null
    ? Number(this.options.approvalTimeout)
    : this.options.timeout,
```

```javascript
if (result.downloadedFiles) {
  // ... existing branch unchanged
} else if (result.errorCode == "ADDON_NOT_AUTO_SIGNED") {
  // ... existing branch unchanged
} else if (Number(this.options.approvalTimeout) === 0 && !result.errorCode) {
  core.info(
    "Submitted to AMO. Skipped waiting for approval/signed XPI " +
    "(approvalTimeout=0)."
  );
  return {
    addon_id: result.id,
    target: null,
    name: null,
    upload: uploadUuid?.uploadUuid,
    channel: uploadUuid?.channel,
    crcHash: uploadUuid?.xpiCrcHash,
  };
} else {
  console.error(result);
  throw new Error(`The signing process has failed (${result.errorCode}): ${result.errorDetails}`);
}
```

Deliberately **not** touching the v4 branch — v4 is Thunderbird-only and `sign-addon` doesn't split the timeouts anyway. Upstream PR review will likely want that left alone too.

## Fork workflow (operational)

1. **Fork** `kewisch/action-web-ext` → `Texarkanine/action-web-ext`.
2. **Branch** `feat/approval-timeout` off upstream `v1` (the tag, so you're based on what everyone actually uses).
3. Apply the three-file patch above.
4. **Tag your fork** with something that doesn't collide with upstream semantics — I'd use `v1.1.0-approval-timeout.1` or just `v1-approval-timeout`. Avoid overwriting `v1`; if you ever want to sync upstream's `v1` back in, you don't want to have rewritten the tag.
5. **SHA-pin** in your workflow (standard GitHub Actions hygiene for forks you own):

   ```yaml
   - name: Sign with AMO (submit only, don't wait for signed XPI)
     uses: Texarkanine/action-web-ext@<full-40-char-sha>  # v1-approval-timeout
     with:
       cmd: sign
       source: amo-submit/unsigned.xpi
       channel: listed
       releaseNotes: ${{ steps.gh_release.outputs.body }}
       metaDataFile: amo-submit/amo-metadata.json
       apiKey: ${{ secrets.AMO_SIGN_KEY }}
       apiSecret: ${{ secrets.AMO_SIGN_SECRET }}
       timeout: 900000
       approvalTimeout: 0
   ```

6. **Delete** `scripts/amo-listed-submit.mjs`, the sparse checkout, the `setup-node`, and the `npm ci` step from the `amo-submit-listed` job. It collapses to the step above plus the metadata + release-notes steps you already have.
7. **Open the upstream PR** from your fork branch. Reference issue #3098 in mozilla/web-ext if relevant.

## Draft upstream PR

**Title:** `feat: add approvalTimeout input to skip waiting for AMO approval`

**Body:**

> AMO reviewer approval for listed versions can take anywhere from minutes to days. The current action always waits for approval and the resulting signed XPI (both driven by the single `timeout` input, which caps at 15 min and requires the job to stay alive that long). For CI pipelines that just need to submit a version reliably on release and don't need the signed artifact back in the same job, the wait forces either a doomed timeout or an artificially high `timeout` that ties up a runner.
>
> `web-ext`'s `signAddon` already supports decoupling these via `approvalCheckTimeout: 0` (see [`mozilla/web-ext` `lib/util/submit-addon.js`](https://github.com/mozilla/web-ext/blob/master/src/util/submit-addon.js) — "Waiting for approval and download of signed XPI skipped."). This PR surfaces that as a new `approvalTimeout` input.
>
> - Defaults to current behavior (falls back to `timeout` when unset), so existing workflows are unaffected.
> - `approvalTimeout: 0` → action succeeds as soon as upload + validation succeed; no signed file is downloaded. Outputs `target: null` and `name: null` in that case.
> - Scoped to the v5 code path. v4 (Thunderbird / `sign-addon`) doesn't expose a separate approval timeout and is untouched.
> - Adds a handler for the "submitted, not waiting" result shape so the action reports success instead of falling through to the generic failure branch.
>
> **Testing:** Used a forked build in a real release pipeline (tab-yeet). Submission succeeds, job terminates in ~30 s instead of 15 min, signed XPI appears on AMO through normal review.

## What I'd do in our repo right now

Your call on ordering:

- **Option A (minimal change now):** keep the current script. Fork + PR on your own time. Switch workflows when the fork tag is ready.
- **Option B (do both in one go):** fork, patch, tag, then change `release-please.yaml` to use the fork + delete the script in the same PR.

Both are fine. Option B is more churn in one PR but gets you to the nicer end state in one sitting. Option A lets you verify the script-based flow works on a real release before touching it again.

Want me to apply Option B changes to the workflow + delete the script now, with a placeholder SHA for you to fill in once you push the fork?

---

**User**

Great, I forked it and checked out a branch: @\home\mobaxterm\Documents\git\action-web-ext\ . It's on main. How do I get the tags from upstream? I forked only the `main` branch...

---

**Cursor**

Done. Pulled all 6 tags (`v1` rolling + `v1.0` through `v1.3`) and upstream `main`. Let's verify what `v1` actually tracks so you know what to base your branch on:

Useful findings:

- **`v1` is a rolling major tag** pointing to `fe10addf` (same as `v1.3`). That's what consumers of `kewisch/action-web-ext@v1` actually run.
- **`upstream/main` is 2 commits ahead of `v1`** (two dependency-update chore commits from Jan 2025 that were never tagged).
- Your fork's `main` is identical to `upstream/main` (good, no drift).

So two practical implications for your `submit-timeout` branch:

**For the upstream PR:** keep basing on `main`. That's the correct PR target — maintainers merge into `main`, and your branch includes the two dep-bump chores they already shipped on `main`.

**For your own consumable tag (while waiting on the PR):** you have a choice:

1. **Tag from `submit-timeout` (currently main-based).** Tag name e.g. `v1-approval-timeout.1`. Includes the two untagged dep commits. Slightly diverges from what `@v1` consumers get today, but those commits are harmless dep bumps.
2. **Create a second branch off `v1` with just your patch cherry-picked**, tag that. Byte-identical to what `@v1` gives everyone today, plus your change only. More surgical; better if you want "exactly upstream v1 + my fix."

I'd go with **option 1** unless you have a specific reason to pin to v1's exact tree. The dep commits are `chore: Update dependencies` × 2 — unreviewed but trivial, and you're the one running it anyway.

One small hygiene tip since you already did it: it's worth setting upstream as push-disabled so you can't accidentally push there:

```bash
git remote set-url --push upstream DISABLED
```

Ready when you are — want me to draft the three-file patch into your `submit-timeout` branch, or are you applying it yourself?

---

**User**

let's use our local submit-timeout branch, which we made off main. Please minimally patch the action to accept split inputs for submit vs approval timeout, and update its documentation/comments accordingly.

---

**Cursor**

Now applying the minimal patch across `action.yml`, `src/index.js`, `src/action.js`, and `README.md`.

Now the README.

Now lint and verify the edits are well-formed.

JS + eslint passed. The yaml check failed only because the `yaml` npm package isn't installed here — let me validate with Python instead.

All checks pass. Let me show you the final diff for review.

Patch looks clean. Summary of what changed on branch `submit-timeout`:

```
 README.md     |  8 ++++++--
 action.yml    | 12 ++++++++++--
 src/action.js | 23 ++++++++++++++++++++++-
 src/index.js  |  1 +
 4 files changed, 39 insertions(+), 5 deletions(-)
```

### What the patch does
- **`action.yml`** — new optional `approvalTimeout` input (no default, so empty string signals "fall back to `timeout`"); tightens the `timeout` description to say it covers upload + validation.
- **`src/index.js`** — one-line passthrough.
- **`src/action.js`** — two minimal surgical changes:
  1. In the v5 branch, `approvalCheckTimeout` is now pulled from `approvalTimeout` with fallback to `timeout`.
  2. A new success branch **before** the generic failure throw handles the `approvalTimeout=0` result shape (id present, no `downloadedFiles`, no `errorCode`). Without this third branch, a successful skip-approval submit would crash with `"The signing process has failed (undefined): undefined"` — the bug I flagged earlier.
- **`README.md`** — documents the new input alongside `timeout`.

### Deliberately **not** touched
- **v4 / Thunderbird branch.** `sign-addon` (v4) doesn't split validation vs approval, so `approvalTimeout` has no meaningful mapping there. I didn't add a warning for `approvalTimeout` + v4; setting it will just be silently ignored, matching how the action handles other v5-only options.
- **Backward compatibility.** Existing workflows that don't set `approvalTimeout` get identical behavior to before, because the fallback is `timeout` (which kept its old default of 900000).
- **Tests.** Repo has no unit tests for `src/action.js` — just an `amo_metadata.json` + `extension/` fixture for integration runs. Not adding fake ones.

Three sanity gates passed: `node --check` on both JS files, `npx eslint src/` clean, and a Python YAML load confirms `approvalTimeout` is in `inputs`.

Ready to commit when you are — want me to stage and commit it with a Conventional Commit message (`feat: add approvalTimeout input to skip waiting for AMO approval`), or are you handling commits yourself?

---

**User**

I tried it. Looks like zero DOESN'T bypass?

```
Run texarkanine/action-web-ext@submit-timeout
  with:
    cmd: sign
    source: amo-submit/unsigned.xpi
    channel: listed
    releaseNotes: ## [0.8.1](https://github.com/Texarkanine/tab-yeet/compare/tab-yeet-v0.8.0...tab-yeet-v0.8.1) (2026-04-17)
  
  
  ### Bug Fixes
  
  * **ci:** do not attempt to attach signed XPI that we won't be getting ([27408a6](https://github.com/Texarkanine/tab-yeet/commit/27408a6184b1fa449d479d082dd834f3ef3748f3))
  * **ci:** do not wait for AMO approval on deploy ([71b507a](https://github.com/Texarkanine/tab-yeet/commit/71b507a43c6bc765bc2e56a0750e4555c9842d55))
    metaDataFile: amo-submit/amo-metadata.json
    apiKey: ***
    apiSecret: ***
    timeout: 300
    approvalTimeout: 0
    artifacts: web-ext-artifacts
    verbose: false
    ignoreFiles: []
    apiUrlPrefix: https://addons.mozilla.org/api/v5
  
Signing Tab Yeet 0.8.1...
Waiting for validation...
Error: Error: Validation: timeout exceeded.
Error: Validation: timeout exceeded.
    at Timeout._onTimeout (file:///home/runner/work/_actions/texarkanine/action-web-ext/submit-timeout/node_modules/web-ext/lib/util/submit-addon.js:140:16)
    at listOnTimeout (node:internal/timers:581:17)
    at process.processTimers (node:internal/timers:519:7)
```

---

**Cursor**

This isn't a bug in the patch — this is a config issue. Look at your inputs:

```
timeout: 300
approvalTimeout: 0
```

`timeout: 300` is **300 milliseconds** (0.3 seconds). The action gave up on **validation** (the first step — AMO processing the upload) after 300ms. Validation typically takes several seconds to a minute. The error proves this: it says `Waiting for validation...` then `Validation: timeout exceeded.` — approval was never even reached.

The two timeouts do different things:

| Input | What it caps | Realistic value |
|---|---|---|
| `timeout` | How long to wait for AMO to upload + **validate** the XPI | 300000 ms (5 min) minimum; default 900000 (15 min) is fine |
| `approvalTimeout` | How long to wait for **human review** + signed XPI download | `0` to skip |

`approvalTimeout: 0` correctly short-circuits the second phase, but you still need a real `timeout` for validation. With `timeout: 300`, the job would fail with or without our patch — it never got far enough to exercise the bypass.

Let me check your current workflow and fix it.

Already at 300000 now — good. Let me just add a clarifying comment so the distinction between the two timeouts is self-documenting for next time.

