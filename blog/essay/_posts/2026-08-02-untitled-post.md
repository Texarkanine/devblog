---
layout: post
title: "You Can't Backfill Yesterday"
subtitle: ""
description: "Agent memory is institutional memory: five kinds will wait for you, and one has a start date. An audit of what backfills, what doesn't, and why the difference is a fold."
author: "texarkanine"
tags:
  - agentic-engineering
  - ai
  - memory
---

Show up for your first day at any functioning organization and the same five things happen, in roughly the same order.

1. You arrive remembering what you do here and what you were doing yesterday.
2. Someone hands you the binder: here's how we do things around here.
3. You get a ticket: here's your task, here are its files.
4. When you finish, it gets filed, so that when someone later asks "what did we do for the X widget?", the answer doesn't depend on who's still employed.
5. And when something looks wrong - "wait, how did it get like *this*?" - there's a record for when it changed and footage for how and why.

That ladder is the entire memory apparatus of an institution: personal recall, the operations binder, the ticket queue, the archive, the audit trail. Before I name a single tool, place your own agent setup on it. Which rungs do your agents have? Which are missing? The missing ones matter unequally: exactly one of them cannot wait.

## Six Stores, Five Rungs

Here's my stack, rung for rung. [OptMem](https://github.com/VictorTaelin/OptMem) is rung 1: while working, the agent records what it judges worth remembering, and at the start of every session its recent memories are pushed into context - what I do here, what I was doing yesterday. The persistent files of [Niko's](https://github.com/Texarkanine/.cursor-rules/tree/main/rulesets/niko) memory bank are rung 2, the binder: product context, system patterns, tech stack. The active memory bank is rung 3, the ticket: current task, plan, progress. The memory bank archive is rung 4: one completion record per task, finer-grained than an ADR. Rung 5 splits in two: git history answers *when*, and [Stockroom](https://github.com/Texarkanine/stockroom) - security-camera footage of every agent conversation across every [harness](/garden/ai-horses.html), queryable by SQL and semantic search - answers *how* and *why*.

(If you know your cognitive science: yes, [procedural](https://en.wikipedia.org/wiki/Procedural_memory) maps to the binder, [semantic](https://en.wikipedia.org/wiki/Semantic_memory) to the archive, [episodic](https://en.wikipedia.org/wiki/Episodic_memory) to the footage, and working memory to the context window. I assembled this stack empirically and noticed the isomorphism afterward.)

Exactly one store is pushed. OptMem's memories arrive unbidden at session start, under a hard cap. Everything else is pulled - the active ticket by a nudge, the archive, the git history, and the footage only when the agent goes digging. That ratio is a staffing decision, not an implementation detail: push more than one rung and you've reinvented context stuffing with extra steps.

## The Notepad Isn't on the Org Chart

The ambient advice for "give your agent memory" is a markdown file the model appends to. `memory.md`, `MEMORY.md`, a notes section at the bottom of `AGENTS.md` - the shape is the same: a shared, unordered notepad. Where does it sit on the ladder? Nowhere. Every rung has a write rule (what gets recorded, by whom, when), a read trigger (what causes an entry to resurface), and a retention policy (what ages out, compresses, or gets promoted). The notepad has none of the three. Anything may be appended at any time, nothing determines when an entry is seen again, and nothing ever leaves. Someone will tell me their memory.md is very tidy; tidiness doesn't supply a write rule.

The generous reading is that the notepad persists the context window. But the context window is scratch paper. You scribble on it while solving the problem; then you solve the problem, record the solution somewhere governed - the ticket, a commit, the archive - and throw the scribbles away. They should not be preserved. If anyone later needs to know how you arrived at the solution, the napkin won't tell them; the footage over your shoulder will, and that's rung 5's job. A memory.md is a photograph of the napkin, filed under "memory." No functioning organization runs on one.

## The Rung Nobody Built

Institutions did not arrive at the ladder by theorizing. They arrived at it by failing, and the binder rung has the best-documented failure of all.

During the Second World War, bombs were going off inside British munitions factories.[^1] The government's remedy was the binder, enforced: to be a supplier you wrote down your procedures, your workers were inspected against what you wrote, and a state inspector audited the whole method. The bombs stopped going off in the factories. That seed grew through military procurement standards - the US MIL-Q-9858 in 1959, the UK's Def Stan 05-21 - into the British Standard BS 5750 in 1979, which in 1987 became the [ISO 9000 series](https://en.wikipedia.org/wiki/ISO_9000_family). Its flagship, ISO 9001, now counts over one million certified organizations across essentially every industry on Earth. "Here's how we do things here" got standardized planet-wide because the failure mode that preceded it left craters.

The other rungs have similar origin stories: ticketing, record-keeping, and audit trails all got formalized after failures made them non-optional. But notice what's missing. No institution ever built rung 1. There is no ISO standard for "remember what you were doing yesterday." Nobody wrote one, nobody productized it, no vendor category exists - because every hire arrives with it pre-installed. Humans come with yesterday's salience for free. The one memory that never needed institutionalizing got a name anyway: we call it experience, and we price it in salary bands.

The four rungs institutions built are also exactly the four you can construct from records - which is what made them institutionalizable in the first place. A binder can be written from what practitioners already know. An archive can be assembled from what the tickets say. An audit trail accretes from artifacts that exist anyway. Whatever required a live judgment in the moment could never be turned into a document control standard, so it stayed in people's heads.

Machine agents show up with rung 1 empty. The one rung with no institutional precedent to copy is the one your agents are missing - and it's also the only one you cannot start late.

## Adopt It Six Months Late

The test: for each rung, suppose you become a believer six months from now instead of today. What have you permanently lost?

| Store | Loss if adopted six months late |
|---|---|
| git history | Zero. It has been recording whether or not you believed in it. |
| The binder | Zero. Arguably better written later, with more system to describe. |
| The ticket | Zero. Point an agent at whatever tracking you already have, whenever. |
| The archive | Near zero. The facts survive in tickets and commits; some texture fades. |
| The footage | Real, but mechanical. See below. |
| Rung 1 | Total. See below. |

Four zeros. Most of agent memory is safe to procrastinate on, and anyone who tells you otherwise is selling something.

A recorder you weren't running can't be re-run, so the footage loss is real - but it's mechanical, and mechanical loss is the fixable kind, because the raw material usually still exists. Your harnesses have been writing conversation logs to disk all along; that's why Stockroom, on the day I built it, backfilled my entire agent history from those files, including formats the harnesses had already abandoned. In [Just Try the Thing]({% post_url blog/essay/2026-08-01-just-try-the-thing %}) I described that as the tool paying *backwards*. Come around to footage in six months and you'll backfill in an afternoon and be nearly whole.

Rung 1's loss is total, and "you'll have zero memories on day one" understates it: no process, at any budget, can manufacture what would have been there.

## Salience Is a Fold, Not a Map

Run the thought experiment that seems to defeat me. Suppose you have perfect transcripts - footage of every session for the past six months. Suppose the exact model that ran those sessions is still being served, so the judge is the same. Suppose token cost is no object. Replay the whole six months through the API, and at each juncture ask the model: what here is worth remembering? Write its answers into your store, timestamped into the past. You now hold six months of memories.

Do you?

The five backfillable stores are [maps](https://en.wikipedia.org/wiki/Map_%28higher-order_function%29) over history: each record is a function of the events it describes, so you can compute any record, in any order, at any distance from the events. That's the mathematical reason the audit table has four zeros in it, and it's the property the replay is betting on.

Rung 1 is a [fold](https://en.wikipedia.org/wiki/Fold_%28higher-order_function%29). Each salience judgment took two inputs: the moment being judged, and the accumulator - every memory recorded so far, pushed into the very context doing the judging. The agent that evaluated week ten had been shaped, at the start of every session, by what it wrote in weeks one through nine. So run the replay and watch it invalidate itself: the first memory it writes changes the context in which the second judgment should have been made, and the transcript you're replaying was recorded in a world where that memory didn't exist. Rewrite commit three and every SHA downstream changes. There is no fixed set of memories waiting to be recovered, because the memories, had they existed, would have changed everything downstream of them - including which memories came next. The replay doesn't reconstruct your history. It manufactures a history that never happened.

And even granting the manufactured set, it's missing the thing that made the originals memories: none of it ever influenced anything. A real rung-1 memory earned its place by steering the decisions that came after it. The replayed entries are receipts for judgments that never occurred - downstream of nothing, upstream of nothing.

So the artifact was never the memory. The judgment was - the live, in-context act of deciding *this matters*, in time for it to matter. The store is a receipt. Rungs 2 through 5 backfill because their contents are records of events, and events leave evidence. Rung 1 doesn't, because its contents are records of judgments, and the judgment is the perishable part.

## The Shape, Not the Tool

I use OptMem for rung 1. You don't need OptMem. You need something in its shape:

1. An agent judges salience [in medias res](https://en.wikipedia.org/wiki/In_medias_res) - during the work, while the judgment can still steer it.
2. Judgments are written to a temporally-aware store.
3. Recent entries get priority.
4. Older entries get compressed.
5. What's pushed into context is hard-capped.
6. Older memories can be resurfaced - progressively disclosed - when judged relevant.

Nothing in that list names a vendor, a file format, or a harness; five people could implement it five different ways, which is how you know it describes a class of memory and not a product. It's also the sieve I'd hold up to the firehose of memory tools shipping this year. Anything that satisfies it is a rung-1 candidate; anything that merely persists text is a notepad with a landing page.

## Open Positions

I may have overfit. This ladder is one practitioner's stack, audited by the practitioner. My check is a redaction test: describe each store by its question, its write rule, and its read trigger, with the tool names removed, and see whether the description still picks out something implementable. The six stores above survive it. But the test can't tell me about rungs I never built.

One gap is visible already: nothing in my stack recalls associatively. The archive, the git history, the footage - all of it gets read when someone already knows to look. Human recall is involuntary; you don't decide to remember the X widget, the X widget surfaces on its own when something rhymes with it. My agents' recall is deliberate all the way down. That's an open position on the org chart, and I haven't interviewed a credible candidate yet.

## The Only Rung with a Start Date

Everything else on the ladder will wait for you. Write the binder when you're ready; it improves with age. Point an agent at your tickets whenever. Turn the footage on late and backfill from the logs your tools were keeping anyway. Four zeros and one afternoon of catch-up: that's the honest cost of procrastinating on five-sixths of agent memory.

Rung 1's clock only runs forward. Adopt it in six months and you'll hold zero memories on day one, six months of judgments behind - and those judgments weren't recorded and lost; they never happened at all.

So find something rung-1-shaped and [just try the thing]({% post_url blog/essay/2026-08-01-just-try-the-thing %}). Starting the clock costs pennies and minutes. Nothing you can pay later will start it retroactively.

[^1]: Seddon, John. "A Brief History of ISO 9000." In *The Case Against ISO 9000*. Oak Tree Press, 2000. <https://beyondcommandandcontrol.com/wp-content/uploads/2015/09/a-brief-history-of-iso-9000.pdf>
