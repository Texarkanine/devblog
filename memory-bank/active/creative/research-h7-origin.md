# Research Digest: H7 Origin

Covers the first H7 request through the v2 and v3 test prints and the v4 build that answered them, plus the first talk of publishing models publicly and the first survey of print-site upload APIs.

Citations: `[dda9a5c3#N]` / `[45e66c5d#N]` is the message ordinal. Some operator messages were sent while the agent was mid-turn and survive only as quotes inside a compaction summary; those are cited `[...#N summary]` and may be lightly trimmed by the summarizer.

## Sessions Covered

- **`2026-10-12-1418-claude-dda9a5c3.md`** (Claude Code, Oct 12 14:18 to Oct 13 01:18, three compactions). Started in the operator's folder for the downloaded H11 case. H7 cover v1 to v3, the v2 test print, the hunt for the PX26d standard, the square collar; then a local git repo, the Niko memory bank, the monorepo question, and the first upload-API survey (Thingiverse blocked by Cloudflare, Cults3D reachable).
- **`2026-10-13-0019-claude-45e66c5d.md`** (Claude Code, Oct 13 00:19 to 05:43). Started in the new `H7 bulb case` repo. The v3 fit-test report, then a Niko Level 2 run (plan, preflight subagent, test-first build, usage-limit cut-off, QA subagent, reflect) producing v4, tagged `v4-print1`. The v4 print result is not in this transcript.

Inference from timestamps: the sessions overlapped. Session 2 began at 00:19 while session 1 was still answering Thingiverse questions (last visible reply 00:23).

## What Happened

### Oct 12 Afternoon: Request, v1, v2

