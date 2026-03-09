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

The tools have started eating the techniques we dress them up in. From [Cline](https://docs.cline.bot/home) to [Claude Code](https://code.claude.com/docs/en/overview) and [Cursor](https://cursor.com/docs), major harnesses and models are absorbing these behaviors natively. The gap between "community workaround" and "native feature" is compressing over time

Here are some of the key techniques that we've discovered:

### 🗺️ Planning

> The agent should research and plan before building. The single highest-leverage intervention — the difference between an agent that wanders and one that ships.

Niko's phased plan-then-execute workflow forced the agent through research, planning, and validation before a single line of code got written. This came from my original learning from agentic dev experience & readings that "you should make a plan before you start coding," which I then taught to my agents.

### 📋 Context Initialization

> The agent should understand the project it's working in. Memory bank files, codebase embeddings, and structural summaries all solve this differently.

Niko's memory bank initialization creates a structured set of files — product context, system patterns, tech context — a variation of the [Cline Memory Bank](https://github.com/nickbaumann98/cline_docs/blob/main/prompting/custom%20instructions%20library/cline-memory-bank.md) set, refined through personal industry experience, giving the agent a persistent understanding of the project across sessions. The Cline Memory Bank itself was community-created on the Cline Discord around early 2025 by [nickbaumann98, Krylo, and SniperMunyShotz](https://docs.cline.bot/prompting/cline-memory-bank). The lineage runs through [vanzan01's Cursor adaptation](https://github.com/vanzan01/cursor-memory-bank) into Niko. A *lot* of people, independently, arrived at the same conclusion: agents need structured context to do good work.

Claude Code's `/init` scaffolds a `CLAUDE.md` file by scanning the codebase, too, but only writes to the single file.

Cursor's approach is actually more interesting and arguably *better* than the manual pattern: it [computes embeddings for every file in your codebase](https://cursor.com/docs/context/codebase-indexing) and provides those alongside a brief tree/text summary of the project structure. This is *indirect* context — you embed the code so the model kinda-sorta knows it, without burning context window on a monolithic description. It's the [Stop Doing AGENTS.md]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %}) thesis made manifest by tooling: instead of a giant global prompt telling the model about your code, the model just *implicitly knows* because the code is embedded. The brief structural summary gives just enough for the model to know where it might want to look — rather than the monolithic `AGENTS.md` antipattern.

Multi-file repo context documents are being actively developed; I see murmurs of it in my "Stop Doing AGENTS.md" spaces. `/init` will probably produce something closer to Niko's multi-file structure before long. And how long before the tools add "after I realize I built a plan, go update the docs that `/init` touches?"

### 🔁 The Ralph Wiggum Technique

> Put the agent in a loop, let it try the same prompt over and over until it's good. Fresh context each iteration, accreted codebase underneath, tests as back-pressure. Deterministic correctness from a nondeterministically fallible machine.

