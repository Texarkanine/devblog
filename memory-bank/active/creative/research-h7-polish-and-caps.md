# Research Digest: H7 Polish And The Prong Caps

## Sessions Covered

- `2026-10-16-1351-claude-a79f8c63.md` (10-16 13:51-14:59): an LED H7 flange measured at 0.85 mm leads to clip files renamed and pruned against the PX26d standard. `README.txt` becomes `README.md`. Both clips are printed and work.
- `2026-10-16-1502-claude-58e497ae.md` (10-16 15:02-15:40): "too much detail" in the README, so each fact gets one home. Wrong print-setting claims are corrected, a pre-merge sweep runs, the print-tag rule is killed, and PR #9 is made ready.
- `2026-10-16-1620-claude-16dfa9a3.md` (10-16 16:20-16:48): Cursor Bugbot on PR #9. The clip for standard bulbs really did miss the flange. The fix is a second rename, not new geometry.
- `2026-10-18-1633-claude-912e6731.md` (10-18 16:33 to 10-19 16:19): prong and connector covers for both bulb families. The "three prongs" slip, test print 1 (H7 too big, H11 flops), the rework, a context compaction, and test print 2 ("Those both work!"). PR #16 is opened and merged.
- `2026-10-19-1107-cursor-b06fd584.md` (10-19 11:07): `h11_connector_cap` is renamed to `h11_prong_cover`. The meshes don't store the name; the script does.

## What Happened