- **14:18** The operator has an H11 bulb case from Printables that "works. BUT - I need one for an H7 form factor." An H7 "doesn't twist lock it just sits in and then spring locks over a tab." A MakerWorld H7 case exists but "screws together to entomb the bulb", which fails for "LED bulbs with big fans on the back." They have Solid Edge Community (free tier), will accept Blender/FOSS, but need an STL for the slicer [dda9a5c3#0]. Mid-turn, a photo of their LED H7s: "I'd like it to be properly generic!" [dda9a5c3#135 summary].
- **14:19-14:23** Before modelling, the agent hunts dimensions: regulation sites block scripted downloads, so it pulls the H7 drawing from an Australian copy of the lamp regulation, checks a datasheet for the ~34 mm flange, and measures the operator's H11 STL and the MakerWorld cup [dda9a5c3#24, #38, #53].
- **14:34** v1, 16 minutes after the request: cover, clip, a fit-test print, STEP files, the CadQuery source, a README. Collision checks against stand-in bulbs (halogen and LED) [dda9a5c3#78, #87]. The clip is a long U-shaped wedge that slides through the collar into the gap behind the flange, "the same gap the car's wire spring clip uses", and fits any 1-3 mm flange. The flange outline is unknown: "it's in a paid IEC standard" [dda9a5c3#102].
- **14:43** Operator: the clip is "far too long ... this isn't going to store very well"; wants short tines, a screwdriver loop, squeeze-to-release barbs "like all the automotive connectors do"; "The cover itself looks dope as hell though" [dda9a5c3#103].
- **14:56** v2: a 49 mm barbed U-clip (was 80 mm), spring bumps against rattle, and four clip variants, one per 0.5 mm band of flange thickness, because a fixed latch cannot adapt like the wedge did [dda9a5c3#105, #134].

### Oct 12 Evening: v2 Print, v3, The Standard

- **21:29** v2 print report with photos: sideways first print failed; the 2.0 mm clip fitted; the bulb spins because nothing catches its tab; "why are there two openings?"; clip should enter from either side; aim for support-free printing [dda9a5c3#136]. Mid-turn: "Just for funzis let's throw a git repository in this" [dda9a5c3#329 summary]. v2 committed as baseline `3fb3213` [dda9a5c3#209].
- **21:50-22:01** An overhang checker confirms v2's clip-window ceilings are attached on one side only [dda9a5c3#154]. v3: square collar so tunnel roofs become bridges, ribs for the tab, symmetric tunnels, bigger leaning barbs, longer tips [dda9a5c3#209].
- **22:26-22:31** The operator asks for an SVG to explain the requested measurements [dda9a5c3#210], then answers with exasperation that naming H7 should have made calipers unnecessary [dda9a5c3#227]. They also correct the diagram's flange shape [dda9a5c3#329 summary].
- **22:38-22:42** The agent retracts the rib key (it would have blocked the operator's flange) and moves to key blocks beside the tab [dda9a5c3#250]; then corrects a one-sided flat to a symmetric tab [dda9a5c3#251, #266].
- **22:42** "if we're going to share this with the world as we plan to eventually it needs to be for the standard plus a little tolerance" [dda9a5c3#267]: the first statement of publishing intent.
- **22:49** The PX26d numbers turn up in a Russian national adoption of IEC 60061-1; the design is re-anchored to the standard's maxima. Readiness is announced with emoji, as requested [dda9a5c3#297].
- **22:49-22:58** "Why square?", material numbers, the square recast as a packing feature, a collar-down prototype, and a decision to stay tube-down [dda9a5c3#298-#323]. `a94b4c8` tagged `v3-print1`; v2 clips don't fit v3 [dda9a5c3#312, #328].

### Oct 12-13 Night: Persistence, Repos, Publishing

- **23:56** After a compaction: "Is our state persistence outside this conversation sufficient" [dda9a5c3#330]. Gaps found: check scripts only in `/tmp`, agent memory filed under the H11 folder where the session began, decisions and print history only in notes. Also: the MakerWorld STL is committed, so check its licence "before the repo goes public" [dda9a5c3#340].
- **23:59-00:08** The operator installs their rules tooling (`ai-rizz` with the `niko` ruleset, converted by `a16n`); two failed attempts (wrong flag, wrong folder) [dda9a5c3#341-#358]. The agent initializes the memory bank, moves scripts into `tools/`, and writes the history into an archive file because `/handoff` needs a git remote and there is none [dda9a5c3#361-#414]. Commits follow "'cmon man commit the other repo please" [dda9a5c3#415, #427].
- **00:06** Repo layout research ("monorepo (bleh). Repo per?" [dda9a5c3#516 summary]): the agent recommends one repo for the operator's own designs, a folder per design, per-design tags, and observes nobody publishes from GitHub to print sites [dda9a5c3#414].
- **00:09** "Well hey, we know our next project, don't we?" [dda9a5c3#428]. The survey: Thingiverse, Cults3D, MyMiniFactory have upload APIs; Printables and MakerWorld don't; Yeggi is a search engine [dda9a5c3#461, #465]. Thingiverse and MyMiniFactory are behind a Cloudflare challenge from this machine, even with Firefox user agents; Cults3D answers curl; the Thingiverse spec comes from the Wayback Machine [dda9a5c3#493, #515].

### Oct 13: v3 Fit Test And v4

- **00:19** v3 fit test: "It technically works"; "great bed adhesion"; "dimensionally everything seems beautiful". Fixes: bigger barbs, a tab pocket 4-5 mm deep instead of ~1 mm, and a guide so the clip can't angle down and miss the far tunnel [45e66c5d#0].
- **00:25-00:54** `/nk-chat` is read-only, so the agent plans and finds a catch per fix [45e66c5d#12]; the operator runs `/niko` and sends four photos showing nothing behind the flange where taller keys would go [45e66c5d#13, #22, #25]. Mid-build, the operator notes gravity makes bulb-up insertion hard, delegates the guide choice, and stops the over-testing [45e66c5d#200 summary].
- **01:09-01:37** Preflight subagent passes with advisories and catches a wrong plan premise [45e66c5d#76]. The check script becomes a pass/fail suite; new checks fail on v3 then pass on v4 [45e66c5d#87-#140]. The usage limit hits; the agent stops before QA and says the files are printable [45e66c5d#162, #165].
- **04:41-04:48** QA subagent passes; tagged `v4-print1`; reflection written [45e66c5d#174-#199].

## Turning Points

- **The wedge met a storage bin.** One wedge clip for every flange seemed elegant [dda9a5c3#102]. But the covers are for "a box or a bag, maybe even in your car", and a fork sticking out both sides wastes space and "if that bin gets disturbed at all those pins are going to wiggle out" [dda9a5c3#103]. Found from the preview, before printing. Change: a short barbed clip, at the cost of four variants [dda9a5c3#134].
- **Two openings, one tab.** v1/v2 had two open collar slots for adapter tabs [dda9a5c3#102]. The print showed the bulb spinning and a clip arm sinking into the gap beside the tab [dda9a5c3#136]. The keying then went wrong twice on paper: a rib key guessed from a photo reached Ø32.6 and would have blocked the Ø33.3 flange [dda9a5c3#250], and a one-sided flat ignored the symmetric tab [dda9a5c3#251, #253]. Both were caught by the operator's measurements before any plastic was spent.
- **The paywalled standard was findable.** v1 treated the flange outline as unknowable [dda9a5c3#102]. After the operator's frustration [dda9a5c3#227] and the build-to-the-standard norm [dda9a5c3#267], a proper search found the PX26d table in GOST IEC 60061-1-2014, a text-only identical adoption. The agent matched its letters to features using the operator's caliper readings and a retailer's description [dda9a5c3#269, #297].
- **Round to square for printability.** Straight tunnels exiting a curved collar leave roofs attached on one side; a square collar makes them bridges [dda9a5c3#154, #303]. Cost: 16.0 to 23.3 cm³. The operator objected on material, then: "we can cast it as a feature" because square covers pack side by side [dda9a5c3#298, #304].
- **Collar-down, tried and shelved.** "Are you sure tube down and collar on top is not insane?" [dda9a5c3#329 summary]. The prototype was more stable and used less plastic (20.1 cm³) but flipped the seat, inner end and tunnel tops upside down [dda9a5c3#322]. Kept tube-down "for now" [dda9a5c3#323]; the v3 print then stuck well [45e66c5d#0].
- **A compaction started a publishing pipeline.** Lost context led to a persistence question [dda9a5c3#330], a repo, a monorepo question, the observation that "everyone uploads by hand" [dda9a5c3#414], and "we know our next project" [dda9a5c3#428].
- **Thingiverse looked obvious and was walled off.** "hell we could curl it, couldn't we?" [dda9a5c3#466]. Cloudflare blocked every scripted request; Cults3D answered with a proper `401` and was ranked "the easiest to build against" before any account existed [dda9a5c3#461, #493, #515].
- **A reviewer subagent caught a wrong premise.** The v4 plan assumed the groove ledge held the barb 2.1 mm behind the clip tip; preflight found 4.7-6.3 mm, so the tip could still dip. Fix: 0.5 mm 45° tunnel mouths [45e66c5d#76, #199].
- **Test-first met prototyping.** The agent stubbed checks for the new guide shapes; the operator said not to test shapes that might not survive. Three checks were dropped and the memory bank now says to "add a check only for a behaviour that has settled" [45e66c5d#200 summary, #174].

## The Physical Loop

- **v2 print 1:** printed sideways, no brim; "spaghetti'd on the adapter" [dda9a5c3#136].
- **v2 print 2:** longitudinal with one tree support; clip-channel area "pretty crappy but the clips still do work". Flange ~1 mm; adapter behind it ~3.5 mm. The 2.0-2.5 mm clip band fit; thicker ones were "HARD to get out". 1.2 mm barbs felt small; "print QUALITY matters for the barbs". Clips "adequately springy and resilient". Tips (~2 mm proud) too short to pinch [dda9a5c3#136, #209].
- **v3 response:** barbs 1.5 mm with a 20° back-face lean so they drag smoothly; tips 7 mm proud with grip pads [dda9a5c3#209].
- **Calipers:** tab 7.5, then "7.67 or seven point eight"; flange Ø33.3; gap ~6.75 [dda9a5c3#210, #227]. Modelled: tab 7.7, flat ~12.8 mm from centre, 3.4 mm step each side [dda9a5c3#266]. These numbers caught the rib key's Ø32.6 error before printing [dda9a5c3#250].
- **Against PX26d:** O 33.8-34.0, K 7.9-8.0, Q 13.2-13.7, M 25.9-26.0. The operator's adapter is "slightly under the standard on every measure", so the cover is sized to the standard's maximum plus clearance: bore Ø35, collar 43 mm square [dda9a5c3#297].
- **v3 fit test** (printed between ~23:00 Oct 12 and 00:19 Oct 13): good adhesion tube-down; "just enough clearance on the imprint you've made for the flange". The 0.8 mm keys let "the slightest wibble" lift the tab out. The clip can angle past the far tunnel; easy bulb-down, hard bulb-up against gravity. Barbs "catch enough for it to not wiggle out but they'll still give when you pull" [45e66c5d#0, #200 summary].
- **A number that didn't add up:** the best clip was the "2.0-2.5 mm flange" band on a ~1 mm flange; the agent said this "suggests something does sit behind the flange" [45e66c5d#12]. (Inference: the label described the wrong thing; the research index records a later rename to "flange plate rim thickness".)
- **v4 response:** barbs 2.0 mm, catch 1.2 to 1.7 mm deep; keys 0.8 to 4.5 mm with a 1.0 mm slope; a tab lifted 3 mm cannot turn 3°; a bulb 2° off still finds the pocket; 1 mm groove ledge; release squeeze about 2 mm per tip [45e66c5d#165, #174]. Watch-items: tab stays put, bulb-up insertion, no pull-out without a pinch, possible ledge droop [45e66c5d#199].

## Operator Corrections And Teachings

- **Real use first:** "the idea is to be able to put these in a box or a bag, maybe even in your car. However they latch it's got to be secure." [dda9a5c3#103]
- **Tools are fine:** the pull tab "doesn't have to be finger serviceable." [dda9a5c3#103]
- **Support ladder:** "The goldilocks is a model that can be printed w/out any support, followed closely by one with only very obvious, external, easy-to-remove, minimal supports." [dda9a5c3#136] Later: "supports are not inherently evil", but avoid geometry where supports scar a surface and skipping them makes the overhang fail [dda9a5c3#304].
- **Use the agent's patience:** "concessions to 45-degree angling that would be too tedious for a human to model by hand ... are NOT beyond YOUR grasp. Maybe we don't optimize on that YEt?" [dda9a5c3#136]
- **Think about shipping:** orient files "so that people get the right thing out of the box"; let the clip go in either side because "for a user it's not going to be obvious" [dda9a5c3#136].
- **Tolerate harmless wiggle:** fine as long as the bulb can't "bash the side of the bulb into the inside of the container" [dda9a5c3#136].
- **Anchor to the standard** [dda9a5c3#267], and know it without asking for calipers [dda9a5c3#227].
- **Flange geometry lesson:** "you have a perfect circle and then you cut straight a cord parallel to the center line ... it isn't a indent that traces the circumference" [dda9a5c3#329 summary]; "the tab that sticks out is symmetrical" [dda9a5c3#251].
- **Plain words:** "Bold of you to assume I know what a lintel is." The agent: "sorry about 'lintel'; I'll stick to plain words." [dda9a5c3#329 summary, #322]
- **Don't test prototypes** [45e66c5d#200 summary]; **delegate with a fallback:** "pick one and record the other" [45e66c5d#200 summary].
- **The agent pushed back too:** it argued the operator's own support rule favoured the square collar ("Your rule about supports actually backs the square", because the tunnel roofs are working surfaces) [dda9a5c3#306]; and, after trying the operator's user-agent idea: "I wouldn't build the publisher on that: it breaks whenever Cloudflare changes, and it means deliberately dodging their bot protection." [dda9a5c3#515]

## Quotable Lines

1. **Operator** [dda9a5c3#0]: "do you think you're up to the task of making a 3D model that I can eventually print of the H7 LED bulb case that I don't have?" (The opening dare.)
2. **Operator** [dda9a5c3#0]: "Something that I can insert them into like the headlamp assembly and then clip lock in place ... while allowing for arbitrarily large things out the backside." (The spec in one breath.)
3. **Operator** [dda9a5c3#103]: "The cover itself looks dope as hell though, I can't wait to print that and let you know if it fits!" (Joy before plastic.)
4. **Operator** [dda9a5c3#103]: "if I toss four of these in a bin for long term storage if that bin gets disturbed at all those pins are going to wiggle out" (Use case beats geometry.)
5. **Assistant** [dda9a5c3#134]: "What CAD can't tell me is the feel: whether the latch is too stiff or too soft, and whether the barbs hold up in your material." (Limits of simulation.)
6. **Operator** [dda9a5c3#136]: "didn't print brim b/c printing the clips flat "wasted" material. mea culpa, now i wasted more and had to reprint." (Relatable failure.)
7. **Operator** [dda9a5c3#136]: "there's only one tab so why are there two openings?" (Print exposes a guess.)
8. **Operator** [dda9a5c3#227]: "b come on man you don't know that the diameter of an H7 bulb hell if I know it" ... "it's a circle dude it's a circle" (Dictated exasperation.)
9. **Assistant** [dda9a5c3#250]: "I guessed from your photo, and the guess was wrong. With the ribs reaching in to Ø32.6, your Ø33.3 flange couldn't have seated. **Don't print the v3 files from my last message.**" (Clean admission.)
10. **Operator** [dda9a5c3#267]: "if we're going to share this with the world as we plan to eventually it needs to be for the standard plus a little tolerance but we should anchor ourselves to the standard" (First publishing intent.)
11. **Assistant** [dda9a5c3#297]: "🎉🖨️✅ **Ready to slice and send to the printer!** 🚀💡🔩✨" (Requested: "Let me know with a bevy of Emoji" [dda9a5c3#329 summary].)
12. **Operator** [dda9a5c3#304]: "we can cast it as a feature. It means that they will slot into a box next to each other and stay" (Cost becomes feature.)
13. **Operator** [dda9a5c3#304]: "supports are not inherently evil" (One-line philosophy.)
14. **Operator** [dda9a5c3#329 summary]: "Bold of you to assume I know what a lintel is. OK I see. ... So this is actually brilliant! I'mma print the fit test." (Jargon called out, then won over.)
15. **Operator** [dda9a5c3#329 summary]: "the best of both worlds like Hannah Montana" (Humor.)
16. **Operator** [dda9a5c3#323]: "we'll cross that bridge when we get to it" (Unintended pun mid bridge-printing debate.)
17. **Assistant** [dda9a5c3#414]: "GitHub keeps the source; people find prints elsewhere. ... everyone uploads by hand." (The gap that became the next project.)
18. **Operator** [dda9a5c3#428]: "Well hey, we know our next project, don't we? ... We only need one...!" (Origin of the CD pipeline.)
19. **Operator** [dda9a5c3#466]: "hell we could curl it, couldn't we? how's it auth?" (Optimism before Cloudflare.)
20. **Assistant** [dda9a5c3#515]: "curl's TLS handshake looks like curl whatever user agent it sends, so "Firefox" over curl's handshake is a mismatch that looks more like a bot, not less." (Why spoofing fails.)
21. **Operator** [45e66c5d#0]: "even the slightest wibble back and forth pivoting is enough to lift the flange not the flange sorry the tab out of its little recessed spot" (Vivid failure, corrected mid-dictation.)
22. **Operator** [45e66c5d#0]: "dimensionally everything seems beautiful" (The standard pays off.)
23. **Operator** [45e66c5d#200 summary]: "don't go overboard designing tests that don't actually guard or protect a behavior ... we're still in the prototyping phase." (TDD vs prototyping.)
24. **Assistant** [45e66c5d#12]: "if that roof touches the arm, the arm's springy span drops from 30 mm to about 10 mm." (A guide that would kill the spring.)

## Unique Technical Details

- **H7 envelope (UN R37, sheet H7/1):** ≤Ø25.0 for 4.1 mm in front of the reference plane, then Ø19.0; glass ≤Ø15; ≤44 mm long; reference plane set by three bosses on the flange front [dda9a5c3#102, #135 summary].
- **PX26d (IEC 60061-1 sheet 7004-5)** via GOST IEC 60061-1-2014: O, K, Q, M as above; letters assigned by fit and cross-checked with a retailer's "34 mm round plate, 21 mm flat, 8 mm tab" [dda9a5c3#297].
- **Getting drawings by script:** UNECE PDF behind a Cloudflare challenge; EUR-Lex returned HTTP 202 with an empty body; the Australian ADR 51/00 Word file worked, with its drawings extracted via `olefile` [dda9a5c3#135 summary].
- **How the car holds it:** a wire spring clip in the gap between flange and base or heatsink; v1 reused that gap [dda9a5c3#102].
- **Bridges vs cantilevers:** the agent's `overhang.py` classifies each flat overhang as a bridge (held both sides) or cantilever (one side); square collar gives ~6 mm bridges [dda9a5c3#303, #329 summary].
- **Shoulder trick:** with 45° faces the rounded corner ridges of the square-to-round shoulder lean ~55°; setting the faces to 55° brings the ridges to 45° [dda9a5c3#171, #303].
- **Material (solid volume):** v2 round 16.0 cm³; square, 55° shoulder 23.3; square, 45° shoulder 20.6; collar-down 20.1; real grams differ less because the shoulder is mostly infill [dda9a5c3#303, #322].
- **CadQuery/OpenCascade gotchas:** cone tips meeting at a point left 8 bad edges and a non-watertight STL, fixed with a ruled loft between rounded squares [dda9a5c3#167]; a zero or oversized chamfer fails with "command not done" [45e66c5d#76].
- **Clip mechanics:** cantilever snap barbs at ~20-24 MPa estimated arm stress; spring bump squeezes the flange 0.1-0.6 mm across each band; PETG at 100% infill recommended because "the tines are springs" [dda9a5c3#134, #135 summary].
- **Verification:** boolean collision checks against mock bulbs and a Ø38 heatsink, insertion sweeps both ways, squeezed-release sweeps; ~77-84 s per run; regenerated STLs byte-identical to committed ones [45e66c5d#59, #174].
- **Environment gotchas:** creating `h7 bulb case` silently matched `H7 bulb case` (NTFS is case-insensitive) [dda9a5c3#65]; the agent's memory was keyed to the starting folder, stranding H7 notes under H11 [dda9a5c3#340].
- **Upload APIs, as researched Oct 13 (docs only, untested):** Thingiverse REST + OAuth2, apps private until moderated; Cults3D GraphQL `createCreation`, HTTP Basic with nickname + API key, files given as URLs, licence defaults to "Cults - Private Use"; MyMiniFactory API v2 with staff test-prints; Sketchfab (viewer only); Thangs (desktop bulk uploader); Printables (undocumented GraphQL; Manyfold's sync "blocked" since July 2025); MakerWorld (web only, imports from linked Thingiverse or Printables); Yeggi (aggregator) [dda9a5c3#461, #465].
- **Thingiverse spec via Wayback (April 2025):** Bearer auth only; `POST /things/` needs name, license (`cc`, `cc-sa`, `cc-nd`, `cc-nc-sa`, `cc-nc-nd`, `pd0`, `gpl`, `lgpl`, `bsd`) and category by full name; the file-upload operation is defined but missing from the paths list; publish returns 400 if name or description is blank [dda9a5c3#515].
- **Cloudflare:** 403 "Just a moment..." for every user agent, with or without a token; it checks TLS fingerprint and JavaScript, not the UA string. Cults3D replied `401 HTTP Basic: Access denied` [dda9a5c3#493, #515].

## Emotional Beats And Humor

- A dare answered in 16 minutes [dda9a5c3#0, #102]; "dope as hell" [dda9a5c3#103].
- "mea culpa" over the brim-less print [dda9a5c3#136].
- Caliper exasperation ("come on man", "it's a circle dude", "fine fine") [dda9a5c3#227].
- The requested emoji bevy [dda9a5c3#297].
- The lintel exchange, "Hannah Montana", "funzis", and the bridge pun [dda9a5c3#322, #323, #329 summary].
- "monorepo (bleh)" [dda9a5c3#516 summary]; "'cmon man commit the other repo" [dda9a5c3#415]; the one-word "yeggi?" [dda9a5c3#462].
- Spotting the next project: "we know our next project, don't we?" [dda9a5c3#428].
- Cliffhanger: the usage limit cut the v4 run at 01:37; it resumed three hours later [45e66c5d#162, #166].
- Payoff: "that's fantastic", "dimensionally everything seems beautiful" [45e66c5d#0].

## Candidate Blog Angles

- **"Looks dope, won't fit in a bin."** The first agent design was correct and impractical; the operator's storage and car-connector experience reshaped it. Audience: makers and engineers curious about AI-assisted design.
- **Find the standard, not the photo.** Every early fit bug came from guessing from photos; the fix was a paywalled IEC sheet found through a Russian national adoption. Audience: anyone designing to a standard.
- **"Supports are not inherently evil."** Orientation as a design input: bridges vs cantilevers, the square collar, the 55° shoulder trick, the material table, and working surfaces that must not depend on supports. Audience: 3D-printing hobbyists.
- **What CAD can't tell you.** Every version passed collision checks; every print found something new (spinning bulb, shallow keys, gravity). Audience: skeptics of agent-designed parts.
- **From bulb case to publishing pipeline in one evening.** Compaction, persistence, repo, monorepo question, "everyone uploads by hand", API survey, the Cloudflare wall. Audience: developers interested in CD for physical things.
- **Don't test the prototype.** A short section rather than a post: test-first rules vs "we're still in the prototyping phase". Audience: developers using agents with TDD rules.

## Open Questions And Uncertainties

- **v4 print result** is not in these transcripts.
- **Clip band naming:** "2.0-2.5 mm flange" clip on a ~1 mm flange, flagged but unresolved here [45e66c5d#12]; likely resolved by the later rename (inference).
- **Fit-test height:** "8 mm tall" [dda9a5c3#209], "only 14 mm tall" [dda9a5c3#322], 43 × 43 × 13.95 [dda9a5c3#329 summary]. Probably 8 mm above the seat plus collar; "about 14 mm" printed.
- **v3 volume:** "16 to 25 cm³" [dda9a5c3#209] before the standard resized the bore and collar; 23.3 after [dda9a5c3#303].
- **Tab width:** 7.5, then 7.67-7.8, modelled 7.7; standard K is 7.9-8.0 [dda9a5c3#210, #227, #266].
- **Mid-turn quotes** ("funzis", "lintel", "Hannah Montana", "don't go overboard", gravity) exist only in compaction summaries; wording depends on the summarizer.
- **Session 1 after 00:23:** nothing visible until the 01:18 compaction.
- **Supports on the v3 fit test:** the agent said none were needed [dda9a5c3#250]; whether any were used is not stated.
- **H11 case:** here it "works" and printed "almost perfect vertically except the channel it twistlocks into" [dda9a5c3#0, #136]. The background's "failed the standard" is a later finding, not a contradiction.
- **"Spring clip"** in the background describes the final design; here the clip is a barbed snap-latch with spring bumps.
- **Unverified:** MyMiniFactory's February 2026 purchase of Thingiverse is the agent's web finding [dda9a5c3#461].
- **Printer, slicer, filament** are not named; PETG is only the agent's recommendation [dda9a5c3#134].

## Privacy Flags

- Transcript headers and summaries contain the operator's local Windows paths, including their Windows username; agent sandbox paths embed it too. Never quote; use `<operator-docs>/...`.
- Early commits used a placeholder test identity from the machine's global git config (flagged by the agent). Don't quote its email.
- Skill text exposes the operator's private handoff repo path and agent-memory tooling internals. Describe generically if at all.
- A summary contains the operator's rules-source repo URL (public handle); check before linking.
- A third-party MakerWorld STL was committed to the operator's local repo with its licence unresolved; don't imply redistribution.
- The operator's plan usage limit appears; mention only generically.
- The bulbs are for the operator's car ("maybe even in your car" [dda9a5c3#103]). No vehicle model is named in the text, but photos were attached; don't infer or name it.
