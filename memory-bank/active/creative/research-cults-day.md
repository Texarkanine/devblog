# Research Digest: The Cults3D Day

## Sessions Covered

All times are 2026-10-15, US Central (UTC-5) unless marked UTC. Seven separate Cursor chats, several running in parallel in the same repo.

- `2026-10-15-1009-cursor-55db5482.md` (10:09-10:56 AM): the first manual deploy of the first release dies on a Cloudflare 1010 ban. The fix adds a trigger on release publish, keeps the manual run as a backup, and sets a custom User-Agent. The operator strikes the User-Agent tests. PR #8.
- `2026-10-15-1058-cursor-837a0fbe.md` (10:58-11:08 AM): the first successful publish, after one transient "Could not download URL". Also the AGPL-to-GPL license question, Thingiverse license codes, and how image order is controlled.
- `2026-10-15-1116-cursor-6d6ab2a0.md` (11:16 AM, then 2:06-2:10 PM): YAML `|` versus `>` for a Markdown listing description. PR #9 (relicense, listing copy, photos). The operator asks for a multi-line conventional-commit squash message.
- `2026-10-15-1409-cursor-0c2d1d78.md` (2:09-2:35 PM): reading the Cults terms of service. Can a listing link to GitHub? Exclusivity, and free elsewhere. Does a title change move the URL slug? Issues #11 and #12.
- `2026-10-15-1415-cursor-380b634b.md` (2:15-7:24 PM): the H7 v1.0.2 update deploy refuses a "partial publish". The real update path is built from the official schema, which the operator pulled by hand with curl. PR #13.
- `2026-10-15-1930-cursor-de9b68d7.md` (7:30-7:56 PM): the republish fails with "Cults has no creation with this id". Live probes show `creationsBatch(ids:)` does not accept the id Cults itself returns. PR #14.
- `2026-10-15-2007-cursor-a3410637.md` (8:07-8:24 PM): the republish fails with "Price must be greater than or equal to 0.5", and the listing's files are duplicated. Fix: omit the price and reorder the mutations. PR #15.

## What Happened

