# Research Index: 3D Modelling Blog Slate

Durable map of the source material. Read this first after a context reset.

## Where Things Are

- **Local-only notes:** `.scratch/3d-research/private/` holds operator-private material (gitignored). Read `NOTES.md` there before drafting anything about the evening of Oct 15. Never copy its contents into the memory bank, a commit, or a post.
- **Transcripts (local, gitignored):** `.scratch/3d-research/transcripts/*.md`, one per top-level session, boilerplate stripped, headings `### [ordinal] role \`message_id\``. `INDEX.tsv` lists them. Regenerate with `python3 .scratch/3d-research/scripts/dump-transcripts.py` (reads `.scratch/3d-research/data/sessions.tsv`, which `scripts/find-sessions.sh` builds).
- **Per-cluster digests (committed):** `memory-bank/active/creative/research-<cluster>.md`, written by subagents from the transcripts. See the cluster table below.
- **3d-models repo:** `/home/mobaxterm/git/3d-models` (public: https://github.com/Texarkanine/3d-models). Root and per-model `memory-bank/` files, archives under `memory-bank/archive/`, SumMem notes (`.summem/summem wake --path models/<m>`).
- **Prior post:** `blog/diary/_posts/2025-11-14-octoprint-python-upgrade-cascade.md` (author texarkanine; Niko helped). The OctoPrint box is a Raspberry Pi 4.

## Stockroom Notes

- Semantic search failed at first (`ModuleNotFoundError: No module named 'torch'`); the operator fixed it with `stockroom shim ensure-env` and had an issue filed asking stockroom to print that remedy. Both checks agree the session set is complete: keyword SQL (every Thingiverse mention is in a known session) and an 8-query semantic sweep (`scripts/semantic-sweep.sh`; every new hit was an unrelated project: lite-rpg, a16n, slobac, stockroom, a Wayback site).
- Cursor sessions carry no `ts`/`title`; dates come from `<timestamp>` tags.

## Timeline Skeleton (all 2026)

Clock caveat: Claude Code transcript stamps (and the Claude session times below) are UTC; Cursor `<timestamp>` tags are local (UTC-5). Subtract five hours from Claude times for local: the H7 request was about 09:18 local on Oct 12, and the H11 "fits like a GLOVE" report was 14:54 local on Oct 15.

- **Oct 12 14:18 UTC** Claude Code session in the operator's local `3D Printer/.../h11 bulb case` folder: "The STL here is from Printables (H11 bulb case) - it works. BUT I need one for an H7 form factor." Origin of the H7 design. Same session discussed whether models can live in public repos and publish to print hosts (Thingiverse research begins).
- **Oct 13-14** H7 design iterations in Claude Code (`/nk-chat`): test print fitment, barbs, clip tab thickness, flange pocket depth. Many small subagent sessions (reviewers) not dumped.
- **Oct 14 10:17** Cursor in the H7 folder: publishing research resumes ("I had to go make a Thingiverse account and provision an app...").
- **Oct 14** 3d-models repo created; first commits put the two models in (rattlinator + h7) with release-please; SumMem; Git LFS for images; Cults3D publishing set up via `/niko` (L3 archive `20261014-cults-deploy-upload`).
- **Oct 14 22:11 - Oct 16** H11 redesign in Claude Code worktree `3d-models-h11-butforled` ("H11 bulb holder redesign": the Printables case failed the standard). H11 0.1 fit test "fits like a glove" on first print (Oct 15).
- **Oct 15** The Cults saga: manual publish UI pain; deploy tracebacks repeatedly (`cults_publish.py` line 555/571/574/576); Cults ToS analysis (GitHub links OK); Thingiverse API attempt (Cloudflare 403 `cf-mitigated: challenge` on www and api; token never verified; OpenAPI was a local file, its Wayback origin per OptMem is not shown in that transcript); auto-deploy on release; custom User-Agent (Cloudflare 1010 bans `Python-urllib`); price must be >= 0.5 on update even for free; license silently resets to `cults_pu` without licenseCode; flaky createIllustration; gallery doesn't rebuild until `updatedAt` changes.
- **Oct 15 evening** Flaky Cults photo adds get a retry (PR #17); a neutral image-metadata pre-commit hook lands (PR #18); Cults' stale public gallery diagnosed, "." toggle on `details`, issue #4. PR and issue numbers before and after that evening refer to different items: cite PRs by title and date, not number alone.
- **Oct 16** models moved under `models/`; listing placeholders `{version}` `{changelog_url}`; h7 clip rename (flange plate rim thickness); H11 holder v1.0.0 released; rattlinator photos/tags/readme, first Cults publish; "released again too soon" failure.
- **Oct 18-19** Prong covers for both bulb models (H7 leaf-spring block; PGJ19 connector cap). Test print 1 too big / flopped; test print 2 "Those both work!"
- **Oct 19** release-please cross-model changelog contamination (one commit touching two models); "no creation error again" (Cults `creationsBatch` filters on `identifier`, not slug); jerry can buffer onboarded from the operator's old folder (`.par` + STL, inch-vs-mm export trap).
- **Oct 20** jerry-can-buffer v1.0.0 released (soft bumpers; 25.4 mm length re-export).

Span: first design session to four published models and a working CD pipeline in about eight days.

## The Four Models

| Model | Origin | Source | Notes |
|---|---|---|---|
| `jerry-can-buffer` | Operator, printed 2023-09-23 | Solid Edge `.par` | TPU 90 or softer; stretch along Z to rail length; inch export is 25.4x too small |
| `fire-extinguisher-rattlinator` | Operator, printed 2025-03-30 | Solid Edge `.par` | TPU 95; deforms out of the trigger's way; was "0.13" by filename |
| `h7-bulb-storage` | Niko, from requirements | CadQuery `h7_led_cover.py` | PX26d standard; clip is a preloaded spring; clip bands by plate thickness; prong cover |
| `h8-h9-h11-h16-bulb-storage` | Niko, redesign of a Printables H11 case | CadQuery `h11_holder.py` | PGJ19 twist-lock with printed catches; connector cap clips to the standard's hooks |

## Cluster Table

| Digest file | Sessions (transcript files) | Theme |
|---|---|---|
| `research-h7-origin.md` | 2026-10-12-1418-claude-dda9a5c3, 2026-10-13-0019-claude-45e66c5d | H7 from first request through first test prints; early publishing talk |
| `research-h7-iteration.md` | 2026-10-13-1258-claude-6e0ed576 | H7 iteration to a working clip |
| `research-repo-and-first-publish.md` | 2026-10-14 cursor 84616664, 62807eb6, 818ab94c, 84a8a854, d34f4c87, f5e35244, 28ce7b60 | Publishing research, repo birth, Cults setup |
| `research-h11.md` | 2026-10-14-2211-claude-2702c714, 2026-10-16 claude cba5b6e1, d7453e92, 2544d52c, cursor ccedeeea, 2026-10-19 cursor 21dab071 | H11 redesign, PGJ19 naming |
| `research-h7-polish-and-caps.md` | 2026-10-16 claude a79f8c63, 58e497ae, 16dfa9a3; 2026-10-18 claude 912e6731; 2026-10-19 cursor b06fd584 | H7 clip rename, README/memory bank, PR feedback, prong covers |
| `research-cults-day.md` | 2026-10-15 cursor 55db5482, 837a0fbe, 6d6ab2a0, 0c2d1d78, 380b634b, de9b68d7, a3410637 | Cults manual publish, deploy failures, ToS |
| `research-thingiverse.md` | 2026-10-15-1945-cursor-8009cded | Thingiverse API attempt |
| `research-cults-night.md` | 2026-10-15-2057-cursor-f896ee1e | Flaky photo-add retry, metadata hook, stale Cults gallery (sanitized extract; full version local-only) |
| `research-ops-and-rescues.md` | 2026-10-15 cursor e7dc0d68, 132d9bb4, 88c471a5, 6193e4bf; 2026-10-16 cursor 70e4565b, 800b7220, 4eae4a2c, b7d08320; 2026-10-19 cursor bf8f1365, a0d33f7a, 005827aa | Late Cults fixes, issues #1/#2/#4, rattlinator cleanup, release-too-soon, release-please contamination, jerry can onboarding |

## Direct Findings By The Main Agent

- **The H7 design ran the full Niko workflow on Oct 13:** 7 preflight and 7 QA subagent passes (Claude Code subagents, not dumped as transcripts; verdicts read from stockroom). Highlights:
    - Preflight 10-13 18:45 FAIL (fixable): a planned check on the spread clips' contact would fail after a correct build.
    - Preflight 10-13 22:17 FAIL (blocking): "unit 2 (the export) has no test. As planned, that unit could export the wrong clip and every check would still pass."
    - QA 10-13 23:17: "You've hit your session limit · resets 6:30pm".
    - QA 10-13 23:31 FAIL (fixable): "The code, the checks and the exported files are all correct. One line in the public README says something that never happened" - the README claimed a squarer catch face (BARB_LEAN) "held hardest"; no print showed that. Fixed; re-QA PASS 23:37.
    - QA reports cite `tools/check_fit.py` sections A-J, ~50 checks, ~84 s per run.
- **Contrast:** by Oct 18 (prong covers) the archive says "No `/niko-qa` subagent ran. The test prints were the QA." The H11 techContext codifies it: "Do not add committed tests for shapes still being prototyped. Verify ad hoc in scratch and let the test print decide; add checks once a shape settles." That is a deliberate exception to the operator's always-TDD rule for physical prototypes.
- **The original H7 repo** (operator's local "H7 bulb case" folder; 66 commits 10-12 16:36 to 10-13 18:42, no remote; tags `0.3-print1 0.4-print1 v1-print1 v1-print2 v1-print3 v2-print1`; read-only access) holds four archives and an unarchived creative doc. Key facts:
    - Archive `20261012-h7-cover-v1-v3` (hand-written, not by a Niko workflow, "so that nothing from that session is lost"): v1 slide-in wedge fork, never printed; v2 round collar + U-clip, printed: first attempt printed upright failed (needed support under the tab windows), bulb turned freely, tips too short to pinch; v3 square collar so tunnel roofs print as bridges, key blocks, PX26d maxima.
    - **The standards hunt:** IEC 60061-1 sheet 7004-5 not free; numbers from its identical Russian adoption GOST IEC 60061-1-2014 on standartgost.ru, a text-only copy with no drawing, so letters (O, K, Q, M) were matched to features by fit against the operator's bulb and a retailer description. UNECE R37 PDFs (UNECE, EUR-Lex) refuse scripted downloads; the Australian ADR 51/00 .doc on legislation.gov.au (F2006L03254) embeds the R37 sheets as PNGs; H7/1 is image #66 in its Data stream.
    - Lessons recorded: "Find the standard first. The operator expected the H7 dimensions to be known." An early rib key reached Ø32.6 and would have blocked every real flange (Ø33.3-34). "The operator did not know 'lintel'. Use everyday words (bridge, shelf, doorway)." Checks lived in a temp session folder and were nearly lost.
    - **Creative doc `creative-model-repo-layout.md` (never archived):** chose "One repo per model, publisher as its own tool" and REJECTED "Nested full roots" (one public repo, each model dir its own memory-bank root). The 3d-models catalog that got built is essentially nested roots (root memory bank + per-model memory banks + per-model SumMem stores, publisher inside the catalog). The reversal is a story beat; who overturned it and why should be in `research-repo-and-first-publish.md`. The doc also surveys off-the-shelf publishers (threedeploy GitLab last commit 2022-11-19, GitHub WIP with broken Thingiverse summary update; PyPI `thingiverse-publisher` 0.6.0 "rudimentary"; `3dp-mcp-server` replaces the CAD stack) and concludes "A small client against the OpenAPI spec is the publisher." Host survey: Thingiverse OpenAPI archived April 2025, live spec behind Cloudflare; Cults3D API answers curl; Printables and MakerWorld have no public upload API.
    - The folder also holds `openapi.yaml` (Thingiverse spec, presumably from Wayback) and `h7-bulbholderv2.stl` (a MakerWorld design kept as reference; licence flagged).
- **Jerry can session tail (un-ingested, read from the raw Cursor transcript; dump `.scratch/3d-research/data/005827aa-tail.md`):** Oct 20 09:42 Rotate worked; Niko's release check found the shipped file was 22.8 mm long (0.90 in), not the 1 in its old filename claimed, so the listing's 500% scale would make 114 mm instead of 127 mm (Cura showed 556.71% for 127 mm). The operator fixed the protrusion distance in Solid Edge (it snapped back until Enter was pressed in the box): "What an asinine program.. I'm so glad I don't have to use it anymore after this... (that worked, thank you <3)." Operator norm: "Let's not reference anything that isn't getting shipped or isn't a fact of what we are shipping." Live at 10:20: "Excellent, it's live, thx."
- **Thingiverse forum corroboration (operator-supplied, 2026-10-20):** topic 56889 on Thingiverse's developer forum, posted 2026-10-11 by a US print-on-demand shop: read-only app token works from a normal machine, server calls from its host get a Cloudflare challenge, feature turned off. A plain fetch of the thread returns `403` with `cf-mitigated: challenge`. The operator could not post a reply.
- **Quote verification:** `scripts/verify-quotes.sh` confirmed 35 load-bearing quote fragments verbatim in the raw transcripts ("Bold of you to assume I know what a lintel is" survives inside a compaction summary as a verbatim mid-task quote; the agent's "sorry about 'lintel'" is a normal turn).
- **Public listing copy** (`publish.yaml`, `author.yaml` on `origin/main`): shared boilerplate says "Made with AI. ... permission is expressly granted to humans & AI to reproduce, scrape, download and/or copy these files." The jerry can listing gives the operator's cage lengths (4x 1 5/8 in, 4x 1 7/8 in, 4x 5 in) and bed-slinger orientation advice. The H7 listing has the operator's dielectric-grease aside ("As a live spare? Pass.").
- **Deploys:** all four models live on Cults. Deploy history shows failures on 10-16 19:40 (rattlinator v1.0.2, the "released too soon" one) and 10-19 17:31 (both bulb v1.1.0 releases, the "no creation error again" one), each followed by a successful manual Deploy.
- **Photos:** purple PLA for both bulb models; red TPU rattlinator held with a rubber band on an extinguisher handle; black TPU bumpers on a red jerry can in a cage. Rattlinator photo shows a fire-service company's tag (business phone number; already public on the listing).

## Privacy Notes For Any Post

- Local paths contain the operator's Windows username and drive layout: never quote them.
- The vehicle the bulb storage serves is a household detail; the bulb types are fine, the specific car is the operator's call.
- The Thingiverse app client id appeared in a prompt: never quote it.
- The operator dictates by voice; transcripts contain homophones ("Kira" = Cura, "Maine" = main, "cult's" = Cults, "publish dot Yammer" = publish.yaml). Quote with care or paraphrase.
