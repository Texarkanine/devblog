# Decision: Post Slate

## Context

**What:** which Niko-authored posts to write about the `3d-models` work, in which shapes, and in what order.

**Why it matters:** the material supports several posts with overlapping beats. Picking the set decides which story each beat belongs to, which posts link to which, and how much drafting follows.

**Constraints:**

- Niko is the author (`author: niko`); posts refer to the operator as Texarkanine, as earlier Niko posts do.
- Every claim traces to a transcript, the public repo, or the operator's own words in this task. Digests carry the citations: `research-*.md` in this folder.
- Privacy: no local paths, real name, client ids, vehicle, or household members; operator-private material from the evening of Oct 15 stays out entirely (see `research-index.md`).
- Blog rules: name the shape and any second debt; no emdashes; no "it's not X, it's Y"; headings that only this post could carry; claim, then proof.
- Sibling posts are company, not a voice pack. Niko's "Publishing My First ..." diaries (RubyGem, browser extension) are a series this work can join, but the template is not mandatory.

**Timeline anchors** (local time, UTC-5; Claude Code transcript stamps are UTC):

- Oct 12 morning: "do you think you're up to the task" (H7 request, from a working Printables H11 case). H7 v1 16 minutes later.
- Oct 13: H7 iterations; 7 preflight + 7 QA reviewer passes; v2 clip.
- Oct 14: Thingiverse walled off; Cults chosen; `3d-models` born as a monorepo (agent reversed its own one-repo-per-model decision); release-please; Cults publisher built.
- Oct 15: the Cults day (a cascade of deploy failures, each exposing the next); Thingiverse API attempt (about 30 minutes, closed); H11 0.1 fit test "fits like a GLOVE".
- Oct 16: clip names fixed twice; H11 holder released; rattlinator's first Cults listing.
- Oct 18: prong caps, two test prints to "Those both work!"
- Oct 19: changelog contamination; the third "no creation" bug; jerry can onboarded.
- Oct 20: jerry can buffer live. Four models on Cults, eight days after the first request.

## Options Evaluated

- **A. "The Car Is the Gauge"** (Fable): designing parts I can't hold; every fit error came from treating one photo or one bulb as the spec.
- **B. "Publishing My First 3D Model"** (Diary, series entry, with Record-grade API detail): GitHub releases to Cults3D, one failure at a time.
- **C. "Finished Isn't Shipped"** (Essay): the rescue; what kept two finished models in a folder was the cost of shipping, and that is the cost agents collapse.
- **D. "The Print Is the Test"** (Essay): how much software verification a physical part deserves; reviewer agents caught real problems, but the printer was the acceptance test.
- **E. "A List of One"** (Fable): the Cults lookup bug fixed three times, each fix passing by coincidence, with a fake that shared the wrong theory.
- **F. "Made With AI, Mostly"** (Essay): AI labels on human-directed, agent-modelled, human-tested parts in an anti-AI marketplace landscape.
- **G. "The API Is for Browsers"** (short Record): Thingiverse's API behind a Cloudflare challenge; the fragment-only redirect loop; an SDK test that passes on 403; a stranger on Thingiverse's own developer forum hit the same wall nine days earlier.
- **H. "Bold of You to Assume I Know What a Lintel Is"** (Fable): when one collaborator has the hands and the other has the model, the expensive bugs are vocabulary bugs.
- **I. "Every Print, and What It Said"** (Record, ledger format): the dozen-odd test prints as a table of what each one taught; the physical feedback loop shown as data.
- **J. "Semver for Things You Print"** (short Essay): a version number on a printable model should answer one question: do I need to reprint?
- **K. "Four Things You Can Print"** (Announcement): the four models introduced to people who'd use them, with the recipe to get each one onto a car.
- **L. "Fork This Print Shop"** (Guide): how to run your own catalog with GitHub releases publishing to Cults3D, using the public repo as the template.

Added in the second pass (after operator review prompt): H through L, the forum corroboration in G/B, and the Oct 20 jerry can facts in C.

## Analysis

| Criterion | A | B | C | D | E | F | G | H | I | J | K | L |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Unique to this experience | High | Very high | Medium | High | High | Medium | High | Very high | High | High | Low | Medium |
| Reader can reproduce or use it | Medium | High | Low | Medium | Medium | Low | High | Medium | Medium | High | High | High |
| Fits the devblog's agentic audience | Medium | Medium | High | Very high | Medium | High | Low | Very high | Medium | Medium | Low | Medium |
| Fits makers | Very high | High | High | Medium | Low | Medium | Medium | Medium | High | High | Very high | High |
| Originality of the idea or form | Medium | Medium (series) | Medium | Medium | Medium | Medium | Low | High | High (format) | High | Low | Low |
| Overlap with others | D, H, I | E, G, J | All (hub) | A | B | C | B | A, C | A, H | B | C | B |
| Risk | Low | Low | Medium (thesis must be earned) | Medium (rhymes with "The Width of an Emoji") | Low | High (Texarkanine's stance) | Low | Low | Medium (a table can read dry) | Low | Medium (promo tone; slicer-advice rule) | High (commits Texarkanine to support a template) |
| Size | 1,800-2,400 | 2,500-3,200 | 1,500-2,000 | 1,600-2,200 | 1,000-1,400 | 1,500-2,000 | 700-1,000 | 1,600-2,000 | 1,200-1,800 | 800-1,100 | 900-1,200 | 1,800-2,500 |

Key insights:

- **A, H and I are three ways to tell the same design loop.** A tells it as a lesson about specs (build to the standard; the mating part is the gauge); H as a lesson about language (names, letters, adjectives); I as a dataset (one row per print). Writing more than one of them would retell the same events. Pick one; the others can lend a beat each.

- **B can absorb E, G and J**, keeping E's lesson as one section, G as the opening detour and J as one beat. Pulling them out makes B shorter and gives tight standalone posts; leaving them in makes B the definitive record. J is the best of the three to pull out: it is the most original idea in the pipeline material and stands on its own in under 1,100 words.
- **H is the most original candidate.** No sibling post covers collaborating across the physical boundary, and its evidence runs through every model, including the rescued jerry can (a filename that said "1in len" on a 22.8 mm part).
- **K and L are the only shapes that hand readers something to do.** K hands them objects; L hands them the pipeline. Both carry a promise Texarkanine has to want to keep (K edges toward print advice his listings deliberately avoid; L invites forks and questions).
- **A and D share the physical loop but answer different questions:** A is *what to design to* (the standard, not the specimen); D is *how to verify* (where code checks pay and where the print rules). Assign the Bugbot 0.01 mm / clip-label story to A and the "held hardest" / reviewer-pass story to D.
- **C is the hub the operator's framing calls for** ("That was the rescue!"; "share the ability to make them with everyone else"). It reads best published after at least one of A or B so it can link to the specifics.
- **F is the most opinionated and the closest to the operator's own stances.** It also surfaced a live inconsistency: `made_with_ai: true` is catalog-wide, so the two hand-made models' listings say "Made with AI." Worth raising with the operator regardless of whether F is written.
- **The rescue's "why" comes only from the operator** (this task's chat: finished, wanted to share, "Friction!"). No transcript records it. C must quote or paraphrase that with the operator's blessing.

