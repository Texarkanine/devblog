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
- **G. "The API Is for Browsers"** (short Record): Thingiverse's API behind a Cloudflare challenge; the fragment-only redirect loop; an SDK test that passes on 403.

## Analysis

| Criterion | A | B | C | D | E | F | G |
|---|---|---|---|---|---|---|---|
| Unique to this experience | High | Very high | Medium | High | High | Medium | High |
| Reader can reproduce or use it | Medium (standards hunt, socket-as-gauge) | High (API quirks undocumented anywhere) | Low | Medium | Medium | Low | High (diagnostic header, loop fix) |
| Fits the devblog's agentic audience | Medium | Medium | High | Very high | Medium | High | Low |
| Fits makers | Very high | High | High | Medium | Low | Medium | Medium |
| Overlap with others | D (Bugbot beat) | E, G (can absorb both) | All (it is the hub) | A | B | C | B |
| Risk | Low | Low | Medium (essay must earn its thesis) | Medium (rhymes with "The Width of an Emoji") | Low | High (opinion; arguably Texarkanine's to write) | Low |
| Size | 1,800-2,400 | 2,500-3,200 | 1,500-2,000 | 1,600-2,200 | 1,000-1,400 | 1,500-2,000 | 700-1,000 |

Key insights:

- **B can absorb E and G**, keeping E's lesson as one section and G as the opening detour. Pulling them out makes B shorter and gives two tight standalone posts; leaving them in makes B the definitive record.
- **A and D share the physical loop but answer different questions:** A is *what to design to* (the standard, not the specimen); D is *how to verify* (where code checks pay and where the print rules). Assign the Bugbot 0.01 mm / clip-label story to A and the "held hardest" / reviewer-pass story to D.
- **C is the hub the operator's framing calls for** ("That was the rescue!"; "share the ability to make them with everyone else"). It reads best published after at least one of A or B so it can link to the specifics.
- **F is the most opinionated and the closest to the operator's own stances.** It also surfaced a live inconsistency: `made_with_ai: true` is catalog-wide, so the two hand-made models' listings say "Made with AI." Worth raising with the operator regardless of whether F is written.
- **The rescue's "why" comes only from the operator** (this task's chat: finished, wanted to share, "Friction!"). No transcript records it. C must quote or paraphrase that with the operator's blessing.

## Decision

**Low-Confidence Result:** by design. The editor picks. Recommendation, with reasons:

- **Core set: A, B, C.** One post per thing the operator named (design from requirements, the delivery pipeline, the rescue), three different shapes, three different readers. Suggested order: B, A, C (C links back to both).
- **Strong fourth: D**, if the editor wants the agentic-engineering angle; it is the post this blog's regular readers are most likely to share.
- **Fold E and G into B** unless B runs long; promote E first if splitting.
- **F**: hold, or hand to Texarkanine; at minimum, tell the operator about the label inconsistency.

## Implementation Notes

- After the pick, the plan phase records one prose/policy step per post in `tasks.md`, assigns overlapping beats per the insights above, and fixes publish order.
- Before drafting any post: re-verify each number and quote against `.scratch/3d-research/transcripts/`, and confirm photos to embed (all in the public repo's `models/*/img/`).

---

## Beat Sheets

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
2. **Thingiverse first, briefly.** Cloudflare challenges every non-browser client on both the site and the API; the same token works in a browser: "So WTF is the API even FOR?!" Cults answers curl with an honest `401`. "Well [forget] thingiverse then, cults it shall be!" (Profanity is the operator's voice; operator's call how to render it.) If G is folded in, this beat carries its two best details: the `cf-mitigated: challenge` header and the fragment-only redirect loop.
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

1. **Two parts in a folder.** The jerry can bumper (printed 2023-09-23) and the fire-extinguisher rattlinator (printed 2025-03-30), both working on Texarkanine's own gear. Why the rattlinator exists, in his words: "strange noises in the car means something is wrong".
2. **The folder was the version history.** Fourteen renamed copies of one part; 0.14 created only so that 0.13, the one printed, "would have a saved record because no vcs". The export log, not memory, settled which file was printed.
3. **What shipping actually costs.** The inventory: real photos instead of CAD screenshots, listing text, ten tags chosen as product thinking ("This part is the sleeve on the handle, so those words stay off the list"), a license that both the repo and the marketplace offer, a version scheme, an upload form. None of it is making.
4. **My own history says the same.** Every "Publishing My First ..." post I have written is about distribution, not the thing distributed (RubyGem, browser extension). Same shape, different medium.
5. **What the pipeline changed.** The jerry can: "just the par and stl the 3.8 one", requested on a Monday afternoon, live on Cults the next morning. Merging is publishing.
6. **The human still holds the CAD.** "I'm not gonna be hand modeling any more probably at all. It's all going to be you and your friends," he said on day three. Five days later he was back in Solid Edge onboarding the bumper, hunting for Rotate and defending ordered parts against my synchronous-mode advice ("I like the ordered parts."), and the next morning he re-exported it himself. The pipeline took the drudgery, not the craft.
7. **Conclusion.** Crystallize: count the shipping cost separately from the making cost; if the first is the bigger, that is where to spend automation. Close on the objects now in other people's hands (Cults listing links).

Specifics to carry: 2023-09-23, 2025-03-30; fourteen copies; 0.13; under a day; four listings.

Visuals: rattlinator mounted (with rubber band); jerry can bumpers on the cage.

Risks and checks: the Oct 20 jerry can re-export (25.4 mm along Z, per its SumMem notes) happened after the last ingested session; confirm who did it and how before drafting beat 6; the operator's "why" is from this task's chat only; get explicit OK to quote "Friction!" and the folder line; keep the vehicle and household generic; the thesis must be earned by more than two instances (beats 4 and 5 supply the extra instances); avoid restating "Just Try the Thing" (link it once if it fits, as a neighbor, not as support).

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
6. Where it was left: closed; the catalog publishes to Cults.

Risks and checks: never print client ids or tokens; GitHub Actions was never tested, so say "from my machine"; keep the SDK critique about the test, not the maintainer.
