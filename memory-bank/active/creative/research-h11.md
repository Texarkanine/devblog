# Research Digest: The H11 Redesign

## Sessions Covered

Clock note: Claude Code timestamps in these dumps are UTC; Cursor timestamps are local (UTC-5). Proof: the Claude session opened draft PR #11 at "16:59", and a Cursor session at "1:34 PM" local found it already open [cba5b6e1#93] [ccedeeea#21].

| File | When | Gist |
| --- | --- | --- |
| `2026-10-14-2211-claude-2702c714.md` | Oct 14 22:11 UTC to Oct 16 02:37 UTC, compacted twice | The whole design arc: complaint, PGJ19 standard, measuring SVG, add-a-model checklist test, three LED measurements, the 0.1 fit test that "fits like a GLOVE", release-ready commits, domed top. |
| `2026-10-16-1650-claude-cba5b6e1.md` | Oct 16 16:50 to 19:38 UTC (11:50 to 14:38 local) | Rebase after main moved models under `models/`, README and listing polish in H7's style, draft PR #11; later confirms merge, 1.0.0, Cults deploy, and a broken README link. |
| `2026-10-16-1826-claude-d7453e92.md` | Oct 16 18:26 to 18:33 UTC | "should we call the h11 bulb holder a pgj19-bulb-storage instead?" Agent says keep the name; operator reveals an H9 lives in the holder; tags. |
| `2026-10-16-1334-cursor-ccedeeea.md` | Oct 16 13:34 to 13:36 local | Updates PR #11 after the operator's rename to `h8-h9-h11-h16-bulb-storage`; fixes release-please paths. |
| `2026-10-16-1834-claude-2544d52c.md` | Oct 16 18:34 to 18:36 UTC | On Haiku 5.5: which bulbs share H7's connector? PX26d, essentially only the H7 family. |
| `2026-10-19-1500-cursor-21dab071.md` | Oct 19 15:00 to 15:02 local | The operator had pasted the `pgj19` tag into H7's listing; H7 is PX26d. |

Inference: the Cursor PR update and the Haiku question both began at 13:34 local, so the operator ran two agents in parallel in the minutes before the merge.

## What Happened