**10-16, the clip rename.** The operator opened with a caliper reading: "My led bulb flange measures 0.85mm thick, and the 1.5-2.0mm clip is the one that it needs." They sketched a new naming scheme ("I think you can figure it out"), asked that any to-spec maximum be honoured, and asked for a feature branch [a79f8c63#0]. The agent went looking for the H7 flange limit, first in an earlier session's notes and then in another copy of the standard [a79f8c63#24, #35, #51]. The operator was watching the agent's thinking: "saw some 5.96mm in the thinking and... idk where that's relevant" [a79f8c63#42]. The agent kept the operator's uncommitted `publish.yaml` edit out of its own commits [a79f8c63#51, #95].

The files were renamed with git so history followed them. Regenerated STLs were byte-identical, and the STEP files differed only in a timestamp line, so the agent restored them [a79f8c63#77, #80]. The result [a79f8c63#103]: old `1.5-2.0` became `0.5-1.0` (for the 0.85 mm bulb), old `1.0-1.5` became `0.0-0.5` (a taller bump), and `2.0-2.5` and `2.5-3.0` were dropped. The reason came from PX26d sheet 7004-5-6. The plate is 0.6-0.8 mm thick, but the bulb rests on three lugs on the plate's front, so the plate's back can sit up to 1.4 mm behind the seat. The old names gave that depth, not the thickness. A new `PLATE_SETBACK = 1.0` was "taken from your bulb". The agent kept the thin clip against the operator's lean to drop it, because a bulb built to the standard "could rattle a little" in the main clip [a79f8c63#103].

The operator then asked for a proper `README.md`, framed by audience: Cults3D is "the primary consumption", and GitHub is for people who want the source. They asked the agent to "error on the side of not writing too much, because remember we do have a memory bank", and said they were printing both clips [a79f8c63#104]. The agent wrote "about 70 lines" and moved the print history into SumMem notes [a79f8c63#111, #128]. It also flagged that the operator's listing said PLA while its own notes preferred PETG [a79f8c63#128]. The operator replied: "Good, they worked. Thank you! /handoff" [a79f8c63#129, #141].

**10-16 15:02, "too much detail".** A new session opened with "Ah, the h7 README - too much detail." The README also cited an unlinked MakerWorld case cup and duplicated the Cults print notes: "I don't want duplicate information because I'm not going to maintain it and it will drift" [58e497ae#0]. While hunting for the link, the agent found the design was on Printables, not MakerWorld [58e497ae#31]. The new README has three parts: a sentence with the Cults link, a table of where things live, and the build command with pointers. It "holds no sizes, print settings or clip advice". The design rule became "each fact has one home" [58e497ae#59]. The agent listed problems in the operator's listing text without editing it ("it's your text"). One problem was the nonexistent file `h7_clip_flange_0.0-1.0mm.stl`; another was the agent's repeated claim that the clip needs 100% infill [58e497ae#59].

The operator corrected it: "We definitely only used pla [for] the clip ... I currently did 10% infill but it wasn't a problem because the default wall settings we're not going to try to tell people that stuff". They added "definitely fix and commit everything" [58e497ae#60]. The agent fixed the memory bank and committed `2f0ce38` and `853ada0` [58e497ae#64, #75]. When the operator asked "Anyting else we missed before we open a ppr and merge and publish?" [58e497ae#76], the agent swept for problems. It found that `tools/render_sections.py` would crash on a deleted clip, and that it read the cover through a hard-coded local Windows path, "and this repository is public" (fixed in `d72f57f`) [58e497ae#106]. The checks passed: STLs byte-identical to a fresh build, 0 fit failures, 80 repo tests. A draft [PR #9](https://github.com/Texarkanine/3d-models/pull/9) already existed with a stale description. The agent advised a squash merge, which gives one changelog line and patch release 1.0.4; a rebase would leak a mis-scoped commit into the changelog. It also noted a "Tat to publish" typo and a memory-bank rule that every test print gets a git tag [58e497ae#106]. The operator: "prints do NOT get tags ... We tag RELEASES" [58e497ae#107]. The rule was fixed, and PR #9 was pushed and marked ready [58e497ae#111, #129].

**10-16 16:20, Bugbot.** "hilariously, [PR #9] there are "pr issues". [...] please <3" [16dfa9a3#0]. There were two Bugbot findings; CodeRabbit had skipped [16dfa9a3#11]. The operator set a hard constraint: "the things that printed worked correctly and were geometrically correct. so.... don't go changing geometry or else I'l have to reprint" [16dfa9a3#27]. The agent judged each item on three questions (valid? worth fixing? in scope?) [16dfa9a3#29].

- **Item 1, valid.** The `0.5-1.0` clip's bump top sat 1.41 mm behind the seat, past the standard's 1.4 mm maximum, so it never touched a standard bulb. Fit section F tested only at `t + PLATE_SETBACK`, so it couldn't see the miss. The setback had come from one LED bulb whose plate is thicker than the standard allows. Disposition: "Don't take the reviewer's fix: reshaping the clip changes geometry. Rename instead." `PLATE_SETBACK` became 0.5, and the same bytes moved up a name again (`0.0-0.5` to `0.5-1.0`, `0.5-1.0` to `1.0-1.5`).
- **Item 2, valid.** The agent's new sentence "the listing gives no material advice" was false (the listing says "PLA (recommended)"), so it was deleted.

The fixes landed as `d669a34` and `f7af9aa`. 46 fit checks passed, including a new worst-case standard flange that the new `0.5-1.0` clip squeezes by 0.49 mm; the old one "stopped 0.01 mm short" [16dfa9a3#59, #71]. The rewritten PR maps the names on `main` to the final ones: `1.0-1.5` to `0.5-1.0`, and `1.5-2.0` to `1.0-1.5`. A deploy risk was noted: the live Cults listing already had a `1.0-1.5` file with the other shape [16dfa9a3#93].

**10-18 16:33, the prong-cover brief.** "So, GJ on the H*N* bulb covers. But, the prongs are exposed. I'd like if you could whip up three little plug covers" [912e6731#0]. The brief:

- **H9/H11 family:** a PLA "nubbin" that goes into the female socket and latches over the retaining bump, removed with a finger below and a thumb on the latch. "not flexxi not a waterseal".
- **H7:** "normall this is 3 prongs; you can find the spec". A friction fit with a pull grip, ideally an hourglass that is "radially symmetric".
- **LED H7:** "only two prongs", with full caliper measurements and "Yes these don't add up; they're very tiny and my calipers are relatively large".

The agent rendered the PX26d and PGJ19 sheets from the cached standard [912e6731#23]. The operator then conceded: "You're absolutely right that there are two tabs on an H7 bulb ... we don't need the three pin!" They had been thinking of the H4 bulb in their vehicle [912e6731#47, #48]. The agent built, mesh-checked, overhang-checked and rendered both parts. Along the way it fixed an overhang-checker crash and staggered facing ridges that would have printed shut [912e6731#72-#130, #231]. It also copied the test STLs into the operator's local print folders [912e6731#60, #64]. Its verdict was "You only need one H7 cover": the LED tabs matched the standard's 6.3 × 0.8 mm tabs at 11.5 mm centres [912e6731#156].

- **H7 v1:** a 25 × 31 mm round spool with a 17 mm waist. Two springs in each slot pinch each tab, "so it doesn't depend on how tight your printer makes the slots".
- **H11 v1:** a short plug in the socket mouth and a see-saw lever that hooks behind the side bump.

Nothing was committed or listed before a print [912e6731#156].

**10-18 21:24, test print 1.** The H7 "WORKS but is a little big ... I was expecting much closer to a rectangular extension of the plug itself, that just happened to cover the prongs ... commit firs[t] of course". The H11 has "a weird diagonal fade ... on the ovoid insert", and "doesn't retain; it has ONE clip, which does land, but... the thing flops loose". The operator's diagnosis: three unused retaining nubs, and an insert that never mates with the plug's material. They attached two photos of commercial H11 connectors to borrow from, and asked for Niko-style progress logging [912e6731#157, #158]. The agent committed v1 per model. It confirmed the stale task in `memory-bank/active` was finished before replacing it [912e6731#169-#175]. Then it redesigned both parts:

- **H7 v2:** the same springs, shorter and thinner, in a 12.8 × 17.8 × 12.2 mm block [912e6731#180, #185]. A render caught spring roots poking through a chamfer "as tiny nubs" [912e6731#190].
- **H11 v2:** a render caught a tooth placed wrong: "The revolve sweeps the other way from what I assumed" [912e6731#203]. The insert now fills the socket 13 mm deep, as "two towers, like the green insert in your second photo". Two arms clip the standard's end hooks with 45° teeth, so about 9 N pulls it off. It prints on its back face, which removes the diagonal. The side bump is abandoned, because an arm long enough to clear it doesn't fit [912e6731#230].

The context then ran out and the session was compacted. The summary records standing rules, including "Land on main only after a test print is verified and photographed" and "Do not add committed tests for prototype shapes" [912e6731#231].

**10-18 22:59, test print 2.** "Okay! Those both work! Please prepare a pull request ... I'll print enough for my bulbs and handle the photo updates" [912e6731#232]. The agent did four things:

- promoted its scratch fit checks to permanent sections, mutation-checked ("fail as they should when I break a part on purpose");
- added the caps to both `publish.yaml` files;
- fixed a Cults link it couldn't verify ("Cults blocks scripted requests");
- archived the task log and opened [PR #16](https://github.com/Texarkanine/3d-models/pull/16).

It gave a squash message so the unshipped v1 commits wouldn't reach the changelogs, and photo-name prefixes for upload order [912e6731#255-#314]. On 10-19 16:18: "Done, thank you very much! It's merged and making its way out" [912e6731#318]. The agent declined a handoff: "git already records everything" [912e6731#326].

**10-19 11:07, the rename.** "can we make [the three h11_connector_cap files] all be h11_prong_cover, matching how we named the h7s? I'm not sure if it's a simple name change to those three files or if you need to change content within them!" [b06fd584#0]. The answer was both: the meshes store no name, but the script's `export` call does, so renaming only the files "would have recreated the old filenames". `check_fit.py`, `publish.yaml` and the docs were updated too. The design notes still say "connector cap" as a description, and the 10-18 archive keeps the old name as history. 83 tests passed, and nothing was committed [b06fd584#19].

## Turning Points

- **The clip names measured the wrong thing.** The labels looked like plate thickness but gave the depth of the plate's back behind the seat, because of the three lugs. It surfaced when the 0.85 mm bulb needed the "1.5-2.0" clip and the PX26d drawing was read [a79f8c63#0, #103].
- **One bulb isn't the standard.** `PLATE_SETBACK = 1.0` came from a bulb whose 0.85 mm plate exceeds the standard's 0.8 mm. Bugbot showed the clip meant for standard bulbs missed by 0.01 mm. The setback became 0.5 and the fit check gained a worst-case flange [16dfa9a3#29, #71].
- **The fix was a rename.** With the geometry frozen by working prints, the agent accepted the finding but rejected the reviewer's reshape. It renamed the same bytes a second time, with byte-identical STLs as proof [16dfa9a3#27, #29, #55].
- **The pushback turned out right.** The thin clip the agent kept "in case a standard bulb rattles" [a79f8c63#103] became, after the Bugbot fix, the clip for standard bulbs, renamed `0.5-1.0` [16dfa9a3#71]. This framing is inference; no session states it.
- **The README overshot.** The operator asked for brevity, the agent wrote about 70 lines, and the end state holds no numbers at all [a79f8c63#104, #128; 58e497ae#0, #59].
- **The agent's print-setting claims kept being wrong.** It said 100% infill and PETG; the real print was PLA, 10%, default walls. Its replacement sentence, "the listing gives no material advice", was also false, and Bugbot caught it. The same error in a global memory note was fixed [a79f8c63#128; 58e497ae#59, #60; 16dfa9a3#29].
- **A credit was misattributed.** The source said MakerWorld; it was Printables [58e497ae#31].
- **"Three prongs" became two tabs, and three covers became two.** The operator had been thinking of the H4 bulb. The LED H7 matched the standard, so one H7 cover serves both bulbs [912e6731#47, #48, #156].
- **Test print 1 changed both designs.** The H7 grip worked but was "a lot". The H11's single side latch and shallow plug flopped. v2 used the standard's end hooks and a full-depth insert [912e6731#157, #230].
- **The "diagonal fade" was the agent's own "chin cut".** v1 had a cut that let a plug strip print as a cantilever; v2 removed it by changing the print orientation [912e6731#231].
- **Renders caught two geometry bugs before any print:** stray spring nubs and a reversed revolve [912e6731#190, #203].

## The Physical Loop

- **The trigger:** a caliper reading of 0.85 mm on the LED H7 flange, which needed the then-"1.5-2.0" clip [a79f8c63#0]. Against PX26d (plate 0.6-0.8 mm, back at most 1.4 mm behind the seat) this showed what the old names really measured [a79f8c63#103].
- **The rename print:** both clips printed after the first rename, and "Good, they worked" [a79f8c63#104, #129]. Because both shapes fit the 0.85 mm bulb, the listing's "0.85 mm flange uses 0.5-1.0" stayed true through the second rename [16dfa9a3#71].
- **The real settings:** PLA, 10% infill, default walls [58e497ae#60].
- **Frozen geometry:** "worked correctly and were geometrically correct", so every later change had to keep the STL bytes [16dfa9a3#27, #55].
- **The new fit check:** a worst-case standard flange (back 1.4 mm behind the seat) gets 0.49 mm of squeeze; the old label's clip was 0.01 mm short [16dfa9a3#71].
- **LED H7 tab measurements:**
  - Size: 0.8 thick, 6.2 wide, 10.3 long, 10.75 apart.
  - Retaining hole: 2.5 mm diameter, from 5.7 to 8.3 mm from the base.
  - Tip: tapers to 4.5 wide, starting 8 mm from the base [912e6731#0].
  - Against the standard (6.3 × 0.8 tabs, 11.5 c-c), they "match" [912e6731#156]. Inference: 10.75 is the face-to-face gap (11.5 − 0.8 = 10.7).
  - The tab hole was left out, since the Lear catalogue gives no hole size [912e6731#156].
- **Test print 1** (STLs 17:15, feedback 21:24 on 10-18): the spool grips but is too big; the H11 cap flops and shows a diagonal artifact; the insert's shape is right [912e6731#156, #157].
- **Real-world prior art:** photos of two commercial H11 connectors (pinch arms; a sleeve with a green insert) directly shaped v2 [912e6731#157, #230].
- **Test print 2** (v2 sent 21:44, verdict 22:59, about 75 minutes): "Those both work!" Final sizes: H7 block 12.8 × 17.8 × 12.2 mm, H11 cap 21.7 × 31.2 × 17 mm [912e6731#230, #232].

## Operator Corrections And Teachings

- **Audience split:** Cults is "the primary consumption". GitHub is for "people that want to work with the source and understand how we produced the output". Repo-wide topics like `publish.yaml` belong in the root README [a79f8c63#104].
- **No duplicates:** "I'm not going to maintain it and it will drift". The README carries only what has no better home and what "Orients somebody to how we ran this little folder of code" [58e497ae#0].
- **No slicer advice:** "this will all technically perform its role if people tune so we're not going to worry about that" [58e497ae#60]. The agent saved this as a preference [58e497ae#75].
- **Tag releases, not prints:** "prints do NOT get tags, we should fix that. We tag RELEASES. we might try 5 times to print a model/stl properly" [58e497ae#107].
- **Freeze proven geometry:** "don't go changing geometry or else I'l have to reprint" [16dfa9a3#27].
- **Commit before a redesign:** "commit firs[t] of course in case we want to keep this" [912e6731#157].
- **Size to the object, and diagnose:** the cover should be "a rectangular extension of the plug itself". The cap flopped because it used one nub of four and its insert didn't mate [912e6731#157].
- **Ergonomics and material are inputs:** a finger and thumb on the latch; an hourglass "the middle will locate in-between their fingers"; "print intent is PLA" [912e6731#0].
- **Name consistently:** "matching how we named the h7s" [b06fd584#0].

## Quotable Lines

1. Operator [a79f8c63#0]: "My led bulb flange measures 0.85mm thick, and the 1.5-2.0mm clip is the one that it needs." The measurement that starts the arc.
2. Operator [a79f8c63#42]: "saw some 5.96mm in the thinking and... idk where that's relevant." The operator auditing the agent's thinking live.
3. Assistant [a79f8c63#103]: "The clip's bump presses on the back of the plate, and the old names gave that depth, not the plate thickness." The aha.
4. Operator [58e497ae#0]: "Ah, the h7 README - too much detail." Right after asking for brevity.
5. Operator [58e497ae#0]: "I don't want duplicate information because I'm not going to maintain it and it will drift". The documentation philosophy.
6. Assistant [58e497ae#59]: "It holds no sizes, print settings or clip advice, so changing a parameter never makes it go stale." The payoff.
7. Operator [58e497ae#107]: "We tag RELEASES. we might try 5 times to print a model/stl properly." Physical iteration versus release discipline.
8. Operator [16dfa9a3#0]: "hilariously, ... there are "pr issues"." The tone of the review.
9. Operator [16dfa9a3#27]: "the things that printed worked correctly and were geometrically correct. so.... don't go changing geometry or else I'l have to reprint." Atoms outrank diffs.
10. Assistant [16dfa9a3#29]: "Your prints are correct. The labels are what's wrong". A post thesis.
11. Assistant [16dfa9a3#29]: "Don't take the reviewer's fix: reshaping the clip changes geometry. Rename instead." Accepting a finding while rejecting its fix.
12. Assistant [16dfa9a3#71]: "The old `0.5-1.0` clip stopped 0.01 mm short of that flange." A hundredth of a millimetre, caught by a bot.
13. Operator [912e6731#0]: "So, GJ on the H*N* bulb covers. But, the prongs are exposed." Praise and the next job at once.
14. Operator [912e6731#0]: "they're very tiny and my calipers are relatively large. close with tolerance should be fine." Honest about measurement limits.
15. Operator [912e6731#47]: "You're absolutely right that there are two tabs on an H7 bulb so there you go that's all we need we don't need the three pin!" The human uses the stock AI phrase.
16. Assistant [912e6731#156]: "You only need one H7 cover." Three requested parts become two.
17. Operator [912e6731#157]: "It just feels like "a lot" for something that size". A judgement no fit check makes.
18. Operator [912e6731#157]: "it has ONE clip, which does land, but... the thing flops loose." Test print 1 in a sentence.
19. Assistant [912e6731#203]: "The revolve sweeps the other way from what I assumed." A CAD assumption caught by a render.
20. Assistant [912e6731#230]: "Each design is checked against model bulbs; only a print will show how they actually fit." The limit of simulation.
21. Operator [912e6731#232]: "Okay! Those both work!" Test print 2.
22. Assistant [b06fd584#19]: "The STEP and STL files are only geometry ... Leaving the old stem there would have recreated the old filenames." A transferable lesson about generated artifacts.
23. Assistant [912e6731#326]: "Nothing is worth a handoff note: the work is merged and the task log is archived, so git already records everything." A clean ending.

## Unique Technical Details

- **PX26d (H7), sheet 7004-5-6:** plate 0.6-0.8 mm thick; the plate's back is at most 1.4 mm behind the seat; the bulb seats on three lugs on the plate's front [a79f8c63#103]. Source: [GOST IEC 60061-1-2014 on meganorm.ru](https://meganorm.ru/mega_doc/norm/gost_gosudarstvennyj-standart/18/gost_IEC_60061-1-2014_mezhgosudarstvennyy_standart_tsokoli_i.html), the Russian edition of IEC 60061-1 [912e6731#156].
- **PX26d terminals, sheet 7004-5:** two ISO 8092-1 6.3 × 0.8 tabs, 11.5 mm centre to centre; X ≥ 8, Y 15-16, V ≥ 6 [912e6731#231]. The [Lear 6.3 mm tab catalogue](https://www.tti.com/content/dam/ttiinc/manufacturers/lear/pdf/FlatConnectors6.3.pdf) gives no hole size [912e6731#156].
- **PGJ19 connector, sheet 7004-110-2, as script parameters:** socket 15.15 × 24.6; mouth 11.75 × 21.15, recess 5.85; cavity 8.2 × 17.65 × 15.85 deep; pin pitch 6.1, pins 2.8 × 0.8, 5.25 deep; key 1.85; hook tip 14.075-14.225 [912e6731#231]. The end hooks are what the standard says hold the car's connector [912e6731#230].
- **Clip naming:** clips are built for plate thickness plus `PLATE_SETBACK`, which went from 1.0 (one bulb) to 0.5 (the standard). Net change against `main`: every kept name dropped by 0.5 mm, and the 2.0+ clips were removed [a79f8c63#103; 16dfa9a3#93].
- **Proof of no geometry change:** compare rebuilt STLs byte for byte. Rebuilt STEP files differ only in a header timestamp, so restore them [a79f8c63#80; 16dfa9a3#55; 912e6731#288].
- **The H7 cover's grip:** "in-plane springs", walls standing on the bed, fixed at one end with a gap all round, so they bend within a layer.
  - Facing ridges leave a 0.3 mm gap that prints shut, so the ridges are staggered in height.
  - Bridged roofs need a 1.2 mm `TOP_GAP` so sag can't fuse them to the springs.
  - v1 pull-off: 4-6 N. v2: about 3.6 N per spring at 0.25 mm squeeze (21 MPa), with `E_PLA = 3000`.
  - The permanent test allows only the four ridges to touch, each 0.1-0.4 mm in [912e6731#156, #231, #314].
- **The H11 cap's catch:** 45° teeth give preload that takes up tolerance and still allows pull-off. The teeth reach 1.2-1.35 mm under the hooks; each arm lifts 1.45 mm with about 2.8 N (16 MPa); the cap pulls off at about 9 N. The side bump (1.8 mm high) would need an arm too long to fit [912e6731#230, #231].
- **Print orientation:** the H7 cover prints slotted face down; the H11 v2 cap prints on its back face, insert up. PLA, no supports [912e6731#156, #230].
- **Tooling:**
  - CadQuery 2.8 via `uv run --no-project --with cadquery`; STEP for Solid Edge, STL for the slicer [912e6731#231].
  - The overhang checker crashed on untraceable outlines and now says "check by eye" [912e6731#231].
  - Fit tests become permanent only after a print settles the shape [912e6731#314].
- **Release-please:** a squash merge's title is the single changelog line, while a rebase merge adds one line per commit. A custom squash message keeps unshipped iterations out of the changelogs [58e497ae#106; 912e6731#314].
- **Cults3D:**
  - It blocks scripted link checks [912e6731#314].
  - Reusing a filename for a different shape on a live listing is a deploy risk [16dfa9a3#93].
  - Photo filename prefixes set the upload order [912e6731#314].
- **Generated filenames:** STL and STEP don't embed their filename; the CadQuery `export` call does [b06fd584#19].

## Emotional Beats And Humor

- **Warmth throughout:** "please <3" [16dfa9a3#0], "GJ" [912e6731#0], "Thank you!" [a79f8c63#129], "Done, thank you very much!" [912e6731#318].
- **Amusement:** "hilariously, ... there are "pr issues"", when parts that worked in hand were flagged by a bot [16dfa9a3#0, #27].
- **Self-deprecation:** "my calipers are relatively large" [912e6731#0], and the cheerful "never mind!" about the H4 mix-up [912e6731#48].
- **Role reversal:** the operator's "You're absolutely right" uses the stock AI phrase on the AI. Reading it as wry is inference [912e6731#47].
- **Relief:** "Okay! Those both work!", after a test print 1 that was half "WORKS" and half "flops loose" [912e6731#157, #232].
- **Rename comedy:** the same two shapes were renamed twice in one afternoon, and the name `1.0-1.5` ended up on the other shape [a79f8c63#103; 16dfa9a3#93].

## Candidate Blog Angles

- **"The Prints Were Right, the Labels Were Wrong":** a review bot finds a real 0.01 mm miss on a part that works in hand. The fix is renaming files, proven by byte-identical STLs. Audience: developers curious about hardware.
- **"Your One Bulb Isn't the Standard":** a single caliper reading, thicker than the standard allows, became a design constant until a worst-case check corrected it. Audience: makers who design from one measured part.
- **"Two Test Prints to a Prong Cap":** from spec research and a wrong "three prongs" memory, through a chunky spool and a floppy cap with photos of commercial connectors, to "Those both work!". It shows where model-bulb checks ended and hands took over. Audience: hobbyists trying AI-assisted parametric CAD.
- **"Each Fact Has One Home":** README, memory bank and listing, and why the README ended up holding no numbers. Audience: maintainers of small or agent-assisted repos.
- **"Tag Releases, Not Prints":** fitting "we might try 5 times" physical iteration into git, release-please and squash merges. Audience: developers building CD for non-software artifacts.

## Open Questions And Uncertainties

- **The "5.96mm":** what it was, and whether the agent answered, isn't recorded [a79f8c63#42].
- **Where "two tabs" came from:** no assistant message before [912e6731#47] says it. Inference: the operator read it in the agent's visible thinking, as at [a79f8c63#42].
- **Tool images in the user role:** most "user" images are probably renders or PDF crops, e.g. [912e6731#14, #38, #85] and [58e497ae#85]. Only [912e6731#158] is clearly an operator attachment (two print photos, two web photos of connectors).
- **Whether the rename reached PR #16:** the `h11_prong_cover` rename (10-19 11:07) ends uncommitted [b06fd584#19], and PR #16 merged at 16:18 the same day [912e6731#318]. These transcripts don't show which change carried it.
- **"Three" covers:** the operator asked for three and got two. They never objected [912e6731#0, #156, #232].
- **"LED H11":** the agent assumed "LED H11" meant the LED H7s, and that LED H11s share the halogen socket. Neither was confirmed [912e6731#156].
- **Release timing:** "haven't released any other prints besides this h7 yet" (10-16 15:38) [58e497ae#107] sits oddly beside the rattlinator 1.0.2 redeploy and the Cults fix (#15) mentioned as done by 10-18 [912e6731#175, #230]. Likely other releases happened later on 10-16.
- **Left open:** whether to keep the `1.0-1.5` clip, and whether the post-deploy listing carried the new `1.0-1.5` bytes [16dfa9a3#93]. The 1.0.4 merge and deploy aren't shown.
- **Naming against the context:** the context's "prong caps" are `*_prong_cover` in files. The H11 part was "connector cap" until 10-19, and its notes still describe it that way [b06fd584#19].

## Privacy Flags

- **Image source paths:** these contain the operator's Windows username and temp directory [912e6731#158].
- **STL copy destinations:** these reveal the operator's local printer-models folder tree and drive mapping. Write `<operator-docs>/...` [912e6731#64, #230, #231].
- **The vehicle:** the operator names their vehicle as the source of the H4 confusion [912e6731#48]. Say "a different bulb type in the operator's vehicle".
- **The leaked path:** a public-repo script once held a hard-coded local Windows path [58e497ae#106]. Tell the story, but don't quote the path.
- **The commit trailer:** the compaction summary includes the agent's commit trailer email [912e6731#231]. Don't reproduce it.
- **Handoff batons:** these go to a private shop repo marked "not public". Mention that one exists, but don't quote it [a79f8c63#141; 16dfa9a3#93].
- **Connector photos:** the two connector photos came from web retailers [912e6731#158]. Don't reuse them.
