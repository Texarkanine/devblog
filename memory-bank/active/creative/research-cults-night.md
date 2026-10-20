# Research Digest: The Cults Night (Public-Safe Extract)

This is a sanitized extract. Part of this session is operator-private and must not appear in this repo or in any post without the operator's explicit say-so; the full digest is local-only under `.scratch/3d-research/private/`. Draft only from this extract unless the operator opts in.

## Sessions Covered

- `2026-10-15-2057-cursor-f896ee1e.md` (Cursor), 2026-10-15 20:57 to 22:09 local. A Level 1 `/niko` bug fix for a failed Cults3D deploy (flaky photo upload, PR #17), a neutral image-metadata pre-commit hook (PR #18), other work out of scope here, and a long diagnosis of Cults' stale public gallery (issue #4).

## What Happened

**20:57, a new failure.** "/niko  The most-recent cults3d publishing work failed in a new way". The traceback ends `RuntimeError: Cults request failed: [{'message': 'Unexpected error!'}]` in `create_assets` [f896ee1e#0]. It was a republish of `h7-bulb-storage-v1.0.2` just after the free-price fix (PR #16). The text update and all 10 `createBlueprint` calls succeeded; the third `createIllustration` failed [f896ee1e#4, #6, #23].

**Live probe.** The agent queried the listing read-only and found 20 blueprints and 6 photos (old plus new, because the run died before its destroy step) [f896ee1e#8, #11]. The failing PNG had failed in an earlier run with "Could not download URL" and worked three minutes later [f896ee1e#11, #56]. It then added the same URL to the live listing three times: "The same photo uploaded fine three times in a row, so the file is not the problem; the failure is intermittent on Cults' side." It deleted the probe photos afterwards [f896ee1e#17, #18].

**The fix (PR #17).** A re-run already converges: the publisher records the existing assets, adds the new ones, then destroys the recorded set [f896ee1e#19]. So the job was to let the transient failure recover on its own: retry blueprint and photo creates only (4 attempts, 10/30/60 s backoff, injectable `sleep`; the final error names the mutation and URL). It deliberately does not retry destroys, `updateCreation`, or `createCreation` (a retried first publish could make a duplicate listing) [f896ee1e#19, #30, #38]. Four new tests failed first ("the first one reproduces the deploy's exact error"), then 52 passed [f896ee1e#35, #37]. The agent caught that a red run against old code was "contaminated" by a `TypeError` from the missing `sleep` argument and used the honest stub-phase red run instead [f896ee1e#51]. The PR cut no model release, because `tools/` is in no release-please package [f896ee1e#52, #53].

**The metadata hook (PR #18).** The operator asked for "generic metadata stripping to a pre commit hook" [f896ee1e#57]. Choices: the pre-commit framework, not `core.hooksPath`, which would bypass Git LFS's own hooks [f896ee1e#62, #63]; ExifTool built from CPAN by pre-commit (`language: perl`) because ExifTool wasn't installed but Perl was [f896ee1e#63, #67]; keep Orientation and the ICC profile (identical pixel hashes, idempotent second run) [f896ee1e#71]; and `tools/strip_svg_metadata.py`, written test-first, because ExifTool can't write SVG; it refuses to write a file it would break [f896ee1e#72-#75]. The agent checked the live listing and found Cults strips image metadata on upload and serves its own copies, so no re-release was needed and the commit became `chore` [f896ee1e#81, #83].

**21:54, the gallery.** The operator sent screenshots showing 15 files and duplicate photos: "I think our dedupe still needs [some] work" [f896ee1e#171]. The API showed 10 files and 4 photos; `curl` got a Cloudflare 403 so the agent used the IDE browser; repeated photos were carousel clones; logged out, the page said "10 files" [f896ee1e#174-#182]. "That wraps it up." [f896ee1e#185].

**21:56-22:09, not wrapped up.** "there are dupes in the image gallery, still - including 7 clip previews...!!" [f896ee1e#186]. The agent: "'7 clip previews' suggests these aren't your photos at all": Cults adds a 3D preview per STL to the gallery [f896ee1e#187]. The page's gallery URLs did not match the API's current assets, and deleted image URLs still returned 200 [f896ee1e#191, #193]. Neither a no-op update nor adding and deleting a temporary photo bumped `updatedAt` [f896ee1e#195, #199]. "I've got 3 copies of the photos visible now, both logged-in and logged-out :(" and publish "should SET the images on the model to exactly the ones that are in the repo" [f896ee1e#201]. Setting the empty `details` field to "." and back made the page rebuild [f896ee1e#206, #223]. Issue #4 was opened for the permanent fix [f896ee1e#218]. "Your dedupe was never the problem. Cults kept serving an old cached copy of the gallery." [f896ee1e#223].

## Turning Points

- **Bad file, or flaky server?** The same PNG failed in two deploys; three live re-adds succeeded, so the fix became a retry [f896ee1e#11, #18].
- **`docs` became `chore`.** Cults strips metadata itself, so clean photos needed no re-release [f896ee1e#63, #81].
- **The false summit.** "That wraps it up" [f896ee1e#185]. The operator suspected the dedupe; the agent proved the page was stale. Its theories ran from cache lag, to add-without-delete refresh, to an `updatedAt` freeze, ending with the "." toggle [f896ee1e#184, #197, #199, #206, #223].

## Failure Ledger

| Symptom | Root cause | Fix | Citation |
|---|---|---|---|
| Deploy fails: `Unexpected error!` on a photo add | Cults intermittently fails to fetch a good GitHub URL | Retry creates at 10/30/60 s; final error names mutation and URL (PR #17) | [f896ee1e#0, #18, #30, #53] |
| Listing left with 20 files, 6 photos | Run died after adds, before destroys | A re-run converges | [f896ee1e#11, #19] |
| Red run "contaminated" | Old `publish()` lacked the `sleep` kwarg | Use the stub-phase red run, disclosed | [f896ee1e#51] |
| Gallery shows old photos, "7 clip previews", then "3 copies" | Cults rebuilds the gallery only when a listing field changes; the deploy swaps assets after the field update | `details` "." toggle by hand; issue #4 | [f896ee1e#191-#208, #223] |
| `curl` gets 403 on the listing page | Cloudflare bot block | IDE browser | [f896ee1e#175] |

## Quotable Lines

1. Operator [f896ee1e#0]: "/niko  The most-recent cults3d publishing work failed in a new way". The weary opener.
2. Assistant [f896ee1e#18]: "The same photo uploaded fine three times in a row, so the file is not the problem; the failure is intermittent on Cults' side." Proof by experiment.
3. Assistant [f896ee1e#56]: "Cults sometimes fails to fetch a good GitHub URL."
4. Assistant, working notes [f896ee1e#51]: "Wait, that red run against the old code is actually contaminated". TDD honesty.
5. Operator [f896ee1e#186]: "there are dupes in the image gallery, still - including 7 clip previews...!!"
6. Assistant [f896ee1e#187]: "'7 clip previews' suggests these aren't your photos at all." The reframe.
7. Operator [f896ee1e#201]: "I've got 3 copies of the photos visible now, both logged-in and logged-out :(" The low point.
8. Operator [f896ee1e#201]: "update/publish should SET the images on the model to exactly the ones that are in the repo - it is correct to throw anything else out..." The right contract, aimed at the wrong suspect.
9. Assistant [f896ee1e#223]: "Your dedupe was never the problem. Cults kept serving an old cached copy of the gallery."
10. Assistant [f896ee1e#223]: "I set the empty `details` field to "." and straight back to empty, which made Cults rebuild the page." The absurd fix.

## Unique Technical Details

- Cults asset adds fail two ways on good URLs: "Could not download URL" in the payload, or a top-level `Unexpected error!` [f896ee1e#16, #56]. Retry worst case: about 100 s extra per failing asset [f896ee1e#37].
- Cults strips EXIF on upload and serves its own copies [f896ee1e#81].
- ExifTool via pre-commit: CPAN build, needs Perl and `cpan`, about 100 s the first time; it can't write SVG, BMP or ICO [f896ee1e#89]. Pre-commit reports "Failed" when a hook modifies files [f896ee1e#77, #85].
- Cults page quirks: carousel clones; an automatic 3D preview per STL; deleted image URLs still return 200 [f896ee1e#180, #187, #193].
- Gallery rebuild happens only when a real field change bumps `updatedAt`; asset create/destroy and no-op updates don't [f896ee1e#195, #199, #223].
- No "set assets" mutation exists. Unused ones: `createIllustrations`, `createBlueprints`, `createChangeNotification`, `updateIllustration` [f896ee1e#205, #206].
- Free-listing updates need `downloadPrice: 0` plus the current `licenseCode` [f896ee1e#194].

## Candidate Blog Angles

1. **Retrying a flaky third-party API**: the live probe, what not to retry, convergence on re-run. Audience: API integrators.
2. **"The dedupe was fine; the page was lying"**: carousel clones, STL previews, an `updatedAt`-keyed cache, and the "." toggle. Audience: Cults makers; anyone debugging API-versus-page mismatches.
3. **A metadata-stripping pre-commit hook for a maker repo** (neutral hygiene framing only): ExifTool from CPAN, Git LFS coexistence, a safe SVG stripper.

## Privacy Flags

- Operator-private material from this session is excluded from this extract by the operator's standing instruction. Do not reconstruct it from public repo metadata or speculate about it in posts.
- Personal identifiers (commit email, real name and Windows username in pasted paths, helper app id) and credential locations stay out.
