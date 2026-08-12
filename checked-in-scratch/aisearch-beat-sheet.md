# [aisearch] Beat sheet — rewrite (2026-08-11)

First draft (`blog/essay/_posts/2026-08-10-untitled-post.md`) discarded. Operator hand-writing; agent helps with beats then a draft. Thesis still mostly held for Act III.

**Shared machinery (known to us, revealed gradually to readers):** every such platform is a hub with three loops.

1. **Consumers (leeches):** give attention; get the thing (articles, answers, working code).
2. **Converter (platform secret sauce):** turns plentiful consumer-side input into platform sustenance + what producers want; skims a cut. Conversion mechanics vary (ads, subs, hosting quotas, brand attention); principle does not.
3. **Producers:** give content / presence that attracts consumers; get fame and/or fortune (reputation, karma, money, doors opening). Fame ↔ fortune are convertible; exchange rates vary by situation — not asserted as bad or 1:1.

Also load-bearing (forgot on first pass, keep on charts): **producers can feed producers** — social dues, community, "you're not alone," subreddit culture, sticking around. That is part of what some flywheels pay and require.

Growth on either side, or better converter efficacy, feeds the other branches.

---

## Act I — Lay out the reactions

Introduce what each platform is *doing* in response to AI. Optionally ask: is this Pink Margarine — futile, misguided purity theater? Don't answer yet. Readers do not yet know these are the same machine in different denominations.

Order / shapes to establish (without naming the shared diagram yet):

| Specimen | Shape |
|---|---|
| **New York Times** | Salaried publisher / distribution-rent defense (important shape) |
| **Reddit + Stack Overflow** | Volunteer Q&A / reputation + attention flywheel (one shape; mention searching both / across subs) |
| **Rust** | Single OSS project (important shape) |
| **Codeberg** | Forge / project host — level above a single project (important shape; rhymes with Reddit/SO but in code-hosting terms) |

Stay at the level of observed policy/posture. Do not yet deliver "Codeberg has the only plan that could work."

---

## Act II — The flywheels, then AI's rewrite

### II-A. Healthy charts (in order)

1. **NYT** — consumers give attention (+ pay) → articles; converter turns that into money; skims; pays writers; writers supply articles that draw consumers.
2. **Reddit / SO** — same topology without (or with less) dollar pay to producers: attention → info; converter → ads/etc. for platform + reputation/karma for producers; producers supply human perspectives/answers. Mention both because pre-AI you often had to search both (and multiple subs).
3. **Rust** — consumers (people building software) give attention/care → language that works; much smaller contributor set gets paid in reputation (curl guy, conference comps, open doors) and community; project’s job is to make the converter work (attention → reputation; contributions → working code that draws eyeballs); project skims brand attention.
4. **Codeberg** — step up: OSS host analogous to GitHub/GitLab. Consumers want working projects → attention for code; projects inhabit the forge for storage, CI, issues, hosting, etc.; they pay with presence that attracts more consumers; Codeberg’s job is fair conversion so hosted projects get reputation/eyeballs and the platform sustains. **Rhymes with Reddit/SO**, now in the code domain where the rest of the argument wants to live.

### II-B. AI-broken charts (same order)

1. **NYT — consumer-side middleman.** Direct consumer↔Times loop gains an AI aggregator middleman (ChatGPT / AI search). Embeddings in a latent space outperform traditional search indices — especially with *all* sources, not one site. Same reason people used Google instead of a 12-site bookmark folder: the aggregator had read everything; embeddings make the aggregator faster and more personalized than NYT (or old search) could offer directly. Cable → Netflix: content aggregated, people saw better UX, they consume there. Chart: pull consumer block off (right); insert AI middleman; attention/content loop now closes on AI; Times gets hit by one consumer (the AI) that sends nothing back → **leak / drain → flywheel spins down.**

2. **Reddit / SO — same consumer-side shape, without dollars.** Ask AI that has read all of them (and every sub). Consumer loops against AI middleman; eyeballs/attention don't return to sustain the platform → flywheel spins down.