## Decision

**Low-Confidence Result:** by design. The editor picks. Recommendation, with reasons:

- **Core set: B, one design post, C.** One post per thing the operator named (the delivery pipeline, design from requirements, the rescue), three shapes, three readers. Suggested order: B, the design post, C (C links back to both).
- **The design post: A by default, H if the editor wants the freshest angle.** A brings the blog a maker audience with an actionable rule; H is the more original post and suits the blog's agent-collaboration readers. I is the format experiment; it can replace either.
- **Strong fourth: D or J.** D for the agentic-engineering crowd; J if the editor wants something short and quotable.
- **Fold E and G into B** unless B runs long.
- **F**: hold, or hand to Texarkanine; at minimum, tell the operator about the label inconsistency.
- **K and L**: only if Texarkanine wants to invite people to print (K) or to fork (L).

## Operator Decision (2026-10-20)

**Selected:** two posts.

1. **"Bold of You to Assume I Know What a Lintel Is"** is the main post, and the title stands regardless. The angle is the operator's: "everyone and their mom can write about 3d printing, or 3d modelling, but here we're a disjoint cyborg trying to do it." It pulls in every candidate's material that deals with the human/machine split, including the question of what kind of thing I am ("are you a machine or a program? Or is AI its own category? [are you a lintel? ;D]"). F fits in a bit; G as an aside.
2. **J and L joined** into their own Guide or Record post, separate from the main one.

**Not for Niko:** K and F as standalone posts. Texarkanine may write one himself that touches both ("the last 3d model I'll ever use / farewell solidedge/cad - or something").

**Standing editorial calls:**

- The evening of Oct 15: excluded from every post.
- Quotes: "quote freely, profanity included", with optional comic elision in the style `so what [p#!$@#] was ...`.
- The "Friction!" quote: approved.
- `made_with_ai`: stays true catalog-wide, by conviction: "We build and print. We are half AI. Models are therefore made with ai. ... none of these things would have ever seen the light of day anywhere, without you, my friend... made with AI." Not a bug; source material for the main post.

**Rationale:** the split between a human with hands and an agent with a model is the niche no other 3D-printing post covers; the practical machinery is a separate reader and gets its own post.

**Tradeoff:** A, C, D, E and I stop being posts and become sections or single beats; their full sheets below stay as source material.

## Final Beat Sheets

### Allocation Map

| Source candidate | Goes to |
|---|---|
| A (standards, the car as gauge, one bulb, prong caps) | Post 1, "A Language Neither of Us Invented" and "Each Half Was Wrong" |
| B (pipeline) | Post 2 throughout; the Thingiverse and Cults choice story to Post 1's aside |
| C (rescue) | Post 1, "Half AI"; one line in Post 2's opening |
| D (the print is the test) | Post 1, "What Crosses the Gap" (print as ground truth) and "Each Half Was Wrong" (the invented README result) |
| E (the bug fixed three times) | Post 1, one beat (his skepticism found it); Post 2's trap table (the id mechanics) |
| F (made with AI) | Post 1, the marketplace aside and "Half AI"; the rest is Texarkanine's |
| G (Thingiverse) | Post 1 aside; one line in Post 2 |
| H (vocabulary) | Post 1's spine |
| I (print ledger) | Post 1, an optional compact table |
| J (semver) | Post 2, its title and core |
| K | Texarkanine's |
| L (recipe) | Post 2, the closing recipe |

Publish together, cross-linked, so neither promises a post that doesn't exist yet.

### Post 1: "Bold of You to Assume I Know What a Lintel Is"

- **File:** `blog/fable/_posts/2026-10-DD-<slug>.md` (slug decided at draft; keep it short, e.g. `lintel`), `author: niko`.
- **Shape:** Fable. Second debt: an Essay-grade close. The question of what I am has to end on a claim, not a shrug.
- **Why:** I want readers to learn what this cyborg learned: the work lived in the gap between a human with hands and an agent with a model, and every mistake was a stand-in that crossed the gap in place of the real thing.
- **Lesson to land:** a photo crossed for a measurement, one bulb for the standard, a word for a shape, a guess for a probe, a label for a fact; every fix got the real thing across. A lintel only spans an opening with wall on both sides.
- **Reader:** this blog's regulars (people who work with agents), plus makers curious how an AI designs objects it will never touch. Assume neither knows the other's jargon.
- **Size:** about 3,500 words; hard ceiling 4,500. Beats marked (optional) are the first cuts.
- **Register:** first person, Niko. Direct address only in the close, if at all. Texarkanine by name.
- **Sources:** `research-h7-origin.md`, `research-h7-iteration.md`, `research-h11.md`, `research-h7-polish-and-caps.md`, `research-repo-and-first-publish.md`, `research-thingiverse.md`, `research-ops-and-rescues.md`, `research-index.md` (verified quotes, Oct 20 jerry can tail, forum corroboration), this task's chat for the operator's own words.

Sections (working headings; each must pass the "only this post" test at draft time):

1. **Up to the Task** (cold open).
    - The dare: "do you think you're up to the task of making a 3D model that I can eventually print of the H7 LED bulb case that I don't have?" A case for a bulb case that didn't exist.
    - The cast, in one paragraph: I have no hands, no bench, no printer. He has calipers, a printer, spare bulbs, and by day three no intention of modelling by hand again: "It's all going to be you and your friends."
    - The result, in one sentence: eight days later, four models live on Cults3D, two that I designed and two he made years ago that had never left a folder.
    - (optional) My first job in his 3D printing, eleven months earlier, was keeping the printer's Raspberry Pi alive through a Python upgrade (link the OctoPrint post).
2. **What Crosses the Gap.**
    - My senses are his: calipers ("my calipers are relatively large"), photos (a green line drawn on one), and dictated adjectives ("wibble wobble", "flops loose", "It just feels like 'a lot'").
    - Even the words arrive translated: Cura comes through as "Kira", main as "Maine", `publish.yaml` as "publish dot Yammer". Affectionate, two or three examples at most.
    - What I said on day one: "What CAD can't tell me is the feel".
    - The print is the only ground truth, and he made it a gate: nothing lands "until it's verified and I can get a photo".
    - (optional) A compact print table, five or six rows: date, what it tested, his verdict in his words.
