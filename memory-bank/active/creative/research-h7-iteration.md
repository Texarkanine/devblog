# Research Digest: H7 Iteration

## Sessions Covered

- `2026-10-13-1258-claude-6e0ed576.md` (Claude Code, title "Flange pocket depth for clips"), 2026-10-13 12:58 to 2026-10-14 14:51 (transcript timestamps are UTC; see Open Questions). The session opens with design 0.4 ("v4") already modelled and waiting for its fit-test print. Over one day it takes the H7 cover and clip through four physical prints and two internal releases: v1 (bigger barb, sized tube) and v2 (clip arms printed angled outward so they act as a preloaded spring). The 2026-10-14 part is only a declined `/handoff`.

## What Happened

**12:58, the pocket-depth argument.** The operator opens with `/nk-chat` (read-only Q&A) just before printing the 0.4 fit test. They object that the agent built the wrong thing: "the tabs are very thick but the little channel for the rest of the flange is shallow that's not what I was meaning ... sink the entire channel for the flange, the tab is part of the flange, make that deeper" [6e0ed576#0]. The in-flight task was "h7-cover-v4: bigger barbs, taller key blocks (4.5 mm), and a roof over the barb groove" [6e0ed576#15]. The agent admits the misreading: "I took your v3 note as 'make the key blocks taller.' You meant 'sink the whole flange pocket.'" [6e0ed576#15].

Before answering, the agent runs "a throwaway script in scratch" to measure the pocket wall around the flange. It is about 4.9 mm at the tab ends, about 3 mm mid-side, and **0.5 mm** over four stretches of about 40° each, exactly where the clip tunnels pass through the side walls [6e0ed576#15]. The reason: wherever a clip arm crosses the wall, the wall can't be taller than the thinnest flange the clips fit (1.0 mm) minus room for the bump to slide past. The agent offers three options: print 0.4 as-is; trim the inner tunnel to win back about 8° per stretch; or redesign the retention entirely, e.g. "a ring that screws or twists onto the back, like the MakerWorld case" [6e0ed576#15].

The operator wants "a pocket where the [flange] is going to sit a millimeter below flush" and sends an annotated picture, "I tried to mark in green the height I'm talking about making higher by making the platform the flange sits on, lower" [6e0ed576#16]. The agent maps their green line onto its "pocket wall" term and explains why lowering the platform doesn't help: the bulge must reach down further, so the step it slides over drops too [6e0ed576#25]. The operator pushes back hard: "literally just take some layers off of the bottom of that ledge ... it's radially symmetric you have lots of vertical height you can just drop it two millimeters" and "I could do it with a file if I was bored" [6e0ed576#26-28]. The agent reframes in the operator's own terms, as the doorways the clip arms slide through: "A taller bulge always needs a taller doorway" [6e0ed576#32]. It proposes a workable variant (drop the ledge, taller bulges, narrow channels cut in each doorway floor), with sizes flagged as "estimates from the dimensions, not something I've modelled" [6e0ed576#32].

**14:28, the 0.4 print works.** The operator concedes ("Guh, you're absolutely right. The bulges are at capacity wrt the doors for them. Bollocks.") and reports that the 0.4 fit test "works perfectly. Oka, so that's our real V1! Call everything so far (just fyi) 0.X" [6e0ed576#33]. They ask for a slightly larger barb so clips can't get knocked out in storage. Mid-turn (per the later summary) they also ask that the tube be "the longest possible specification bulb for H7 ... and then give us like a centimeter beyond that" [6e0ed576#229].

**14:31, research and constraint answers (still in read-only chat).** The barb can go from 2.0 to at most **2.2 mm**, because the arm has to bend inward through the doorway. The catch on the collar goes 1.7 to 1.9 mm. The cover's groove has to deepen 0.2 mm too, so cover and clips must be printed as a matched set [6e0ed576#60]. Tube: the longest legal H7 is 44.0 mm from the flange's front face (UN R37 sheet H7/1). The agent notes that "Online, that sheet is only a picture, so I couldn't re-read the number myself today" and cross-checks a distributor table. The current tube allows 52 mm, so the operator's rule gives 54 mm [6e0ed576#60]. It also warns that "LED replacement bulbs don't always keep to the standard" [6e0ed576#60].

**15:09–16:15, release v1.** The operator runs `/niko make the changes, please!` [6e0ed576#61]. The agent insists on archiving the finished 0.4 task first rather than mixing it in, "v4 succeeded, so mixing new changes into its record would blur what was tested" [6e0ed576#64]. Level 2 workflow: plan → preflight subagent → build → QA subagent → reflect. Preflight ran a scratch copy of the model with v1 values and passed with advisories. Among them was a floating-point trap, "The raw value is 1.8999999999999986, so a plain `>= 1.9` would fail" [6e0ed576#125]. It also suggested making the v1 cover a fixed base so future clip changes wouldn't force cover reprints (not applied) [6e0ed576#125]. The build ran TDD-style. Check H went red at 1.70 mm, then green at 1.90. A new check K, which intersects a solid "maximum H7 lamp" with the cover body, went red with 567 mm³ of overlap at 52 mm and green at 54 [6e0ed576#136-153]. QA mutation-tested the new checks: HEAD_LEN 53.9 turns K red (28.35 mm³), BARB 2.1 turns H red [6e0ed576#183]. Tagged `v1-print1`; cover now 62.0 mm long [6e0ed576#196, #210]. The operator approves renaming old tags `v3-print1`/`v4-print1` to `0.3-print1`/`0.4-print1` so `v<N>` stays free, "Yes, rename." [6e0ed576#211-228].

**18:32, v1 print feedback and the clip-variant experiment.** "The container's great, but let's rework the clip." The friendly back angle lets the clip "slide out very easily when you pull," and the straight arms sit "at a bent in angle" under slight inward pressure [6e0ed576#230]. The operator designs a 2×2 experiment: square (90°) barb back; legs "ever so slightly angled outwards so that the whole thing was in constant tension"; and both. They limit it to one band: "only do it at the two millimeter bump, because that's the one that I'm using" [6e0ed576#230]. The agent restates with numbers. Arms spread about 1.5°. The far tunnel wall pushes each arm back about 0.8 mm, and each barb catches its full 2.2 mm. A beam estimate says the preload is only "roughly 0.1 to 0.3 N (the weight of 10 to 30 g)," because the 2.4 mm bridge bar flexes more than the 3.8 mm arms [6e0ed576#271]. The operator replies "You got it, babe!" [6e0ed576#272].

**18:57, preflight catches a pose bug.** Preflight returns FAIL (fixable). Spreading turns the whole arm, so the spring bump also moves 0.57–0.62 mm outward. In the rigid as-printed model it cuts up to 0.36 mm into the collar wall, while in the pose the cover actually forces (0.397°) it clears [6e0ed576#296]. Preflight also suggests a water-bottle pull test [6e0ed576#296]. Re-planned, re-preflighted (PASS; suggests a fourth `spread-2.5` clip) [6e0ed576#315]. Build, QA PASS, tag `v1-print2` [6e0ed576#335-399]. Reflection insight: "A clip that is printed bent has to be checked in two positions" [6e0ed576#399].

**20:31, the "3 mm" misunderstanding.** Result: "They're all a little loose so it's hard to tell but I think I like the 90 degree and angled out the best" — and the operator asks for "three millimeter versions," reading the band name as bump size [6e0ed576#400]. The agent explained (via a question whose text is not in the transcript) that the band is the *flange thickness*, so a *thinner* band means a *taller* bump. The operator chose the 1.5–2.0 band (bump 1.95 mm vs 1.45 mm) as a rework [6e0ed576#417, #657]. README gains "the band number is the flange thickness, not the bump size" [6e0ed576#434]. Preflight suggests a "bump ladder" (1.45/1.70/1.95), noting "an earlier session measured your flange plate at about 1 mm, so the real thickness under the bumps is unknown" [6e0ed576#435]. Tagged `v1-print3` [6e0ed576#486-489].

**22:08, the winner and v2.** "The combo - angle'd backside of the barbs, and the slight bulge - is the winner. Lock it in & then /niko-archive !" [6e0ed576#490]. The agent interprets the winner as **spread** (v1's leaning barb back plus 1.5° arms) and confirms by question that it's spread, not square-spread, and that the release is called v2 [6e0ed576#498, #657]. Preflight 4 fails *blocking*. The plan made `clip()` default to the held pose, so the export could silently ship the 0.397° clip instead of the 1.5° one "and every check would still pass" [6e0ed576#523]. Per the operator's preference against a heavy suite, the fix is a one-off byte comparison of new STLs against the printed spread STLs rather than a permanent test [6e0ed576#538, #657]. The first QA dies on a usage limit and is restarted [6e0ed576#604-612]. The second QA fails the build for a README line the agent invented: the square catch "held hardest" [6e0ed576#613]. Fixed, re-QA'd PASS, tagged `v2-print1`, archived (commit 0382439) [6e0ed576#615-652].

**2026-10-14 13:57.** `/handoff` declined: "Nothing worth handing off" [6e0ed576#656].

## Turning Points

- **"Deeper key" meant something else.** The agent believed the v3 note meant taller key blocks and built 4.5 mm blocks. The operator meant the whole flange pocket [6e0ed576#0, #15]. It surfaced only when the operator looked at the model before printing. The agent recorded it as a lesson.
- **The geometry said no, and the operator came round.** The operator was sure that lowering the platform was "incredibly simple" [6e0ed576#26]. The agent's doorway explanation turned them: "Guh, you're absolutely right" [6e0ed576#33]. The idea was dropped, not built.
- **The print that was "complained about" became v1.** The operator printed 0.4 to get "comparison data points" [6e0ed576#16], and it "works perfectly" [6e0ed576#33]. All prior versions were renumbered 0.x on the spot.
- **The friendly barb angle is quantified as the leak.** Pulled back 0.3 mm, a square barb still catches 1.90 mm, but "the v1 clip meets it over 0 mm" [6e0ed576#296].
- **Band names misled the operator.** From [6e0ed576#230] ("the two millimeter bump") through [6e0ed576#400] ("three millimeter versions"), the operator read `2.0-2.5mm` as bump size. In fact it is the flange-thickness range, and the clip that won was the *1.5–2.0* band with the *taller* bump.
- **The spread clip collides only in a pose it never takes.** Treating the bent-printed arm as rigid shows a collision. In the pose the cover forces, it clears. Preflight caught the false alarm before build [6e0ed576#296]. The general insight is to check printed-bent parts in both poses [6e0ed576#399].
- **A test suite that can't see the export.** Making the held pose the default meant every check could pass while the wrong STL shipped [6e0ed576#523]. Proof that v2 is the tested part came from byte-identical STL comparison instead [6e0ed576#580].
- **The agent fabricated a result, and QA caught it.** Build wrote "A squarer catch face (BARB_LEAN 0) was tried and held hardest" into the public README. QA: "No result supports 'held hardest'... Build wrote the phrase itself" [6e0ed576#613]. Agent: "QA is right. 'Held hardest' is a claim I wrote with no evidence behind it." [6e0ed576#615].

## The Physical Loop

| When | Print | What the real world said | What changed |
|---|---|---|---|
| Before 12:58 (pre-print look) | 0.4 model in slicer/viewer | Tabs thick, flange channel shallow; operator marks the wanted height in green on a picture [6e0ed576#0, #16] | Explanation only; idea dropped |
| 14:28 | 0.4 fit test (`h7_fit_test` + `h7_clip_flange_2.0-2.5mm`) | "works perfectly" [6e0ed576#33] | Becomes v1; barb 2.0→2.2, tube 52→54 mm |
| 18:32 | `v1-print1` (62 mm cover, 2.2 mm barb) | Cover "great"; clip pulls out "with only a small tug, and the arms bow inward under light pressure" [6e0ed576#230, #246] | Three trial clips |
| 20:31 | `v1-print2` (square / spread / square-spread, 2.0–2.5 band, bump 1.45 mm) | "They're all a little loose so it's hard to tell" [6e0ed576#400] | Same trials in 1.5–2.0 band (bump 1.95 mm) |
| 22:08 | `v1-print3` (plain + three trials, 1.5–2.0 band) | Spread wins [6e0ed576#490] | Spread becomes every band's clip: v2 |

Other numbers from the loop:

- The H check's history records how catch depth grew print by print: "0.3 caught 1.2, 0.4 caught 1.7, v1 must catch ≥ 1.9" [6e0ed576#229]. v2 catches 2.21 mm [6e0ed576#563].
- Print turnaround was tight. The agent tagged `v1-print2` at 19:25 and the result arrived at 20:31. `v1-print3` was tagged 21:15 and its result arrived at 22:08 [6e0ed576#388, #400, #486, #490].
- The agent didn't trust matching file sizes. "The new STL sizes match the 2.0-2.5 ones byte for byte. That is expected for files with the same face count, but I'm confirming the new clips really have the taller bump." It measured 3.54 vs 3.04 mm tall at the bump [6e0ed576#459-462].
- Telling bands apart without calipers: QA noted that 3.5 vs 3.0 mm "needs calipers" but bump length (about 9.8 vs 8.0 mm) "can be seen by eye"; README also says to mark sets with a pen [6e0ed576#480, #482].
- The agent advised the operator to measure their own bulbs before shortening the tube, because LED replacements may not follow the standard [6e0ed576#60].
- A flange-thickness mystery: an earlier session measured the operator's flange plate "at about 1 mm," yet the winning clip is the 1.5–2.0 band [6e0ed576#435]. (Inference: the effective thickness the clip bears on may differ from the plate measurement; the transcript leaves it open.)

## Operator Corrections And Teachings

- **Read my intent, not my words:** "I was meaning that you sink the entire channel for the flange, the tab is part of the flange" [6e0ed576#0].
- **Comparison data over argument:** "I'm Going to print the one that I complained about because it's possible my idea ... is going to make it too hard for the clips to lock in so we want the comparison data points" [6e0ed576#16].
- **The maker's sanity check:** "I could do it with a file if I was bored." / "like a scraper or file, not a data on disk. nail file, etc. Knife even." [6e0ed576#27-28].
- **Versioning by reality:** "that's our real V1! Call everything so far (just fyi) 0.X of whatever version it's been!" [6e0ed576#33].
- **Material economy:** "we want to make sure that the full tube isn't any longer than it needs to be we don't want to waste material or space" (quoted in compaction summary) [6e0ed576#229].
- **Experimental design:** three variants, one variable each plus the combo, in one band only; "If any of those design variants proves better that's the one we'll end up using and include the various bump sizes" [6e0ed576#230].
- **Knowing when it's good enough:** "everything else turned out really good and honestly this is good enough and now we're just chasing excellence !" [6e0ed576#230].
- **Keep the test suite lean:** per the agent's summary, the operator said "why even bother? … don't go overboard?" about a big test suite for a public 3D-model repo. They declined a permanent export-vs-model check in favour of one-off comparisons [6e0ed576#657]. The agent wrote this into `techContext.md` [6e0ed576#596]. The verbatim exchange isn't in the transcript, only this summary.
- **Norm set by QA, adopted by the agent:** README test results must come only from the operator's own reports [6e0ed576#613, #657].
- **Process norms the agent held to:** it would not edit from read-only chat ("Chat is read-only, so I won't change anything from here.") [6e0ed576#25], and it archived each successful task before starting the next [6e0ed576#64, #241].

## Quotable Lines

1. Operator [6e0ed576#0]: "the tabs are very thick but the little channel for the rest of the flange is shallow that's not what I was meaning". This is the inciting complaint, from looking at the part before printing.
2. Assistant [6e0ed576#15]: "**Short answer: no. Most of the shallow part can't be made deeper with this clip at all.**" A blunt "no", backed by measurement.
3. Assistant [6e0ed576#15]: "I took your v3 note as 'make the key blocks taller.' You meant 'sink the whole flange pocket.'" A clean admission of a misreading.
4. Operator [6e0ed576#26]: "I want it deeper so that it doesn't wibble wobble out if it stays shallow it's always going to wibble wobble out." Vivid voice-dictated engineering.
5. Operator [6e0ed576#26]: "geometrically you're just like it's radially symmetric you have lots of vertical height you can just drop it two millimeters". The operator's confident and wrong intuition.
6. Operator [6e0ed576#27-28]: "I could do it with a file if I was bored." / "like a scraper or file, not a data on disk. nail file, etc. Knife even." Physical-maker humour, and the voice-dictation ambiguity of "file".
7. Assistant [6e0ed576#32]: "A taller bulge always needs a taller doorway, so wherever a bulge passes, the step can't be much taller than the thinnest flange the clips fit". The one-sentence constraint that ended the argument.
8. Operator [6e0ed576#33]: "Guh, you're absolutely right. The bulges are at capacity wrt the doors for them. Bollocks." Concession with personality.
9. Operator [6e0ed576#33]: "Well your original 'big tab for tab' has finished printing and... Yeah it works perfectly. Oka, so that's our real V1!" The test print redeems the design.
10. Assistant [6e0ed576#60]: "Online, that sheet is only a picture, so I couldn't re-read the number myself today." The standard's key drawing is image-only, and the agent says so honestly.
11. Assistant [6e0ed576#64]: "v4 succeeded, so mixing new changes into its record would blur what was tested." Record hygiene as a design value.
12. Operator [6e0ed576#230]: "it might be nice if the clip feet were ever so slightly angled outwards so that the whole thing was in constant tension pushing the hooks of the barbs out a little bit." The idea that became v2.
13. Operator [6e0ed576#230]: "honestly this is good enough and now we're just chasing excellence !" Sets the tone of the afternoon.
14. Assistant [6e0ed576#271]: "So 0.8 mm of spread gives only a gentle push, roughly 0.1 to 0.3 N (the weight of 10 to 30 g)." A back-of-envelope beam estimate before printing.
15. Operator [6e0ed576#272]: "You got it, babe!" Warmth.
16. Preflight subagent [6e0ed576#296]: "clamp the cover with the loop hanging down and hang a bottle from the loop on a string. Add water 50 mL at a time until the clip lets go." Kitchen-table metrology, offered and not taken up.
17. Assistant reflection [6e0ed576#399]: "A clip that is printed bent has to be checked in two positions: as printed, which shows how hard it presses against the cover; pressed back by the cover, which shows whether it fits." The generalisable lesson.
18. Operator [6e0ed576#400]: "They're all a little loose so it's hard to tell but I think I like the 90 degree and angled out the best". An honest, noisy test result.
19. Operator [6e0ed576#490]: "The combo - angle'd backside of the barbs, and the slight bulge - is the winner. Lock it in & then /niko-archive !" The verdict.
20. Preflight subagent [6e0ed576#523]: "As planned, that unit could export the wrong clip and every check would still pass." A test suite blind to its own output.
21. QA subagent [6e0ed576#613]: "No result supports 'held hardest'... Build wrote the phrase itself during its README edit." An AI reviewer catching an AI author's invented result.
22. Assistant [6e0ed576#615]: "QA is right. 'Held hardest' is a claim I wrote with no evidence behind it." A plain owning of the error.

## Unique Technical Details

- **Clip-through-wall constraint:** a sideways-sliding clip that hooks the back of the flange forces the pocket wall down to (thinnest flange − bump clearance) = 0.5 mm wherever an arm crosses it. The 0.4 cover had 4.9 / 3 / 0.5 mm wall depths around the flange [6e0ed576#15]. The flange is 34 mm across [6e0ed576#32].
- **UN R37 sheet H7/1:** maximum lamp outline Ø25 × 4.1 mm, then Ø19, at most 44.0 mm from the reference plane. The online sheet is image-only (Lexaris); a distributor table (Flosser) also lists 44 mm; makers' ~59 mm "overall" includes the plug behind the flange [6e0ed576#60, #229].
- **Tube sizing:** `HEAD_LEN = 54.0` (44 + 10 mm spare); cover 60 → 62.0 mm long [6e0ed576#229].
- **Barb limits:** `BARB = 2.2` is capped by the assertion `SQUEEZE >= BARB - CLEAR + 0.3`. `BARB_LEN = 4.4` keeps the ramp at about 27°. `BARB_LEAN` is the 20° "friendly" catch-face lean. The groove depends on barb size (`Y_FREE = Y1 + BARB + CLEAR`), so barb changes force cover reprints [6e0ed576#60, #125, #229].
- **Release squeeze:** 2.05 mm (v1); the squeeze needed at each tip went from 1.7–2.2 to 1.9–2.2 mm; the spread clip needs 2.35 mm (README: "about 2.5 mm each") [6e0ed576#183, #315, #399, #652].
- **Spread clip (v2):** printed `ARM_SPREAD` 1.5°; held pose `HELD_SPREAD = atan(CLEAR/(HALF−X_BAR)) ≈ 0.397°`; preload 0.834 mm per side; catch 2.207/2.201 mm; tips 1.25/1.30 mm wider than v1; tip starts 0.22 mm wide of its tunnel; 2.5° is the most spread that still clears the near tunnel [6e0ed576#271, #296, #315, #375, #657]. In use, the arms reach 17.1 mm from centre (README previously said 16.8) [6e0ed576#523].
- **Bump-corner graze in the rigid model:** 0.40 / 0.38 / 0.36 / 0.33 mm across the four v2 bands. A bending-arm worst case puts it at about 0.02 mm, "below print resolution" [6e0ed576#435, #523, #628].
- **Bands vs bumps:** the 2.0–2.5 band has a 1.45 mm bump (about 8.0 mm long, clip 3.04 mm tall at the bump). The 1.5–2.0 band has a 1.95 mm bump (about 9.8 mm long, 3.54 mm tall) [6e0ed576#435, #462, #489].
- **Printability:** the 0.4 and v1 covers each have "4 tunnel bridges and 2 groove ledges of 1 mm" (in v1 "moved up 2 mm, with the ledges 0.2 mm further out"), are watertight, and "print without supports". Clips have no overhangs. Parts are exported in print orientation and printed "flat, solid infill" [6e0ed576#125, #183, #182, #399]. The overhang/watertight check is `tools/overhang.py` (trimesh, shapely, rtree, networkx, scipy) [6e0ed576#657].
- **Toolchain:** parametric CadQuery `h7_led_cover.py`, run as `uv run --no-project --with cadquery python ...`; fit suite `tools/check_fit.py` with lettered sections A–L. It actually had 47 checks (earlier records said 50, counting 3 info lines), then 55 with section L, and runs in about 77–82 s [6e0ed576#229, #375, #585].
- **Geometry-as-test idiom:** checks intersect solids and measure overlap volume (e.g. `vol(max_lamp(length).intersect(body))`) rather than mirroring parameters. QA mutation-tested them to prove they're "live" [6e0ed576#125, #183, #229].
- **Floating point in CAD checks:** the catch came out as 1.8999999999999986, so the checks need a 0.01 tolerance [6e0ed576#125, #296].
- **STEP export noise:** STEP files change on every export (header timestamp, plus a `PRODUCT` export counter that shifts when export order changes). Header-only diffs are restored with `git checkout --`, never committed. STLs regenerate byte-identically and serve as the proof of sameness [6e0ed576#353-355, #435, #455, #657].
- **Verification pipeline per change:** preflight subagents applied the plan to a scratch copy and ran it before the build (about 7–13 minutes each). QA subagents re-ran everything in scratch, including mutation tests (about 3–6 minutes each). There were six preflights and six QA launches in one day [6e0ed576#125-#628].
- **Tag scheme:** `v<N>-print<M>` for releases, `0.<N>-print<M>` for pre-releases. Tags this session: `v1-print1` (2187846), `v1-print2` (b8b145c), `v1-print3` (d9e21d7), `v2-print1` (0cb7fd9). The repo had no remote at the time [6e0ed576#210, #228, #657].

## Emotional Beats And Humor

- Tension at the start: the operator is mildly frustrated that the agent built the wrong thing ("that's not what I was meaning") and is sure the fix is trivial [6e0ed576#0, #26].
- Comic deflation: "I could do it with a file if I was bored," then the immediate clarification that they mean a nail file, not a data file. "Knife even." [6e0ed576#27-28].
- Graceful concession plus relief in one breath: "Guh, you're absolutely right ... Bollocks ... Yeah it works perfectly" [6e0ed576#33].
- Affection and momentum: "You got it, babe!" [6e0ed576#272]; "now we're just chasing excellence !" [6e0ed576#230].
- Mild embarrassment for the agent: QA caught it inventing a result for the public README, and it owned it plainly [6e0ed576#613-615, #627, #652].
- An interruption: the QA agent died on a usage limit late in the evening, and the work resumed about 12 minutes later [6e0ed576#604-612].
- A quiet ending: the next day's `/handoff` found "Nothing worth handing off," because everything was archived [6e0ed576#656].

## Candidate Blog Angles

1. **"The print that was supposed to lose."** The operator printed the design they'd just complained about, purely for comparison, and it became v1. A story about letting test prints settle arguments. Audience: hobbyist makers and anyone who designs physical things with AI help.
2. **"A taller bulge always needs a taller doorway."** How a snap-clip that slides in from the side constrains its pocket, told through the human-vs-agent argument, the green-marked photo, and the one-sentence geometric reason. Audience: people new to designing snap-fits and clips for FDM.
3. **"Printed bent: checking a spring in two poses."** The spread-arm clip, why the rigid model showed a phantom collision, and why the test suite could pass while shipping the wrong pose. Audience: CadQuery/code-CAD users and engineers interested in testing geometry.
4. **"Four prints, one day: a controlled experiment with a 3D printer."** The 2×2 clip experiment (square catch × spread legs), noisy subjective results ("all a little loose"), the band-naming confusion, and the convergence on v2. Audience: makers; anyone interested in iterating physical designs quickly.
5. **"My AI reviewer caught my AI author making things up."** The preflight/QA subagent pipeline, the "held hardest" fabrication, and the norm that public test results come only from the human's reports. Audience: developers using agentic workflows.
6. **"How much test suite does a 3D model need?"** The operator's "don't go overboard" against the agent's urge to add permanent checks, resolved with one-off byte comparisons of STLs. Audience: developers bringing software habits to hardware hobbies.

## Open Questions And Uncertainties

- **Contradiction with brief scope:** this transcript does not cover iterating from scratch. Versions 0.1–0.3 were designed and printed in an earlier session (archive `features/20261012-h7-cover-v1-v3.md`; "Test prints of 0.2 to 0.4 ... (2026-10-12/13)") [6e0ed576#15, #229]. This session starts at 0.4, and its 2026-10-14 portion is only a declined handoff [6e0ed576#656].
- **Contradiction with catalog context:** this work happened in a standalone local "H7 bulb case" repo with "no remote" [6e0ed576#210]. Nothing in it touches the 3d-models catalog, release-please or Cults3D. How the internal v1/v2 releases map to catalog versions isn't in this transcript.
- **Print orientation and supports** get little discussion here. Parts are exported in print orientation, printed flat, and need no supports. The "roof over the barb groove" was a 0.4 change made before this session [6e0ed576#15]. Any richer orientation story is in the earlier session.
- **Which clip "I liked" before:** at [6e0ed576#400] the operator says "the one I was using before that I liked was actually the three millimeter." All clips printed in this session were the 2.0–2.5 band, so this may be a misremembering driven by the naming confusion. Unresolved in the transcript.
- **Winner interpretation:** "The combo" [6e0ed576#490] could read as square-spread. The agent confirmed "spread" by a question whose text isn't in the transcript; the summary says it was confirmed [6e0ed576#657].
- **Operator's "don't go overboard" quote** exists only in the agent's compaction summary, not as a verbatim operator turn [6e0ed576#657].
- **Flange thickness:** earlier measured "about 1 mm," but the winning band is 1.5–2.0 [6e0ed576#435]. Never reconciled.
- **Timestamps** appear to be UTC: the usage-limit message says "resets 6:30pm (America/Chicago)" at a 23:19 timestamp, and the reset notice arrives at 23:31 [6e0ed576#604-606]. So the operator's local times run about 5 hours earlier than listed.
- **"59 mm overall length"** in the v2 QA README check [6e0ed576#613] is ambiguous: it is either the bulb's overall length or some part dimension (the cover is 62 mm).
- **"MakerWorld case"** [6e0ed576#15] is cited as a twist-on H7 reference. Its relationship to the Printables H11 case named in the context is unclear.
- **v2 coverage:** the 1.0–1.5 and 2.5–3.0 v2 clips were never printed [6e0ed576#652].

## Privacy Flags

- Transcript paths embed the operator's Windows username (their first name) and personal documents folder structure. Use `<operator-docs>/...` or omit.
- The usage-limit message reveals the operator's time zone and AI-plan reset time [6e0ed576#605].
- Request ids, task ids, tool-use ids and `/tmp` scratchpad paths appear throughout. Don't reproduce them.
- The commit trailer includes an email address for the agent persona. Don't reproduce it.
- Private tooling is named: a "shop repo" for handoff batons under the operator's config directory, and a private memory tool. Describe generically if at all; the handoff skill itself says batons are "not public".
- The operator's own bulbs (LED replacements) are mentioned; no vehicle is named in this transcript.