**Morning: the first release does not publish itself.** The operator merged the release PR for `h7-bulb-storage` 1.0.1 ([PR #7](https://github.com/Texarkanine/3d-models/pull/7)). They "kind of expected it to go automatically", then found they "had to do it by hand" [55db5482#0]. The manual run form annoyed them: the tag has to be chosen twice, once in GitHub's "Use workflow from" dropdown and again in a free-text input. They were "tempted to pick a tag off the used workflow from but it's not actually going to work" [55db5482#0]. The run failed at 10:07 AM (15:07 UTC) with Cloudflare `Error 1010: Access denied`, `browser_signature_banned`, and the JSON advice "**Do not retry.** Your user-agent has been banned by the site owner." The operator's whole comment: "lol :(" [55db5482#0].

Niko's diagnosis [55db5482#8]: `tools/cults_publish.py` posted to `https://cults3d.com/graphql` with `urllib` and no `User-Agent`, so Python sent `Python-urllib/3.x`. Niko reproduced the 1010 locally with no key. Then it sent the same request with a made-up User-Agent and got through Cloudflare to Cults' own `401 HTTP Basic: Access denied.`, which proved the ban was on the client signature. The manual-only deploy was the documented design: all three memory-bank files said deploy "is started by hand and does not run when a release is created". There was a second trap. Deploy checked out the typed tag and ran *that tag's* copy of the publisher, so a fix merged to `main` could never republish an old tag. Niko recommended triggering on `release` published, taking the tag from `github.event.release.tag_name`, and always running the publisher from the default branch while reading model files from the tag [55db5482#8].

At 10:15 the operator asked for automatic publishing by default with manual kept as a backup, and for a custom UA, "something like `Texarkanine GitHub CICD for Cults3D`", avoiding anything from the original UA "just in case" [55db5482#9]. They ruled out republishing as part of the fix. The point of the manual path is to run "the main branches updated work flow against an old tag" [55db5482#19]. The work went through Niko's plan, preflight, build, QA and reflect phases (38 tests) and became [PR #8](https://github.com/Texarkanine/3d-models/pull/8) at 10:42 [55db5482#79, #85]. Two minutes later the operator demanded a rework. The tests asserting the custom User-Agent, and the absence of `Python-urllib`, were "pointless" and had to go [55db5482#86]. They went, and the suite fell to 36 [55db5482#112]. The operator merged PR #8 before the archive step, which briefly confused Niko when the archive commit landed on `main` [55db5482#125-#127].

**Late morning: the first listing goes live, on the second try.** The 10:58 manual run (main's workflow, tag v1.0.1) got past Cloudflare and then failed with `createCreation failed: ['Could not download URL https://media.githubusercontent.com/media/.../h7-bulb-storage-tubeonly-cura.png']`. The operator retried and it worked: "maybe race?" [837a0fbe#0]. Niko rejected all three of the operator's hypotheses [837a0fbe#10]:

- **A race:** the tag commit was about fifty minutes old (15:04:43 UTC against an attempt at 15:55 UTC), and a ref Cults couldn't see would have failed every URL.
- **A GitHub block:** the retry used the same URLs three minutes later and succeeded, and an empty-UA fetch returned HTTP 200 for the 283,237-byte PNG.
- **Cults unable to fetch this host:** the other LFS image from the same host and tag came through.

Niko's conclusion was one transient pull. "We hand Cults the URL and they pull it. One blip fails `createCreation`." The listing went live at 15:58 UTC as design number 5064983 [de9b68d7#16].

At 11:02 the operator asked whether to drop AGPL for plain GPLv3 to match Cults [837a0fbe#12]. Niko said yes [837a0fbe#18]:

- The Affero clause only bites on networked software, and the only program in the repo is the publisher script.
- Cults' license list has `gpl` and no Affero entry, so the listings were already GPL. A Cults download could be passed on under GPL, which made the stricter git grant hollow.
- Thingiverse's API client lists `cc`, `cc-sa`, `cc-nd`, `cc-nc-sa`, `cc-nc-nd`, `pd0`, `gpl`, `lgpl`, `bsd`, plus three CERN-OHL v2 variants added to the upload form in April 2026. Neither site has an Affero option, and both treat `gpl` as one bucket.

At 11:04 the operator noticed that the Cura print-orientation screenshot of the clip was the listing's first image, and said "I want the pictures to come first" [837a0fbe#20]. Niko found that `_listing_photos` sorts every filename in `img/` and that order becomes `imageUrls`, so "The filename sort is the whole control" [837a0fbe#24]. The fix is zero-padded numeric prefixes. Niko also warned of something it had not yet tested: Cults' documented `updateCreation` has no `imageUrls`, and the publisher would refuse such an update [837a0fbe#24]. That warning came true at 2:15.

**Midday: Markdown in YAML.** At 11:16 the operator was writing "an actual markdown document" into `publish.yaml` and asked which block style keeps newlines [6d6ab2a0#0]. Niko's answer was the literal `|`, because folded `>` turns a numbered list into `1. First item. 2. Second:`. Niko added that the publisher only `.strip()`s the field, so "What YAML gives you is what Cults gets" [6d6ab2a0#6]. At 2:06 the `various-fixes` branch became [PR #9](https://github.com/Texarkanine/3d-models/pull/9) [6d6ab2a0#13]. It relicensed AGPL-3.0 to GPL-3.0, rewrote the shared author boilerplate, and added rattlinator manufacturing notes (TPU 95, support blocker, tree supports). For H7 it added a new description and manufacturing notes (tube-down, a clip-thickness hint), two new LFS JPGs, and renamed the Cura PNGs to `02-`/`03-`. The operator asked for a squash message with one conventional-commit line per change plus the trailer [6d6ab2a0#14]. Niko said release-please reads only the first line of a squash commit, so the subject had to be `docs: refresh Cults listing copy`. The other lines would only stay in git history [6d6ab2a0#17].

**Afternoon: the terms of service.** At 2:09 the operator asked whether they could put a GitHub link on Cults [0c2d1d78#0]. Niko said the legal page was in French. The operator: "stop. it's not french. what's going on?" [0c2d1d78#13]. Niko explained that the English page says it is a translation and that "the French version shall prevail" (Terms v6.1, 31 March 2026, SAS CULTS), so it had been checking clauses against the French [0c2d1d78#14]. The verdict [0c2d1d78#16]: a GitHub link is fine on the profile and in a description. The terms never name GitHub and never ban outside links. Three limits apply:

- If the same creation is free elsewhere, Cults may set its price to free. Selling a file that is free on another site is grounds for removing the listing and blocking the account.
- Payment for a Cults-listed creation goes through Cults.
- A listing must not be commercial or advertising in character.

There is also a practical cost: Cults is more likely to feature exclusive models on its homepage and newsletter. The operator showed a screenshot of the Files-column note [0c2d1d78#17]. Niko read it as forbidding uploaded *documents* that point to an outside download, and said "The line I would not cross is making GitHub the way someone gets the printable files" [0c2d1d78#18].

The operator then asked whether a version number in the title would change the URL [0c2d1d78#19]. The URL `/en/3d-model/gadget/h7-bulb-storage` is category plus a slug made from the title at creation. What a rename does is undocumented, and one live listing showed title and slug had diverged. The bigger problem is that the publisher finds an existing listing by exact name, so a renamed title would make the next publish create a second listing. The version goes in the description [0c2d1d78#29]. The operator asked for two issues: `{version}` and `{changelog_url}` placeholders, and first a move of all models under `models/`, because that changes the changelog paths [0c2d1d78#30]. Niko refused at first because another session had an in-flight Niko task (the update work below) [0c2d1d78#33]. The operator overruled it: "this will not affect in progress work!" Issues [#11](https://github.com/Texarkanine/3d-models/issues/11) and [#12](https://github.com/Texarkanine/3d-models/issues/12) were opened [0c2d1d78#34, #40].

**Afternoon: the update that refused itself.** Merging PR #9 cut `h7-bulb-storage` v1.0.2. Its deploy failed at about 2:15 with `ValueError: update cannot carry fileUrls and imageUrls; refusing a partial publish` [380b634b#0, #13]. This was deliberate. `publish.yaml` now held `cults_creation_id`, which the deploy bot had written after the first create, so the publisher chose an update. Live introspection confirmed that `updateCreation` has no file or image arguments, and the guard refused rather than change the text while leaving old files and photos in place [380b634b#18]. The operator: "why can't we update this I just changed the model and text and pictures" [380b634b#14]. Then: "that doesn't answer me why didn't this work is this a bug" [380b634b#19]. At 2:23 they told Niko to "Figure out how to make updates work and then make them work" [380b634b#22].

The plan used `createBlueprint`, `destroyBlueprint`, `createIllustration` and `destroyIllustration`. Preflight failed on three holes, then passed [380b634b#41-#55]. Then the operator spotted the source: "preflight grabbed the api docs from like... somebody's discord" [380b634b#57]. Niko could not read the official GraphiQL page (blank in its browser, `401` without a key), so it held the build [380b634b#63]. The operator had the key in a terminal env var but their curl failed. Niko gave them a corrected command (`curl -u user:key`, query as the POST body) [380b634b#68]. The response was so large that it "killed the convo"; the transcript has a 77.5 MB omitted blob at that point [380b634b#69-#72]. The operator saved it to an uncommitted scratch file, "9600 lines... use jq judiciously!" [380b634b#71].

The official schema confirmed the plan and added details [380b634b#82]:

- `creation` on the query root takes a `slug`.
- `myself.creationsBatch` takes `ids`.
- `Blueprint.fileUrl` is Cults' own URL and cannot be compared with GitHub URLs, so an update replaces the whole set.

[PR #13](https://github.com/Texarkanine/3d-models/pull/13) shipped at 47 tests. The reflection recorded as a key insight: "The stored creation id is not a slug. `myself.creationsBatch(ids:)` is the official read for it" [380b634b#107]. That was wrong, as 7:30 showed.

**Evening, failure 1: no creation with this id.** At 7:30 the manual republish (main's workflow, tag v1.0.2) died in `_listing_assets` with `ValueError: Cults has no creation with this id` [de9b68d7#0]. Niko could not tell from the log which of two readings was right [de9b68d7#16]. The operator offered their key-bearing terminal but held the key: "you'll have to print curls/queries for me to run" [de9b68d7#31]. Niko wrote one read-only aliased query with five probes [de9b68d7#33]:

- the stored global id
- the design number `5064983`
- the design number encoded as a global id
- the slug
- an unfiltered scan

It added a second query using `creation(slug:)`. Result: the stored id `Creation/h7-bulb-storage` returned `total: 0`. The slug, the design number, and the numeric global id all found the listing, and every row came back carrying the stored id as its `id` (10 blueprints, 2 illustrations) [de9b68d7#36]. The `ids` filter does not accept the id Cults itself returns. The test fake had modeled the opposite [de9b68d7#36]. The operator asked who writes `cults_creation_id` for a new model [de9b68d7#37]. The deploy job does, as `github-actions[bot]`, after the first successful create, in a `chore: record Cults creation id` commit that release-please ignores [de9b68d7#39]. The Level 1 fix decodes the base64 id, sends the part after `Creation/` as the `ids` filter, and keeps the global id for `updateCreation` (48 tests) [de9b68d7#96]. Niko had committed it on local `main`, which the PR skill refused ("oh poop!"). The commits moved to `fix/cults-update-lookup` and became [PR #14](https://github.com/Texarkanine/3d-models/pull/14), with nothing pushed to `main` [de9b68d7#99-#120].

**Evening, failure 2: the invented price.** At 8:07 the next run (publisher from `6d99629`) failed with `Cults updateCreation failed: ['Price must be greater than or equal to 0.5']`. The operator: "i don't think that's right. what gives?" [a3410637#0]. `publish.yaml` sets no price. The publisher filled in `downloadPrice: 0` whenever introspection marked the argument non-null. Cults treats 0 as a paid price below its €0.50 floor. The original `createCreation` had omitted the price and succeeded [a3410637#22]. The operator wondered whether a wrong data type was sent [a3410637#23]. Niko's answer: no, the error came from Cults' application-level validation, so the value arrived as a number [a3410637#45, #67]. Then the operator posted a screenshot: "It looks like it's duplicated the files... that's not acceptable either" [a3410637#28]. That was the same failure. New blueprints and illustrations were added before `updateCreation`, and old ones removed only after it, so the price rejection stranded both sets. The PR #13 pre-mortem had predicted exactly this: "A job that dies midway can leave duplicate files until the next successful publish" [380b634b#45]. The fix ([PR #15](https://github.com/Texarkanine/3d-models/pull/15)) omits `downloadPrice` for a free listing and runs `updateCreation` first, then adds the new files and removes the old ones [a3410637#67, #80]. Niko suggested testing it by running Deploy *from the feature branch* against tag v1.0.2 [a3410637#67]. These transcripts do not show the outcome.

## Turning Points

- **Automatic was never built.** The operator assumed a release would publish. The memory bank said deploy was manual by design. Found by the operator having to click Run workflow. Changed to trigger on release published, with manual kept [55db5482#0, #8, #9].
- **The API key was not the problem.** The 403 looked like an auth failure. It was Cloudflare banning `Python-urllib`. Niko found this by sending the same request with no key and comparing it against a custom-UA request that reached Cults' own 401 [55db5482#8].
- **The tag runs its own publisher.** Belief: fix main, rerun. Reality: deploy executed the tag's frozen copy of the script. Changed to running the publisher from the workflow ref and the assets from the tag. The operator named this as the core reason the manual path exists [55db5482#8, #19].
- **"Maybe race?" was wrong, and so were the other two guesses.** Niko ruled out each hypothesis with timestamps and a direct fetch, and concluded it was a single transient pull by Cults [837a0fbe#10].
- **The guard worked "as designed", and the operator didn't accept that as an answer.** Niko first explained the refusal mechanically. The operator pushed: is it a bug? That turned the deliberate stop into a feature gap, and it was built [380b634b#18-#22].
- **The Discord-sourced docs.** The plan and its preflight review relied on a third-party writeup citing Discord. The operator noticed and pointed to the official GraphiQL. The official schema mostly agreed but added the `creation(slug:)` and `creationsBatch(ids:)` facts [380b634b#57, #63, #82].
- **The parameter name lied.** Niko read `creationsBatch(ids:)` in the schema and wrote down "the stored creation id is not a slug" [380b634b#107]. Live probes showed `ids` accepts slugs and design numbers but not the global id Cults returns. The fake in the test suite had baked in the wrong assumption [de9b68d7#36].
- **Zero is not "no price".** The publisher treated a schema-required argument as safe to fill with 0. Cults' business rule calls 0 a paid price below €0.50. Create had worked without the field [a3410637#22, #67].
- **A pre-mortem came true.** PR #13's plan named the duplicate-files risk. Five hours later the operator saw doubled files. The fix reordered the mutations so a failed text update adds nothing [380b634b#45; a3410637#28, #67].
- **Title is the lookup key.** A version in the title would have made the next publish create a duplicate listing, because the publisher matches by exact name. The version went in the description instead, which led to issues #11 and #12 [0c2d1d78#29, #30].

## Failure Ledger

| Symptom | Root cause | Fix | Citation |
|---|---|---|---|
| Release did not publish; manual form needs the tag twice | Deploy was manual-only by design; "Use workflow from" and the tag input are separate controls | Trigger on `release` published; keep `workflow_dispatch` as a backup | 55db5482#0, #8, PR #8 |
| `HTTP 403` Cloudflare 1010 `browser_signature_banned` | `urllib` sent default `Python-urllib/3.x`, which Cults' Cloudflare zone bans | Send `User-Agent: Texarkanine GitHub CICD for Cults3D` | 55db5482#8, #79 |
| Fixed publisher could not reach an old tag | Deploy ran the publisher from the checked-out tag | Publisher from the workflow ref; `publish.yaml`, `img/` and file URLs from the tag | 55db5482#8, #19, #79 |
| Agent-written UA tests | Asserted a header string; operator judged them pointless | Deleted (38 → 36 tests) | 55db5482#86, #112 |
| `createCreation failed: Could not download URL ...tubeonly-cura.png` | Transient fetch failure on Cults' side; Cults pulls URLs itself and does not report the HTTP status | Retry (attempt 2, 3 min later) succeeded; no code change | 837a0fbe#0, #10 |
| Print-orientation screenshot is the first gallery image | `imageUrls` = sorted filenames in `img/` | Zero-padded numeric prefixes | 837a0fbe#24; 6d6ab2a0#13 |
| Markdown lists collapse in YAML | Folded `>` turns line breaks into spaces | Literal `\|` | 6d6ab2a0#6 |
| `ValueError: update cannot carry fileUrls and imageUrls; refusing a partial publish` | `updateCreation` has no file or image args; a guard refused deliberately | Separate `createBlueprint` / `createIllustration` / `destroy*` calls (PR #13) | 380b634b#13, #18, #82, #107 |
| Plan's mutation names from an unofficial source | Agent could not reach official GraphiQL (blank page, 401 without key) | Operator ran introspection with their key; schema read with `jq` | 380b634b#57, #63, #71, #82 |
| Operator's curl errored on a nested brace | Raw key in the header; JSON passed as a second URL | `curl -u user:key`, query as the POST body | 380b634b#68, #82 |
| Introspection output "killed the convo" | Response too large for the chat | Saved to an uncommitted scratch file | 380b634b#69-#72 |
| `ValueError: Cults has no creation with this id` | `creationsBatch(ids:)` filters by slug or design number, not by the global id Cults returns; the test fake modeled the opposite | Decode the base64 id and send the slug; keep the global id for `updateCreation` (PR #14) | de9b68d7#0, #36, #96 |
| PR skill refused to open a PR | Fix committed on local `main` | Commits moved to a feature branch; `main` reset to match origin | de9b68d7#99-#120 |
| `updateCreation failed: Price must be greater than or equal to 0.5` | Publisher sent `downloadPrice: 0` when the arg was non-null; Cults reads 0 as a paid price below €0.50 | Omit `downloadPrice` for a free listing (PR #15) | a3410637#22, #67 |
| Every `.step` and `.stl` duplicated on the listing | New assets added before `updateCreation`; old ones removed after it; the price failure stranded both | `updateCreation` first, then add new, then remove old | a3410637#22, #28, #67 |

## Operator Corrections And Teachings

- **Clarity on the manual path's job:** "Do not republish anything. Once the fixes land on the main branch, I will use the updated tool on the main branch to target the old tag to rerun deployment. This is exactly the situation that the manual run needs to be able to handle" [55db5482#19].
- **Against pointless tests:** "This is a change detector well not even that it's even worse because it's pointless and doesn't matter. Let's strike any and all such **** tests. Real point in testing that, there is not." [55db5482#86]. This overrode Niko's reflection insight about how to test UA headers [55db5482#79]. Niko also proposed letting the org PR template accept "I don't know yet" when proof is a post-merge smoke test, but did not edit that template [55db5482#89, #112].
- **Correcting a false alarm:** "no that is correct, i already merged teh pr and movd us to main" [55db5482#126].
- **Stopping a strange detour:** "stop. it's not french. what's going on?" [0c2d1d78#13].
- **Separating issue-filing from in-flight work:** "Please open both issues against the repository, this will not affect in progress work!" [0c2d1d78#34]. He also set the ordering: the models move before the changelog placeholders, "since the paths to changelog urls will change" [0c2d1d78#30].
- **Demanding a straight answer:** "All right so that doesn't answer me why didn't this work is this a bug that we need to fix in our publishing code?" [380b634b#19].
- **Primary sources over hearsay:** "preflight grabbed the api docs from like... somebody's discord do you need me to give you the API docs?? https://cults3d.com/graphiql should have 'em?" [380b634b#57].
- **Docs hygiene:** "the scratch directory won't be committed so canonical committed documentation can't refer to it" [380b634b#83].
- **Key custody:** "I mean you'll have to print curls/queries for me to run." [de9b68d7#31]. The agent writes the queries and the human runs them with the secret.
- **Probing the contract:** "Who is responsible for setting a creation id in publish.yaml, and when? Let's say a new model is added - its first publish, it can't possibly have an id. so, who adds it, when, and how?" [de9b68d7#37].
- **Branch discipline:** "please put all of these commits on a branch and don't push any of it to main" [de9b68d7#100].
- **Bundling related defects:** duplicate files are "not acceptable either. Things need to be fixed since they're both about updating a listing." [a3410637#28].
- **Commit conventions:** a squash message with "a separate conventional commit line for each change" and the trailer [6d6ab2a0#14].
- **Reviewer selection:** "leave muse wonder off the picker list and it'll work. I'll go fix that bug in another thread." [de9b68d7#73]. This was a side bug in the QA reviewer-model picker. Kimi was chosen instead [de9b68d7#96].

## Quotable Lines

1. Operator [55db5482#0]: "I kind of expected it to go automatically um but then I found that I had to do it by hand". The whole day starts from this mismatch.
2. Cloudflare's error JSON, pasted by the operator [55db5482#0]: "**Do not retry.** Your user-agent has been banned by the site owner." Then the operator: "lol :(". The deadpan of the machine against the human sigh.
3. Operator [55db5482#19]: "the old build Yamel [YAML] on the old tag won't work so we have to use the main branches updated work flow against an old tag." This is the design principle in one breath.
4. Niko [55db5482#79]: "`urllib` adds `Python-urllib` only when `User-Agent` is missing, so a scan of the headers you already set stays green while the ban is still there." A subtle testing insight, which the operator then threw out.
5. Operator [55db5482#86]: "Let's strike any and all such **** tests. Real point in testing that, there is not." The second sentence is word order straight out of Yoda.
6. Operator [837a0fbe#0]: "I tried a 2nd time and it worked so maybe race?" A relatable guess that turned out wrong.
7. Niko [837a0fbe#10]: "We hand Cults the URL and they pull it. One blip fails `createCreation`. The next run pulled it." The pull-based upload model and its fragility, in three sentences.
8. Niko [837a0fbe#18]: "A bulb clip and a TPU sleeve are not a program anyone interacts with over a network." It sinks the AGPL case in one line.
9. Niko [837a0fbe#24]: "The filename sort is the whole control." Galleries are ordered by `ls`.
10. Niko [6d6ab2a0#6]: "What YAML gives you is what Cults gets." It is a crisp pipeline contract.
11. Operator [0c2d1d78#13]: "stop. it's not french. what's going on?" A comic interruption, and a good lesson in checking agent claims.
12. Niko [0c2d1d78#18]: "The line I would not cross is making GitHub the way someone gets the printable files. The files on this page are the download." The ToS answer, distilled.
13. Operator [380b634b#14]: "I just changed the model and text and pictures and I want to update them why was that disallowed?" Frustration with a guard that was too careful.
14. Operator [380b634b#57]: "I noticed that preflight grabbed the api docs from like... somebody's discord". The human catching an AI's sourcing.
15. Operator [380b634b#64]: "guhhhh I bet you can figure it out form ehere tho. i put an api key in an envvar. you ahve to base64 the pw or somethign tho?" Raw, typo-laden late-afternoon fatigue.
16. Operator [380b634b#72]: "(you did but it was too big and it killed the convo) ... 9600 lines of their openapi. use jq judiciously!" The schema dump that crashed the chat.
17. Niko [de9b68d7#36]: "The stored id is the right creation. `creationsBatch(ids:)` does not look creations up by that id." This is the punchline of the API's lie.
18. Operator [de9b68d7#100]: "oh poop! OK please put all of these commits on a branch and don't push any of it to main". A comic save.
19. Operator [a3410637#0]: "i don't think that's right. what gives?" This was the operator's reaction to being asked for a price on a free model.
20. Niko [a3410637#22]: "This run got as far as `updateCreation` and then Cults rejected a price the publisher invented." Niko owning the bug in plain words.
21. Niko [a3410637#67]: "Zero is a paid price below Cults' minimum. A free GPL listing omits the field." A quirk worth a blog paragraph.
22. Niko, in the PR #13 pre-mortem [380b634b#45]: "A job that dies midway can leave duplicate files until the next successful publish". The prophecy, fulfilled at 8:13 PM.

## Unique Technical Details

- **Cloudflare 1010 on `Python-urllib`.** `cults3d.com` returns `403` with `error_code 1010`, `browser_signature_banned`, and `"retryable":false`. Any other User-Agent (even with no key) reaches Cults' own `401 HTTP Basic: Access denied.` [55db5482#0, #8].
- **Auth.** HTTP Basic, `username:API key`, base64-encoded; `curl -u` does it for you. The endpoint is `https://cults3d.com/graphql`, and the official explorer is at `/graphiql` (blank in the agent's browser; it needs sign-in) [380b634b#63, #68, #82].
- **Cults pulls, it does not receive.** `createCreation` takes `fileUrls` and `imageUrls`, and Cults fetches them. Git LFS files come from `media.githubusercontent.com/media/<owner>/<repo>/<tag>/...`. A failed pull surfaces only as `Could not download URL <url>`, with no HTTP status. In the failed attempt the upload step ran 27 seconds; a successful upload step took about 8 [837a0fbe#0, #10].
- **`updateCreation` arguments.** `id`, `name`, `description`, `locale`, `licenseCode`, `madeWithAi`, and the category fields. No `fileUrls` and no `imageUrls` [380b634b#82].
- **Asset mutations.** `createBlueprint(creationId, fileUrl, position?)`, `createBlueprints(creationId, fileUrls)`, `destroyBlueprint(id)`, `createIllustration(creationId, imageUrl, position?)`, `createIllustrations(creationId, imageUrls)`, `destroyIllustration(id)` [380b634b#82].
- **Lookups.** `creation(slug:)` on the query root; `myself.creationsBatch(ids:, limit:, offset:)` with `blueprints { id fileName }` and `illustrations { id }` [380b634b#82].
- **Id forms.** The global id Cults returns is base64 of `Creation/<slug>` (here `Q3JlYXRpb24vaDctYnVsYi1zdG9yYWdl` = `Creation/h7-bulb-storage`). The public design number was `5064983`, and base64 of `Creation/5064983` also works as a filter. `creationsBatch(ids:)` matched the slug, the design number and the numeric global id, and returned `total: 0` for the slug-form global id it hands out itself [de9b68d7#33, #36].
- **`Blueprint.fileUrl` is Cults' own URL.** You cannot diff it against GitHub URLs, so an update replaces the whole set [380b634b#82, #107].
- **Price.** Create succeeds with `downloadPrice` omitted. The update schema marks it non-null. Sending `0` triggers the application error `Price must be greater than or equal to 0.5`. The Cults FAQ says 0 means free, with €0.50 as the minimum above that [a3410637#22, #67].
- **Listing URL.** `/en/3d-model/<category>/<slug>`. The slug is made from the title at creation, and long titles are cut off. What a rename does is undocumented. One live listing had a title that differed from its slug [0c2d1d78#29].
- **The Files column on Cults.** Its note says the 3D viewer shows only STL and OBJ [0c2d1d78#18]. One public profile showed Website, Printables and GitHub links side by side [0c2d1d78#16].
- **GitHub Actions.** The "Use workflow from" ref decides which workflow file loads. A separate input is what `actions/checkout` uses, and GitHub will not fill it from your tags. A `release` published event provides `github.event.release.tag_name` [55db5482#8]. The deploy writes the creation id back to `main` as `github-actions[bot]` with `chore: record Cults creation id`; as a `chore`, it does not cut a release, and it skips the commit if the id already matches [380b634b#18; de9b68d7#39]. Runner tracebacks show the publisher under a `publisher/` subdirectory, which fits the two-tree checkout (inference) [837a0fbe#0; de9b68d7#0]. The runner also showed a notice that `ubuntu-latest` moves to Ubuntu 26 on October 19 [380b634b#13].
- **YAML chomping.** `|-` drops the final newline and `|+` keeps extra trailing newlines [6d6ab2a0#6].
- **Test counts across the day:** 38 → 36 → 47 → 48 [55db5482#79, #112; 380b634b#107; de9b68d7#96].

## Emotional Beats And Humor

- There is a whack-a-mole rhythm. Each fix exposed the next layer: Cloudflare ban, then download blip, then refused update, then wrong lookup key, then the invented price and duplicated files. By evening the messages are terse: "i don't think that's right. what gives?" [a3410637#0].
- The operator's patience thins: "guhhhh" [380b634b#64]; "Oh rught it's not set in your terminal ugh, just fix the curl for me I guess please/" [380b634b#67].
- The chat dies on a schema dump, and the operator laconically re-delivers it as a file with "use jq judiciously!" [380b634b#72].
- Niko insists the terms page is French, then calmly shows it was half-right [0c2d1d78#13, #14].
- Small warm moments: "Ok, thank you!" [837a0fbe#25], "Thanks!~" [6d6ab2a0#18], "OK, thx." [de9b68d7#40], and the "OH!" when the version-in-description idea lands [0c2d1d78#19].
- Dramatic irony: Niko warned at 11:04 that update refusal "has not been tried on a real listing yet" [837a0fbe#24]. It was tried at 2:15. The 2:4x PM pre-mortem predicted duplicate files, and they showed up at 8:13 PM.
- Parallel-session friction: one chat's in-flight task blocked another chat from filing issues until the operator stepped in [0c2d1d78#33, #34].

## Candidate Blog Angles

1. **"Five tracebacks to a published listing"**: a failure-by-failure chronicle of one day wiring GitHub releases to Cults3D. Each failure has a clear symptom, cause and fix. Audience: developers automating publishing to a third-party marketplace API.
2. **"The parameter is called `ids`. It does not take ids."**: the `creationsBatch(ids:)` discovery, why the schema and a fake test double both agreed on the wrong thing, and how one aliased probe query settled it. Audience: GraphQL and API integrators, and anyone who writes fakes for external APIs.
3. **"Run today's publisher against yesterday's tag"**: the deploy design that splits *which code publishes* (default branch) from *what is published* (the tag). It covers the `workflow_dispatch` "Use workflow from" trap and the release-published trigger. Audience: GitHub Actions and release-please users.
4. **"Can I link to GitHub from Cults3D?"**: a maker-focused reading of the terms (exclusivity, free elsewhere, French prevails, no download links in documents), plus why the repo moved from AGPL to GPL to match the license dropdowns on Cults and Thingiverse. Audience: hobbyists sharing open-source models.
5. **"Fail closed, then fail in order"**: the refuse-a-partial-publish guard, the pre-mortem that predicted duplicate files, and the reordering that makes a failed update harmless. Audience: engineers designing multi-step, non-transactional API updates.
6. **"Holding the keys while the agent drives"**: the operator kept the API key, ran agent-written curls, caught a Discord-sourced spec, struck pointless tests, and stopped a bad push to `main`. Audience: developers working with AI coding agents.

## Open Questions And Uncertainties

- **Was the price and order fix verified live?** The transcripts end with PR #15 opened and a suggested deploy from the feature branch. No successful update of the H7 listing appears here [a3410637#67, #80]. The transcripts also don't say how omitting an argument the update schema marks non-null passes GraphQL validation. The publisher added `0` *because* introspection said non-null [a3410637#22].
- **Merges between sessions are inferred.** PR #13 was presumably merged between 7:24 and 7:30 PM, and PR #14 between 7:56 and 8:07 PM (the 8:07 run used publisher commit `6d99629`). Neither merge is shown. A large session at 7:45 PM (`2026-10-15-1945-cursor-8009cded.md`) falls in this window but was not assigned to this digest.
- **Was the first v1.0.2 deploy (2:15 PM, run 38792024073) the first *automatic* release-triggered run?** The transcript doesn't say [380b634b#13].
- **The release-please claim.** Niko said release-please "reads only the first line of a squash commit" [6d6ab2a0#17]. That is unverified here, and I believe release-please documents a way to declare several changes in one commit (my outside knowledge, not from the transcripts). The release commit cited later is `docs: relicense to GPLv3; Cults copy and h7 listing photos` [380b634b#13], not Niko's suggested `docs: refresh Cults listing copy`. The operator apparently chose a different subject.
- **A contradiction about `cults_creation_id`.** At 2:14 PM Niko said "`cults_creation_id` is still blank" [0c2d1d78#29]. At 11:04 it had said `main` already had the id [837a0fbe#24], and at 2:15 the v1.0.2 tag had it [380b634b#13]. The 2:14 claim probably came from an older local branch (inference).
- **YAML evidence.** Niko said it was verifying with PyYAML, then quoted "Ruby's YAML parser" output [6d6ab2a0#3, #6]. The conclusion is standard YAML either way.
- **PR template suggestion.** Niko's "I don't know yet" proposal for the org PR template is attributed to the rework, but the operator's visible message only asked to strike tests [55db5482#86, #89]. The source may be in stripped content. The template was not edited.
- **Which model's upload form?** At 2:13 PM the operator's screenshot showed a Cults upload form that "has the cover and the clips themselves" [0c2d1d78#18]. Which model it was is unclear; possibly the rattlinator, being listed by hand.
- **Framing in the assignment.** The "double select of the tag" pain was GitHub's Run workflow form, not the Cults web UI [55db5482#0]. The Cults UI appears only in the Files-column note and the duplicate-files screenshot.
- **Repo layout differs from the context.** On this day the models lived at the repository root (`h7-bulb-storage/publish.yaml`). The move under `models/` was only filed as issue #11 [0c2d1d78#37, #40]. Deploy was also manual-only until PR #8, so "continuous delivery" began partway through this day.
- **Cause of the download failure.** Niko's "one transient pull" is a best fit. Cults gives no status, so it is not proven [837a0fbe#10].

## Privacy Flags

- Image-attachment paths in the transcripts contain the operator's Windows username and workspace-storage hashes. Never reproduce them.
- The transcripts contain local filesystem paths: the home directory, the Cursor projects and terminals folders, and a local clone of the org `.github` repository. Write `<operator-docs>/...` or describe them generically.
- The Cults API key was held in an env var in the operator's terminal. The key itself never appears, but don't quote terminal-file references or anything near it. The curl examples include the Cults account username, which matches the public handle; consider replacing it with a placeholder.
- The agent's co-author trailer and the GitHub Actions bot identity appear with email addresses. Omit the addresses.
- Handoffs are written to a private "shop" repository; mention it only generically.
- The internal QA and preflight transcript links (UUIDs) are private chat references.
- The headlamp-bulb models imply a specific vehicle elsewhere in the project, but no vehicle is named in these seven transcripts. Keep it that way.