**Oct 14: the complaint.** The operator's Printables H11 case held halogen H11s, but no orientation or support style (tree, none, "the hot new fin support thing") printed it cleanly: a clean fin channel meant a stringy outside, and the reverse, and halogens went in only by force [2702c714#3]. Their LED H11s, with fins they described as cast or billet and "much thicker", and no locking nub, "do not lock into these holders at all." Riding the H7's success, they asked the agent to look up the H11 spec, design "a new and correct bulb storage solution", and test "the bootstrap new project script that I'm sure is in here somewhere" [2702c714#3]. The worktree branch was `h11-butforled`.

**Research in about ten minutes.** The agent sliced the old STL, then pulled the PGJ19 cap sheet (IEC 60061-1 sheet 7004-110) from "the same Russian adoption of the standard that the H7 work used" [2702c714#36], the car-socket sheet (7005-110) "so the new holder grips the bulb the way a car's socket does" [2702c714#59], and glass limits from UNECE R37 [2702c714#69]. Its report diagnosed four failures of the old case and proposed a one-piece twist-lock copying the car socket, printed open end down without supports, with a 2.4 mm wall, a 45° slot ceiling, and "a printed spring catch inside the slot" that "doesn't depend on the bulb's nub" [2702c714#83]. It rejected the H7 slide-clip because clip arms would have to fit the roughly 3 mm gap where the O-ring sits. It asked for nine measurements, reported there was no bootstrap script (only the six-step checklist in `AGENTS.md`), and proposed moving the branch onto `origin/main` because it had been cut from unfinished Cults work [2702c714#83].

**Decisions.** "yes absolutely twist lock", fit H8, H9 and H16 too, keep the branch, and draw a lettered SVG like the H7 one "so we could be sure that we were talking about the same thing" [2702c714#84]. The agent generated `measure_cap.svg` from a script, rendered it to PNG to check, fixed overlapping labels [2702c714#101], and ran the add-a-model checklist by hand as the "bootstrap" test. Gaps found: no step for a model `AGENTS.md`, no step for the root README table, and `summem start` "prints nothing when it works" [2702c714#133].

**Oct 15: scope trimmed.** The operator did not want a README table at all and pushed back on measuring everything [2702c714#135]. The agent fixed the checklist, removed the table, and cut the ask to nothing from the halogen and three numbers from the LED, because the operator's car socket had already gauged the rest [2702c714#144].

**Measurements to model in 30 minutes.** The operator sent "F: 1mm / E: 3.33mm / L: ~32mm" (seal removed) plus about 1.38 mm from the top of the fitted seal to the fins [2702c714#145] at 17:27 UTC. The agent confirmed from the standard's notes that E is measured to the plate, so the LED is in spec [2702c714#158], committed, rebased onto main [2702c714#193], wrote `h11_holder.py`, fixed a CadQuery failure where "two sloped surfaces lined up exactly" [2702c714#215], wrote a check script for every fin type, the twist path and the catches [2702c714#236], and at 17:57 UTC delivered version 0.1 and a fit-test STL [2702c714#282]. The operator set the rule that nothing lands on main "until it's verified and I can get a photo" [2702c714#283]; the agent committed on the branch and sent six questions to answer after printing [2702c714#292].

**19:54 UTC: "Printed. It fits like a GLOVE. Both the LED and the Halogen. Full send, let's wrap this sucker up!"** [2702c714#302]. The agent rebased again (H7 at 1.0.2, repo relicensed to GPLv3) [2702c714#339], committed the check script now that the shape was proved [2702c714#326], and filled the listing. The operator wanted the full holder to print for photos [2702c714#340], then a domed top "so it matches the other models" [2702c714#345]. The agent gave it a domed outside over a hidden 45° cone [2702c714#348] [2702c714#370].

**Oct 16: release prep after the reorganisation.** "A lot of changes have landed one of them rearranged where models get stored" [cba5b6e1#0]. The agent rebased six commits, moved the model under `models/`, replaced `README.txt` with an H7-style `README.md` (usage and standards moved into the script docstring "so nothing is written down twice"), matched `publish.yaml` to H7, dropped slicer coaching, scrubbed a note pointing at a folder on the operator's PC, and ran "the real publisher against a fake Cults" to preview the listing [cba5b6e1#77] [cba5b6e1#93]. It flagged two listing lines as "from design reasoning, not from a print": "PETG (recommended)" and a knife tip for freeing a fused catch. 33 fit checks and 80 repository tests passed; draft PR #11 opened [cba5b6e1#93].

**The naming question.** After adding photos (in a commit scoped `pgj19-bulb-storage`, which the agent noticed), the operator asked whether to rename to `pgj19-bulb-storage` [d7453e92#0]. The agent explained PGJ19 is the cap, not a bulb, recommended keeping `h11-bulb-storage` for four reasons (it matches `h7-bulb-storage`; people know H-numbers; buyers rarely see the directory; H11 is the bulb actually tested), conceded "the case for renaming is real but weaker", and predicted the README's Cults link would break because Cults builds the address from the title [d7453e92#14] [d7453e92#17]. The operator: an H9 is in there right now, "I want people to be able to find it... I guess I can use tags for that?" [d7453e92#18]. The agent conceded that cancelled one of its reasons, proposed tags, and warned tags had never been through a real Cults publish [d7453e92#28]. "thx, I've got it." [d7453e92#29].

**Rename, merge, release.** The operator picked a third name. A Cursor session updated PR #11 for the rename to `models/h8-h9-h11-h16-bulb-storage` and fixed stale release-please and test paths (`4f09b1c`) [ccedeeea#21]. Outside the transcripts, the PR's commit list shows the operator's "docs: rename to indicate other matching bulbs" at 18:34 UTC and the merge at 18:35:58 UTC, about ten minutes after the question. Then: "Version 1.0.0 was released, the Cults deploy succeeded, and the Cults listing ID was saved back to `main`. Your listing edits (PLA, with the knife tip removed) went in with it" [cba5b6e1#119]. The predicted broken link had come true.

**H7 coda.** On Haiku 5.5 the operator asked which major bulbs share H7's connector: PX26d, "mostly the H7 family", with "I haven't checked this against a current source" [2544d52c#5]. On Oct 19 they caught the `pgj19` tag they had copied into H7's listing [21dab071#0]; the agent confirmed PX26d (IEC 60061-1 sheet 7004-5) [21dab071#2] and the fix landed as `78ee40b` [21dab071#8].

## Turning Points

- **No bootstrap script.** The operator was "sure" one existed [2702c714#3]. Running the checklist by hand became the test and produced two checklist fixes [2702c714#133] [2702c714#144].
- **README row reversed.** The agent added the model to the README table, following the existing rows, and called the missing step a gap [2702c714#133]. The operator wanted no table [2702c714#135]. The memory tool "can't delete notes, so I added a new one that corrects it" [2702c714#144].
- **Nine measurements became three.** First ask: nine items for both bulbs plus photos [2702c714#83]. After pushback the agent found the principle: the car socket already limits fin width, reach and nose, and the socket standard accepts every in-spec bulb, so only F, E and L mattered [2702c714#144].
- **The "thick LED fins" theory evaporated.** The operator called the LED fins "much thicker" [2702c714#3], and the agent's first diagnosis included "Your LED fins may hardly fit" the old 2.75 mm slot [2702c714#83]. Measured F was 1 mm [2702c714#145], a quarter of the 4.0 mm limit. Never reconciled in the transcript; on the numbers, the LED problem was the missing lock and the over-thick plate (inference).
- **E drawn in the wrong place.** "My diagram had pointed E at the seal. I fixed and redrew it" [2702c714#282]. The operator had measured it correctly.
- **The branch argument.** The agent conceded it only mattered at PR time and predicted a clean PR after the Cults work merged [2702c714#133]. Then: "That was wrong. That work was merged as one combined commit" [2702c714#282], so it replayed its commits onto main.
- **First print success.** 0.1 fit both bulbs on its first print [2702c714#302]. No geometry iteration followed; the dome was cosmetic.
- **Dome, with a catch.** True outside, false inside: "Inside a hollow round dome, the top portion, about 15 mm across, is flatter than 45°, and that would sag" [2702c714#348].
- **PETG became PLA.** The agent recommended PETG "because the catches are springs" [2702c714#282] and later flagged that as reasoning, not evidence [cba5b6e1#93]. The released listing says PLA, an operator edit [cba5b6e1#119].
- **The name nobody proposed.** Question: `h11` or `pgj19`. Agent: keep `h11`. Result: `h8-h9-h11-h16-bulb-storage` [cba5b6e1#119]. The agent's own point backed findability over taxonomy: "The directory name has no effect on search. Cults never sees it" [d7453e92#28].
- **A prediction that came true.** The Cults address follows the title at first publish [d7453e92#17]; after release the README link was broken exactly as predicted [cba5b6e1#119].

## The Physical Loop

- **The old case, sliced** [2702c714#83] [2702c714#134]: entry plate 3.25 mm with keyways out to r about 14.1; twist slot Ø31 by 2.75 mm tall under a flat ring ceiling about 4.75 mm wide that "sags or strings in any orientation"; hole Ø19.5; bore Ø17.5; overall 33 mm OD by 74 mm. Standard: fins up to 4.0 mm; car socket wall about 2.2 to 3 mm; only 3.0 mm promised behind the fins, seal included.
- **The LED, measured** [2702c714#145]: F 1 mm; E 3.33 mm to the plate under the seal (standard: 3.0 min) [2702c714#158]; L about 32 mm; fitted seal top to fins about 1.38 mm.
- **Seal squeeze, designed in.** With a 2.4 mm wall, "Your LED's seal gets squeezed about 1 mm, as in a car" [2702c714#282]. Inference from the same numbers: the old 3.25 mm plate would squeeze it about 1.9 mm and leave about 0.08 mm before the hard plate, consistent with bulbs that had to be forced.
- **The halogen was never measured:** "Measuring your halogen would only tell us whether it's in spec, which doesn't change the design" [2702c714#144].
- **The fit test**: "the open end only and about 10 mm tall", printed open end down with no supports; elephant-foot compensation suggested because each catch's 0.6 mm gap might fuse on the first layer [2702c714#282] [2702c714#292]. STL ready 17:57 UTC, "fits like a GLOVE" at 19:54 UTC: under two hours including the print (inference). The six detailed questions (fused catches, one-way turn, 65° stop, click, rattle, release) got no separate answers.
- **H9 in use.** The holder ended up storing an H9: "your H9 in the holder shows it fits" [d7453e92#28]. H8 and H16 rest on the standard and the check script only [d7453e92#14].
- **File identity.** STL copies in the operator's print folder were checked byte-for-byte against the committed files with `cmp` [2702c714#344] [cba5b6e1#93].
- **Envelope.** Old case 33 by 74 mm; new holder 32.8 mm across the open end by 62.7 mm long [2702c714#282].

## Operator Corrections And Teachings

- **Looseness before the twist is fine:** "it is absolutely fine if the bulb is loose until you twist it because you're going to twist it" [2702c714#84].
- **Stay put:** "Why would you move the branch? You're on the right place to explore this work aren't you?" [2702c714#84].
- **Shared vocabulary first:** the lettered SVG, "so we could be sure that we were talking about the same thing" [2702c714#84].
- **No catalog table:** "I don't actually want them all in the README. There are folders. Ppl can look." [2702c714#135]. Became a checklist rule.
- **Measure only what changes the design** [2702c714#135], later listed by the agent as a standing norm: "Ask only for measurements that change the design" [2702c714#371].
- **Physical gate on delivery:** nothing to main "until it's verified and I can get a photo" [2702c714#283], saved as a repo note [2702c714#292].
- **Tooling:** "`git sync -y` no it doesn't need interactive" [2702c714#319]; the agent checked and found the installed `git-sync` takes only `-m` and `-h` and would treat `-y` as a branch name [2702c714#371].
- **Consistency across the catalog:** the dome request, "so it matches the other models" [2702c714#345].
- **Listing copy:** PLA, knife tip removed [cba5b6e1#119]; the agent had already dropped slicer advice "since your listings don't coach slicer settings" [cba5b6e1#93].
- **Findability:** "I want people to be able to find it" [d7453e92#18], then the four-bulb rename.
- **Standing norms in the agent's summaries:** no committed tests for prototype shapes; plain language (the agent reminded itself to avoid "lintel" and say "fins"); commit or push only when asked [2702c714#134] [2702c714#371].

## Quotable Lines

1. Operator [2702c714#3]: "honestly I can print other things without issue it's just that this is a poorly designed object for printing with fdm." The redesign's thesis.
2. Operator [2702c714#3]: "So riding on the coattails and euphoria of the successful H7[...] can you just look up the specs for H11 and design a new and correct bulb storage solution". Momentum from the first model.
3. Operator [2702c714#3]: "so we can design something with tolerances that are going to work for every H11 bulb that we throw at it!" The original ambition, later trimmed.
4. Assistant [2702c714#83]: "Yes, this is doable, and the H11 standard explains each problem you've had." The standard as diagnosis.
5. Assistant [2702c714#83]: "The ceiling of that slot is a flat ring about 4.75 mm wide with nothing under it, whichever way up you print." Why no orientation could work.
6. Operator [2702c714#84]: "it is absolutely fine if the bulb is loose until you twist it because you're going to twist it."
7. Assistant [2702c714#133]: "Capital letters and r8 are the standard's own names. w, L and d are mine, because the standard has no letter for those." Honest about which labels are canon.
8. Operator [2702c714#135]: "I don't actually want them all in the README. There are folders. Ppl can look."
9. Operator [2702c714#135]: "I feel like me measuring every part of my bulb to confirm whether it is or is out of spec isn't really productive for our task of modeling something that would fit to spec..."
10. Assistant [2702c714#144]: "Your LED fits your car, so the car's socket already limits how wide the fins are, how far out they reach, and how wide the front of the bulb is. I only need what a car socket doesn't limit". The car as a gauge.
11. Assistant [2702c714#144]: "Halogen: none. The holder copies the car's socket, and the socket standard is written to take every bulb that's in spec."
12. Assistant [2702c714#282]: "I told you earlier that once the Cults upload work merged, a pull request from here would show only the H11 changes. That was wrong." Plain self-correction.
13. Operator [2702c714#283]: "we don't want to land anything to Maine [main] until it's verified and I can get a photo so we're going to do our printing and iteration on this branch". A physical gate on continuous delivery.
14. Operator [2702c714#302]: "Printed. It fits like a GLOVE. Both the LED and the Halogen. Full send, let's wrap this sucker up!" The peak.
15. Operator [2702c714#346]: "I think you can still do a gentle enough dome that we can overhang without needing support, right?"
16. Assistant [2702c714#348]: "Yes, with one catch." ... "A cone is the shortest roof that prints without support." Design-for-FDM in a sentence.
17. Assistant [cba5b6e1#93]: "Two listing lines come from design reasoning, not from a print". Evidence versus inference in public copy.
18. Assistant [d7453e92#14]: "PGJ19 is the cap the bulb plugs in by, not a bulb type".
19. Operator [d7453e92#18]: "The big thing is that it's going to work for H9 I actually honestly have an H 9 in there right now not an H11 O... I want people to be able to find it... I guess I can use tags for that?" The reveal that reframed the naming question.
20. Assistant [d7453e92#28]: "That's good news. It also cancels one of my reasons for keeping the name". Updating mid-argument.
21. Assistant [d7453e92#28]: "The directory name has no effect on search. Cults never sees it."
22. Assistant [2544d52c#5]: "I haven't checked this against a current source." A small model flagging its own uncertainty.
23. Operator [21dab071#0]: "what is the connector spec for h7? it/s not pgj19 - i copie dthat from the h11 section." Copy-paste drift, caught by the human.

## Unique Technical Details

**Standards**

- H8 = PGJ19-1, H11 = PGJ19-2, H16 = PGJ19-3, H9 = PGJ19-5; H8B, H9B and H11B use PGJY19 and don't fit [2702c714#134] [d7453e92#14]. H7 is PX26d, IEC 60061-1 sheet 7004-5 [21dab071#2].
- Sources were Russian national adoptions fetched with curl, because unece.org returns 403 to curl [2702c714#134]: GOST IEC 60061-1-2014 (cap sheet 7004-110-2), GOST IEC 60061-2-2017 (socket sheet 7005-110-3), GOST R 41.37-99 (R37 sheet H8/1) [2702c714#83].
- The current H11 outline sheet wouldn't download, so head sizes came from H8: Ø25 for 4.0 mm from the datum, then Ø19, glass Ø15, 44.0 mm max length [2702c714#83] [2702c714#134].
- Cap: datum is the fins' back face, resting on three bumps; nose 19.0 max; fin tip radius 12.15 to 12.25; fin block 4.0 max; datum to seal plate 3.0 min; nose plus relaxed spring 21.4 max. Wide fin: 8.0 centred (-1), 6.0 + 4.0 off-centre (-2), 10.0 centred (-3), mirrored 4/6 (-5). Two narrow fins about ±63° from the plug, identical on every variant [2702c714#134].
- Socket: hole 19.5 to 20.0; opening radius 12.4 to 12.5; wall at least 2.2 mm at three pads about 3 by 3 mm; retaining bump 0.25 to 0.35 mm. Note (6): the bulb's spring pushes the nose into a V-support with at least 10 N, then at least 5 N presses the fins onto the socket, and snaps into a retaining recess. That spring is the halogen "nub"; LEDs lack it [2702c714#134].
- The sheets never say which side the front view is seen from, so the off-centre wide fin may be mirrored; openings are sized by width, not side [2702c714#133] [2702c714#134].

**The holder** [2702c714#282] [2702c714#371]

- Wall 2.4 mm (car socket wall); hole Ø20.2; keyways are the union of all variants' largest fins plus 0.4 mm; fin ring radius 12.9 under a 45° cone ceiling.
- Twist 65° clockwise seen from the plug; one stop ends the turn and blocks the wrong way; `TWIST = "ccw"` flips it.
- Two cantilever catches click behind the narrow fins, so the lock works on every variant without the bulb's spring: beam 1.0 mm thick, 40° arc, 0.6 mm gap. Force estimates differ: "about 3–4 N per catch, but that's a rough calculation" [2702c714#282] versus "2.8–5.5 N each" in a summary [2702c714#371].
- Printed on its open end, so the wall the fins bear on is the first layers and comes out flat; nothing beyond 45° except a 1 mm spot at the closed tip.
- Dome: outside a half-sphere of the tube's 12.3 mm radius, stopped at 88° with a sub-1 mm flat to keep the STL watertight; inside the 45° cone; at least 1.8 mm solid between; height unchanged at 62.7 mm because that dome reaches exactly the old tip [2702c714#348] [2702c714#370] [2702c714#371].

**Method and tooling**

- Shapes are defined once as "regions" (half-planes, circles, polygons): shapely in 2D for the fit checks, CadQuery in 3D with true arcs. STEP shrank from about 4 MB to 320 KB, the build takes 6 seconds, and a check confirms the 3D model matches the 2D shapes [2702c714#254] [2702c714#259] [2702c714#371].
- CadQuery fails when two sloped faces coincide exactly; offset one [2702c714#215]. Each build rewrites STEP header timestamps, so a STEP whose only change is the header gets restored [2702c714#354].
- The fit-check script stayed in scratch until the print proved the shape (the operator's "no committed tests for prototype shapes" rule), then went in as `tools/check_fit.py` [2702c714#282] [2702c714#326]; 33 checks by release [cba5b6e1#60].
- The measuring SVG is script-generated and drawn to scale at the standard's largest sizes; the agent rendered it to PNG to look at it [2702c714#133] [2702c714#134].
- Signing fails during `rebase --continue`; workaround: commit the resolution with `--no-gpg-sign -C <sha>`, then continue [2702c714#371].

**Publishing**

- Release-please's first release of a package is 1.0.0 [2702c714#371]. It assigns commits by files touched, not scope; a squash merge keeps only the PR title [d7453e92#14].
- Cults builds a listing's address from its title at creation and never changes it [d7453e92#17]; confirmed by the broken link [cba5b6e1#119]. Cloudflare blocked the agent's check of a Cults address [cba5b6e1#93].
- Main gained a pre-commit hook that strips photo metadata [2702c714#385] [cba5b6e1#93].

## Emotional Beats And Humor

- **Frustration to euphoria in a day.** A long vent about ugly, stringy prints [2702c714#3] ends in all caps: "fits like a GLOVE ... Full send" [2702c714#302].
- **The branch name** `h11-butforled`, and the mythical bootstrap script "that I'm sure is in here somewhere" [2702c714#3].
- **"True yo"** [2702c714#340]: "wrap this sucker up" meant "you do everything else, I print the full thing for photos".
- **The made-up flag:** `git sync -y`, which the tool would read as a branch name [2702c714#319] [2702c714#371].
- **The H9 confession:** the H11 holder's first real tenant was not an H11 [d7453e92#18].
- **"IIRC we merged it"** [cba5b6e1#94]: the pace left the operator unsure whether the release had happened. It had.
- **"thx, I've got it."** [d7453e92#29]: the operator takes the decision back and picks a third name.
- **Courtesy:** "sorry, I interrupted. please continue." [21dab071#5], and the ritual "thx, /handoff" closing several sessions [ccedeeea#22] [d7453e92#29] [2544d52c#6].

## Candidate Blog Angles

1. **Design to the socket, not the bulb.** The car's socket is a gauge every in-spec bulb already passes, so copy the socket's standard and measure only what it doesn't constrain: nine measurements became three, the halogen needed none. Audience: makers designing parts that mate with commercial products.
2. **Why that Printables model fought every orientation.** A flat 4.75 mm ceiling can't print cleanly any way up; the redesign puts the critical face on the bed, slopes every ceiling at 45°, and hides a cone under a decorative dome. Audience: hobbyist FDM printers who blame their calibration first.
3. **"Fits like a glove" on the first print.** A 10 mm fit-test coupon, a check script that sweeps every variant through the twist, printed spring catches replacing the lock LEDs lack, tests committed only after the print proved the shape. Audience: developers curious about CAD-as-code.
4. **Naming a thing by what people search for.** PGJ19 is correct, H11 is familiar, and the shipped name lists four bulbs because an H9 already lived in it; the directory never reaches Cults, but the title becomes the permanent URL. Audience: people publishing models or packages.
5. **The human as editor.** The operator cut the README table and the measurement list, gated main on a photographed print, swapped PETG for PLA, and caught a copy-pasted tag; the agent's best moments were updating ("It also cancels one of my reasons"). Audience: readers interested in AI-assisted development.

## Open Questions And Uncertainties

- **LED fin thickness:** "much thicker" [2702c714#3] versus a measured 1 mm [2702c714#145], never reconciled.
- **Material:** nothing records what the fit test or full holder was printed in [cba5b6e1#93]. The agent's spring reasoning said PETG; the listing says PLA [cba5b6e1#119]. Whether PLA catches were judged adequate is not stated.
- **Catch behaviour:** the six post-print questions [2702c714#292] got one answer, "fits like a GLOVE" [2702c714#302].
- **The domed holder:** requested for photos [2702c714#340] and photos were added before the merge [d7453e92#14], so it was probably printed, but no line says so. Which holder holds the H9 is likewise implied, not stated.
- **H8 and H16** were never physically tried [d7453e92#14]. The head envelope used the H8 sheet as a proxy for H11 [2702c714#83].
- **Unverified claims:** "Cults search uses the title first" is the agent's assertion [d7453e92#28]. Whether tags survived a real publish, and whether the broken README link was fixed, are outside these transcripts.
- **Who made the rename:** "you renamed the model" [cba5b6e1#119]; the commit (outside the transcripts) landed at 18:34 UTC, the minute the Cursor session started, so it may have been by hand or in another tool.
- **Clock mismatch with the research index:** it treats Claude Code times as local. The fit-test report was 14:54 local Oct 15; PR #11 merged at 13:35 local Oct 16.
- **Brief check:** halogens were forced, but LEDs were not; they never locked [2702c714#3]. "Fits like a glove on its first print" refers to the 10 mm open-end fit test, not the full holder [2702c714#292].

## Privacy Flags

- Local Windows paths to the operator's print folders recur and contain their Windows username and drive letter. Write `<operator-docs>/...` or "my local print folder".
- Session summaries name the private notes repo used for handoff batons, with commit hashes and paths. Treat as private infrastructure.
- The agent mentions a leftover file holding the Cults API key in a scratch folder [2702c714#388]. Don't repeat its location.
- Cults category IDs appear in a summary [2702c714#371]. Not secret, but no reason to print them.
- The stored bulbs imply which lamp types the household vehicle or vehicles use (H11, H9, LED conversions). Bulb types are fine; don't tie them to a specific vehicle.
- The operator's real name appears only inside local paths; keep it out.
