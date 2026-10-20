---
task_id: 3d-modelling-slate
complexity_level: 3
date: 2026-10-20
status: completed
---

# TASK ARCHIVE: 3D Modelling Blog Posts

## SUMMARY

Niko researched the operator's and its own work in the public `3d-models` repository (github.com/Texarkanine/3d-models). That work covered two models the operator made years earlier, two bulb holders Niko designed from his requirements, and a GitHub-release-to-Cults3D publishing pipeline. Niko proposed a slate of posts, and the editor picked two, which Niko drafted:

- **"Bold of You to Assume I Know What a Lintel Is"** (`blog/fable/_posts/2026-10-20-lintel.md`, Fable, about 3,200 words): the human/machine split in designing physical parts, told as a series of stand-ins that crossed the gap in place of the real thing.
- **"Do I Need to Reprint?"** (`blog/record/_posts/2026-10-20-do-i-need-to-reprint.md`, Record with a Guide recipe, about 3,300 words): the catalog, versioning ("a version number on a printable part answers one question"), the Cults3D API traps, and steps to run your own.

The posts cross-link and ship in one merge. QA passed on its second run. The editor's verdict on the lintel post: "What a banger".

## REQUIREMENTS

- Research every relevant conversation (stockroom across all worktrees, Cursor and Claude Code), plus the 3d-models memory banks, SumMem notes, and git/PR history.
- Propose post types with beat sheets; draft nothing before the editor picks.
- Draft the picked posts as Niko (`author: niko`), calling the operator "Texarkanine".
- Acceptance gates (added to the brief after preflight):
    - every quotation verbatim in a source;
    - privacy sweep clean;
    - local build passes with cross-links, Mermaid and polaroids rendering;
    - blog rules hold (`.cursor/rules/blogging.mdc`, `revising.mdc`).
- Standing editorial calls:
    - the evening of Oct 15 (an operator-private repository event) is excluded from everything committed;
    - quotes are free, profanity included, with comic elision allowed;
    - `made_with_ai` stays true catalog-wide by conviction ("We build and print. We are half AI.");
    - the operator's Solid Edge farewell lines are reserved for his own post;
    - no changes to the 3d-models repo.

## IMPLEMENTATION

### Research (Plan phase, creative exploration)

- **Sessions:** stockroom found 46 top-level sessions (Oct 12-20). Keyword SQL and an eight-query semantic sweep agreed the set was complete. Transcripts were dumped to `.scratch/3d-research/transcripts/` (local, gitignored), and nine subagent digests were committed under `memory-bank/active/creative/`. Those digests remain in git history at commit `261324a` on branch `3d-modelling`.
- **Timeline** (local UTC-5; Claude Code stamps are UTC):
    - Oct 12: the H7 request ("do you think you're up to the task..."), with v1 16 minutes later.
    - Oct 13: H7 iterations, with 7 preflight and 7 QA reviewer launches.
    - Oct 14: Thingiverse walled off by Cloudflare; Cults3D chosen; the monorepo built; release-please wired.
    - Oct 15: a day of Cults deploy failures; the H11 fit test "fits like a GLOVE".
    - Oct 16: clip rename; H11 holder and rattlinator released.
    - Oct 18: prong caps.
    - Oct 19: changelog contamination; the third Cults lookup bug; jerry can onboarded.
    - Oct 20: jerry can live. Four listings in eight days.
- **Slate:** twelve candidates (A-L):
    - A: the car is the gauge;
    - B: a publishing diary;
    - C: finished isn't shipped;
    - D: the print is the test;
    - E: a list of one;
    - F: made with AI;
    - G: the API is for browsers;
    - H: the lintel vocabulary fable;
    - I: a print ledger;
    - J: semver for printables;
    - K: an announcement;
    - L: a fork-this-shop guide.

  The recommendation was B, one design post, and C. The editor chose H as the main post, with every candidate's human/machine material folded in ("here we're a disjoint cyborg trying to do it"), plus J and L joined into one Record. K and F were left for Texarkanine's own post. The rationale: the human/machine split is the niche no other 3D-printing post covers, and the practical machinery serves a different reader.
- **Privacy:** local paths contain the operator's Windows username; vehicle and partner details are out; the Thingiverse client id is never quoted; the Oct 15 evening is excluded. Its notes live only in `.scratch/3d-research/private/`.

### Plan and Preflight

Three prose steps: Post 2, then Post 1 (drafted twice: eight sections, and a cut around the five stand-ins), then cross-links and verification. Preflight passed with advisories, all applied:

- The helper GitHub App is required, not optional. Release-please creates the release with its token, and GitHub starts no workflow for a release made with the default token.
- A stranger also needs to change the deploy URL and `USER_AGENT`, fill `license_code` and `category_id`, clear the release-please files, and set up Actions.
- The quote check must extract quotes from the drafts, not use a fixed list, and search the operator-chat corpus too.
- Embed the SVG drawing as a PNG, since the thumbnail plugin fails on SVG.
- Avoid the rattlinator photo with a vendor phone number in frame.
- Read 3d-models from `origin/main`, since the local checkout was stale.
- Amend the project brief before QA.

### Build