3. **Rust — producer-side change (not better-UX aggregation).** AI shows up as a *producer*: code that works, but no community contribution — no time spent, no human wanting to socialize, no human others want to socialize with. Working code still feeds consumers; **community does not get paid into.** Linus: "it's just a tool" / working code is enough — large projects may survive that bet. Solo/small maintainer: a contribution used to signal "someone else understands / cares / you're not alone"; AI can open 1 or 100 PRs with no intent to return. Reputation pay came from community (know the curl guy; humans who opened 100 PRs open hiring doors; AI doesn't meet, learn, or hire that way — for now computers aren't making those management decisions). **AI contributors don't pay social dues**, and they contribute at scale far above dues-paying humans → community spins down → contribution spins down → less attractive to consumers → flywheel spins down. Rust manifesto/policy spells the community/contributor-formation problem explicitly.

4. **Codeberg — Rust problem pulled up a level.** Ghost factories (their term — confirm against manifesto): projects attach with no community (one person + AI). No community for contributors to pay into or be attracted by; that project's flywheel isn't running, so it throws off no prestige / widely-used gravity for Codeberg — but it **consumes resources**. Same as individual level: these appear faster than dues-paying traditional projects that consume but pay back in kind the platform can use. (Still *not* yet the "only plan that could work" uppercut — that lands in Act III.)

---

## Act III — Judge each response against its flywheel

Same specimen order. Test: does the proposed fix close the loop AI broke, or only feed the platform short-term / draw a circle that leaves a needed side outside?

### NYT — cut the AI aggregator *(current posture = miss)*; reframed customer = conditional hit

- **Current posture (block / sue / restrict):** Draw a circle around the old flywheel. Failure: consumers already live *outside* that circle on the preferred UX. Latent-space aggregation is a discovered preference; NYT cannot reverse it by restricting supply. LinkedIn "using the internet illegally" / piracy-as-service-problem rhyme. Cable←Netflix: once tasted, no voluntary return. **Verdict on current play: miss.** Circle drawn after the consumers left.
- **Operator answer (2026-08-12) — reframe the direct customer as the AI aggregator:**
  - Why Reddit's Google deal fails and NYT's *could* work: Reddit producers are paid in reputation/attention; platform $ does not convert into that food. NYT producers are **staffed writers paid in money** — editing, fact-check, voice, investigative dispatch into meatspace. AI $ can feed that loop.
  - What labs actually want (receipt: buying/destroying rare books to scan — fact-check primary): verified-human text, published-book quality bar, not already in training data / not freely online, and preferably **exclusive vs competitors**. DMCA framing is the news wrapper; exclusivity + provenance is the demand.
  - Product reframe: readers still want NYT **reputation/authority**; information-access UX now lives on AI. Sell the authority coat-tails + the production pipeline to labs as the primary customer.
  - Mechanisms: premium AI subscriptions; exclusivity windows (week / month / six months before public); exclusive commissions (AI-only corpus that never, or late, hits nytimes.com) — patronage / artistic-commission model, millennia-old, works.
  - Click-through becomes irrelevant: lab already paid many zeros more than an $11 subscriber; public eventually sees the piece; AI cites NYT authority without needing the visit.
  - **Verdict if executed: mechanical hit for legacy media only** — closes the producer loop because the currency matches. Market/execution risk remains (will they reframe? will labs pay exclusivity premiums? does authority dilute when licensed widely?).
  - **Social / editorial split (why telemetry loss is fine for them, fatal for Reddit/SO):** Legacy media always published what *they* chose — editorializing, selecting, "all the news that's fit to print." Public demand telemetry was never direct input to the machine. The product is a curated surprise (subscribe to a magazine; you don't know the TOC in advance; that's what you signed up for). Reddit/SO are pull products: you go when you need something particular, not for recreational browsing of the corpus; the whole product *is* the public telemetry of what's hard / what's asked. Patronage $ can replace ad/sub revenue at NYT; it cannot replace the demand signal that *is* Reddit/SO. Second non-transfer condition alongside currency mismatch.
  - Scope limit (load-bearing): **does not generalize**. Needs (1) aggregators want what you produce, (2) producers eat money (not reputation), **and** (3) editorial push model (not social pull / telemetry-as-product). Money is the only converter currency identified so far; editorial selection is the only production steering that survives without public demand signal.

