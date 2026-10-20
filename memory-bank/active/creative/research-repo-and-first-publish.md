# Research Digest: Repo Birth and First Publish

## Sessions Covered

All seven are Cursor sessions on Wednesday 2026-10-14 (UTC-5). Citations use the first eight characters of the session id plus the message ordinal, e.g. `[84616664#12]`.

- `84616664` (10:17-12:46): opened in the old standalone H7 folder. Recaps the 2026-10-12 host survey, drops Thingiverse (Cloudflare wall), picks Cults3D, flips from one repo per model to a public monorepo, bootstraps `3d-models` with the rattlinator and H7, wires release-please with a separate manual deploy, and opens and merges PR #1.
- `62807eb6` (12:48-14:04): the first release PRs. Merging one model's release PR left the other conflicted; fixed with `always-update: true` (PR #4). Both models reach 1.0.0.
- `818ab94c` (14:05-14:07): installs SumMem 0.12.0 at the root and gives each model directory its own store.
- `84a8a854` (14:05-15:14, in parallel with `818ab94c`): Cults API key and nickname, the GraphQL category and license lookup, the license choice (GPL listing, AGPL repo), Cults' NoAI notice, the shared "made with AI" disclaimer, and `docs` commits made patch releases. Niko Level 2, archived.
- `d34f4c87` (15:39-15:46): Git LFS for all image formats; deploy checkout fetches LFS.
- `f5e35244` (16:22-~16:45): `/niko` for CI/CD publishing to Cults. Level 3, planned, preflight passed with advisories.
- `28ce7b60` (16:43-18:37): `/niko-build`. Publisher built test-first, the operator kills a change-detector test, 31 tests pass QA, a chore commit is reworded to `docs` so the photos cut releases, PR #5 opened.

## What Happened

### Picking up the host research (10:17)

