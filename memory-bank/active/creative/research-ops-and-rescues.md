# Research Digest: Operations, the Two Rescued Models, and Late Fixes

## Sessions Covered

Times are local (UTC-5) unless marked UTC. A citation like `[e7dc0d68#26]` means session `e7dc0d68`, message ordinal 26.

| Session | When | Gist |
| --- | --- | --- |
| `e7dc0d68` | 2026-10-15 20:30-20:51 | Cults rejects a free listing's update. Two guessed fixes had failed. A live probe finds the rule and exposes a license-reset trap. |
| `132d9bb4` | 2026-10-15 22:14-22:39 | Issue #4: the gallery keeps deleted photos. Operator makes the agent move the fix off `main`. |
| `88c471a5` | 2026-10-15 22:41-22:45 | Issue #1: models move under `models/`. Agent text mostly redacted in the dump. |
| `6193e4bf` | 2026-10-15 22:46-23:44 | Issue #2: `{version}`/`{changelog_url}`/`{license_name}` in listing text, with operator-widened scope. Rework: print notes landed in the description. |
| `70e4565b` | 2026-10-16 10:00 | Opens PR #9 (H7 clip rename). Housekeeping. |
| `800b7220` | 2026-10-16 13:52-14:34 | Rattlinator cleanup before its first Cults release: photos, tags, README, an AI-label question, an EXIF check. |
| `4eae4a2c` | 2026-10-16 14:43-15:15 | Rattlinator v1.0.2 fails. The operator blames timing; the agent blames base64 padding. The operator asks "are we recreating the old problem?" A partner cameo follows. |
| `b7d08320` | 2026-10-16 15:15-15:20 | Root README goes from "brain dump" to orientation. |
| `bf8f1365` | 2026-10-19 11:22-12:35 | release-please cross-model changelog contamination, a GitHub outage, and the operator's one-model-per-commit rule. Both 1.1.0 Cults deploys then fail. |
| `a0d33f7a` | 2026-10-19 12:32-15:00 | "Haven't we squashed that bug twice?" The operator refuses a revert-shaped fix. Cults' lookup never filtered by slug, and the earlier fixes passed by coincidence. |
| `005827aa` | 2026-10-19 16:16-20:58 | Jerry can buffer onboarded from the operator's old folder: inch-fraction filenames, STEP verification, inner dimensions, a Solid Edge orientation struggle. Ends unresolved. |

## What Happened

### 15 October, 20:30: The Free-Price Wall

