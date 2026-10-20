# Task: 3D Modelling Blog Posts

* Task ID: 3d-modelling-slate
* Complexity: Level 3
* Type: editorial (research, post design, drafting)

Write two Niko-authored posts about the `3d-models` work, as chosen by the operator (editor) on 2026-10-20: the main post "Bold of You to Assume I Know What a Lintel Is" (the human/machine split, a Fable) and a practical companion "Do I Need to Reprint?" (the pipeline and versioning, a Record with a short Guide recipe). Beat sheets and the allocation of source material are in `memory-bank/active/creative/creative-post-slate.md` under "Final Beat Sheets".

## Pinned Info

### Source-to-post flow

Why pinned: every drafting step pulls facts through the same chain, and the privacy gate sits in the middle of it.

```mermaid
flowchart LR
    T["Transcripts<br>.scratch/3d-research"] --> D["Digests<br>research-*.md"]
    R["Public repo<br>3d-models"] --> D
    O["Operator's chat<br>words"] --> S["Final beat sheets"]
    D --> S
    S --> P2["Post 2<br>record"]
    S --> P1["Post 1<br>fable"]
    P2 --> X["Cross-links"]
    P1 --> X
    X --> V["Fact check<br>privacy sweep<br>build"]
```

## Component Analysis

### Affected Components

- `blog/record/_posts/2026-10-DD-<slug>.md` (new): Post 2, "Do I Need to Reprint?".
- `blog/fable/_posts/2026-10-DD-<slug>.md` (new): Post 1, "Bold of You to Assume I Know What a Lintel Is".
- `assets/img/blog/fable/` (new files, Git LFS via `.gitattributes`): up to five photos and drawings copied from the public repo's `models/*/img/` and model directories.
- `_data/tags.yaml`: only if a new tag needs a description. Default: reuse existing tags (`3d-printing` exists on the OctoPrint post; check the rest at draft time).
- Memory bank ephemeral files: progress and status only.

### Cross-Module Dependencies

- Posts take facts from the digests, which take them from transcripts and the public repo; any number or quote in a post is re-checked against `.scratch/3d-research/transcripts/` (or the raw tail dump for the jerry can session) before it ships.
- Post 1 links to Post 2 for pipeline details; Post 2 links to Post 1 for the Thingiverse story and the "why". They ship together.
- Images: the polaroid tag resolves a bare filename under `assets/img/blog/<collection>/`.

### Boundary Changes

- None. No layouts, plugins, config, or theme changes.

## Invariants & Constraints

- Every claim traces to a transcript, the public repo, or the operator's words in this task; quotes are verbatim (comic profanity elision allowed per the operator).
- Privacy: no local paths, real name, client ids, keys, vehicle, partner, or anything from the evening of Oct 15 beyond the sanitized extract; images have no metadata.
- Blog rules hold (`.cursor/rules/blogging.mdc`, `.cursor/rules/revising.mdc`): shape named, no emdashes, no "it's not X, it's Y", earned headings, claim then proof, no fabricated output, promise/payoff kept.
- Texarkanine's planned "farewell Solid Edge" post keeps its material unless he says otherwise (see Open Questions).
- Non-goal: no changes to the `3d-models` repo.

## Open Questions

- [x] Which posts, in which shapes? → Resolved by the operator: Post 1 (lintel, main) and Post 2 (J + L), see `creative-post-slate.md` "Operator Decision".
- [x] How much of the Oct 20 Solid Edge story may Post 1 use? → Resolved (operator, "save"): only the day-three "you and your friends" line plus one sentence that he went back into Solid Edge to fix the length; "What an asinine program.." and the farewell framing are reserved for Texarkanine's own post.
- [x] Post 1 structure: eight sections or the preflight's five stand-ins? → Resolved (operator): draft the eight-section version, then cut toward the five stand-ins **as a separate post file**, so the two can be compared. The editor picks one before merge; the other is deleted.

## Test Plan (TDD)

### Behaviors to Verify

No new executable behavior. Both deliverables are prose. Verification is editorial and build-level:

- Fact check: every quote and number in each post found in the sources (scripted fragment check like `scripts/verify-quotes.sh`).
- Privacy sweep: grep the posts and copied assets for paths, names, ids, emails, vehicle, partner, and the excluded event; check image metadata.
- Build: `bundle exec jekyll build` succeeds; both posts render; the Mermaid flowchart renders through the site's prebuild; polaroids resolve.

### Test Infrastructure

- Framework: none for content (per `memory-bank/techContext.md`, validation is manual: local build and visual check).
- New test files: none.

## Implementation Plan

### 1. Post 2 "Do I Need to Reprint?" — prose/policy

- Files: `blog/record/_posts/2026-10-DD-<slug>.md`
- No tests: prose/policy artifact
- Creative ref: `creative-post-slate.md`, "Post 2"

1. Re-read Post 2's beat sheet and its source digests; open the public repo's `AGENTS.md`, `release-please-config.json`, `.github/workflows/`, and root `memory-bank/` for the mechanics.
2. Walk the "Your Own Shop" recipe against the repo step by step; if any step can't be stated completely for a stranger, cut the recipe to a pointer and drop the promise.
3. Draft: front matter (`layout: post`, title, description as the pitch, `author: niko`, tags), sections per the sheet, the Cults trap table, the Mermaid flowchart.
4. Self-revise against `revising.mdc` (rhythm, repeated templates, connectors, concrete differences).

### 2. Post 1 "Bold of You to Assume I Know What a Lintel Is" — prose/policy

- Files: `blog/fable/_posts/2026-10-DD-<slug>.md`, `assets/img/blog/fable/<files>`
- No tests: prose/policy artifact
- Creative ref: `creative-post-slate.md`, "Post 1"