### Reddit / SO — charge the AI (Reddit); shrug (SO?)

- Reddit shape (verify counterparty: inventory has **Google ~$60M/yr**, Anthropic suit; confirm OpenAI if claimed): thick new conversion line — AI's one-consumer read → money. Short-term: platform sustenance improves.
- What it does *not* do: route attention/reputation back through the middleman to **producers**. Production flywheel still spins down → corpus value to AI falls → licensing pay falls → consumer side already drained → **collapse from both sides**.
- Feeds the platform, not the flywheel. Short-term play. **Contrast with NYT answer:** same dollar instrument, wrong producer denomination.
- SO: check actual posture; may be closer to "good run" / soft decline than a clean licensing play — don't overclaim.
- **Verdict: miss** (for the charge-AI shape). Sustains the entity while starving the asset.

> Sustains the entity while starving the asset.

### Rust — filter for community, keep wanting the big consumer market

- Personal stake: author keeps seeing Rust, considers it for next fast build, would leech happily, would fix a bug with a PR if needed — but is not joining the Rust community; would use AI for that contribution. Policy correctly clocks him. Functionally Rust stops evaluating as open source *he can contribute back to* → less likely to choose it → more likely AI-welcoming fork / alternative ("whatever fork it ends up being"). Three years out: AI-side fork actively developed; original at human pace; pick the more developed one you can patch.
- Nose-cutting: shrinks potential contributor pool without increasing consumer-side appeal. Competitive disadvantage vs equivalent projects that don't filter that way. Sales-funnel dynamics worsen; short-term chilled contributors leave now.
- Grace: they admit they don't know, they're trying something, door open to update priors — traditionally hard for humans. Can't be mad for addressing a real problem; worse to do nothing. Tune in a year.
- **Verdict: likely miss** — spins contributor side down; flywheel follows. Experiment deserves a timestamp, not a eulogy.

### Codeberg — shrink both loops together; keep the known shape

- Looks like Rust one level up; differs in kind (see below). Stronger stance: no (mostly-)AI projects — ghost factories out.
- General-purpose forge vs single-purpose language: hot-dog boiler can lose demand entirely if the product is bad; much harder for people to decide they simply don't cook. Broader offering → demand less likely to vanish entirely.
- What they did: proportionally scale down TAM, and **lock platform members into the pre-AI intact flywheel shape**. Bet: among the slice that wants software *without* AI involvement, contributor:consumer ratios still work. Smaller human↔human loops on each side; converter they know how to run; may never flip GitHub — but can sustain. Bet 2: That TAM is actually large enough to still have sufficient critical mass to sustain the platform. 
- Less charitable: head-in-sand. Stronger read: the circle includes everything they need and excludes everything that breaks the converter — **internal consistency**.
- **Verdict: only mechanically coherent bet** so far (market-size risk remains; not a guarantee of growth).

### Rust vs Codeberg — why not the same boat

**Keep this full table until publish** (working memory). In the article, **drill loop mismatch** as the primary distinction; ghost-factory / drive-by filtering is secondary but real.

Personal note for prose: the author's exit from Rust's contributor funnel is **by discovered preference, not by edict** — policy correctly predicts him; he self-filters because he won't join the community / will use AI for a drive-by fix.

| | **Rust** | **Codeberg** |
|---|---|---|
| **Loop matching (PRIMARY)** | Wants **large** consumer adoption of Rust *and* a **filtered** producer community — mismatched loops | Shrinks **both** loops together and matches them inside the circle |
| **Unit of regulation** | How you contribute to *one product* (disclosure, review, mentoring expectations) | Which *projects* may inhabit the *platform* (ghost factories banned) |
| **AI in the thing that matters** | Still allows AI-touched **code** if disclosed / human-reviewed; mostly policing unreviewed code + prose-as-community-signal | No on both sides — human contributor loop and human consumer loop only |
| **Substitutability** | Specific language; AI-friendly forks/alternatives compete head-on for the same consumer job | Forge-class / "somewhere to host & collaborate"; niche can be small and still needed (cooking vs one hot-dog brand) |
| **Act II problem targeted (secondary)** | AI producers skip social dues — response also predicts/chills drive-by humans who would use AI | Ghost projects consume resources without prestige dividend — response removes that unit from the roster |

