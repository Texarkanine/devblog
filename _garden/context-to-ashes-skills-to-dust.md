---
layout: garden
title: "Context to Ashes, Skills to Dust"
subtitle: "All your AI agent wrangling tips will be obviated ere long"
tags:
  - ai
  - claude-code
  - cursor
  - niko
  - llm-context-management
  - thoughts
---

This is the fourth in what has become an unplanned series.

[The Last Programming Language](the-last-programming-language.html) argued that the entire history of programming languages was a project to close the gap between human intent and machine execution, and that LLMs are the endpoint because they execute natural language directly. [Stop Doing AGENTS.md]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %}) and [It's Model Context Protocol, Not Agent Context Protocol]({% post_url blog/essay/2026-02-23-model-context-protocol-not-agent-context-protocol %}) argued, from different angles, that most agent customization is wasted context - duplicated, task-specific, or self-evident to the model.

I think the same logic applies one level up: to the *workflows and orchestration* we wrap around the agents themselves.

The distance between "how humans already know work should be done" and "how AI agents do work" is collapsing, for the same reason the programming language gap collapsed - the knowledge was always trivially expressible. We just hadn't told the machine yet.

## The Cathedral

I stopped writing code about a year ago. In its place, I built an elaborate orchestration system - [Niko](https://github.com/Texarkanine/.cursor-rules/tree/main/rulesets/niko) - that turned AI coding agents into something resembling a senior colleague with a rigorous process. Phase-gated workflows with complexity tiers. Memory banks split into persistent and ephemeral files. Preflight validation. QA loops. TDD enforcement. An archive system for long-term institutional memory. Mermaid diagrams as a conceit to my human desire to understand the process. A whole cathedral.

And it *worked*. Measurably, demonstrably better than vanilla agentic coding harnesses. The original introduction of [Niko's core](https://github.com/Texarkanine/.cursor-rules/blob/main/rules/niko-core.mdc) turned GPT-4o into Sonnet 3.5, back in January 2025. Niko's lineage traces back through [vanzan01's Cursor memory bank adaptation](https://github.com/vanzan01/cursor-memory-bank) to the original [Cline Memory Bank](https://docs.cline.bot/features/memory-bank), community-created on the Cline Discord around early 2025. The genealogy matters because it shows that a *lot* of people, independently, arrived at the same conclusion: agents need structure, memory, and process to do good work.

We were all correct. And now we can all stop.

## The Subsumption

The tools have started eating the dressings we lay on top of them. From [Cline](https://docs.cline.bot/home) to [Claude Code](https://code.claude.com/docs/en/overview) and [Cursor](https://cursor.com/docs), major harnesses and models are absorbing these behaviors; the gap between "community workaround" and "native feature" is compressing over time.

### Planning

Niko's phased plan-then-execute workflow forced the agent to research, plan, get the plan validated, and only *then* build. This was the single highest-leverage intervention - the difference between an agent that wanders and one that ships. This came from my original learning that "you should make a plan before you start coding," which I taught to my agents.

* October 2025: Cursor shipped [Plan Mode](https://cursor.com/blog/plan-mode), with improvements in [2.1 (November)](https://forum.cursor.com/t/cursor-2-1-plan-mode-browser-improvements-ai-code-reviews-and-more/143675) and [2.2 (December)](https://cursor.com/changelog/2-2) 
* January 2026: Claude Code shipped the [/plan](https://code.claude.com/docs/en/overview) slash command, granting easy access to "Plan Mode" which had been around since at least August 2025 in [1.0.77](https://claudefa.st/blog/guide/changelog#v1077)

Crucially, both tools now also detect when you're *trying* to plan - describe a complex task and they'll enter plan mode unprompted. You don't have to *ask* for the process, you just have to end up in it.

Niko's planning is still slightly better.

The base is good enough.

### Context Initialization

Niko's memory bank initialization creates a structured set of files - product context, system patterns, tech context a variation of the Cline memory bank set, refined through my own personal industry experience - giving the agent a persistent understanding of the project across sessions.

Claude Code's `/init` has been present since launch in February 2025, scaffolding a `CLAUDE.md` file by scanning the codebase. 

But Cursor's approach here is actually more interesting and arguably *better* than the manual pattern: it [computes embeddings for every file in your codebase](https://cursor.com/docs/context/codebase-indexing) and provides those alongside a brief tree/text summary of the project structure. This is *indirect* context - you embed the code so the model kinda-sorta knows it, without burning context window on a monolithic description. It's the [Stop Doing AGENTS.md]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %}) thesis made manifest by tooling: instead of a giant global prompt telling the model about your code, the model just *implicitly knows* because the code is embedded. And the brief structural summary gives just enough for the model to know where it might want to look - rather than the monolithic `AGENTS.md` antipattern.

Multi-file repo context documents are being actively developed; I see murmurs of it in my "Stop Doing AGENTS.md" spaces. `/init` will probably do this better soon. And how long before the tools add "after I realize I built a plan, go update the docs that `/init` touches?"

Niko's "memory bank" files are still slightly better than `/init`'s, and Cursor's embeddings are arguably better for a different reason.

The base is good enough.

### The Ralph Wiggum Technique

In July 2025, [Geoffrey Huntley documented](https://ghuntley.com/ralph/) what he called the Ralph Wiggum technique: put an AI coding agent in a bash `while` loop:

```shell
`while :; do cat PROMPT.md | claude-code ; done`
```

and let it autonomously ship. Each time through the loop, the context is fresh but the codebase has accreted changes, and the agent keeps making progress towards the goal in the prompt. Doesn't matter if it doesn't get it on the first try, after 50 tries overnight, it will! Cheerfully. Relentlessly. Deterministic correctness from a nondeterministically fallible machine. The name comes from [Ralph](https://en.wikipedia.org/wiki/Ralph_Wiggum)'s energy - not his incompetence, but his unwavering, guileless commitment to the task at hand.

People put agents in Ralph loops and they [shipped entire projects overnight](https://github.com/repomirrorhq/repomirror/blob/main/repomirror.md). Claude Code shipped [`/loop`](https://github.com/anthropics/claude-code/releases) in early 2026, a first-class command to run a prompt or slash command on a recurring interval. The technique became a feature.

We'll come back to Ralph.

### Parallelization

You used to handcraft hordes of subagents, or a least explicitly kick them off, to get decent parallelization on tasks - wiring up the topology yourself like a computational middle manager. 

* May 2025: Cursor shipped [Background Agents](https://cursor.com/changelog/0-50) in preview, scaling to eight parallel agents in Cursor 2.0 (October), with [multi-agent judging](https://cursor.com/changelog/2-2) in 2.2 (December) that evaluates parallel runs and recommends the best solution.
* July 2025: Claude Code shipped custom subagents in [v1.0.60](https://claudefa.st/blog/guide/changelog#v1060), background agents in [v2.0.60](https://claudefa.st/blog/guide/changelog#v2060) (December), and an [Agent Teams research preview](https://claudefa.st/blog/guide/changelog) in February 2026.

By March 2026, both harnesses detect when work is parallelizable and spin off subagents autonomously with appropriate context. You don't wire the topology; you write a good spec and the tool figures out the rest.

The base is good enough.

---- CUT HERE ----

### Ephemeral Context and Compaction

Models have a limited amount of text they can hold "in mind" at once - the context window. When it gets full, [performance can degrade]() and when you add more content than the window can hold, you just lose the older stuff; it drops out the back of the window.

Transparently dropping older parts of a conversation is not a good user experience!

Cursor was one of the first major harnesses to tackle the context window *filling* problem by *automatically compacting* conversations that reached the end of the current model's context window. When the end of the window got close, it would run the current conversation history through a summarizer, produce a summary document, and start a new context window with the summary document injected as context.

This allowed the end-user to continue a conversation indefinitely with no visible interruption! This is certainly better than being forced to end a conversation when the window fills, but compaction is still a lossy process. With a good-enough compactor, maybe you don't lose anything *important*. But that's the trick - you've got to have a good-enough selection process for what makes it into the summary for the next window, and what gets discarded.

In [January 2026](https://cursor.com/blog/dynamic-context-discovery#2-referencing-chat-history-during-summarization), Cursor notes the addition of a technique I'd been doing manually: Saving the original conversation transcript to disk before compacting, and then referencing the full transcript in the next conversation alongside the summary.

Niko operationalizes and obviates this conversation history management by making "recording the important things to disk" part of the workflow so that at any point you can throw the current context window away without losing anything important. Niko's [ephemeral memory-bank files](https://github.com/Texarkanine/.cursor-rules/blob/main/rulesets/niko/README.md#ephemeral-files) track the current task: a project brief, active context, progress, task lists, reflections, creative decisions. When Niko finishes a phase and it's time for the human to make a decision, you manually open a new context window and run the next `/niko-*` command. Niko reads the memory bank from disk and pick up where it left off - clean context, full awareness. If you abort mid-phase, Niko's rigorous record-keeping enables your agent to diff the code on-disk against the last memory bank entry to deduce what was lost and resume work from the right place.

What this buys you is context windows as [cattle, not pets](https://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/), and your "Agent" is the state saved to disk (and source control) - something durable and portable.

This technique largely sidesteps the problem of running out a model's context window and the associated risks of having it very full.

Claude Code introduced auto-compaction in [v0.2.47](https://claudefa.st/blog/guide/changelog#v0247) in March 2025, which works [similarly](https://claudefa.st/blog/guide/mechanics/context-buffer-management) to Cursor.

Niko's technique is still superior - first-class support for "Agents as Cattle" and "memory is on-disk by default." The 

### Validation Loops

Niko's preflight and QA phases are genuine validation gates: the plan must pass preflight before building starts, and the build must pass QA before the task is considered done. These are not yet natively absorbed. TDD forcing - making the agent write tests first and use them as back-pressure - is also still a value-add, which is frankly surprising given [how impactful TDD is](https://ghuntley.com/ralph/) at producing good outcomes in agentic workflows.

But if your spec has good acceptance criteria, you're most of the way there. The final validation loop is the last frontier of orchestration that hasn't been eaten.

### Archival Memory

Niko archives summaries of past work into the memory bank - a layer of long-term institutional memory that doesn't come off-the-shelf. But this is partly because archival is opinionated: maybe you'd "archive" in Jira tickets, or GitHub issues, or commits, or a changelog, or some other service. Eventually there will be something native that handles it. Claude.ai can already read past conversations for context. Claude Code [automatically records and recalls memories](https://claudefa.st/blog/guide/changelog) as it works. Cursor has [Memories](https://blog.promptlayer.com/cursor-changelog-whats-coming-next-in-2026/) that persist facts across sessions. This one's on the roadmap in a way that everything above was once on the roadmap.

### The Scorecard

Niko does everything listed above, and does each one slightly better than the native version. But for anyone starting today, the built-in tools are past good enough. The delta is real but the delta is shrinking, and the floor keeps rising. You would not tell a newcomer to install Niko. You'd tell them to type their task into Claude Code and let it work.

---

## The Napkin

The reason all of these behaviors get absorbed so easily is that the underlying knowledge fits on a napkin.

"Plan before executing." "Test before shipping." "Remember what you learned." "Break big work into small work." "Validate before declaring done." "Archive what you did for next time."

These aren't arcane insights. They're things every human business and workflow has understood for decades to centuries to millennia. The entire Niko ruleset - the mermaid diagrams, the phase gates, the memory bank, the complexity tiers - is an elaborate encoding of wisdom that, stripped of implementation details, is under a hundred words of natural language.

The only reason this wisdom wasn't already in the tools is that the tools weren't smart enough to act on plain-language instructions. Now they are. A single engineer can encode "plan before executing" into a system prompt or fine-tuning signal and it just works. Three words. When you omit them, you get what you asked for, which is execution without planning. Remembering to say them was the middle step - the era where a cottage industry of AI optimization tips emerged to teach people what amounts to basic project management. Embedding three words into a model's harness or system prompt is close to trivial for where the tool makers are now.

There are probably under a hundred words needed to fully specify the correct autonomous development behavior with superhuman reliability, and the LLMs themselves are helping sift all of humanity's messy corporate process wisdom into those hundred words. This will not take long. And with a little support from the harness, you're done - and moreover, the [models are building their own harnesses now](https://x.com/bcherny/status/2030109840555790357). Force-multiplication. Positive feedback loops. Each generation of model is better at specifying the behavior that makes the *next* generation's harness more effective.

Evidence: [Boris Cherny](https://x.com/bcherny/status/2007179832300581177), head of Claude Code, uses vanilla Claude Code. No elaborate skills, no MCP orchestra, no Niko-like system. The person closest to the tool doesn't need the scaffolding because the tool already internalizes the important stuff.

The practical upshot, stated directly: unless you're on the bleeding edge and could write [an essay]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %}) on *why* a given behavior exists and how to do it better, off-the-shelf is beyond good enough and trying to optimize it yourself is time you could spend building the thing instead.

---

## The Inversion

We chuckled when we named the [Ralph Wiggum technique](https://ghuntley.com/ralph/). We put agents in bash loops and they shipped projects overnight. We tuned them like guitars, erected signs at the top of slides, and watched them cheerfully, relentlessly build. We felt clever. We *were* clever.

Now look at us.

Poking and prodding at the agentic process. Fiddling with orchestration. Tuning prompts. Adding yet another rule to `AGENTS.md`. Reading blog posts about the optimal number of subagents. Installing one more MCP server, just in case.

*"I'm helping!"*

We're in our own loop - optimizing a process that's optimizing itself faster than we can keep up. The difference is that Ralph actually shipped. The human in the optimization loop is increasingly just adding latency.

The good news is that unlike Ralph, we can recognize the loop and step out of it. The practical takeaway is simple: specify well - good requirements, good acceptance criteria, which will proc plan mode and subagents on their own - auth your pathways, and get out of the way.

---

## The Key

What's actually left?

Auth. It's the one place where the human's role isn't "know something the model doesn't" - that's a knowledge problem, and knowledge problems dissolve once you can express the answer in natural language to a sufficiently capable model. Auth is a trust problem. You `gh auth login` so the agent can push. You `aws sso login` so it can deploy. You grant the filesystem access, the API keys, the OAuth flows. You pave the desire paths the agents will follow. [MCP](https://modelcontextprotocol.io/) - it's MCP, [not ACP]({% post_url blog/essay/2026-02-23-model-context-protocol-not-agent-context-protocol %}) - handles auth separation well when it applies, but the core act is still yours: being the human who says "yes, you may."

But this too is eroding. Organizations already delegate trust to automated systems constantly. CI/CD pipelines hold credentials. Service accounts have scoped permissions. Kubernetes operators rotate secrets without asking anyone. The trend line points toward the auth boundary dissolving from the edges inward, as organizations get comfortable granting progressively broader trust to automated actors.

In 1965, Gordon Dickson wrote a short story called *[Computers Don't Argue](https://en.wikipedia.org/wiki/Computers_Don%27t_Argue)* in which a man receives a book club shipment he didn't order. He tries to return it. The automated correspondence systems escalate the dispute through increasingly severe bureaucratic channels - billing, collections, legal, criminal - because no human ever intervenes to apply judgment. Every system in the chain has the *authority* to escalate but not the *judgment* to stop. The trust chain between systems is treated as sufficient without a human checkpoint. The man is convicted and sentenced to hang over a book order. DRY violation as Kafkaesque horror: his innocence was the canonical truth, but no system was configured to reference it.

The orchestration skills are dust. The context management skills are ashes. What remains, after everything else has been automated away, is the architecturally unglamorous, existentially critical work of ensuring that somewhere in every automated trust chain, there's a circuit breaker that a human can reach.

When the machines have all the keys, someone had better be able to break the loop.
