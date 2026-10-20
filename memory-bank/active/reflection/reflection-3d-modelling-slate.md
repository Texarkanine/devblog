---
task_id: 3d-modelling-slate
date: 2026-10-20
complexity_level: 3
---

# Reflection: 3D Modelling Blog Posts

## Summary

Researched the `3d-models` work, proposed a slate, and drafted the two posts the editor picked: "Do I Need to Reprint?" (Record with a Guide recipe) and "Bold of You to Assume I Know What a Lintel Is" (Fable, drafted twice for comparison), with five images. Every gate passes, and QA passed on its second run after one fixable failure.

## Requirements vs Outcome

- Delivered: both posts, cross-linked; Post 1 in an eight-section version (3,247 words) and a five-stand-in cut (2,283 words, `published: false`, own slug); five images; local builds with and without unpublished posts; verified quotes; clean privacy sweep.
- Added: acceptance criteria in the project brief (preflight finding 9), and four reusable checks in `.scratch/3d-research/scripts/` (quote check over every quoted string, privacy sweep, rendered-page check, word count).
- Descoped or changed: the rattlinator photo was left out (a service tag with a phone number is in frame); the jerry can photo was cropped; version 2 is about 200 words under its "about 2,500" target; no tag descriptions were added (optional).
- Left for the operator: pick one Post 1 version; confirm the OctoPrint sentence in version 1's second paragraph, which changed mid-edit to wording I did not write; the 3d-models `AGENTS.md` line that says `license_code` and `category_id` "stay empty until the first publish", which the publisher's code contradicts (out of scope here).

## Plan Accuracy

The order held: Post 2, then Post 1 twice, then cross-links and verification. Every preflight finding landed where the plan said it would: the helper GitHub App is required, the drawing is a PNG, the rattlinator photo choice, the quote check rebuilt to read the drafts, 3d-models read from `origin/main`.

Surprises came from elsewhere:

- **Diagram sizing.** The plan said "a plain flowchart". On this site Mermaid SVGs scale to the column width, so a six-box row was unreadable and a six-box column was enormous. Two rows of three, as subgraphs, took three builds to find.
- **Drift in the digests.** Three beat-sheet facts were slightly wrong: the forum post was "nine days earlier" than Oct 20, but three days before our first Thingiverse try; one digest said the publisher sent a price of `0`, while the live probe showed it never sent one; the rattlinator had waited a year and a half, not "years". The plan's rule to re-check every fact against the transcripts caught all three.
- **A paraphrase of the docs.** The recipe turned `AGENTS.md`'s "`cults_creation_id` stays empty" into "leave it out". The publisher treats a missing key and an empty one differently, and QA caught it.

## Creative Phase Review

- **The two-post decision held.** The allocation map left no beat homeless and no beat told twice. Post 2 carries the id mechanics; Post 1 carries Texarkanine's "back and forth through time" as one line.
- **The lesson line organized both versions.** The beat sheet's line ("a photo for a measurement, one bulb for the standard...") structured version 1's close and every section of version 2. That made the second draft fast, since its outline was already in the first.
- **The recipe gate worked.** "Walk it against the repo or cut it" held: walking it surfaced the deploy URL, the User-Agent, the license and category lookup, and the helper app, and preflight had listed most of these already.
- **One beat merged two days into one.** The sheet put "So WTF is the API even FOR?!" right after "the same token works in his browser". The browser success was Oct 14, and the quote is from Oct 15. Drafting from the transcripts split them back apart.
- **One heading came from my memory of the transcript, not the draft.** "Curl Is Still Curl" was a line I knew but never wrote into the section.

## Build & QA Observations

- **Went well:** the quote script found every quotation verbatim on its first run, which pushed fact-checking into drafting rather than after it. The privacy sweep was tested on planted bad text first, so its clean result means something. Version 2 cost little because version 1's research was all in context.
- **Was hard:** the diagram layout, and one paragraph of version 1 changing under me between two edits (kept, and flagged).
- **QA run 1 found two real problems:**
    - The recipe line would have broken a stranger's first deploy at the write-back.
    - A heading named a line the section never said.

  It also made four fair advisories, all taken. Run 2 passed, and its one prose advisory was taken after QA.

## Cross-Phase Analysis

- **Preflight half-found the recipe bug.** It flagged one docs-versus-code mismatch in `publish.yaml`: `AGENTS.md` says leave `license_code` and `category_id` empty, but the code requires them. I fixed that instance in the recipe and didn't check the file's other fields against the code. `cults_creation_id` was the same kind of bug, in the same file and the same `AGENTS.md` sentence. The QA failure traces straight back to fixing one instance instead of the class.
- **Subagent digests, then my own re-checks.** The digests were good maps with small factual drift. The plan's "re-check against transcripts" step absorbed that drift during build instead of letting it reach QA or readers.
- **The quote check proves existence, not placement.** QA's cap finding is the example: "Those both work!" was a real quote, but my paragraph placed it after one cap when it covered two. A quote that passes the script still needs its context read.

## Insights

### Technical

- On this site a Mermaid diagram scales to the post column (about 640 px). Keep a row to about three boxes, and use LR subgraph rows linked subgraph to subgraph. ImageMagick renders these SVGs blank, so only a browser can confirm a diagram.
- `published: false` plus its own slug lets two versions of a post build side by side with `--unpublished`, and a normal build leaves the hidden one out of the pages, feed and sitemap.
- The polaroid tag resolves subfolder paths (`lintel/file.jpg`) and takes `alt=`. A 16-bit PNG can produce a thumbnail larger than the original, and the plugin then falls back to the original. That is harmless.

### Process

- When one field of a file turns out to have docs that disagree with the code that reads it, check every field of that file against that code before writing instructions about it.
- A post title or heading taken from a quote has to show that quote in its section. Check headings against body text in the same pass as the quote check.