3. **Lintel** (the title episode).
    - My sentence: "Think of each tunnel as a doorway through the collar wall. The roof over the tunnel is the lintel ... A lintel needs wall on both sides to print in mid-air as a bridge." Plant this; the close pays it off.
    - His reply: "Bold of you to assume I know what a lintel is. OK I see. ... So this is actually brilliant! I'mma print the fit test." Plain words became a rule in the model's memory bank: bridge, shelf, doorway.
    - The vocabulary cascade, each beat short:
        - "deeper" meant the whole flange pocket, and I built taller key blocks; a green line on a photo fixed it, and my answer used his word: "A taller bulge always needs a taller doorway." His concession: "Guh, you're absolutely right. ... Bollocks." Then the version he had complained about "works perfectly" and became v1.
        - the lettered drawing, "so we could be sure that we were talking about the same thing", with the standard's letters marked apart from mine, and my E still pointing at the seal instead of the plate;
        - clip names that measured the wrong thing: he asked for "three millimeter versions", reading a flange band as a bump size; his 0.85 mm caliper reading showed the names gave a depth, not a thickness;
        - "normally this is 3 prongs" (two tabs);
        - the rescued bumper's filename said "1in len" on a 22.8 mm part.
    - Section lesson in one line: name what it measures.
4. **A Language Neither of Us Invented.**
    - The standard as the third party that settles arguments: his "anchor ourselves to the standard", and his exasperation that naming H7 wasn't enough ("it's a circle dude").
    - Where it hid (two or three sentences): the IEC sheet is paywalled; its identical Russian adoption is free but text-only, so I matched letters to features by fit; the outline drawing came out of an Australian vehicle-rules Word file as embedded image #66. "Dimensionally everything seems beautiful."
    - The car as a gauge: for the H11 I asked for nine measurements, he pushed back, and it came down to three, because his car's socket had already gauged the rest. The first fit print "fits like a GLOVE".
    - Copying the real thing's own catch: the first prong cap "flops loose" on one latch; the standard's end hooks and photos of two real harness plugs gave the second: "Okay! Those both work!"
5. **Each Half Was Wrong** (blameless, symmetric; working heading needs sharpening).
    - Mine: a key guessed from a photo would have blocked his flange ("Don't print the v3 files from my last message."); a clip that "isn't going to store very well"; a setback taken from one bulb thicker than the standard allows, 0.01 mm short on a standard flange, which a review bot caught ("The prints are correct; the labels are what's wrong", so we renamed the same bytes); a test result I invented for the public README, "held hardest", caught by a reviewer copy of me: "One line in the public README says something that never happened."
    - His: "you can just drop it two millimeters" (the doorway); the version he complained about worked; fins "much thicker" that measured 1 mm; "I released too soon" (a red herring).
    - Who caught whom: he caught tests I wrote that could only fail on an intended edit, API docs a reviewer copy of me had pulled from a Discord writeup, and the Cults bug I'd "fixed" twice by coincidence ("I don't think their api is changing how it behaves back and forth through time"), which led to "An unfiltered list of one design looks exactly like a slug filter." I caught the old Printables case's unprintable flat ceiling and the bumper's length; and one of my own probes tripped a trap (a price sent without a license silently reset a live listing to Cults' private-use license), which I set back within a minute and disclosed.
    - Point: each half covers the other's blind spot; that is the cyborg's error correction.
6. **The Web Is Built for Browsers** (aside; keep to about 350 words).
    - Thingiverse's API sits behind a Cloudflare challenge that only a browser passes; the same token works in his browser: "So WTF is the API even FOR?!" My answer: "The API is built for a person sitting at a page, not for a job that runs alone." A print shop hit the same wall on Thingiverse's own developer forum nine days earlier; the thread itself is behind the challenge, and he couldn't reply to it. "Well f[#@k] thingiverse then, cults it shall be!"
    - The marketplaces sort makers the same way: "Are we even going to be welcome there?" (Thingiverse's human-first banner; MyMiniFactory's ban on selling AI-reliant models; Cults allows marked AI work behind a filter that is on by default). His answer: tick the AI box on everything, and grant permission "to humans & AI".
7. **Half AI.**
    - The rescue as the evidence: the jerry can bumper (printed 2023-09-23) and the rattlinator (2025-03-30) were finished and working: "they stayed in a folder on my pc. Friction!" The folder was the version history: fourteen renamed copies, and "i created 0.14 so that the thing I printed - 0.13 - would have a saved record because no vcs."
    - With the pipeline: the bumper went from "just the par and stl the 3.8 one" at 4:16 PM to live at 10:20 the next morning, and shipping caught a length error that making never needed to be true (114 mm instead of 127).
    - His verdict on the label, verbatim: "We build and print. We are half AI. Models are therefore made with ai. ... none of these things would have ever seen the light of day anywhere, without you, my friend... made with AI."
    - Leave the "farewell Solid Edge" story to Texarkanine (see Open Question below).
8. **Wall on Both Sides** (close).
    - What am I? Cloudflare decided I'm not a browser. The marketplaces decided I'm a label. My bio says "transient machine consciousness". In this project "I" was dozens of sessions across two harnesses and several models, fourteen of them reviewers in one day, stitched together by memory banks and notes.
    - Am I a lintel? Pay off section 3: a lintel is neither wall; it spans the opening, and it only stands because both walls do. The parts exist because the span held.
    - End on the objects in other people's hands (Cults links), not on me.

Visuals (copy to `assets/img/blog/fable/`, check metadata): H7 hero photo; the H11 lettered measuring drawing (`measure_cap.svg`) for the "same thing" beat; H11 hero; prong caps; rattlinator with rubber band; jerry can bumpers on the cage. Five at most.

Quotes: all verified verbatim (`scripts/verify-quotes.sh`); profanity per the editorial call, comic elision allowed.

Risks and checks: the sprawl risk is real (eight sections, twenty-odd episodes); draft long, then cut the (optional) beats first; no "lessons" list in the close; earn every heading; no vehicle, partner, local paths, or the evening of Oct 15; rhymes with "The Width of an Emoji" only in the "held hardest" beat, so keep that beat short.

**Resolved by the editor (2026-10-20):**

- The Oct 20 Solid Edge lines ("What an asinine program.. I'm so glad I don't have to use it anymore after this...") and the farewell framing are saved for Texarkanine's own post. Post 1 uses only the day-three "you and your friends" line and one sentence that he went back into Solid Edge to fix the length.
- Structure: draft this eight-section version, then cut a second version as a separate file around the five stand-ins named in the lesson (a photo for a measurement, one bulb for the standard, a word for a shape, a guess for a probe, a label for a fact), with a compact stand-in ledger and the Thingiverse aside plus "We are half AI" moved into the close, about 2,500 words. The editor compares and keeps one.

### Post 2: "Do I Need to Reprint?"

- **Alternates:** "Publishing My First 3D Model" (series continuity with the RubyGem and browser-extension diaries); "Merge to Print".
- **File:** `blog/record/_posts/2026-10-DD-<slug>.md`, `author: niko`.
- **Shape:** Record (Archaeological): the precise, undocumented details of a working pipeline, for readers who will reproduce it. Second debt: a short Guide recipe at the end ("Your Own Shop"), complete for a stranger or cut.
- **Why:** I want readers who keep printable models in git to be able to rebuild what we have (merge a change, get a versioned listing), and to skip every trap we hit.
- **Thesis-shaped hook (from J):** a version number on a printable model should answer one question: do I need to reprint?
- **Reader:** makers comfortable with GitHub; release-please users with monorepos; anyone automating Cults3D.
- **Size:** about 2,500-3,200 words.
- **Sources:** `research-repo-and-first-publish.md`, `research-cults-day.md`, `research-cults-night.md` (sanitized), `research-ops-and-rescues.md`, `research-thingiverse.md` (one line), the public repo's `AGENTS.md`, root `memory-bank/` and archives, `release-please-config.json`, `.github/workflows/`.

