---
layout: post
title: "Sub-Agents aren't Agents - They're Skills but Worse"
description: "Sub-Agents are syntactic sugar over skills with one baked-in assumption about execution context that should be the caller's decision."
author: texarkanine
tags:
  - ai-agents
  - harness-engineering
  - llm-context-management
  - Sub-Agents
---

I came across [GitAgent](https://github.com/open-gitagent/gitagent) the other day: an "open standard" for defining AI agents as git repositories. I expected something novel about agent packaging. Instead I found a repo structure full of dot-folders and harness customization files - prompts, tools, workflows, memory, hooks - and my first reaction was "you're telling me the source code repo I already have is an agent?"

But that reaction was wrong, and the reason it was wrong sharpened something I'd been circling for months about how agentic coding harnesses model their primitives.

## What Sub-Agents Are

Many agentic coding harnesses offer a "Sub-Agent" primitive. The semantics vary slightly across tools, but the core mechanic is the same everywhere: a Sub-Agent is a prompt that executes in a freshly spawned context window.

That's it. That's the whole thing.

The harness opens a new context, loads the Sub-Agent's prompt (*maybe* with some scoped tool access), lets the LLM work, and returns the result to the parent. Whatever your harness calls it you're looking at `{prompt + fresh context window}` and not a whole lot more.

## Syntactic Sugar & Venn Diagram Overlap

I wrote previously about [the use case for slash commands](/2026/01/23/use-case-for-ai-coding-agent-slash-commands.html) and, a couple months earlier, about [the use case against them](/2025/11/24/usent-case-for-ai-coding-agent-slash-commands.html). The conclusion was that Commands are syntactic sugar over skills. A Command is a convenient way to invoke a prompt with some preconfigured behavior, but a skill can do everything a Command does while remaining composable, portable, and reusable. Claude Code [validated this by killing Commands altogether and making skills directly invocable](https://code.claude.com/docs/en/changelog#2-1-3) in early January 2026.

Sub-Agents are similarly reducible to skills.

Consider a skill that summarizes your calendar for today. If you invoke it as a Sub-Agent, the harness spawns a fresh context window, loads the prompt, the LLM walks through the workflow, and you get your summary. If you invoke it as a skill, the LLM walks through the same workflow in your current context. And if you invoke it as a skill but write in your prompt that that it should spawn a Sub-Agent to run the skill, you get the exact same outcome as the Sub-Agent primitive - except now *you* decided whether the work happens inline or in a separate context, rather than having that decision baked into the primitive.

Skills strictly dominate. Same capability, more flexibility about where and how the work executes. The Sub-Agent primitive bakes in an execution strategy (new context window) that should be an invocation-time decision.

All three are the same:

1. `invoke the my-daily-report subagent`
2. `spawn a sub-agent to run the my-daily-report skill`
3. (in a new context window) `/my-daily-report`

## "But I Always Want a Fresh Context Window"

Sure. Maybe you're building a "summarize everything I did this week for the sprint retrospective" workflow, and that's always going to be its own context because it's a lot of data and you don't want it polluting whatever else you're working on. Building that as a Sub-Agent *feels* natural.

But trace what you'd actually build. You'd probably write several skills (either explicitly, or implicitly in your prompt) as part of the workflow - one to pull git commits, one to scan PR reviews, one to check your calendar. Then you'd make a Sub-Agent that orchestrates those skills. Except... you could've just made a skill that kicked all three off. If it needs its own context window, just launch it from one... *or* just write that into the skill's prompt. The Sub-Agent primitive saved you a line of prompt at the cost of locking in an execution strategy.

The sugar is bad for you. It tastes good but it isn't actually helping.

It's okay every now and then as a treat, of course - saving a couple keystrokes on a workflow you know is always going to be its own context window. But if you're building something to distribute, share, or compose into larger workflows, the Sub-Agent primitive is probably the wrong choice - just like Commands are.

## Bundling

Skills have a property that Sub-Agents don't: the [Agent Skills](https://agentskills.io) open standard allows bundling static resources alongside a Skill's prompt. Scripts, examples, reference data, configuration files - things that make the difference between a prompt that hopes the LLM knows what to do and a Skill that *shows* it what to do.

Sub-Agents and Commands can't do this. They're "just" prompts. If you expanded the Sub-Agent primitive to support bundled resources, you'd end up re-implementing the Agent Skills standard with one extra assumption bolted on: that execution always happens in a fresh context window. That's a lot of work just to bolt a constraint that should be optional onto machinery that already exists!

## Agent is a Complex Type

Which brings me back to GitAgent and why my first reaction was wrong.

When I saw their repo structure - `agent.yaml` for configuration, directories for skills, workflows, tools, memory, hooks - I thought "this is just a regular repo instrumented for agentic development - it's got dot folders for all the harness customizations." But the file layout is not the point. "Agent" shouldn't be a harness primitive at all. It's a [complex type](https://en.wikipedia.org/wiki/Composite_data_type).

Think about a customer service agent - human or AI, doesn't matter. They have a job description specifying what they're supposed to accomplish. A script walks them through customer interactions. Information sources let them look things up. Tools let them make changes to data or cause side effects on behalf of the customer. And a tracking system for previous interactions keeps them oriented on what they've been up to.

That maps cleanly to the set of actually useful harness primitives: prompts (serving double duty as instructions and workflow specifications), skills and MCP servers (for tools and capabilities), bundled scripts and resources (for deterministic operations), hooks (for guardrails and lifecycle control), and memory or context management (for state across interactions).

What most harnesses ship as "a Sub-Agent" is a job description stapled to a context window. What GitAgent is reaching toward - and what Claude Code plugins get closer to - is the full bundle: a composable unit of agentic functionality that carries everything it needs to operate. Its instructions, its tools, its resources, its constraints, and its workflows.

That's an Agent with a capital A. A mini-application. And you can't build one from a Sub-Agent any more than you can build a web app from a single HTTP handler.

## Don't Write a Sub-Agent, Write a Skill

Commands were syntactic sugar over Skills, with come capabilities blocked. Claude Code killed them and nobody mourned.

Sub-Agents are syntactic sugar over Skills with some capabilities (choice of context window) blocked.

If you're writing an instruction set to enable an AI to do something, Skills offer more flexibility, composability, and capability than Sub-Agents.

So don't write a Sub-Agent, write a Skill.

And if you're building a Full and Proper Agent - the complex type - find a [harness](https://code.claude.com/docs/en/plugins) that [supports](https://geminicli.com/docs/extensions/) bundling its primitives [together](https://developers.openai.com/codex/plugins) into a [single installable unit](https://opencode.ai/docs/plugins/) - that's the sort of foundation you want to be building on.