In July 2025, [Geoffrey Huntley documented](https://ghuntley.com/ralph/) the technique: put an AI coding agent in a bash `while` loop:

```shell
while :; do cat PROMPT.md | claude-code ; done
```

... and let it autonomously ship. Each time through the loop, the context is fresh but the codebase has accreted changes, and the agent keeps making progress toward the goal in the prompt. Doesn't matter if it doesn't get it on the first try; after 50 tries overnight, it will. The name comes from [Ralph](https://en.wikipedia.org/wiki/Ralph_Wiggum)'s energy — not his incompetence, but his unwavering, guileless commitment to the task at hand.

People put agents in Ralph loops and they [shipped entire projects overnight](https://github.com/repomirrorhq/repomirror/blob/main/repomirror.md).

Turns out you don't actually have to type the prompt out each time; you can just feed the *same* prompt in over and over again!

### 📜 Ephemeral Context and Compaction

> Models forget. The context window fills, and older content falls away. Work is often not complete before the model can't ingest any new information. You must find a way to persist what matters.

Cursor was one of the first major harnesses to tackle this by automatically compacting conversations that approached the limit: run the history through a summarizer, produce a summary document, start a new context window with the summary injected. More recently, Cursor [noted the addition](https://cursor.com/blog/dynamic-context-discovery#2-referencing-chat-history-during-summarization) of a technique people had been doing manually: saving the original conversation transcript to disk before compacting, then referencing the full transcript in the next conversation alongside the summary.

Niko operationalizes and *obviates* this by making "recording the important things to disk" part of the workflow from the start. Niko's [ephemeral memory-bank files](https://github.com/Texarkanine/.cursor-rules/blob/main/rulesets/niko/README.md#ephemeral-files) track the current task: a project brief, active context, progress, task lists, reflections, creative decisions. When Niko finishes a phase and it's time for the human to make a decision, you open a new context window and run the next `/niko-*` command. Niko reads the memory bank from disk and picks up where it left off — clean context, full awareness. If you abort mid-phase, Niko's record-keeping enables the agent to diff the code on-disk against the last memory bank entry to deduce what was lost and resume from the right place.

What this buys you is context windows as [cattle, not pets](https://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/), and your "Agent" is the state saved to disk and source control — something durable and portable. This technique largely sidesteps the problem of running out the context window and the associated risks of having it very full.

### ✅ Validation Loops

> Verify the work. The plan must be *good* before building starts; what is built must be *correct* before the task can be considered complete.

Niko's preflight and QA phases are genuine validation gates. These are not yet natively absorbed. TDD forcing — making the agent write tests first and use them as back-pressure — is also still a value-add, which is frankly surprising given [how impactful TDD is](TODO) at producing good outcomes in agentic workflows.

### 🧠 Archival Memory

> Remember what you learned, not just what you're doing. Long-term institutional memory that survives beyond the current task lets you improve over time.

Niko archives summaries of past work into the memory bank — a layer of long-term institutional memory that doesn't come off-the-shelf in any of the major harnesses. But this is partly because archival is opinionated: maybe you'd "archive" in Jira tickets, or GitHub issues, or commits, or a changelog, or a wiki. Eventually there will be something native. Most web-based chat interfaces already read past conversations for context. [CodeRabbit has Learnings](https://docs.coderabbit.ai/knowledge-base/learnings) that persist facts across code reviews. This one's on the roadmap in a way that everything above was once on the roadmap.

### 🔀 Parallelization

> Break work into parallel tracks. The agent should detect parallelizable work and spin off subagents without being told to.

Parallelization was the one technique that couldn't be solved by better prompting. Every other innovation on this list was, at bottom, a matter of telling the agent what to do differently. Parallelization required the harness to do something differently — you needed multiple context windows running simultaneously, with coordination between them.

Before harness support existed, I was literally cloning repositories into separate directories on my machine, launching a Cursor instance out of each location, and manually giving each one a different prompt. I was the load balancer. Claude Code's early subagent support was more CLI-native but similarly manual — you could spawn subagents, but you were still the one deciding what ran where and reconciling the results. You'd handcraft hordes of subagents, or at least explicitly kick them off, to get decent parallelization on tasks — wiring up the topology yourself like a computational middle manager.

Parallelization matters disproportionately to the other techniques: it's pure force multiplication, and it was the one place where no amount of clever process design could substitute for infrastructure the tool didn't yet provide.

You would handcraft hordes of subagents to get decent parallelization on tasks — wiring up the topology yourself like a computational middle manager.

### The Timeline

So that's a lot to manage, right? No wonder this AI stuff is hard and people struggle to get good results. Right?

In January 2025, yeah. But your information is outdated; take a look at this timeline:

**February 2025** — The 📋 [Cline Memory Bank](https://github.com/nickbaumann98/cline_docs/blob/main/prompting/custom%20instructions%20library/cline-memory-bank.md) emerges from the Cline Discord: structured markdown files giving agents persistent project 🧠 **memory** across sessions. Claude Code launches with `/init` for 📋 **context initialization**.

**March 2025** — [Claude Code v0.2.47](https://claudefa.st/blog/guide/changelog#v0247) ships 📜 **auto-compaction**, automatically summarizing conversations when the context window fills. Before this, you managed the window yourself.

**May 2025** — [Cursor 0.50](https://cursor.com/changelog/0-50) ships Background Agents in preview: 🔀 **parallelization** without hand-wiring the topology.

**June 2025** — [Cursor 1.0](https://cursor.com/changelog/1-0) ships 🧠 **Memories** — persistent facts across sessions. (These later evolved into Cursor Rules, themselves another subsumption: a community concept absorbed, renamed, and integrated.)

**July 2025** — [Claude Code v1.0.60](https://claudefa.st/blog/guide/changelog#v1060) ships custom subagents for 🔀 **parallelization**. Geoffrey Huntley [documents](https://ghuntley.com/ralph/) the 🔁 **Ralph Wiggum technique**: agents in bash `while` loops, shipping overnight.

**August 2025** — [Claude Code v1.0.77](https://claudefa.st/blog/guide/changelog#v1077) ships 🗺️ **Opus Plan Mode**: use Opus for planning, a lighter model for execution.

**October 2025** — [Cursor 2.0](https://cursor.com/changelog/2-0) ships 🗺️ [**Plan Mode**](https://cursor.com/blog/plan-mode). The "make a plan before coding" convention becomes a toggle.

**November 2025** — [Cursor 2.1](https://cursor.com/changelog/2-1) improves 🗺️ **Plan Mode**: the agent can now ask clarifying questions in the UI.

**December 2025** — [Cursor 2.2](https://cursor.com/changelog/2-2) adds Mermaid diagrams to plans — echoing [vanzan01's](https://github.com/vanzan01/cursor-memory-bank) use of Mermaid for visual planning in the community memory banks — dispatches plan items to parallel agents, and ships multi-agent judging for 🔀 **parallelization**. [Claude Code v2.0.60](https://claudefa.st/blog/guide/changelog#v2060) ships background agents.

**January 2026** — [Claude Code v2.1.0](https://claudefa.st/blog/guide/changelog#v210) ships `/plan` as a first-class slash command. Both tools now detect when you're *trying* to plan and enter 🗺️ **plan mode** unprompted.

**February 2026** — [Claude Code v2.1.59](https://claudefa.st/blog/guide/changelog#v2159) ships 🧠 **auto-memories** and [v2.1.32](https://claudefa.st/blog/guide/changelog#v2132) ships 🔀 **Agent Teams**.

**March 2026** — [Claude Code v2.1.63](https://claudefa.st/blog/guide/changelog#v2163) ships 🔁 [`/loop`](https://claudefa.st/blog/guide/changelog#v2163). The Ralph Wiggum technique is now a built-in command.

**Not yet absorbed** 
- ✅ **Validation loops**. Preflight gates. TDD forcing. QA checkpoints. The last frontier.
- 🧠 **Archival memory**. Long-term institutional memory that survives beyond the current task lets you improve over time, stored somewhere durable and accessible.

Thirteen months. From the first community workaround to nearly-complete native absorption of every technique that mattered.

### The Scorecard

Niko does almost everything listed above, usually at least slightly better than the native version. But for anyone starting today, the built-in tools are past good enough. The delta is real but the delta is shrinking and the floor keeps rising. You would not tell a newcomer that they *had* to install Niko to succeed. You'd tell them to cleanly, clearly, and fully type their task into Claude Code and let it work.

And that baseline would be good enough.

---- CUT HERE ---

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