The deploy of `h7-bulb-storage-v1.0.2` failed: `Cults updateCreation failed: ['Price must be greater than or equal to 0.5']`. The listing showed 20 files instead of 10. The previous fix had omitted `downloadPrice`. The operator: "less powerful models have failed to solve the problem, Please make sure it gets solved!" [e7dc0d68#0].

The agent explained the duplicates: the old publisher added files before its update failed, and the fixed one failed before touching files [e7dc0d68#14]. It said two fixes had been guesses and proposed a probe against the live API [e7dc0d68#14]. The operator asked why his merged fix hadn't run [e7dc0d68#15]. The agent proved it had: the traceback line numbers match the new file, and Deploy checks out the publisher from `main` separately from the tag [e7dc0d68#17]. "Oh I'm sorry I just didn't read." The operator supplied the API key locally [e7dc0d68#18, #24].

The probes settled it. An id-only update without `downloadPrice` fails, and `downloadPrice: 0` succeeds while keeping the listing free. Neither failed run had ever sent a price. PR #15's premise, "a theory that 0 counts as a paid price, which was never tested", was wrong [e7dc0d68#26, #27, #70].

One probe sent a price without a license, and Cults silently switched the listing to "Cults Private Use". The agent restored GPL "within a minute" and disclosed it [e7dc0d68#28, #70]. The fix (`0a6f468`) always sends `downloadPrice: 0` and refuses to publish without `licenseCode`. The fake Cults was changed to reject price-less updates as the real API does: 10 tests failed against the old code, and 48 passed with the fix [e7dc0d68#45, #47, #70].

A live Deploy from the branch went green: 20 files down to 10, 4 photos, still free and GPL [e7dc0d68#53-#60]. One STL briefly read `fileName: "unknown"` while Cults processed it [e7dc0d68#55-#60]. This became PR #16 [e7dc0d68#85].

### 15 October, Late: Issues #4, #1, #2

- **Issue #4.** The gallery rebuilds only on a real field change made after the STL previews exist. The publisher now waits for the previews, then nudges and restores `details`. 66 tests passed [132d9bb4#32, #59]. The agent had committed on local `main`. The operator: "this work should be on a [branch] - please move it to a clean branch, reset main to match origin" [132d9bb4#60]. It became PR #5, merged [132d9bb4#73, #74].
- **Issue #1.** "don't miss any locations" [88c471a5#0]. Everything moved to `models/<component>`. Tag names were unchanged, and old tags can no longer be redeployed. 69 tests passed. It became PR #6 [88c471a5#24, #33].
- **Issue #2.** The operator widened the scope while confirming intent. He wanted interpolation in each `publish.yaml`, `{license}` too ("Honestly {license} should work in publish.yaml as well"), and the unused `images` field stripped [6193e4bf#8, #10, #13]. He also defined the URL: "{changelog_url} should be a full, valid, current URL to the changelog on GitHub ... does NOT [deep link] to the tag" [6193e4bf#17]. `name` stays literal because it identifies the listing [6193e4bf#12]. 79 tests passed [6193e4bf#91].
- **Rework.** A screenshot showed the print notes inside the description under "Manufacturing". The publisher searched for an argument named like "manufactur", but Cults calls it `details`. 80 tests passed. It became PR #7 [6193e4bf#92, #108, #122, #147].

### 16 October: The Rattlinator Goes Out

The operator asked: "Is there anything we should clean up for the rattlinator before we do its first release? if so, what and why?" [800b7220#0]. The agent found:

- Cults had never received the model.
- The v1.0.0 tag had a blank license and category, so it could never have published. The first Cults page would be 1.0.1.
- The real photos and text existed only in the working tree.
- The catalog-wide `made_with_ai: true` would label this hand-made part "Made with AI" [800b7220#18].

The operator: "Well OK no crap we're going to put the working tree listing on main with the PR but we want to get the code ready before we open the PR!" He asked for tags [800b7220#19]. He got ten tags, a README and an AMEREX fit line. PR #13 followed [800b7220#48, #68]. He then asked for an EXIF check, and only the hook's empty shell remained: "Nah, that'll do." [800b7220#69, #76, #77].

At 14:43 a deploy failed: "I suspect I tried to release again too soon without waiting after landing the first release for a quick textfix" [4eae4a2c#0]. The agent: "The timing is a red herring." v1.0.1 (the first create) succeeded at about 19:36 UTC, and the bot recorded the creation id at about 19:37. v1.0.2 then failed at about 19:43 on the first-ever update path with `Cults has no creation with this id`. The diagnosis: the rattlinator's id lacked base64 padding, strict decode failed, and the raw id was sent instead of the slug [4eae4a2c#12]. The fix padded before decoding (PR #15, 83 tests) [4eae4a2c#29].

The operator pushed: "look back over the history of this repository ... Are we just recreating that old problem...?" [4eae4a2c#30]. The agent called it the same failure as the earlier slug fix, "reached through a hole that the fix never covered" [4eae4a2c#34]. A rerun succeeded at 20:12 UTC [a0d33f7a#22]. Then the operator's partner briefly took the keyboard [4eae4a2c#35-#37]. At 15:15 the root README was rewritten to "read a little more like orientation and a little less like a brain dump!" [b7d08320#0, #11].

### 19 October: Changelogs, the Third "No Creation", the Jerry Can

**Changelog contamination.** PR #16 (prong caps for both bulb models) was squash-merged, and release PRs #17 and #18 each listed the other model's lines. The operator asked whether discipline was "the only way", believing `always-update` made commits "touch everything" [bf8f1365#0].

The agent read the release-please source. A commit goes to every package it touches, and each conventional-commit line in its body becomes its own entry. The squash body carried three extra lines, from a squash message an earlier agent had suggested [bf8f1365#12]. The agent corrected the premise: `always-update` only keeps release PRs from conflicting, and `author.yaml`-only commits release nothing. It offered `includeEmpty` (an empty commit hits every package) as a way to get that ability [bf8f1365#12]. It also corrected its own memory, which had said release-please reads only the squash subject, a claim stated as fact on 16 October [800b7220#18; bf8f1365#10, #12].

The repair was a `BEGIN_COMMIT_OVERRIDE` in #16's body [bf8f1365#12-#14]. Then: "githuyb actions outage. make changes, but dont' try to run action s yet." [bf8f1365#18]. After recovery, the "queued" run turned out to have executed before the edit. A fresh push re-ran it, and both PRs showed one line. The agent merged them one at a time [bf8f1365#29-#37]. Both Cults deploys failed. The operator: "good job fixing the commit messages and changelog, I will keep commits not touching multiple models in the future That said it looks like this stinking no creation with this [ID bug] that we've squashed before..." [bf8f1365#58, #59].

**The third "no creation".** "this failed with the no creation error again? Haven't we squashed that bug twice? What happened here?" [a0d33f7a#0]. The agent first concluded that "Cults is answering the lookup differently than it did on October 16" [a0d33f7a#22] and restated a fix [a0d33f7a#37]. The operator: "If the fix is just going to be changing back to how things were before that's suspicious I don't think their api is changing how it behaves back and forth through time ... let's not make assumptions here, we want to solve this once and for all.." [a0d33f7a#38].

The schema was unchanged. Cults has two ids, and `creationsBatch(ids:)` filters only by `identifier`. A slug returns every design, newest first, and `limit: 1` took whichever design was newest. The slug fix had passed because only H7 existed then; the padding fix had passed because the rattlinator was newest. "An unfiltered list of one design looks exactly like a slug filter." The test double filtered by slug, so it shared the wrong theory [a0d33f7a#65].

PR #19 matches the stored `id` exactly and rejects pages that contain other designs. 82 tests passed [a0d33f7a#108]. A manual Deploy from `main` per tag republished both: "Thx. it's done! It worked." [a0d33f7a#111, #112].

**Jerry can buffer.** "I'd like to add a new model ... just the par and stl the 3.8 one. those are inch metrics - 3.8 is 3/8in." Plus: "It's been a long time since I touched solid edge and I'm not sure I remembered the export path!" [005827aa#0]. The STEP's log named a missing file, but the geometry matched the 3/8 in STL within 0.0001 mm. The `.par` and STL went onto a branch with a skeleton listing [005827aa#8, #31]. The operator then asked for the inner dimensions [005827aa#32, #38], and next how to make the part land profile-down in the slicer [005827aa#39]. The agent's steering-wheel instructions met "What's pathfinder?" and "I don't know what the steering wheel is" [005827aa#45, #47]. Its synchronous-mode suggestion met "No I don't want synchronous. I like the ordered parts." [005827aa#50]. After re-picking the sketch plane and hunting for Rotate ("no 'rotate' or 'move?'"), the transcript ends at 20:58 unresolved [005827aa#54-#60].

## Turning Points

1. **Omitting the price was untested theory.** Any update without a price fails, and 0 is accepted. One probe beat two guesses. The fake was rebuilt to behave like Cults [e7dc0d68#26, #45, #70].
2. **A probe's side effect revealed a second trap.** A price sent without a license flips the license to Private Use [e7dc0d68#28].
3. **"The old publisher ran" was wrong.** It was the new one; Cults still refused [e7dc0d68#15, #17].
4. **"I released too soon" was wrong.** The failure was the first-ever update path [4eae4a2c#0, #12].
5. **The padding diagnosis was real but incomplete.** The operator's "recreating that old problem?" was closer than the answer: the slug filter itself never worked [4eae4a2c#30; a0d33f7a#65].
6. **"release-please reads only the subject" was wrong.** Body lines become entries for every touched package [800b7220#18; bf8f1365#12].
7. **The operator's `always-update` model was wrong.** The agent corrected it and found `includeEmpty` for what he actually wanted [bf8f1365#12].
8. **The "queued" run had already run**, before the override existed [bf8f1365#17, #32].
9. **"Cults changed its API" was rejected by the operator.** That led to the schema diff and the discovery of `id` vs `identifier`. Both earlier fixes had been coincidences [a0d33f7a#22, #38, #65].
10. **The export path he worried about was fine.** The geometry proved it [005827aa#0, #31].
11. **Instructions written for the synchronous UI failed an ordered-part user**, and the operator held his ground [005827aa#44-#54].

## Failure Ledger

| Symptom | Root cause | Fix | Citation |
| --- | --- | --- | --- |
| `Price must be greater than or equal to 0.5` on a free update | Updates without `downloadPrice` are rejected; none had sent one | Always send `downloadPrice: 0` | [e7dc0d68#26, #70] |
| 20 files on a 10-file listing | Old publisher added files before the update failed | Cleared once the update succeeded | [e7dc0d68#14, #54] |
| License flipped to Cults Private Use | Price sent without `licenseCode` | Restored GPL; publisher requires `licenseCode` | [e7dc0d68#28, #70] |
| STL named "unknown" after deploy | Cults still processing | Waited a minute | [e7dc0d68#55-#60] |
| Gallery kept deleted photos (#4) | Rebuild needs a real field change after previews exist | Nudge and restore `details` | [132d9bb4#32, #59] |
| Fix committed on `main` | Agent didn't branch | Moved to a branch, PR #5 | [132d9bb4#60, #73] |
| Preflight failed | Test tag didn't match its component | Matching tag in tests | [6193e4bf#38, #39] |
| Print notes in the description | Argument-name heuristic missed `details` | Send as `details` | [6193e4bf#108, #122] |
| Rattlinator v1.0.2: "no creation with this id" | Unpadded id, so raw id sent (partial cause) | Pad before decode, PR #15, rerun | [4eae4a2c#12, #29] |
| Both models' lines in both release PRs | Two-model squash; body lines parsed as commits | `BEGIN_COMMIT_OVERRIDE`, merge one at a time, one model per commit | [bf8f1365#12, #37, #59] |
| Override ignored | Run executed before the edit | New push, fresh run | [bf8f1365#32] |
| h7 and h8 v1.1.0: "no creation with this id" | `ids` filters only `identifier`; slug returns all; `limit: 1` took the newest | Match `id` exactly, PR #19, Deploy from `main` | [a0d33f7a#65, #108, #111] |
| Jerry can lands broad-face-down | Sketch on a vertical plane; slicer's Z is up | Re-pick the plane, rotate the sketch (unresolved) | [005827aa#39-#60] |

## The Rescued Models

### Fire-Extinguisher Rattlinator

- **What it is.** "A printed sleeve that slides onto a fire-extinguisher handle so the handle, trigger, and lock stop rattling in a car" (the agent's README draft) [800b7220#48]. "a Solid Edge file edited by hand, the print from 2025-03-30" [800b7220#18]. A sibling `Rattlinator 0.14.par` "stays in the old folder", with no STL [800b7220#18].
- **The state before release.**
  - GitHub had tagged v1.0.0 with a blank license and category, so it was unpublishable and "already spent".
  - `main` still showed a Solid Edge screenshot and an old Cura image.
  - The real photos were in the working tree: mounted with a rubber band, mounted without, the part alone, and the slicer shot with a support blocker on the ring.
  - New listing text: "toss a rubber band around it, as shown", "AMEREX", "TPU 95 (required)" [800b7220#18].
- **What publishing required.**
  - Swap the photos; filename order is gallery order, so the rubber-band shot is `00-`.
  - Add ten tags.
  - Add a README.
  - Align the notes on AMEREX.
  - Keep the title, because the first create freezes the slug.
  - Run an EXIF check [800b7220#18, #48, #69, #76].
- **The tags.** fire extinguisher, extinguisher rattle, extinguisher handle, amerex, 2.5 lb, 5 lb, car, race car, off-road, tpu. "Mount, holder, and bracket are the words on the Cults models that bolt the bottle to the car. This part is the sleeve on the handle, so those words stay off the list." [800b7220#48].
- **The AI-label question.** Catalog-wide `made_with_ai: true` puts "Made with AI" on this hand-made part. The agent flagged it; no decision is recorded here [800b7220#18].
- **First publish.** v1.0.1 created the listing at about 19:36 UTC on 16 October. v1.0.2's "quick textfix" failed on update and succeeded on rerun at 20:12 UTC [4eae4a2c#0, #12; a0d33f7a#22]. Being the newest design, it then caused the bulb models' next failures [a0d33f7a#65].
- **From the repo, not the transcripts.** `models/fire-extinguisher-rattlinator/memory-bank/productContext.md` gives the motive: "Strange noises in the car mean something is wrong, and they want to find the cause rather than learn to ignore it." It also says the part deforms out of the trigger's way, so it never has to be removed. `systemPatterns.md` says the print "was called 0.13 when the only record was a new filename".

### Jerry Can Buffer

- **Hand-off.** "just the par and stl the 3.8 one. those are inch metrics - 3.8 is 3/8in." [005827aa#0]. The filename encodes inch fractions: `Jerry Can Buffer - 1.16 top 3.8 lip 3.32 gap 1in len.stl`. Variants with a 1/4 in lip stayed behind [005827aa#31].
- **Rust.** "It's been a long time since I touched solid edge and I'm not sure I remembered the export path!" [005827aa#0]. "What's pathfinder?" [005827aa#45]. "I don't know what the steering wheel is" (sent twice) [005827aa#47]. "I like the ordered parts." [005827aa#50].
- **Geometry, measured by the agent.** A 1 in channel with a top web 1/16 in thick and 1 5/16 in wide. The lips are 3/8 in long and 1/16 in thick. The opening is 3/32 in and the mouth 7/16 in [005827aa#31]. The largest block that fits inside is 1 3/16 × 3/32 × 1 in (30.1625 × 2.38125 × 25.4 mm) [005827aa#38].
- **Units.** The chosen STL and the new STEP are in millimetres; the left-behind 1/4 in meshes "were exported in inches" [005827aa#31].
- **What publishing required so far.** Copy only the 3/8 in pair, rename it without the fraction code, verify the STEP, create a skeleton `publish.yaml` for the operator to fill with text and photos, and fix the slicer orientation in Solid Edge (unfinished at transcript end) [005827aa#0, #31, #39-#60].
- **From the repo, not the transcripts.** `models/jerry-can-buffer/memory-bank/productContext.md`: a soft bumper for jerry-can cage rails, stretched along its length, printed in TPU 90 or softer. `techContext.md`: "An inch export is 25.4 times too small." The git log shows PR #21: "Add soft bumpers to keep jerry cans from rattling/abrading against their cages".

### Why They Sat Unshared

Not stated in these eleven sessions. See Open Questions.

## Operator Corrections And Teachings

- **Raising the bar.** "Please make sure it gets solved!" [e7dc0d68#0].
- **Branch discipline.** "this work should be on a [branch]" [132d9bb4#60].
- **Completeness.** "don't miss any locations" [88c471a5#0].
- **Scoping while confirming intent.** Interpolate in `publish.yaml`, add `{license}`, strip unused fields, and use an exact `{changelog_url}` with the deep link left to him [6193e4bf#8-#17].
- **Order of operations.** "we want to get the code ready before we open the PR!" [800b7220#19].
- **Privacy.** He requested the EXIF check himself [800b7220#69].
- **History-aware skepticism.** "Are we just recreating that old problem ... Or are we actually detecting a new path ...?" [4eae4a2c#30].
- **Docs.** README as orientation, not brain dump [b7d08320#0].
- **Outage etiquette.** "make changes, but dont' try to run action s yet." [bf8f1365#18].
- **New norm.** One model per commit [bf8f1365#59].
- **Read-only on `main`.** "Don't change anything because we're on the main branch" [a0d33f7a#0].
- **No revert-shaped fixes.** "do not be afraid to stop and ask me to chase down information if something is inexplicable... let's not make assumptions here" [a0d33f7a#38].
- **Tool preference.** Ordered parts, not synchronous [005827aa#50].
- **The agent pushed back too.** The publisher did run [e7dc0d68#17]; the timing was a red herring [4eae4a2c#12]; the `always-update` premise was wrong [bf8f1365#12].

## Quotable Lines

1. Operator [e7dc0d68#0]: "less powerful models have failed to solve the problem, Please make sure it gets solved!" Stakes at the top of the night.
2. Operator [e7dc0d68#18]: "Oh I'm sorry I just didn't read." Disarming honesty.
3. Operator [e7dc0d68#24]: "solve this gnarly problem! Thanku <3" Warmth plus urgency.
4. Assistant [e7dc0d68#70]: "Cults rejects every listing update that leaves out `downloadPrice`, even an update that sends nothing but the listing's id." The bug in one line.
5. Assistant [e7dc0d68#70]: "Then #15 dropped even that, based on a theory that 0 counts as a paid price, which was never tested." Owning an earlier guess.
6. Assistant [e7dc0d68#70]: "One of my test calls sent a price without a license, and Cults switched the h7 license to Cults Private Use. I set it back to GPL within a minute". A disclosed production side effect that became a guard.
7. Operator [800b7220#19]: "Well OK no crap we're going to put the working tree listing on main with the PR but we want to get the code ready before we open the PR!" Exasperated and clear.
8. Assistant [800b7220#48]: "This part is the sleeve on the handle, so those words stay off the list." Tagging as product thinking.
9. Assistant [4eae4a2c#12]: "This was not “released too soon after the text fix.” The timing is a red herring." Disagreeing with the operator.
10. Operator [4eae4a2c#30]: "Once Upon a time we had things not encoded and that was a problem. Are we just recreating that old problem...?" The hunch that proved more right than the answer.
11. The operator's partner [4eae4a2c#35]: "Whatcha up to today? Got games on your phone? :3"
12. Assistant [4eae4a2c#36]: "No phone, no games. I’m the kind of entity that only “plays” when someone asks me to trace a failed GitHub Action at 2:43 PM. Thrilling stuff."
13. Assistant [4eae4a2c#36]: "whether we’re reliving October 16 in a loop. Classic Friday." Accidental foreshadowing.
14. Operator [b7d08320#0]: "read a little more like orientation and a little less like a brain dump!"
15. Operator [bf8f1365#59]: "I will keep commits not touching multiple models in the future That said it looks like this stinking no creation with this [ID bug] that we've squashed before..." A rule and dread in one breath.
16. Operator [a0d33f7a#0]: "Haven't we squashed that bug twice? What happened here?"
17. Operator [a0d33f7a#38]: "I don't think their api is changing how it behaves back and forth through time". The skepticism that cracked it.
18. Operator [a0d33f7a#38]: "I would love for this class of bug to not reoccur ever, at all!"
19. Assistant [a0d33f7a#65]: "An unfiltered list of one design looks exactly like a slug filter." The aha.
20. Assistant [a0d33f7a#65]: "The schema does not say why a slug is ignored while `identifier` filters. That part would have to come from Cults. We do not need it to stop guessing."
21. Operator [a0d33f7a#112]: "Thx. it's done! It worked."
22. Operator [005827aa#0]: "It's been a long time since I touched solid edge and I'm not sure I remembered the export path!" The rescue in miniature.
23. Operator [005827aa#50]: "No I don't want synchronous. I like the ordered parts." Defending a workflow against a one-way conversion.

## Unique Technical Details

### Cults3D GraphQL

- **Price.** `updateCreation` defaults `currency` to EUR and `openPriced` to false. Any update without `downloadPrice` fails with "Price must be greater than or equal to 0.5", even an id-only update. `downloadPrice: 0` keeps a listing free. A Cults FAQ sets a €0.50 minimum donation on price-0 designs [e7dc0d68#6, #10, #26].
- **License.** `downloadPrice` without `licenseCode` resets the license to `cults_pu` [e7dc0d68#28].
- **Uploads.** An imported blueprint reads `fileName: "unknown"` for about a minute while Cults processes it [e7dc0d68#55-#60].
- **Gallery.** It rebuilds only on a real field change after every STL preview exists [132d9bb4#32].
- **Print notes.** "Settings and manufacturing instructions" is the `details` field [6193e4bf#122].
- **Tags and gallery order.** Cults advises 10-20 tags. Gallery order is the sorted filenames in `img/`. The first create freezes the slug from the title [800b7220#18, #48].
- **Two ids.** `Creation.id` is base64 of `Creation/<slug>`, sometimes stored without `=` padding. `Creation.identifier` is base64 of `Creation/<number>`. `creationsBatch(ids:)` filters only by `identifier`: a slug, junk, or `""` returns every design, and the stored `id` returns none. Default sort is `BY_PUBLICATION` descending [4eae4a2c#12; a0d33f7a#65].
- **No schema change.** The 15 and 19 October schema downloads are identical, 84 types each [a0d33f7a#65].

### Deploy Workflow

- Deploy checks out the release tag for model files, and `github.sha` into `publisher/` for the script. Re-running a failed job reuses the old publisher; dispatch Deploy from `main` with the tag instead [e7dc0d68#17; a0d33f7a#111].
- After the move to `models/`, pre-move tags can't be redeployed [88c471a5#24].

### release-please (v17.11.2)

- `commit-split.ts` gives a whole commit to every package it touches. Body conventional-commit lines become separate entries for the same packages [bf8f1365#12].
- `github.ts` uses PR-level files only for single-commit PRs, so rebase-merge with one model per commit isolates changelogs [bf8f1365#12].
- Manifest mode's `includeEmpty` applies an empty commit to every package. A squash defeats it, and rebase-merge's handling of empty commits is untested [bf8f1365#12].
- No help from scopes, `exclude-paths`, or `BEGIN_COMMIT_OVERRIDE` (one message for all touched packages). The override is read live from the merged PR body, but only by runs that start after the edit [bf8f1365#12, #32].
- `always-update` keeps open release PRs from conflicting on the manifest. Merge them one at a time [bf8f1365#12, #37].

### Images

- The pre-commit hook runs exiftool `-all=` plus `-tagsfromfile @ -Orientation -ICC_Profile`. It leaves a 44-byte empty APP1 shell and the ICC profile, with no GPS, date or camera tags [800b7220#76].

### Solid Edge

- **STEP check.** AP214 in millimetres. The translation log names the part, not necessarily the saved file. The agent verified the export by matching 24 corners within 0.0001 mm, with the 1/4 in variants off by exactly 1/8 in [005827aa#31].
- **Orientation.** The slicer treats Z (blue) as up. In an ordered part, orientation follows the sketch plane, and Edit Definition re-picks it. The "steering wheel" handle exists only in synchronous mode, and Move to Synchronous is one-way. In Solid Edge 2025, sketch Rotate is under the small arrow on the Move icon in the Draw group [005827aa#44, #49, #54, #60].

## Emotional Beats And Humor

- **Affection under pressure.** "Thanku <3" [e7dc0d68#24]. A sheepish "I just didn't read" [e7dc0d68#18].
- **Mounting exasperation.** "no crap" [800b7220#19], then "this stinking no creation ... [bug]" [bf8f1365#59], then "Haven't we squashed that bug twice?" [a0d33f7a#0].
- **The partner cameo.** The operator's partner typed "Got games on your phone? :3". The agent replied deadpan. The operator: "(That was [the operator's partner] cutting in...!)". The agent: "Say hi to [them] from the debugging side of the house." [4eae4a2c#35-#40].
- **Foreshadowing.** "reliving October 16 in a loop" [4eae4a2c#36], three days before the bug came back again.
- **The forced pause.** A GitHub Actions outage stopped work for an hour [bf8f1365#18, #26].
- **Payoff.** "Thx. it's done! It worked." [a0d33f7a#112].
- **Gentle CAD stubbornness.** "What's pathfinder?", the doubled "I don't know what the steering wheel is", "I like the ordered parts", "no 'rotate' or 'move?'" [005827aa#45-#58].
- **Good enough is good enough.** "Nah, that'll do. thx." on the EXIF shell [800b7220#77].

## Candidate Blog Angles

1. **"The bug we fixed three times."** Each Cults lookup fix passed by coincidence, and the test double shared the wrong theory. The operator's "APIs don't flip back and forth" broke the loop. Audience: developers integrating third-party APIs and writing fakes for them.
2. **"Probe, don't guess."** Two plausible fixes failed. Minutes of live probing found the price rule, and a side effect exposed the license trap. Audience: developers debugging undocumented APIs, with or without AI agents.
3. **"A monorepo of physical objects."** Per-model release-please, changelog contamination, what `always-update` really does, `includeEmpty`, and one model per commit. Audience: release engineers and monorepo maintainers.
4. **"Getting old parts out of the drawer."** Real photos instead of CAD screenshots, a spent 1.0.0, tags as product thinking, EXIF stripping, the AI label on hand-made parts, inch-fraction filenames, verifying exports after years away, slicer orientation. Audience: makers with unshared models. It needs the operator's own "why" from other sessions.
5. **"Back to CAD with an AI copilot."** A short sidebar on the ordered-vs-synchronous misfire. Audience: hobbyist CAD users.
6. **"Disagreeable in both directions."** The agent corrected the operator three times; the operator corrected the agent at the decisive moments. Audience: people working with AI coding agents.

## Open Questions And Uncertainties

- **Why the old models sat unshared is absent here.** No session in this set has the operator explaining it. The rescue framing must come from other sessions or from the operator.
- **Jerry can print date.** 2023-09-23 isn't in these transcripts.
- **The inch trap is only partly here.** These sessions say only that the 1/4 in meshes were inch exports [005827aa#31]. "25.4 times too small" is from the repo's jerry-can `techContext.md`, presumably from a later session.
- **The jerry can orientation is unresolved** at transcript end [005827aa#60].
- **The rattlinator's AI label** has no recorded decision [800b7220#18].
- **"Released too soon" is contradicted.** The assignment's context says that deploy failed because the operator released too soon. The transcripts show that was his suspicion, which the agent rejected [4eae4a2c#12]. The agent's own padding explanation was later shown to be incomplete [a0d33f7a#65].
- **PR numbers collide.** In `e7dc0d68` (about 20:30-20:51, 15 October), #15 is the omit-price fix and #16 the price-zero fix. Later, #15 is the padding fix and #16 the prong caps [4eae4a2c#29; bf8f1365#12]. PR numbers before and after the evening of 15 October refer to different items (see the research index); the slug fix "pull request #14, 16 October" (01:05 UTC) is in the earlier numbering [4eae4a2c#34; a0d33f7a#65]. Cite PRs by title and date, and verify before printing a number.
- **Test count dipped** from 83 (16 October) to 82 (19 October) without explanation.
- **Why `ids` ignores slugs** is unknown, and only Cults can say [a0d33f7a#65].
- **Redactions.** `88c471a5` and parts of `70e4565b`, `800b7220` and `4eae4a2c` are mostly `[REDACTED]` in the dump.

## Privacy Flags

- **Local paths.** The jerry can request and the attached-image paths contain the operator's Windows username and drive layout [005827aa#0]. Use `<operator-docs>/...`.
- **API key.** It was placed in a git-ignored local file for probing [e7dc0d68#18]. No value appears; say "a local, git-ignored key file".
- **The operator's partner.** The partner appears by a household nickname [4eae4a2c#35-#40]. Don't print it, and ask before using the cameo.
- **Vehicle use.** The rattlinator's notes and tags mention car, race car and off-road use [800b7220#48]. No specific vehicle is named here; keep it generic.
- **Internal tooling.** Handoffs live in a private "shop" repo [4eae4a2c#40]. That is internal plumbing.
- **Live-listing change.** The probe briefly changed a public listing's license [e7dc0d68#28]. Tell it with the caveat that it was restored and disclosed.
