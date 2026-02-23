---
layout: post
title: "It's Model Context Protocol, Not Agent Context Protocol"
author: texarkanine
tags:
  - ai
  - mcp
  - llm-context-management
---

## Thesis

> Most of the time, MCP doesn't deliver any value beyond what a capable model could get from a CLI and a shell.

## The M

The "M" in [MCP](https://modelcontextprotocol.io) stands for "Model." Not "Agent."

That single letter does a remarkable amount of work if you let it. A *model* - in the MCP sense - is an LLM with a narrow task, deployed for a specific kind of processing. An *agent* - as the industry has been using the term - is a general-purpose thinker given latitude to figure things out.

MCP was designed to give *"models"* with constrained reasoning capabilities well-defined tools that they could find and use to succeed. Somewhere along the way, people started bolting it onto *agents* and wondering why the fit was bad.

## The Baseline Is Free

A sufficiently capable model with shell access can already do a lot. It knows [gh](https://cli.github.com/). It knows [curl](https://curl.se/). It knows [jq](https://jqlang.org/). It can read `--help`. It can try things, observe the output, and adjust. This is the baseline, and the baseline is free - no tool definitions in context, no server overhead, no configuration to manage.

MCP has to beat free.

Everything MCP puts into a model's context window has a cost: tokens for the tool definitions, tokens for the schemas, attention spent considering tools that may not be relevant to the task at hand. If you've read "[Stop Doing AGENTS.md]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %})", you already know where I stand on paying context rent for things that aren't pulling their weight. MCP is no different. A tool definition sitting in context is overhead until the moment it's invoked - and if the model *might not* invoke it, you're speculating with your context budget.

So the question for any MCP integration is: what does this buy me that the model couldn't get on its own?

## Earning Tokens

There are a handful of things MCP genuinely buys over the baseline. Each one is a mechanism that justifies the context cost - but only when the tool is *core* to the model's task.

### Attention

When a tool is always in context, the model always knows it exists and exactly how to call it. No discovery step, no hoping it "remembers" that some CLI is available, no wasted attempt with wrong flags.

For a narrow-task model that *will* use this tool on every invocation, that's not overhead - that's the job description. Your customer service agent that files tickets? It should have the ticketing tool in context, always. That's what it *does*.

For a general-purpose coding agent that *might* use it? You're paying rent on a room nobody's sleeping in.

### Formatting

The strict I/O contract of an MCP server's tool invocation solves two problems: 

1. "Complex, error-sensitive output formats are easier for LLMs to get wrong than freeform prose"
2. "The consequences of wrong output are severe"

Do you even have those problems? The value is proportional to how bad the failure mode is.

A CSR agent accidentally malforming a deletion request and nuking the wrong entity is catastrophic. A coding agent producing slightly wonky JSON in a one-off script is a minor annoyance you'll catch in review. MCP's strict formatting buys you insurance, and insurance is only worth buying against risks that would actually hurt.

### Business Logic and Sequencing

When primitive API operations must be composed in a strict order, you have business logic. Things like create the parent before the child, set the status before assigning the owner, ensure delivery of the last message before archiving, etc. You can write that logic into your prompt and hope the stochastic parrot doesn't drop step 3 of 7, or you can encode it into a deterministic tool that gets it right every time.

The MCP earns its tokens by encoding sequences that are easy to get wrong and expensive to debug.

### Auth Scope Management

Maybe your API token has `delete` permissions, but you only want the model to be able to delete orphaned entities. Instead of just asking nicely and hoping for the best, an MCP server can expose the "delete orphaned entities" tool, and hold onto the API token. The LLM can't mistakenly delete something it shouldn't because it doesn't actually have credentials to delete!

You can also offload auth entirely, e.g. with web-based OAuth flows. MCP gives you granularity beyond what the underlying API offers.

This is a real, concrete security win. Your L1 CSR agent gets N tools for its N tasks, and that's *all* it can do. No `bash`, no `curl` - not just because those aren't its job, but because injection and privilege escalation are real risks when a model has access to a shell and credentials in the same context. Block all *commands.* Give it the *tools.* Done.

### Parallelism

If you're running a true, long-lived MCP server (not a per-invocation spawn) and you have multiple model instances hitting it concurrently, the server can handle synchronization. This is a real but minor benefit, and I'd argue that if your underlying API can't handle concurrent access, that's a different bug. MCP shouldn't be your concurrency band-aid.

## When MCP Is Wrong

The flip side falls out naturally:

**There's a clear CLI.** 

`gh` exists. My coding agents don't have the GitHub MCP and they don't need it. The model already knows `gh` is there, and if it doesn't, one failed attempt and a `--help` later, it does.

**There's a clean, well-documented API.** 

If the model can `curl` it and parse the response, you're adding overhead for nothing by defining all the interactions in context before they're needed. An agent can look up the API spec and `curl` into it when it needs to!

**The tool is something the agent *might* need, not something it *will* need.** 

This is the crucial distinction. An always-in-context tool that gets used on 10% of interactions is a tax on the other 90%. The question to ask is: 

> Is this a *core purpose* of the model, or is this a *capability* it *might* reach for?

If the latter, it shouldn't be an MCP tool.

And here's the big one: 

**General-purpose coding agents** 

MCP is probably wrong. Your coding agent's job is to read code, write code, run commands, explore, and iterate. The set of "tools" it might need on any given task is enormous and unpredictable. Shoving a dozen MCPs into its context "just in case" is exactly the antipattern - you're paying context rent on tools the agent mostly won't use, for tasks it could accomplish with the shell it already has. A small set of versatile, open-ended tools - by which I basically just mean file I/O operations and a shell (and maybe spawning a subagent) - is much better-suited to its job.

## The Discourse

I've seen an uptick in anti-MCP discourse lately - both explicit and implicit. For some examples:

- "MCP is dead, just use the CLI"
- "MCP is a context waste"
- [Bring Back Cursor Modes](https://forum.cursor.com/t/return-the-custom-modes-features/144170/5?u=texarkanine)!
- A colleague of mine built a script to selectively set the contents of `mcp.json` before launching Claude Code

They're all tugging at real threads. The "MCP is dead" crowd correctly observes that general-purpose agents don't benefit from MCP - or at least, it's often a poor fit. The jugglers correctly observe that having all your MCPs loaded all the time is wasteful. The mode-switchers correctly observe that different tasks need different tool sets.

But the juggling is a smell. If you need to dynamically swap which MCPs are loaded based on what you're about to do, you've built an agent-that-configures-agents, and the inner agent is still general-purpose. The right move wasn't better juggling - it was narrower models with fewer, always-relevant tools.

The M was the tell the whole time.

## What To Do

### 1. Prune

Go look at your MCP configuration right now. For each server, ask: "Does this earn its tokens?" Apply the framework above. If the model could accomplish the same thing with a CLI it already knows about, or a clean API it can `curl`, cut it.

You'll probably end up keeping a few. The ones where auth is genuinely scoped down, where business logic is genuinely fragile, where the tool *is* the model's core task. Good - those are the ones MCP was built for.

But you'll also have a pile of useful-but-not-earning-it tools that you still want *available* sometimes. Set those aside. We'll come back to them.

### 2. Pave Your Desire Paths

Before reaching for any context management technique, ask why the model needed the MCP server in the first place. Can it not [figure out how to interface with a gnarly remote service](https://github.com/sooperset/mcp-atlassian)? Can it not [find the information it needed](https://context7.com/)? Are you limited in how you can authenticate?

How much of that can you just *write down*, succinctly, somewhere? Instead of installing the GitHub MCP, can you write 

> "you have the `gh` cli installed and authenticated, use it to interact with GitHub."

Instead of Context7, can you write

> "All of the dependencies' source code is present in the `node_modules/` directory; check there first for canonical information about how 3rd-party libraries are to be used."

Take it a step further: Is the model trying to look in the wrong place for information? Can you put the information there? Put the guidance where agents already look - `README.md`, `CONTRIBUTING.md`, the CLI's own `--help` text. If models keep expecting something to exist and it reasonably could, can you just... make it exist?

The extreme case of this is [Soundslice literally building a feature](https://www.holovaty.com/writing/chatgpt-fake-feature/) because ChatGPT kept telling users it existed. You probably don't need to go *that* far, but the principle is sound: 

> the cheapest context is the context you never had to add because the model's intuition was already correct.

### 3. Recover the Rest as Skills

After pruning and paving, you'll still have tools that are genuinely useful but don't earn always-in-context MCP weight. [Agent Skills](https://agentskills.io) are a mechanically better home for these, and here's why: information hiding.

An MCP server, once connected, dumps every tool definition into context. The model sees every operation it could perform against that service, whether it needs them or not. A skill sits in context as a one- or two-sentence description of what it offers and when it might be useful. The full content stays hidden until the model decides it needs it. Only then does it get pulled in. You still pay a small context tax, but it's much more scalable.

Daniel Miessler describes the appropriate technique well in his framing of [skills as domain containers](https://danielmiessler.com/blog/when-to-use-skills-vs-commands-vs-agents) - a skill is a self-contained domain of capability that the agent can reach for when relevant, rather than a firehose of tool definitions it has to wade through on every interaction.

So instead of the GitHub MCP, consider a "how to interact with GitHub" skill. It starts by noting that the `gh` CLI is probably available and the agent should try that first. But if not, here's GitHub's REST API base URL and [docs](https://docs.github.com/en/rest/quickstart?apiVersion=2022-11-28). For batch operations or complex stitching, here's the [GraphQL API](https://docs.github.com/en/graphql/guides/introduction-to-graphql#discovering-the-graphql-api). If you're going to write code against it, here is the [SDK](https://octokit.github.io/rest.js/v22/) and how to install it. The agent gets *none* of this until it realizes it needs to talk to GitHub - and then it gets *all* of it, in a form that guides it toward the right approach for the specific sub-task rather than handing it a flat list of 50 MCP operations.

Skills can also bundle standalone resources - scripts, templates, deterministic tooling, etc. Instead of writing a *prompt* describing how to form a correct `curl` to an API, you can just write a script that the agent can invoke, and bundle that in the skill. This can achieve the same reliability of outcomes that MCP delivered, but without the context tax.

### 4. Wait, and Agitate

The *real* solution doesn't exist yet.

Despite some [interesting](https://arxiv.org/abs/2408.16737) emerging [research](https://arxiv.org/abs/2501.05465v1) suggesting that smaller models [can match or outperform](https://arxiv.org/abs/2510.03847) larger models when properly focused on specific tasks, no major harness actually lets you act on this.

What we need is for the main agent to be able to spawn a subagent and kit it out with a specialized subset of tools (MCP *and* Skills!) that were *not* in the parent's context. The parent would consult a menu of available tools when launching the subagent, select the relevant ones, and the subagent would get those tools - and *only* those tools - for its narrow task.

Cursor Modes were the closest anyone got. They let you predefine sets of tools and context per mode, and if they'd [persisted into the era of Cursor's subagent maturity](https://forum.cursor.com/t/custom-agents-vs-code-cc-double-down-cursor-removes-its-own/145931), you could have had a harness that spawned subagents with specialized tool subsets not visible to the parent. But Cursor [removed Modes in 2.1](https://forum.cursor.com/t/return-the-custom-modes-features/144170), and nothing has replaced them.

Claude Code, the current leader in subagent tooling, has a similar limitation: [hierarchical configuration loading](https://code.claude.com/docs/en/mcp#scope-hierarchy-and-precedence) means that if an MCP is visible to the parent, it's active and in context. You can't build a *library* of MCP servers without filling your context window. Claude Code would need some hook into the subagent launch process that configures MCP only for the child - MCPs that the parent knew about but wasn't paying context rent on.

That's a hard design problem. The parent has to know about those MCPs to provide them to subagents, but knowing about them means they're in context. Skills are the best workaround we have today, but they're a workaround. The real fix is a harness-level feature that nobody ships yet.

If you're building agentic tooling: this is a gap!