The operator opens with the whole problem in one breath: where to keep printable models, "does anybody even put their 3D models on Github?", monorepo or repo per model, how a per-model memory bank fits, and a split between a personal hardware-store one-off and models "designed to solve a problem people might have" [84616664#0]. The framing that drives the day: "I'm not gonna be hand modeling any more probably at all. It's all going to be you and your friends. And so a totally digital, headless code pipeline for model creation, change control, and publishing, is necessary." [84616664#0]

The agent's search of past chats stalls: first the search tool is missing a library ("I fixed torch with `stockroom shim ensure-env` as one does." [84616664#9]), then the meaning-based search misses the thread because none of the H7 session's 517 messages had been indexed. A keyword search finds it [84616664#16]. The recap of the 2026-10-12 survey [84616664#16]:

- Thingiverse, Cults3D and MyMiniFactory have official upload APIs.
- Printables and MakerWorld do not.
- The open blocker: Cloudflare answered `api.thingiverse.com` from this machine with `403 Just a moment…`, user-agent spoofing or not.
- Prior art for model repos: smkent/monoscad, rapax00/3dthings, an HN comment about a CAD-as-code repo built with Claude, and Adafruit's and RatRig's parts repos.

### Layout: one repo per model, then reversed

The operator rejects threedeploy as four years stale, then corrects their own framing: "if there's an existing viable solution then of course we'd prefer to just take it off the shelf.." [84616664#17, #19]. The `/niko-creative` result is **one repo per model**, with a shared publisher command that takes a path, because Niko's memory bank follows the workspace root [84616664#28]. It also corrects the operator's staleness claim. The four-year-old project is the abandoned GitLab copy; a GitHub successor was pushed in March 2025. Still, none of the existing tools clears the bar (details under Unique Technical Details) [84616664#28].

At 10:56 the operator pushes back. A change to the publishing path or the author metadata would mean editing all N repos: "convince me that we really should do one repo per model." [84616664#75] The agent: "I can't." It switches to one public monorepo. Each publishable model is a full project root with its own memory bank. The repo root owns the publisher, the author record and release-please. The personal one-off goes to a private repo [84616664#76]. The stated limit: "Design sessions open the model. Publishing sessions open the root." [84616664#76]

### The Thingiverse saga (10:37-10:56)

A banner on Thingiverse ("SoulCrafted turns 1. What's next for a no-AI, human-first community?") prompts "Are we even going to be welcome there?" [84616664#29]. The agent's research [84616664#34]:

- Thingiverse has been a SoulCrafted site since MyMiniFactory bought it in February 2026, and staff take AI-generated Things off discovery.
- MyMiniFactory forbids selling products that rely on AI-generated models.
- A Thingiverse staff forum post draws the line: "if a human designed it, it belongs here. If a model was generated wholesale by a prompt, it doesn't." It calls AI help with code a gray area.

The agent puts the H7 cover in that gray area: the operator set the standard, the fit rules, the orientation and the physical tests, and an agent wrote the CadQuery. The planned agent-authored catalog with an auto-uploader is "the other side of their line." Cults3D allows AI models if they are marked, hides them behind a No AI filter that is on by default, and limits uploads per day [84616664#34].

The operator makes accounts on both sites anyway (Cults via GitHub sign-in) [84616664#35] and fights the Thingiverse app form ("ugh, nowwhere to click... ok?"). The submit button was hidden under a green banner [84616664#38, #41]. The `curl` token exchange gets Cloudflare's "Just a moment…" page. The agent moves token minting into the browser, and curl with the bearer token is blocked again: "ugh" [84616664#45, #64]. In the browser the same token works: "works in browser. so WTF is the point of an api, then?" [84616664#66] The agent explains that the bot check looks at how the connection starts, never at the token [84616664#67].

The verdict: "Well fuck thingiverse then, cults it shall be! QQ tho... how do the contemporary thingiverse publishers from CICD do it? what do they know that we don't?" [84616664#68] Nothing, the agent finds. Their clients send one bearer header, and a Reddit user hit the same split in October 2025: "A green pipeline in someone else's account means their runner IP was lucky, not that they have a different API." [84616664#74] Cults3D's GraphQL endpoint had already answered a bare curl with `401 HTTP Basic: Access denied.`, "the API answering, not a Cloudflare challenge" [84616664#57].

### Bootstrapping 3d-models (11:10-12:46)

The operator wants a root-level guide for adding a model and "discoverable publishing," and names the folders `h7-bulb-storage` and `fire-extinguisher-rattlinator` [84616664#77]. The agent sketches the layout [84616664#79]:

- Root: `AGENTS.md`, `author.yaml` (no API key), release-please config and manifest, workflows, shared `tools/`.
- Each model: its own `AGENTS.md`, `memory-bank/` and a `publish.yaml` that marks it publishable. Release-please will not discover that file on its own, so both have to be registered.
- Test-print tags gain the directory as a prefix (`h7-bulb-storage-v1-print1`) so they don't collide.

Two challenges follow:

- "I might use Siemens solid edge we might author step files directly with python... We don't bake any assumptions about that in do we?" [84616664#80] The agent says the contract is just the directory and `publish.yaml`, and concedes "One sentence in the sketch did overreach" by making STL and STEP sound like a catalog rule [84616664#81].
- Size and LFS: will 1,000 models kill the repo [84616664#82]? The rattlinator folder is 12 MB. "Almost all of that 12 MB is the same part saved fourteen times under a new name, because the folder was the version history." [84616664#83] Advice: no LFS for model files, because an LFS clone without the store holds only stubs and "the part would no longer be in the clone." The repo is the workshop: "People who want one model get it from Cults, or from that model's GitHub release. They never clone the workshop." [84616664#83]

At 11:32 the operator adds the empty `3d-models` repo: copy only the real content, no history. Which rattlinator was printed? "pretty sure it's 0.13 - i created 0.14 so that the thing I printed - 0.13 - would have a saved record because no vcs." [84616664#84] The Solid Edge export log confirms 0.13, with a matching STL dated 30 March 2025 [84616664#89, #93]. Versions 0.1-0.12, 0.14 and the logs stay behind. From the H7 folder, the old STL, a collar-down prototype and the Thingiverse `openapi.yaml` also stay behind [84616664#93].

The operator asks for a human-editable YAML per model for listing text, which may run to paragraphs [84616664#94], then sees it already exists: "Oh my God you already did exactly that Yaml name i'm stupid, good job!" [84616664#95]. The plan for next steps is the operator's: wire release-please so a merge to main yields tags and releases "on which we can hang publishing to cults and then we'll be able to iterate on that" [84616664#94].

The commit fails. The agent tried to sign it with no terminal for the passphrase, then handed the operator a manual command block [84616664#105]. "Did you forget that you make commits with no gpg sign and no pager?" [84616664#106] PR #1 opens [84616664#111]. Follow-ups pushed to it:

- The rattlinator's purpose, dictated by the operator (see The Physical Loop) [84616664#112].
- Drop version numbers from filenames, giving `rattlinator.par` and `rattlinator.stl` [84616664#115, #121].
- "no CLAUDE.md anywhere pleaase; claude code reads AGENTS.md now." [84616664#122]
- Copy the release-please setup from another of the operator's repos, "the bark/woof emoji line, at least." Use the helper GitHub App so release PRs get checks, and make deploy "a whole separate workflow that can be run manually against a given tag" [84616664#126]. The result: release PRs headed `:service_dog: I have created a release *bark* *woof*`, and a `deploy.yaml` whose Cults step "is still a placeholder and fails on purpose, so a green run cannot mean a listing went up" [84616664#141].

At 12:46 the operator merges and asks for a handoff to a workspace of just that repo [84616664#142].

### First releases and the sibling-PR trap (12:48-14:04)

Two release PRs appear: #2 for `h7-bulb-storage` 1.0.0 and #3 for `fire-extinguisher-rattlinator` 1.0.0 [62807eb6#8]. The agent's advice is to merge them. That makes tags and releases. Nothing goes to Cults yet, because the license and category are still blank [62807eb6#8].

The operator merges #3 and #2 goes into conflict: "Seems like a major design flaw..." [62807eb6#9]. Every per-model release PR edits the one shared manifest file, and release-please rewrites an open PR only when its release notes change [62807eb6#19]. The operator sets the standard: "Needs to be idiot proof and not require manual intervention" [62807eb6#20]. The fix is `"always-update": true` (PR #4, Niko Level 1) [62807eb6#36]. Then: "Done and it worked." Both models are at 1.0.0 [62807eb6#37, #42].

### SumMem and Cults metadata (14:05-15:14)

SumMem 0.12.0 goes in, with a store for the catalog and one per model. `AGENTS.md` gains a "run `summem start`" step for new models [818ab94c#17].

In the parallel session ("what's my next step on cults 3D" [84a8a854#0]), the operator does three things:

- Creates the `CULTS3D_API_KEY` repo secret [84a8a854#15].
- Runs the agent's combined `categories` + `licenses` query in Cults' GraphQL explorer and pastes the result [84a8a854#23, #24].
- Shares a screenshot of the web upload form, which the agent maps field by field onto `publish.yaml` [84a8a854#39].

The agent recommends Gadget > Vehicle Accessories for both car-related models. It notes that the child category needs its own field, and that Cults offers no AGPL license [84a8a854#27].

Then the AI questions. "p.s. oh fuck 'em. Whatever, chekc it on everything." [84a8a854#42], with a screenshot. A later turn refers to "The AI checkbox you decided to tick" [84a8a854#54], so the box is evidently the AI declaration (inference). The operator pastes Cults' NoAI notice and asks whether GPL/AGPL "covers" it [84a8a854#46]: "No. The GPL grant covers your files. It does not cover that Cults page." The license is permission for the files, but it doesn't authorize scraping Cults, override account rules, or settle questions about AI training [84a8a854#54].

The operator dictates a reciprocal disclaimer: "made with AI, permission granted to be downloaded and used by AI, pursuant to the terms of the <license name>, under which this model is made available." [84a8a854#55] The agent keeps it once, as shared boilerplate in `author.yaml` [84a8a854#57]. The operator asks if any printing site isn't "heinously anti-AI" [84a8a854#58], then answers it: "Eh, we have to start somewhere. And we'll start here. They at least ALLOW it as marked, we'll show 'em we're at least as good - if not better - than the butthurt babies ^_^" [84a8a854#62].

The last snag is versioning: "OHHHH but BOLLOCKS what if we add photos and go through RP and then..." [84a8a854#81]. The version belongs to the package, so a photo bumps it even when the part hasn't changed. The operator floats a fourth version number. The agent rejects it, because release-please only emits three-part versions. It proposes a meaning instead [84a8a854#87]:

- Patch: same printable files.
- Minor: the model changed, but old prints still work.
- Major: reprint.

The operator asks that `docs` count as a patch, "which is much more accurate" for photos and descriptions [84a8a854#88]. That works by unhiding `docs` in the changelog config [84a8a854#102, #143]. The records land on local `main` as a `chore` commit. With `main` 8 commits ahead of origin, the PR step refuses to run [84a8a854#161].

### LFS for images (15:39-15:46)

The operator asks for Git LFS on "all images" [d34f4c87#0]. Fourteen image extensions are tracked, and the one existing SVG is migrated into LFS. The deploy checkout fetches LFS so it gets real files, not pointer text [d34f4c87#8]. It is pushed to main as `chore(dev): track images with Git LFS` [d34f4c87#13].

### Wiring the Cults deploy (16:22-18:37)

Photos now sit in each model's `img/` directory. The operator invokes `/niko` to "try to set up cicd publishing to Cults3d as planned." They want a marked place for print notes they'll write themselves: "we do need to put a specific support blocker in the [Cura] slicer and I need to mention that it needs to be printed with tpu 95" [f5e35244#0].

- The task is classified Level 3 [f5e35244#18]. Planning settles a test runner: Python's unittest run under `uv` [f5e35244#39].
- Preflight passes with two advisories: the publisher should stop if a saved Cults id disagrees with the matching listing, and a `--dry-run` would help [f5e35244#58].
- `/niko-build` writes the tests first and watches them fail [28ce7b60#35-#46].

One test demanded that every file in `img/` also be listed in `publish.yaml` [28ce7b60#56]. The operator: "Don't write change-detector tests, BTW... a test that forces me to enumerate in the configuration everything in the folder, is not only tedious but also wrong." [28ce7b60#60] The new rule: anything in `img/` is a listing photo. The printable `files` list stays explicit, and its paths are checked "because a typo there would send Cults a dead URL" [28ce7b60#93].

The result [28ce7b60#93]:

- `tools/cults_publish.py` creates or updates the listing.
- The deploy writes `cults_creation_id` back to `main`.
- The rattlinator's `manufacturing` field is an empty slot with a comment.
- 31 tests; QA passed.

The H7 photos had arrived in a chore commit, so no tag held them [28ce7b60#93]. The operator: "you can just amend and edit that commit so that it will cause a release.." [28ce7b60#94] Commit `515490c` becomes `docs: add the listing photos` (four pictures, both models). PR #5 is titled `docs` "on purpose: a squash merge uses that title, and a `chore` title would not put the photos on a tag" [28ce7b60#97, #119]. The cluster ends there. Nothing has been published to Cults yet.

## Turning Points

- **Thingiverse's API fails for a reason unrelated to auth.** Believed: get a token, then curl works. True: Cloudflare checks the request before Thingiverse ever reads the token; the same token works in a browser. Found by curling the token endpoint, then the API, then pasting the URL into a browser [84616664#45, #64-#67]. Result: Thingiverse dropped, Cults chosen [84616664#68].
- **Existing CI publishers know nothing extra.** They send the same one-header requests and work only where Cloudflare lets them through [84616664#74].
- **The anti-AI landscape is the second filter.** First the SoulCrafted banner and MyMiniFactory's policy [84616664#34], then Cults' own NoAI notice [84a8a854#46]. The operator chooses Cults anyway because it allows marked AI work [84a8a854#62].
- **The agent's creative decision reversed in about 30 minutes.** One repo per model [84616664#28] became a monorepo after the operator's cost argument; the agent said "I can't" defend it [84616664#75, #76].
- **The folder was the version history.** The rattlinator was saved fourteen times under new names, and 0.14 existed only to preserve 0.13, the printed one. The export log settled which was printed, not anyone's memory [84616664#83, #84, #89].
- **LFS: no for parts, yes for photos.** At 11:26 the agent argued against LFS for model files [84616664#83]. At 15:39 the operator put every image format in LFS [d34f4c87#0]. These don't conflict, and a post can state the line plainly.
- **Release PRs collide.** Per-model release PRs share one manifest. Found by merging one; fixed with `always-update`, and the fix verified [62807eb6#19, #37].
- **Package version vs. model version.** A photo bumps the version too. The fix is semver as "do you need to reprint?", with `docs` as a patch [84a8a854#81-#102].
- **Chore commits silently don't ship.** The photos sat in a chore commit and missed the H7 tag until it was reworded [28ce7b60#93, #97].
- **The operator, not the agent, caught the change-detector test** [28ce7b60#60].

## The Physical Loop

Thin in this cluster.

- The rattlinator's job, in the operator's words: extinguisher handles, triggers and locks are "lightweight low tolerance" aluminum or plastic that "resonate at the various frequencies that the car operates at." A TPU 95 sleeve slides onto "the business end" and "will just deform out of the way so it doesn't stop you from stopping a fire" [84616664#112].
- Fit was checked on the operator's 2.5 lb and 5 lb extinguishers. It hasn't been tried on the tiny ones or on restaurant 10, 15 or 20 lb units (dictated as "1015 or 20 pound") [84616664#112, #121].
- The printed version (0.13) was identified from the Solid Edge export log and an STL dated 30 March 2025 [84616664#89, #93].
- Print notes still owed by the operator: a specific Cura support blocker, and TPU 95 [f5e35244#0].
- The agent framed the listing photos as "also the evidence that the models print" [84a8a854#64]. The operator promised "ONE photo for each model" [84a8a854#65]; the docs commit held four pictures in total [28ce7b60#119].
- File sizes: STLs 4-25 KB, the largest `.par` 1.2 MB, the rattlinator folder 12 MB [84616664#83].

## Operator Corrections And Teachings

- Prefer a proven off-the-shelf tool over writing one: "if there's an existing viable solution then of course we'd prefer to just take it off the shelf.." [84616664#19]
- Keep shared facts in one place: "if the author metadata changes at all even if the models don't I'm going to have to go out to all N places and update... convince me" [84616664#75].
- Don't assume a CAD toolchain [84616664#80].
- The repo is the workshop, not the storefront: "that's why we published to the [Thingiverses] to cults so that people can grab just the one they want people the repo is really for me." [84616664#82]
- Use YAML for anything a human writes: "it's a million times easier to use Yaml scalers to type a couple paragraphs" [84616664#94].
- Standing commit flags: "Did you forget that you make commits with no gpg sign and no pager?" [84616664#106]
- "we do not need to keep the version name in the file name anymore now that we are in source control" [84616664#115].
- "no CLAUDE.md anywhere pleaase; claude code reads AGENTS.md now." [84616664#122]
- Keep release and deploy separate; deploy runs by hand against a tag [84616664#126].
- "Needs to be idiot proof and not require manual intervention" [62807eb6#20].
- Leave optional fields empty "so that we can do other releases later" [84a8a854#65].
- Make `docs` a patch for listing-only changes [84a8a854#88].
- The operator writes the print notes: "i'm not asking you to write that but just make sure that I've got a call out the place where I would write that" [f5e35244#0].
- "Don't write change-detector tests, BTW." [28ce7b60#60]
- Practical git: amend the chore commit so it cuts a release [28ce7b60#94].

## Quotable Lines

1. Operator [84616664#0]: "My big thing is I'm not gonna be hand modeling any more probably at all. It's all going to be you and your friends." The thesis of the whole project.
2. Operator [84616664#9]: "I fixed torch with `stockroom shim ensure-env` as one does." Deadpan.
3. Operator [84616664#29]: "Are we even going to be welcome there?" The moment the culture question enters.
4. Assistant [84616664#34]: "The banner is the brand, and a fully agent-authored catalog does not fit it." A crisp verdict.
5. Assistant [84616664#34]: "Thingiverse can hold a model you directed and test-printed. It is a poor bet as the home of an agent-authored catalog." Draws the gray-area line.
6. Operator [84616664#38]: "ugh, nowwhere to click... ok?" Every developer portal, ever.
7. Operator [84616664#66]: "works in browser. so WTF is the point of an api, then?" The punchline of the Thingiverse saga.
8. Assistant [84616664#67]: "The API did its job... Cloudflare never let the curl request get that far." The clean diagnosis.
9. Operator [84616664#68]: "Well fuck thingiverse then, cults it shall be!" The decision, in character (profanity).
10. Assistant [84616664#74]: "A green pipeline in someone else's account means their runner IP was lucky, not that they have a different API." A memorable debunk.
11. Assistant [84616664#76]: "I can't. The costs you just named sit on the author and the publisher, and one repo per model makes you pay them once per model." An agent conceding cleanly.
12. Assistant [84616664#83]: "Almost all of that 12 MB is the same part saved fourteen times under a new name, because the folder was the version history." Every hobbyist's folder.
13. Assistant [84616664#83]: "They never clone the workshop. The monorepo is yours." Reframes who the repo is for.
14. Operator [84616664#84]: "i created 0.14 so that the thing I printed - 0.13 - would have a saved record because no vcs." Version control by hand, confessed.
15. Operator [84616664#95]: "Oh my God you already did exactly that Yaml name i'm stupid, good job!" Self-deprecating delight.
16. Operator [84616664#112]: "strange noises in the car means something is wrong and I need to figure out what it is so I want the fire extinguisher to not make noise." The human reason for the rattlinator.
17. Assistant [84616664#141]: "The Cults upload step is still a placeholder and fails on purpose, so a green run cannot mean a listing went up." A deliberately red step.
18. Operator [62807eb6#20]: "Needs to be idiot proof and not require manual intervention" The bar for continuous delivery.
19. Assistant [84a8a854#54]: "No. The GPL grant covers your files. It does not cover that Cults page." License vs platform rule, in one line.
20. Operator [84a8a854#62]: "Eh, we have to start somewhere. And we'll start here. They at least ALLOW it as marked, we'll show 'em we're at least as good - if not better - than the butthurt babies ^_^" Defiant and funny; the final host decision.
21. Operator [84a8a854#81]: "OHHHH but BOLLOCKS what if we add photos and go through RP and then..." A realization in real time.
22. Assistant [84a8a854#87]: "`fix:` is an awkward word for 'added a photo.'" Dry; sets up the docs-as-patch fix.
23. Operator [28ce7b60#60]: "a test that forces me to enumerate in the configuration everything in the folder, is not only tedious but also wrong." A crisp test philosophy.

## Unique Technical Details

### Thingiverse

- Cloudflare blocks curl from a home connection on both `api.thingiverse.com` and the OAuth token endpoint. Spoofing the user agent didn't help, and the same token works in a browser [84616664#16, #45, #65, #66].
- Making a Web App: the "Thing App Type" radio buttons stay grayed out on purpose. The **Create & Get App Key** button sits at the top right, hidden under a green banner. The terms checkbox "may still say MakerBot" [84616664#37, #41].
- The App Token can only read public Things; uploading needs a user token [84616664#60]. The browser flow (`response_type=token`) puts `access_token` in the address bar. The reply has no expiry and no refresh token, so the token can live in a CI secret until revoked [84616664#45, #60]. The `response_type=code` flow needs a curl exchange that Cloudflare blocks.
- Thingiverse's `openapi.yaml` has no `/users/me`, only `/users/{username}`. It lists upload routes (`POST /things/`, `/things/{thing_id}/files`, `/things/{thing_id}/publish`, `/files/{file_id}/finalize`, `/files/0/uploadFile`, `/files/0/FinalizeFiles`) and declares `BearerAuth` with `bearerFormat: JWT` [84616664#49].
- An app Thingiverse hasn't approved is capped at about 10 users [84616664#16, #37].
- Existing tools:
  - threedeploy. The GitLab copy stopped 2022-11-19; the GitHub copy was last pushed 2025-03-06 (PyPI 1.1.0). It is still a work in progress, its summary update is broken, it requires a fixed layout, and it uses the author's own client id [84616664#28].
  - thingiverse-publisher 0.6.0 (2026-03-15), "rudimentary" by its author's account [84616664#28].
  - Both send only an `Authorization: Bearer` header, via `requests` or `httpx` [84616664#74].

### Cults3D

- `cults3d.com/en/api` is the storefront/affiliate API. The scriptable API is GraphQL at `https://cults3d.com/graphql`, with HTTP Basic auth: the username is the Cults nickname (which can differ from the GitHub sign-in name) and the password is the API key [84616664#57; 84a8a854#14].
- No key gets a real `401`, not a bot challenge [84616664#57].
- `createCreation` takes file and photo URLs, never bytes, so GitHub release assets fit. Omitting `licenseCode` defaults the listing to "Cults - Private Use" [84616664#57; 84a8a854#27].
- Category ids look like `Q2F0ZWdvcnkvMjU`; copy them exactly, with no trailing `=` [84a8a854#27]. (Inference by the digest author, not in the transcript: they decode as base64 of `Category/25`.) The parent goes in `categoryId`, the child in `subCategoryIds` [84a8a854#27].
- Licenses: no AGPL. Free listings can use `cults_pu`, the Creative Commons codes, `cern_ohl`, `gpl`, `lgpl` or `mit`. Paid listings can use `cults_pu`, `cults_cu` or `cults_cu_nd` [84a8a854#24, #27].
- Upload form: the 3D viewer handles STL and OBJ up to 30 MB. STEP files are accepted but not previewed. "Created with AI" is off by default. License and price come on the next page [84a8a854#39].
- AI policy: AI models are allowed if marked, a No AI filter is on by default, and uploads are capped per day [84616664#34]. A separate NoAI page bans reproducing site content through AI services and scraping without the author's permission [84a8a854#46, #54].

### Release-please

- `separate-pull-requests: true` plus one shared manifest means sibling conflicts. Release-please 17.6.0's `maybeUpdateExistingPullRequest` skips any PR whose notes are unchanged (log line: `PR #2 remained the same`). `"always-update": true` force-rewrites open release PRs on every run [62807eb6#19, #23].
- With `release-type: simple` starting at `0.0.0`, the first `feat` release PRs were 1.0.0 [62807eb6#8].
- A helper GitHub App token lets release PRs trigger checks. The default `GITHUB_TOKEN` can't [84616664#141].
- `docs` is hidden by default, so it never cuts a release. Any visible type that isn't a feature or a breaking change becomes a patch. A custom `changelog-sections` list replaces the defaults, so the full default list had to be copied. On a never-released package, the first `docs` commit releases as 1.0.0 [84a8a854#102, #127, #143].
- The prerelease `1.0.0-sp.1` sorts before `1.0.0` in semver, so a "service pack" can't stand in for a fourth number [84a8a854#87].
- With squash merges, the PR title's type decides whether a release is cut [28ce7b60#119].

### Pipeline shape

- `publish.yaml` fields: name, block description, `license_code`, `category_id`, `subcategory_ids`, `manufacturing`, `tags`, `files`, `cults_creation_id`. `author.yaml` holds the nickname, locale `EN`, `made_with_ai: true` and the disclaimer template with `{license_name}` [84a8a854#57, #143].
- Every file in a model's `img/` is uploaded as a listing photo. The `files` list is explicit, and each path is checked [28ce7b60#93].
- Deploy runs by hand (`workflow_dispatch`) against a tag, checks out with `lfs: true`, creates or updates the listing, and commits the returned id back to main [d34f4c87#8; 28ce7b60#93].
- LFS tracks 14 image extensions, and the patterns are case-sensitive on Linux [d34f4c87#8].
- Size thresholds: GitHub warns at 50 MB and refuses files over 100 MB. The estimate was about 1 GB of working tree per 1,000 models, and about 10 GB of history if each binary part is revised ten times [84616664#83].

## Emotional Beats And Humor

- The torch fix "as one does" [84616664#9].
- The SoulCrafted banner reads as comic foreshadowing ("Lol, at the top of thingiverse") [84616664#29].
- Developer-portal pain: "ugh, nowwhere to click... ok?", "Ah, I found it.", then "ugh" at the second Cloudflare wall [84616664#38, #42, #64].
- Exasperation becomes a decision: "WTF is the point of an api", then "cults it shall be!" [84616664#66, #68].
- Self-deprecating delight when the agent had already named the file: "i'm stupid, good job!" [84616664#95].
- A mild scolding over forgotten commit flags [84616664#106].
- From "major design flaw" [62807eb6#9] to "Done and it worked." [62807eb6#37].
- Resignation, then defiance, about anti-AI hosts: "oh fuck 'em. Whatever" [84a8a854#42], then "we'll show 'em... ^_^" [84a8a854#62].
- "OHHHH but BOLLOCKS" [84a8a854#81].
- Warm sign-offs ("Great. merged... thanks!", "Thx") [84616664#142; 818ab94c#18].

## Candidate Blog Angles

1. **Why I publish to Cults3D and not Thingiverse.** The curl-vs-browser saga, the question of what other CI publishers know, and Cults answering with an honest `401`. Audience: makers and developers who want to automate uploads.
2. **Continuous delivery for physical objects.** A monorepo with one release-please component per model, deploy by hand against a tag, Cults pulling files from GitHub release URLs, and semver read as "do you need to reprint?" (patch for listing changes via `docs`). Audience: makers with a DevOps bent; release-please users.
3. **Publishing AI-made models into an anti-AI ecosystem.** SoulCrafted, MyMiniFactory's ban, Thingiverse's "gray area," Cults' allow-but-hide filter and NoAI notice, GPL vs platform rules, and the operator's reciprocal disclaimer. Audience: a general tech audience following the AI culture fights.
4. **"The folder was the version history."** Moving `Rattlinator 0.1`-`0.14.par` and an export log into git: keep only the printed one, no LFS for parts, LFS for photos. Audience: hobbyist CAD users who version by filename.
5. **Arguing with your agent.** The agent's "I can't," its correction of the operator's threedeploy claim, and the operator catching a change-detector test and a forgotten commit flag. Audience: people who code with AI agents.
6. **A short release-please tip.** With separate release PRs and a shared manifest, the first merge leaves the other release PRs in conflict; `always-update: true` fixes it. Audience: release-please monorepo users.

## Open Questions And Uncertainties

- **No Cults publish in this cluster.** PR #5 was opened but isn't shown merged, and the deploy never ran against Cults [28ce7b60#119]. "First publish" here means the first GitHub releases (both 1.0.0) [62807eb6#42].
- **Conflicting version state.** Around 14:24 the agent said `h7-bulb-storage` was still at 0.0.0 and that a photo could ride its first release [84a8a854#87]. Another session had already reported both models at 1.0.0 [62807eb6#42], and a later session found an `h7-bulb-storage-v1.0.0` tag [28ce7b60#93]. Inference: that session read a stale local checkout (it was also 8 commits ahead of origin [84a8a854#161]).
- **How the unpushed `main` got pushed** between 15:14 and 15:46 isn't shown [84a8a854#161; d34f4c87#20].
- **An unanswered license question.** "gpl on a free listing and agpl on the actual thing 'works,' right?" [84a8a854#41] got only "I'll check" [84a8a854#43]; the visible answer is about the NoAI notice. The decision is recorded: GPL on Cults, AGPL-3.0 for the repo [84a8a854#64].
- **The AI declaration in the API.** Cults' example mutation had no AI field, and checking the schema was left as a to-do [84616664#57]. How the build sends `made_with_ai` isn't visible.
- **The layout differs from today's.** Here the models sit at the repo root [84616664#79, #93]; the current repo `AGENTS.md` uses `models/<component>/`. They were evidently moved later.
- **The personal one-off.** It was described as a hardware-store part "nobody else will ever use", headed for a private repo [84616664#0, #76]. The context says `jerry-can-buffer` later went public. Whether that's the same part isn't stated.
- **H7 naming.** The model is called an "H7 bulb cover" and "H7 LED bulb case", with source `h7_led_cover.py` [84616664#16, #93]; possibly it's for an LED replacement bulb. Not stated.
- **Photo count and authorship.** One photo per model was promised [84a8a854#65], but the commit holds four, and its author isn't named [28ce7b60#119].
- **Thingiverse from GitHub's runners** was never tested [84616664#67, #74].

## Privacy Flags

- The first session's workspace path and every image-attachment path contain the operator's Windows username and personal Documents folder layout. Write `<operator-docs>/...`.
- A GPG signing-key fingerprint appears verbatim [84616664#105]. Do not repeat it.
- The helper GitHub App's id value appears verbatim [84616664#141]. Treat it like a client id and don't repeat it.
- The operator obtained Thingiverse client credentials and tokens and referenced terminal output containing them. No values appear in the text; don't reconstruct any.
- The Cults API key is a GitHub secret (`CULTS3D_API_KEY`), and its value never appears. The Cults nickname is the operator's public GitHub handle.
- The operator mentions owning 2.5 lb and 5 lb extinguishers kept in a car, and talks about race and off-road vehicles in general. Keep it generic and don't name the operator's vehicle.
- At [84a8a854#58] the operator used a crude, derogatory slang phrase about Cults' NoAI notice. Don't quote it. The other profanity ("fuck thingiverse", "fuck 'em", "WTF", "BOLLOCKS", "butthurt babies") is the operator's own voice; quote it with care.
- Internal tooling: handoffs go to a separate "shop" repo, with commit hashes and a branch name [84616664#152; d34f4c87#20], plus local indexing counts and past-chat ids. A generic mention is fine; leave out the specifics.