One-liner candidate: Rust draws a circle around *community membership* while still selling to the whole world; Codeberg draws a circle around a *market segment* and only promises to serve that segment. Charts may make this obvious.

Open risk: Codeberg's Bet 2 (critical mass) — durable preference for "human-crafted" / this roster among enough people. If everyone only wants "what works," the niche empties. Market-size uncertainty, not NYT/Reddit/Rust's mechanical failure.

---

## Cloudflare CID → alternate search (bundled-bot beat extension)

Sept 15'26 defaults (Training/Agent blocked on new-domain ad pages; multi-purpose Search+Training bots inherit most-restrictive → Googlebot dies under Training block). Defaults stick for most sites → a real corner of the web falls out of Google. Cloudflare already sees that corpus at the edge → positioned to index/search it; Akamai/Fastly may scoop too. Result: **Netflix fragmentation again** — competing CDN-shaped catalogs, consumers hate it, demand a meta-aggregator. So the blockade that "protects" content reconstitutes the aggregator problem one layer up. Fits Faustian/bundled-bot beat; supports "only rare currency-matched deals work" — CDN search scoops are distribution theater, not producer food.

## Act IV / coda — narrow hit, no general template (updated 2026-08-12)

Act III must not crown Codeberg *or* crown NYT-as-universal-fix. Twist, then personal urgency:

1. **Reddit / SO** — fail (feeds entity not flywheel; $ in wrong denomination).
2. **NYT current posture** — fail (circle after consumers left). **NYT reframed (AI as premium customer / exclusivity / commissions)** — mechanical hit *for staffed, money-paid producers only*; not a template for the open web or volunteer flywheels.
3. **Rust** — soft **Luddite**: filter the tool, mismatched loops; probably won't work; grace for trying. cloudflare-os CONTRIBUTING is the same shape (writing easy, review hard → close the gate).
4. **Codeberg** — Amish: intact pre-AI shape inside the fence; coherent, not scalable advice for most of us.
5. **Cloudflare defaults / CDN search scoops** — fragmentation replay; not a producer-side fix.
6. **Therefore:** one narrow working shape (legacy media ↔ AI patronage when producers eat money); **no template** for platforms whose producers eat reputation/attention/community, nor for "us" as individuals.
7. **False comfort, then the knife:** "If GitHub goes down I'll use GitLab…" → **No.** This flywheel existed *inside you*. **Yadan: link only.**
8. **Close:** keep moving with the thing so a real choice is possible when pieces fall; soft-link own practice posts; don't pretend the NYT patronage model solves Stack Overflow.

**Anti-patterns for the ending**
- Developing Yadan into a second spine (link-only).
- Treating NYT exclusivity as "so everyone should license to AI" — currency mismatch is the whole point.
- Crowning Codeberg without the Amish deflation.
- Claiming "pay the publishers" was always the answer — telemetry/externalization loss still kills social/pull platforms; NYT patronage sustains *staffed editorial* production that never needed that signal. Social/editorial split is load-bearing, not a footnote.

---

## Deferred / out of scope reminders

- Pink Margarine sequel material (ToU text, open-slopware badges, Colour/Skala spine, purity theater deep dive) stays out unless a light optional nod in Act I. Codeberg's detection/enforcement weakness (style ≠ evidence) → sequel, not a knife in this Act III's back unless one sentence.
- Old draft's Netflix cold-open → tying ladder → Yadan private flywheel → Three Bets gradient is **not** this structure; specimens and receipts may be recycled into the new acts.
- Full Yadan / cognitive commons / junior→senior pipeline / goalpost-moving Turing chat: follow-up or one-breath coda only — not a second spine.
- Fact-check before draft: Reddit licensing counterparty (Google vs OpenAI); SO's actual AI posture; Codeberg "ghost factory" exact phrasing.