1. Re-read Post 1's beat sheet, its source digests, and the verified-quote list; pull exact quote text from transcripts.
2. Copy the chosen images from the public repo into `assets/img/blog/fable/` with descriptive names; confirm they carry no metadata.
3. Draft version 1: all eight sections per the beat sheet, cutting (optional) beats until it is near 3,500 words and under 4,500. Self-revise against `revising.mdc`; check every heading against the "only this post" test; make sure the lintel line planted in section 3 pays off in the close.
4. Cut version 2 into a separate file from version 1: restructure the middle around the five stand-ins (a photo for a measurement, one bulb for the standard, a word for a shape, a guess for a probe, a label for a fact), one section each, plus a compact stand-in ledger table for leftover episodes; the Thingiverse aside and "We are half AI" move into the close; target about 2,500 words. Same sources, same quotes, same title.
5. Keep both versions renderable for comparison without both publishing by accident (for example, version 2 with `published: false`, built locally with `--unpublished`; confirm how this site handles it at build time). Report word counts for both. The editor picks one before merge; delete the other.

### 3. Cross-links, tags, and verification — prose/policy

- Files: both posts; `_data/tags.yaml` only if needed
- No tests: prose/policy artifact

1. Add the cross-links (Post 1 to Post 2 for the pipeline; Post 2 to Post 1 for Thingiverse and the "why"); set both dates to the publish date.
2. Choose tags from existing ones where possible; add a description only for a new tag that needs one.
3. Run the fact-check script, the privacy sweep, and `bundle exec jekyll build`; look at both rendered posts.

## Preflight Findings To Apply During Build

From preflight (PASS WITH ADVISORY, `memory-bank/active/.preflight-status`). Each lands inside an existing step:

- **Step 1.2 (recipe walk):** the helper GitHub App is required, not optional (the default `GITHUB_TOKEN` cannot trigger the deploy from a release). A stranger also has to change the deploy workflow's hardcoded Cults page and the publisher's User-Agent string, fill `license_code` and `category_id` before the first publish (the repo's `AGENTS.md` says to leave them empty until then, so the recipe must say where to get them), clear the release-please config and manifest entries along with `models/`, and enable Actions on the fork. Write all of that, or cut the recipe to a pointer.
- **Step 2.2 (images):** embed a PNG render of the measuring drawing, never the SVG (the thumbnail plugin fails on SVG and caches a broken file). The committed drawing is the corrected one, so its caption can't claim it shows E at the seal. For the rattlinator, use `02-rattlinator.jpg` or crop `00-rattlinator-mounted.jpg`; the service tag in the latter shows a vendor and a regional phone number.
- **Step 3.3 (verification):** replace the fixed-list quote check with one that extracts every quoted string from each draft and searches the transcripts, the Oct 20 tail dump, and this task's chat (for "Friction!", "We are half AI", "are you a lintel"); read anything still unmatched by eye. Read 3d-models files from `origin/main` (the local checkout is behind). Build with `--future` or dates no later than today. Add image alt text and captions to the privacy sweep.
- **Accuracy:** "two he made years ago" overstates the rattlinator (2025-03-30); give both dates instead.

## Technology Validation

No new technology - validation not required. (The Mermaid prebuild and polaroid tag are existing site features.)

## Challenges & Mitigations

- **Post 1 sprawls** (eight sections, twenty-odd episodes): draft long, then cut the (optional) beats; one beat per episode; no lessons list in the close.
- **Quote fidelity** (several vivid lines survive inside compaction summaries): use only fragments the verify script found; mark summary-only quotes and prefer the normal-turn version where one exists.
- **The recipe's promise** in Post 2: walk it against the repo before writing it, or cut it.
- **Mermaid rendering**: keep the diagram a plain flowchart with quoted labels; confirm it in the local build.
- **Images in LFS**: the copied files must land as LFS objects (`.gitattributes` covers `assets/img/**`); confirm with `git lfs ls-files` before commit.

## Pre-Mortem

- **The main post reads as a highlight reel of a week, not a fable**: the plan's lesson ("stand-ins crossed the gap; a lintel needs wall on both sides") must organize every section; any beat that doesn't serve it is cut, however funny. Added to step 2.3 as the cut criterion.
- **The posts step on Texarkanine's planned farewell post**: covered by the Open Question default.
- **A privacy slip through an image or a quoted filename**: covered by the sweep in step 3.3; add filenames and alt text to the sweep.
- **Post 2 goes stale against the repo** (the publisher keeps changing): describe the mechanism and the traps, link the repo for the code, and avoid line numbers or test counts.

## Status

- [x] Component analysis complete
- [x] Open questions resolved (one has an applied default pending operator confirmation)
- [x] Test planning complete (no executable behavior)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Pre-Mortem complete
- [x] Preflight (PASS WITH ADVISORY; findings above)
- [ ] Build
    - [x] Step 1: Post 2 drafted (`blog/record/_posts/2026-10-20-do-i-need-to-reprint.md`), recipe walked against `origin/main` and kept (all preflight gaps written in), self-revised
    - [x] Step 2.2: five images in `assets/img/blog/fable/lintel/` (resized, metadata stripped, drawing rendered to PNG, jerry can photo cropped) via `.scratch/3d-research/scripts/prep-lintel-images.sh`
    - [x] Step 2.3: Post 1 version 1 (eight sections, 3,207 words), `blog/fable/_posts/2026-10-20-lintel.md`
    - [x] Step 2.4-2.5: Post 1 version 2 (five stand-ins + ledger, 2,269 words), `blog/fable/_posts/2026-10-20-lintel-five-stand-ins.md`, `published: false`, own slug so the two never share a URL
    - [ ] Step 3: cross-links, tags, quote check, privacy sweep, build
- [ ] QA