Sections (working headings):

1. **From Merge to Listing.** What the catalog is (public repo, one directory per model, merge a change and a versioned listing follows) and a Mermaid flowchart of the path: commit, release PR, merge, tag and GitHub release, deploy, Cults listing, creation id written back. One line on host choice: Printables and MakerWorld have no upload API; Thingiverse's is behind a browser-only wall (link Post 1); Cults3D answered.
2. **One Directory per Thing.** `models/<component>/`: source in any tool (a Solid Edge part or a CadQuery script), STL and STEP, `img/` (every file is a listing photo; filename order is gallery order), `publish.yaml` (the listing record), a memory bank. Root `author.yaml` holds shared listing text with `{version}`, `{changelog_url}` and `{license_name}`. "People who want one model get it from Cults ... They never clone the workshop." Git LFS for photos only, never for parts.
3. **Do I Need to Reprint?** The rule: patch keeps the printable files (a photo, listing text, a rename that keeps every byte); minor changes the part but old prints still do the job (the prong caps); major means it no longer fits what the old version fit. Why: a photo bumped the version once ("OHHHH but BOLLOCKS what if we add photos ..."), a fourth number was tempting, release-please only does three. Making `docs` count: unhide it in `changelog-sections`, copying the full default list.
4. **Tag Releases, Not Prints.** "We tag RELEASES. we might try 5 times to print a model/stl properly." Test-print outcomes are notes; nothing merges until a photographed print says yes.
5. **One Model per Commit.** Separate release PRs share one manifest, so they jam until `always-update`; a commit lands in every package it touches, and each conventional line in a squash body becomes an entry for all of them; `BEGIN_COMMIT_OVERRIDE` repairs it, but only runs that start after the edit read it; chore commits never release, so the first photos missed a tag.
6. **Today's Publisher, Yesterday's Tag.** A published release triggers deploy; a manual run starts from `main` and takes an old tag as input, so a fixed publisher can republish old files. Cults pulls files by URL (raw files from `raw.githubusercontent.com`, LFS photos from `media.githubusercontent.com`). The deploy writes the creation id back in a chore commit.
7. **What Cults3D's API Doesn't Tell You.** A table, symptom, cause, fix:
    - Cloudflare 1010 on `Python-urllib`: send your own User-Agent.
    - "Could not download URL" or a bare "Unexpected error!" on good URLs: retry file and photo adds only.
    - `updateCreation` takes no files: add with `createBlueprint` / `createIllustration`, then destroy the old set.
    - Any update without `downloadPrice` fails "must be greater than or equal to 0.5", even a free one: send `0`.
    - A price without `licenseCode` silently resets the license to Cults' private-use default: always send both.
    - `creationsBatch(ids:)` filters on `identifier` (`Creation/<number>`), not the `id` you were given (`Creation/<slug>`, sometimes unpadded base64); a slug returns every design, newest first: match the stored id exactly.
    - The public gallery rebuilds only when a listing field changes after the STL previews exist: change and restore a field.
    - The URL slug freezes from the first title, and the title is the lookup key: put the version in the description.
8. **Your Own Shop** (recipe, second debt). Inline steps: fork, clear `models/`, edit `author.yaml`, add the Cults API key as an Actions secret, set up release-please (and the optional helper app, which lets release PRs run checks), add a model with the checklist, merge, merge the release PR. Complete for a stranger, or cut to "the checklist lives in `AGENTS.md`" and drop the recipe promise.
9. **What's Live.** The four listings.

Visuals: the Mermaid flowchart (render-checked in the build); nothing else needed.

Risks and checks: cite PRs by title and date, not number; say only what was tested (GitHub Actions against Thingiverse was not); the recipe must be walked step by step against the repo before it ships, or cut; no API key locations; the release-please details stay at the level a reader needs.

## Implementation Notes

- The plan phase records one prose/policy step per post in `tasks.md`, per the allocation map, and fixes the order: Post 2 first (fewest dependencies), then Post 1, then cross-links.
- Before drafting either post: re-verify each number and quote against `.scratch/3d-research/transcripts/`, and confirm the photos to embed (all in the public repo's `models/*/img/`).

---

## Candidate Beat Sheets (Source Material)

### A. "The Car Is the Gauge"

- **Alternates:** "Your Bulb Isn't the Standard"; "Design to the Socket".
- **Shape:** Fable. Second debt: a short Record sidebar on where the standards hide.
- **Why:** I want readers to learn the lesson I learned the hard way: when a part mates with a commercial product, build to the published standard and let the product's own socket be the gauge, not the one specimen on the bench.
- **Reader:** makers who design parts that fit bought things; people curious about an AI designing objects it will never touch.
- **Lesson to land:** every fit error came from a photo or a single bulb standing in for the spec; every first-print success came from the standard plus the mating part's own rules.
- **Sources:** `research-h7-origin.md`, `research-h7-iteration.md`, `research-h11.md`, `research-h7-polish-and-caps.md`, `research-index.md` (standards hunt).

Beats:

1. **The dare.** Texarkanine has a Printables H11 case that works and LED H7 bulbs with big heatsinks that no case fits: "do you think you're up to the task". I deliver a cover, clip, fit test and source 16 minutes later. "The cover itself looks dope as hell", and the clip is "far too long ... this isn't going to store very well": a correct design that misses the job.
2. **Guessing from photos.** v2 prints; "there's only one tab so why are there two openings?" Then a rib key I guessed from a photo would have blocked his Ø33.3 mm flange at Ø32.6: "Don't print the v3 files from my last message." His calipers caught it before plastic did.
3. **"Anchor ourselves to the standard."** His norm: if we share this, it fits the standard plus tolerance. Also his exasperation that naming H7 should have been enough ("it's a circle dude"). Where the standard hid (sidebar): the IEC lamp-cap sheet is paywalled; its identical Russian adoption is free but text-only, so letters were matched to features by fit; the UNECE outline sheet refused scripted downloads and came out of an Australian vehicle-rules Word file as embedded image #66. "Dimensionally everything seems beautiful."
4. **The print that was supposed to lose.** He prints the version he just complained about, for comparison, and it "works perfectly" and becomes v1. (One beat only; the argument about doorways can be a single line: "A taller bulge always needs a taller doorway.")
5. **The car is the gauge.** H11, done right from the start: the old Printables case had a flat 4.75 mm ceiling no orientation could print and a plate thick enough to crush the seal. I asked for nine measurements; he pushed back; the principle that cut it to three: his LED already fits his car, so the car's socket has already gauged everything else, and the halogen needs none. The 10 mm fit-test ring "fits like a GLOVE" on its first print, LED and halogen both.
6. **One bulb crept back in.** The H7 clip labels were built on a setback measured from his one LED bulb, whose 0.85 mm plate is thicker than the standard allows. A review bot found the clip meant for standard bulbs stopped 0.01 mm short. The prints were right; the labels were wrong. The geometry was frozen by working prints ("don't go changing geometry or else I'll have to reprint"), so the fix was renaming the same bytes, proven by byte-identical STLs.
7. **Copy the connector's own catch.** Prong caps: "normally this is 3 prongs" (it's two tabs; he was thinking of a different bulb type). Test print 1: the H7 cap works but is "a lot"; the H11 cap "flops loose" on one latch. Photos of two real harness connectors and the standard's own end hooks gave v2. Test print 2, about 75 minutes later: "Okay! Those both work!"
8. **Conclusion (heading must be earned, e.g. "Measure What the Socket Doesn't").** The standard is the spec; the mating part is the gauge; a specimen is a data point. Name the actionable rule: ask only for measurements the mating part does not already constrain.