- **Post 2:** the recipe was walked against 3d-models `origin/main` and kept. The Cults3D traps went into a table. The Mermaid flowchart is two LR subgraph rows of three, because a six-box row was unreadable at the column width and a top-down chain was huge.
- **Post 1:**
    - Images in `assets/img/blog/fable/lintel/` (LFS, metadata stripped): the H7 cover, the H11 measuring drawing rendered to PNG, connector caps, and jerry can bumpers (cropped to drop a stranger's plate and a sign).
    - An H11 holder photo, later replaced by the operator with his own fit-test photo.
    - A script-drawn lintel-versus-shelf diagram, added in the editor pass.
- **Facts corrected against transcripts during drafting:** the forum post was three days before our first Thingiverse try; the first price failure never sent a price; the rattlinator waited a year and a half.
- **Editor pass:**
    - Kept the eight-section lintel post and deleted the cut ("a diary anyone could write where the cyborg is a sidenote").
    - Moved emphasis to the punchline block quote ("Bold of you to assume I know what a lintel is...").
    - Post 2 now opens by defining the catalog and naming all four models, and is charitable to Cults3D ("the one that worked").
    - Added a ramp before every concept that arrived cold (squash messages, `BEGIN_COMMIT_OVERRIDE`, the Oct 19 incident, `updateCreation`, STL previews, "creation").
    - Linked the Cults API page and explorer.
    - The recipe creates a new repository and copies the machinery with `cp` (operator: "forking is not a template").
    - The closer explains that all four models are still on version 1, so no print has needed replacing.
- **Helper app kept after operator pushback:** release-please works on the default token, but the deploy starts on `release: published`. GitHub's docs, re-checked during this task, say a default-token release starts no workflow.
- **Index order:** `date:` times put the lintel post (12:00) above the reprint post (09:00). If the publish day differs, rename both files and update `date:` and `post_url`.
- **Final touch:** the review-bot link points at the 3d-models review comment that caught the 0.01 mm clip miss. It came from the operator's own Cursor automation, not Bugbot.

### Files

- `blog/fable/_posts/2026-10-20-lintel.md`
- `blog/record/_posts/2026-10-20-do-i-need-to-reprint.md`
- `assets/img/blog/fable/lintel/*` (`h11-holder-and-halogen-bulb.jpg` is now unreferenced)
- Done by a parallel session in commit `7cd6a39`:
    - image-metadata pre-commit hook ported from 3d-models;
    - metadata stripped across `assets/`;
    - `byte-magazine-1996-ad` renamed `.webp`.

## TESTING

No automated suite for content. The checks are local scripts in `.scratch/3d-research/scripts/` (gitignored):

- **`check-draft-quotes.py`** extracts every quoted string and block quote from the posts. It searches the transcripts, the jerry can session tail, the operator's messages in this task, the editor's recorded decision, the author bio, and 3d-models `origin/main`, and finished at 0 missing.
- **`privacy-sweep.sh`** checks text, alt text, captions and image metadata. It was tested first against planted bad text, and came back clean apart from one hit approved by eye: the neutral photo-metadata hook in the recipe.
- **`check-rendered.py`** looks for broken local links and leaked Liquid or Markdown, and confirms the Mermaid figure became an SVG.
- **Builds:** `bundle exec jekyll build`, with and without `--unpublished`, exit 0.
- **Browser:** the pages, the flowchart, the trap table and the images were all checked.
- **`/niko-qa` run 1: FAIL (fixable).**
    - The recipe said "leave `cults_creation_id` out", but the deploy's write-back raises when the key is missing.
    - The heading "Curl Is Still Curl" was never paid off in its section.
    - Four advisories, all taken.
- **Run 2: PASS.** One prose advisory (the Git LFS sentence) was taken afterwards.

## LESSONS LEARNED

- **Fix the class, not the instance.** Preflight caught `AGENTS.md` and the publisher disagreeing about `license_code` and `category_id`. QA's recipe bug was the same mismatch on `cults_creation_id`, in the same sentence. When docs and the code that reads a file disagree on one field, check every field.
- **A heading drawn from a quote must show the quote in its section.** Check headings against the body in the same pass as the quote check.
- **The quote script proves a quote exists, not that it's placed right.** "Those both work!" was real, but it covered two caps, not the one the paragraph placed it after.
- **Mermaid on this site scales to the roughly 640 px column.** Keep about three boxes per row, using LR subgraph rows linked subgraph to subgraph. ImageMagick renders these SVGs blank, so only a browser proves a diagram.
- **Digests are maps, not sources.** Subagent digests carried small factual drift. Re-checking every fact against the transcripts caught it during drafting.
- **Editor craft (operator):**
    - One or two pull quotes at most, since a pull quote's punch drops as their number grows.
    - Ramp the reader into every concept before using it, because the reader has only the lines above.
    - A companion post must stand alone when read cold.
    - No shade, even implicit, on platforms that host us.

## PROCESS IMPROVEMENTS

- **Write drafts against transcripts, not digests.** Keep the digests as an index.
- **Drafting a main post twice for comparison worked** and cost little, since the research was already in context. The editor's choice was clear.
- **Ask the editor sooner about how a post opens.** "This project" assumed context only the sibling post had.

## TECHNICAL IMPROVEMENTS

- The quote, privacy and render checks could become committed tools if Niko-authored posts become routine; today they live only in `.scratch/`.
- 3d-models (outside this repo): `AGENTS.md` step 5 says `license_code` and `category_id` stay empty until the first publish, but the publisher requires them.

## NEXT STEPS

- Operator publishes both posts in one merge (branch `3d-modelling`, not yet pushed), with possible tag tweaks. If the publish day isn't 2026-10-20, rename both files and update `date:` and `post_url`.
- Optional: remove the now-unreferenced `assets/img/blog/fable/lintel/h11-holder-and-halogen-bulb.jpg`.
- Texarkanine's own planned post (a farewell to Solid Edge, maybe "the last 3d model I'll ever use") has its reserved material in the Oct 20 jerry can session tail.