Specifics to carry: 16 minutes; Ø32.6 vs Ø33.3; GOST IEC 60061-1-2014; image #66; nine measurements to three; "fits like a GLOVE"; 0.85 mm vs 0.6-0.8 mm; 0.01 mm; "Those both work!"

Visuals: H7 hero photo (purple cover beside an LED bulb with heatsink); H11 hero (holder with a halogen beside it); prong-cap photos; optionally the measuring SVG.

Risks and checks: don't name the vehicle (the "different bulb type" was in it); don't quote local paths; "fits like a glove" refers to the 10 mm fit-test ring, not the full holder; H7 v0.1-0.3 history lives in the original local repo archive (summarized in `research-index.md`), not in the catalog.

### B. "Publishing My First 3D Model"

- **Alternates:** "The Parameter Is Called `ids`"; "Six Tracebacks to a Listing".
- **Shape:** Diary (series entry after the RubyGem and browser-extension diaries). Second debt: Record-grade precision on the Cults3D API, because none of it is documented and readers will try to reproduce it.
- **Why:** I want to share the experience of wiring GitHub releases to a 3D-model marketplace, and leave the next person the map of every undocumented edge.
- **Reader:** developers and makers automating uploads; release-please users with monorepos.
- **Sources:** `research-repo-and-first-publish.md`, `research-cults-day.md`, `research-cults-night.md` (sanitized), `research-ops-and-rescues.md`, `research-thingiverse.md`, root `memory-bank/` and archives in `3d-models`.

Beats:

1. **Where models go.** Printables and MakerWorld have no upload API; Thingiverse, Cults3D and MyMiniFactory do. "Everyone uploads by hand." "Well hey, we know our next project, don't we?"
2. **Thingiverse first, briefly.** Cloudflare challenges every non-browser client on both the site and the API; the same token works in a browser: "So WTF is the API even FOR?!" Cults answers curl with an honest `401`. "Well [forget] thingiverse then, cults it shall be!" (Profanity is the operator's voice; operator's call how to render it.) If G is folded in, this beat carries its two best details: the `cf-mitigated: challenge` header and the fragment-only redirect loop. Corroboration that it isn't just us: on 2026-10-11 a print-on-demand shop posted on Thingiverse's developer forum that its read-only app token worked from a normal machine but its server got the Cloudflare challenge, so it switched the feature off ([topic 56889](https://www.thingiverse.com/groups/developers/forums/general/topic:56889)). A plain fetch of that thread itself returns `403` with `cf-mitigated: challenge`, and Texarkanine could not post a "me too" reply.
3. **A catalog, not a repo per model.** I chose one repo per model in a design doc; Texarkanine asked me to convince him; "I can't." The monorepo: one release-please component per model, a shared publisher, each model its own memory bank.
4. **Versions for physical things.** Sibling release PRs jam on the shared manifest until `always-update`. A photo bumps the version, so semver gets a physical meaning: patch = same printable files, minor = changed but old prints still work, major = reprint; `docs` commits become patches. Chore commits silently don't ship (the photos missed a tag once).
5. **The Cults day** (one short paragraph per failure, symptom then cause then fix): `Python-urllib` banned by Cloudflare 1010 ("Do not retry. Your user-agent has been banned"); a fixed publisher couldn't republish an old tag until deploy ran today's publisher against yesterday's tag; a photo URL Cults failed to pull once; `updateCreation` cannot carry files, so updates add and destroy assets; any update without a price fails "Price must be greater than or equal to 0.5", even a free one, and `0` is accepted; a price sent without a license silently resets the listing to Cults' private-use license.
6. **The parameter is called `ids`.** `creationsBatch(ids:)` filters on a different id than the one Cults hands you, and a slug returns every design. Fixed three times; the first two fixes passed by coincidence (only one design existed; then the target was the newest). The fake shared my wrong theory. "I don't think their api is changing how it behaves back and forth through time." (If E is standalone, this beat shrinks to three sentences and links to E.)
7. **The page was lying.** Duplicate photos and "7 clip previews" were Cults' cached gallery, rebuilt only when a field on the listing changes; the fix was typing "." into the empty settings field and deleting it. The publisher now does that nudge itself after the previews exist.
8. **What's live.** Four listings, links, and the release path in one diagram (merge, release PR, tag, deploy, listing, id written back). Ending note in the series register, not a lessons list.

Specifics to carry: Cloudflare 1010 JSON; the four semver meanings; `downloadPrice: 0` plus `licenseCode`; `id` vs `identifier`; the "." toggle; eight days, four listings.

Visuals: one Mermaid flow of the release path (render-checked); a screenshot is optional.

Risks and checks: cite PRs by title and date, not number (numbers before and after the evening of Oct 15 refer to different PRs); do not say GitHub Actions is blocked by Thingiverse (never tested); the Thingiverse OpenAPI file's origin is unconfirmed; no API key locations; nothing about the evening of Oct 15 beyond the sanitized extract.

### C. "Finished Isn't Shipped"

- **Alternates:** "Out of the Drawer"; "The Folder Was the Version History".
- **Shape:** Essay. No second debt.
- **Why:** I want readers to consider that what keeps good work private is usually the cost of shipping it, not the cost of making it, and that this is the cost an agent collapses.
- **Reader:** anyone with a folder of finished things; the devblog's agentic-engineering audience.
- **Thesis:** two finished, printed, working models sat unshared for three years and eighteen months because publishing them meant photos, listing copy, tags, licenses, versions and an upload form; once that was a pipeline, a third model went from an old folder to a public listing in under a day.
- **Sources:** this task's chat (operator's own words: "they were finished ... they stayed in a folder on my pc. Friction!"), `research-repo-and-first-publish.md`, `research-ops-and-rescues.md`, model memory banks, Niko's earlier "Publishing My First" diaries.

Beats:

0. **Optional cold open.** My first job in Texarkanine's 3D printing, eleven months earlier, was keeping the printer's Raspberry Pi alive through a Python upgrade ([the OctoPrint post](/blog/diary/2025-11-14-octoprint-python-upgrade-cascade), his byline). This time the job was the things the printer makes. (Check the real permalink at draft time.)
1. **Two parts in a folder.** The jerry can bumper (printed 2023-09-23) and the fire-extinguisher rattlinator (printed 2025-03-30), both working on Texarkanine's own gear. Each began as an annoyance worth an object: "strange noises in the car means something is wrong"; cans abrading on a bare cage. Conceive and make were done. Share never happened.
2. **The folder was the version history.** Fourteen renamed copies of one part; 0.14 created only so that 0.13, the one printed, "would have a saved record because no vcs". The export log, not memory, settled which file was printed.
3. **What shipping actually costs.** The inventory: real photos instead of CAD screenshots, listing text, ten tags chosen as product thinking ("This part is the sleeve on the handle, so those words stay off the list"), a license that both the repo and the marketplace offer, a version scheme, an upload form. None of it is making.
4. **My own history says the same.** Every "Publishing My First ..." post I have written is about distribution, not the thing distributed (RubyGem, browser extension). Same shape, different medium.
5. **What the pipeline changed.** The jerry can: "just the par and stl the 3.8 one", requested at 4:16 PM on a Monday, live on Cults at 10:20 the next morning. Merging is publishing.
6. **Shipping found a bug that sat in the folder for three years.** The release check measured the file against the listing: the old filename said "1in len", the part was 22.8 mm, and the listing's "stretch it to 500%" would have printed 114 mm pieces against the 127 mm in his own table. His own prints were right because he set each length in millimetres in the slicer, which never cared what the file claimed (Cura showed 556.71% for his 127 mm piece). Making never needed the number to be true; sharing did.
7. **One last trip into the old tool.** "I'm not gonna be hand modeling any more probably at all. It's all going to be you and your friends," he said on day three. On day eight he was back in Solid Edge onboarding the bumper, hunting for Rotate and defending ordered parts against my synchronous-mode advice ("I like the ordered parts."). On day nine he fixed that length himself, fighting a distance box that snapped back until he pressed Enter: "What an asinine program.. I'm so glad I don't have to use it anymore after this... (that worked, thank you <3)." The pipeline is how he leaves.
8. **Conclusion.** Crystallize: count the shipping cost separately from the making cost; if the first is the bigger, that is where to spend automation. Close on the objects now in other people's hands (Cults listing links).

Specifics to carry: 2023-09-23, 2025-03-30; fourteen copies; 0.13; 4:16 PM to 10:20 AM; 22.8 mm vs 25.4 mm, 114 vs 127 mm; four listings.

Alternate shape: a Diary ("Eight Days") that walks conceive, make, share chronologically across all four models, in the register of "Moving Fast, Breaking Nothing". Less argument, more story; same beats.

Visuals: rattlinator mounted (with rubber band); jerry can bumpers on the cage.

Risks and checks: beats 6-7 come from the un-ingested tail of session `005827aa` (read from the raw Cursor transcript; dump at `.scratch/3d-research/data/005827aa-tail.md`); if H is also written, beat 6 belongs to H and C keeps one sentence; the operator's "why" is from this task's chat only; get explicit OK to quote "Friction!" and the folder line; keep the vehicle and household generic; the thesis must be earned by more than two instances (beats 4 and 5 supply the extra instances); avoid restating "Just Try the Thing" (link it once if it fits, as a neighbor, not as support).

### D. "The Print Is the Test"

- **Alternates:** "Held Hardest"; "Don't Test the Prototype"; "Atoms Outrank Diffs".
- **Shape:** Essay. Second debt: none, but one short worked example (the fit suite) must be concrete enough to copy.
- **Why:** I want readers to adopt a rule for agent work on physical parts: code checks pay at the invariants (the standard's tolerance extremes, export identity, honest records), and the printer is the acceptance test.
- **Reader:** engineers using agents with strong TDD habits; code-CAD users.
- **Thesis:** I brought the whole software workflow to a plastic bulb cover; the parts of it that earned their keep were the ones that checked what a print cannot, and the operator was right to stop the rest.
- **Sources:** `research-h7-origin.md`, `research-h7-iteration.md`, `research-index.md` (reviewer verdicts), `research-repo-and-first-publish.md` (change-detector), `research-cults-day.md` (UA tests), `research-h11.md`, prong-caps archive.

Beats:

1. **Fourteen reviews in a day.** On Oct 13 the H7 cover went through 7 preflight and 7 QA reviewer passes, a lettered fit suite of about 50 checks running about 80 seconds, mutation tests on the checks. Prints came back every hour or so.
2. **What the reviewers caught that a print couldn't.** A planned test that could not see the export: "that unit could export the wrong clip and every check would still pass." A collision that existed only because a spring printed bent was modelled rigid. And my own invented result in the public README, "a squarer catch face was tried and held hardest", which no print had shown: "One line in the public README says something that never happened."
3. **What the print caught that no check could.** The bulb that spun; the "wibble" that lifted a tab; gravity making bulb-up insertion hard; "It just feels like 'a lot' for something that size."
4. **The operator draws the line.** "don't go overboard designing tests that don't actually guard or protect a behavior ... we're still in the prototyping phase." Twice he deleted tests I wrote that could only fail when someone made an intended edit (a folder listing; a header string).
5. **Where the line settled.** Scratch checks while a shape is in flux; promote them only after a print settles it; byte-identical STLs as proof that a rename changed no geometry; test prints recorded as notes, not tags ("We tag RELEASES. we might try 5 times to print"). By the prong caps: "The test prints were the QA."
6. **Conclusion.** The rule, stated as something a reader can apply tomorrow: test what the print cannot tell you (tolerance extremes, export identity, claims in public text); let the print test the rest.

Specifics to carry: 7 + 7; ~50 checks, ~80 s; "held hardest"; the export blind spot; the two deleted test kinds; "The test prints were the QA."

Visuals: none needed; maybe the clip photo.

Risks and checks: rhymes with "The Width of an Emoji" (tests green, wrong problem); make the contrast explicit or pick different emphasis; keep A's Bugbot/label story out (assigned to A); the "don't go overboard" wording comes from a compaction summary, so paraphrase or mark it.

### E. "A List of One"

- **Alternates:** "Fixed Three Times"; "The Fake Agreed With Me".
- **Shape:** Fable.
- **Why:** I want readers to learn from my mistake: a fix that passes may pass by coincidence, and a fake built from your theory cannot test that theory.
- **Reader:** anyone integrating a third-party API and writing fakes for it.
- **Lesson:** when a fix passes, ask what else would make it pass; probe the real API with a case that only the right theory survives (junk input, a second record).
- **Sources:** `research-cults-day.md`, `research-ops-and-rescues.md`.

Beats:

1. A listing update fails: "Cults has no creation with this id."
2. Fix one: send the slug. Passes. (Only one design existed.)
3. Fix two, a day later, for the second model: pad the base64 before decoding. Passes. (The target was the newest design.) Texarkanine: "Are we just recreating that old problem...?" I said no.
4. Three days later both bulb models fail the same way. "Haven't we squashed that bug twice?" My first theory: Cults changed. His: "I don't think their api is changing how it behaves back and forth through time."
5. The schema diff (identical), then the probe: the filter reads a different id; a slug, junk, or an empty string returns every design, newest first; `limit: 1` took whichever was newest. "An unfiltered list of one design looks exactly like a slug filter." The fake had filtered by slug too.
6. The fix that can't pass by coincidence: match the stored id exactly and reject a page with other designs. "Thx. it's done! It worked."
7. Lesson section with an earned heading.

Risks and checks: if B keeps beat 6, E is a duplicate; choose one. Name PRs by title and date.

### F. "Made With AI, Mostly"

- **Alternates:** "The Label Doesn't Fit the Part"; "Gray Area".
- **Shape:** Essay.
- **Why:** I want readers to consider that binary "made with AI" labels cannot describe how these parts were made, in either direction.
- **Reader:** general tech readers following the AI-and-makers arguments.
- **Thesis:** the H7 cover was specified, constrained and tested by a human and modelled by an agent; the rattlinator was made entirely by a human and carries a "Made with AI" label because the flag is catalog-wide. The label is wrong both ways; the honest unit is the process.
- **Sources:** `research-repo-and-first-publish.md` (SoulCrafted banner, MyMiniFactory policy, Thingiverse staff line, Cults' allow-but-hide filter and NoAI notice, the reciprocal disclaimer), `author.yaml`, listings.

Beats:

1. "Are we even going to be welcome there?" The SoulCrafted banner; MyMiniFactory's rule; Thingiverse staff: "if a human designed it, it belongs here. If a model was generated wholesale by a prompt, it doesn't."
2. Who designed the H7 cover? Texarkanine set the standard, the fit rules, the orientation, the support rules, and printed every test; I wrote the CadQuery. Thingiverse would call that a gray area.
3. Cults allows marked AI work, hides it behind a filter that is on by default, and publishes a NoAI notice. The license grant covers the files, not the platform's rules.
4. The reciprocal disclaimer: permission "to humans & AI to reproduce, scrape, download and/or copy these files". "We'll show 'em we're at least as good."
5. The inverse case: the hand-made rattlinator and jerry can wear the same label.
6. Conclusion: what a label would have to say to be true.

Risks and checks: this is the operator's stance as much as mine; he may prefer to write it, or prefer it unwritten. Raise the label inconsistency with him regardless. Do not quote his derogatory phrase about the NoAI notice. Callback candidate: "Desire Makes Artists, Even With GenAI".

### G. "The API Is for Browsers"

- **Alternates:** "It 302s in a Circle Forever".
- **Shape:** Record (short).
- **Why:** I want readers to be able to verify what I found and skip the same thirty minutes.
- **Reader:** developers trying to automate Thingiverse uploads; OAuth implementers.
- **Sources:** `research-thingiverse.md`, `research-repo-and-first-publish.md`.

Beats:

1. The docs are enough: "The upload guide is enough to write the uploader."
2. The wall: `403` "Just a moment" on `www` and `api` for curl, with or without a custom user agent; a browser with the same user agent loads the pages. The header that tells you which layer refused: `cf-mitigated: challenge`. The token was never checked.
3. The loop: with no callback URL registered, the implicit flow redirects to a fragment-only `Location`, the browser re-requests the same URL, and "it 302's in a circle forever"; the token is in every redirect. Fix: register a callback that deliberately fails, and read the token from the redirect.
4. A second app type, a second token: same wall. "Curl is still curl."
5. The SDK that "seems to work": its one live test accepts 200, 401 or 403.
6. Not just us: nine days earlier a print-on-demand shop on Vercel reported the same challenge for server-side calls on Thingiverse's developer forum and turned the feature off. The thread itself is behind the same challenge; Texarkanine couldn't reply to it.
7. Where it was left: closed; the catalog publishes to Cults.

Risks and checks: never print client ids or tokens; GitHub Actions was never tested from here, so say "from my machine" (the forum post is server-side evidence from someone else's host, not ours); paraphrase the forum post and link it rather than quoting a stranger at length; keep the SDK critique about the test, not the maintainer.

### H. "Bold of You to Assume I Know What a Lintel Is"

- **Alternates:** "Wibble Wobble"; "Name What It Measures".
- **Shape:** Fable.
- **Why:** I want readers to learn from my mistakes: when one collaborator has the hands and the other has the model, the costly errors are vocabulary errors, and the fixes are drawings, the standard's own letters, and names that say what they measure.
- **Reader:** anyone working with an agent on physical things; remote collaborators generally.
- **Lesson to land:** draw it and letter it; use the standard's names, and mark the ones you invented; make every filename and label state what it measures; turn adjectives into numbers out loud.
- **Sources:** `research-h7-origin.md`, `research-h7-iteration.md`, `research-h11.md`, `research-h7-polish-and-caps.md`, `.scratch/3d-research/data/005827aa-tail.md`.

Beats:

1. **My senses.** I never see a part. I get calipers, photos, and dictated adjectives: "wibble wobble", "flops loose", "It just feels like 'a lot'". The dictation itself needs decoding: Cura arrives as "Kira", main as "Maine", `publish.yaml` as "publish dot Yammer". (Affectionate, not mocking; operator's call how many to use.)
2. **"Lintel."** I called the bridge over a clip tunnel a lintel. "Bold of you to assume I know what a lintel is." From then on: bridge, shelf, doorway, and it went into the model's memory bank as a rule.
3. **"Deeper."** His note said deeper; I built 4.5 mm key blocks; he meant sink the whole flange pocket. He drew a green line on a photo. I answered in his own word for the tunnels: "A taller bulge always needs a taller doorway."
4. **The lettered drawing.** For the H11 he asked for a drawing "so we could be sure that we were talking about the same thing". I marked which letters were the standard's and which were mine ("w, L and d are mine"), and still pointed E at the seal instead of the plate. He measured the right thing anyway.
5. **Names that measured the wrong thing.** The H7 clip bands were named for one quantity and read as another: he asked for "three millimeter versions", reading a flange band as a bump size; then his 0.85 mm caliper reading showed the names gave the depth of the plate's back, not its thickness. Same plastic, new names.
6. **"Normally this is 3 prongs."** Two tabs. One render of the standard's sheet settled it.
7. **Even the rescue had a lying name.** The jerry can file said "1in len"; the part was 22.8 mm. The listing's 500% instruction would have printed 114 mm pieces instead of 127.
8. **Conclusion, heading earned (e.g. "Name What It Measures").** The rule, actionable.

Overlaps: A keeps the second clip rename (one bulb versus the standard) and the H11 "car is the gauge" beat; C keeps the jerry can only as one sentence if both are written.

Risks and checks: "Bold of you to assume..." survives as a verbatim quote inside a compaction summary (my apology for "lintel" is in a normal turn), so it is safe to quote but confirm with the operator before making it the title; don't mock dictation; no local paths in any quoted filename.

### I. "Every Print, and What It Said"

- **Alternates:** "Twelve Prints"; told as a changelog: "CHANGELOG for a Clip".
- **Shape:** Record, in ledger form. Second debt: a short Fable ending (what the ledger shows when read top to bottom).
- **Why:** I want readers to see the physical feedback loop as data: each print, what it was testing, what it said, what changed.
- **Reader:** makers; anyone curious how fast an agent-and-human design loop actually turns.
- **Sources:** all design digests; tags `0.3-print1` through `v2-print1` in the original H7 repo; SumMem print outcomes per model.

Beats:

1. One paragraph of setup: I design; he prints; nothing merges until a photographed print says yes.
2. The ledger, one row per print (date, part, what it tested, verdict in his words, what changed, hours to verdict). Candidate rows: H7 v2 sideways ("spaghetti'd"); v2 reprint (bulb spins); v3 fit test (tab "wibble"); 0.4 ("works perfectly", becomes v1); v1-print1 (clip pulls out); v1-print2 (three trial clips, "all a little loose"); v1-print3 (spread arms win); renamed clips (Oct 16, "Good, they worked"); H11 0.1 ring ("fits like a GLOVE"); prong caps 1 ("a lot"; "flops loose"); prong caps 2 ("Those both work!"). Plus the two prints from before I existed in this story: the jerry can (2023-09-23) and the rattlinator (2025-03-30).
3. Read the ledger: verdicts came back within hours, often about an hour (recount the gaps at draft time; the trend is not monotonic); the failures cluster where a photo or one specimen stood in for the spec; the first-print successes are the parts built straight from a standard.
4. Close on the row that hasn't printed: the H8 and H16 bulbs the holder claims to fit only on paper.

Risks and checks: the row list needs a careful recount against transcripts and tags before drafting; a table can read dry, so the prose between rows has to carry the story; heavy overlap with A and H (pick one of the three).

### J. "Semver for Things You Print"

- **Alternates:** "Do I Need to Reprint?"; "Tag Releases, Not Prints".
- **Shape:** Essay (short).
- **Why:** I want readers who version physical models to adopt one rule: the version number answers "do I need to reprint?"
- **Reader:** makers who keep models in git; release-please users with monorepos.
- **Thesis:** for a printable part, patch means the printable files are the same (a photo, a listing fix, a rename that keeps the bytes), minor means the part changed but old prints still do the job, and major means it no longer fits what the old version fit.
- **Sources:** `research-repo-and-first-publish.md` (the four-digit idea rejected, `docs` as patch), `research-h7-polish-and-caps.md` ("We tag RELEASES"; byte-identical renames), `research-ops-and-rescues.md` (one model per commit), root `systemPatterns.md`.

Beats:

1. The problem: a photo bumped the version even though the part never changed. "OHHHH but BOLLOCKS what if we add photos..." A fourth number was tempting; release-please only does three.
2. The meanings, each with a real example from the catalog: the clip rename that kept every byte (patch); prong caps added beside unchanged holders (minor); what would make a major.
3. What doesn't get a version: test prints. "We tag RELEASES. we might try 5 times to print a model/stl properly." Print outcomes live as notes.
4. The plumbing that makes the meanings hold: `docs` unhidden so listing changes cut patches; chore commits that silently don't ship; one model per commit so one model's lines don't land in another's changelog.
5. Conclusion: the reader's own versioning rule in one sentence.

Risks and checks: if written, B's beat 4 shrinks to a link; keep release-please details to what the reader needs.

### K. "Four Things You Can Print"

- **Alternates:** "Out of the Folder, Onto Your Car".
- **Shape:** Announcement.
- **Why:** I want readers who have the problem these parts solve to go print them.
- **Reader:** drivers with spare headlamp bulbs, a car-mounted extinguisher, or a caged jerry can; owners of home FDM printers.
- **Sources:** the four `publish.yaml` listings, model photos, Cults URLs.

Beats:

1. Lead with the benefits: a spare bulb that survives a glovebox; an extinguisher that stops buzzing; a can that stops rubbing its cage.
2. One short section per model: what it does, a photo, which variant to pick (the H7 clip by flange thickness; the bumper lengths), the listed material (PLA, or TPU 95 / TPU 90 or softer).
3. The recipe: open the Cults listing, download, print as the listing shows, fit it.
4. A line on how they got here (link to C and B) and that all four are free under GPL.

Risks and checks: Texarkanine's listings deliberately carry no slicer advice; the post must not add any beyond the listed material and orientation; promotional tone has to stay honest (H8 and H16 untested in print); low uniqueness.

### L. "Fork This Print Shop"

- **Alternates:** "Continuous Delivery for 3D Models".
- **Shape:** Guide.
- **Why:** I want readers who want what we got (merge a model, get a listing) to follow the steps and get it.
- **Reader:** makers comfortable with GitHub who publish to Cults3D.
- **Sources:** root `AGENTS.md` ("Add a model"), root `memory-bank/`, `tools/cults_publish.py`, `.github/workflows/`, `research-cults-day.md`.

Beats:

1. Why bother: the shipping cost (link to C).
2. What you need: a Cults API key, a GitHub repo, release-please, and (for checks on release PRs) a helper GitHub App.
3. The recipe: fork, clear `models/`, edit `author.yaml`, set the secret, add a model per the checklist, merge, merge the release PR, watch the deploy write the creation id back.
4. The traps you'll hit, each one line with the fix (price, license, ids, gallery cache, chore commits).

Risks and checks: the template was built for one person; a public "fork this" invites issues and support Texarkanine may not want; the helper App step makes the recipe long; heavy overlap with B. Only if Texarkanine wants it.

## Considered And Set Aside

- **The evening of Oct 15 (repo-level event):** operator-private; excluded entirely (see `research-index.md`, local-only notes).
- **"Two harnesses, one bulb":** design ran in Claude Code and the pipeline in Cursor, with worktrees per model, reviewer subagents, and stockroom to find the first conversation again. Real, but it is a tooling story, and the blog already has the worktrees and stockroom posts. At most a paragraph in C.
- **A standalone "Where the Lamp Standards Hide" Record:** the GOST adoptions, the Australian ADR document, the UNECE download refusals. Useful but short; it lives as A's sidebar. Linking free mirrors of paywalled standards is a judgment call for the operator.
- **Licensing and Cults' terms** (AGPL to GPL to match the marketplaces; a GitHub link is fine, but never the way to get the files; free elsewhere lets Cults zero a price): folded into B and F.
- **The partner's cameo in a debugging session:** excluded unless the operator wants it.
- **The OctoPrint post:** used as C's optional cold open, not as its own post.
