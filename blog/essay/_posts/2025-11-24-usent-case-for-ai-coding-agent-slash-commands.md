---
layout: post
title: "The Usen't Case for AI Coding Agent Slash Commands"
author: texarkanine
tags: [cursor, ai, claude-code]
---

Cursor introduced "[Slash Commands](https://cursor.com/docs/agent/chat/commands)" fairly recently, in v1.6 in September 2025. Claude Code had had a similar thing - [Agent Skills](https://code.claude.com/docs/en/skills) - for a long time.

# Thesis

> It's not just useless, but an efficiency-reducing antipattern to bind a text prompt to a concrete slash-command for an AI coding agent.

**Corollary**

> Anything you would want to actively invoke as a slash-command, you *also* want to be a rule that the Agent can passively pick up and apply when necessary.

LLMs' whole raison d'être is (pseudo-)stochastic natural language processing and synthesis. When you reach the point where you're trying to codify a *function* - a fixed set of inputs and a predictable output that depends on them - you've exited the domain where LLMs excel. Building a Cursor Command or Claude Agent Skill is an antipattern that makes you less efficient. Deterministic, reliable input/output is the domain of CPU-bound traditional code. You want a fixed command that takes an input and reliably produces an output? We have a technique for that, called *writing software*. Just write the tool.

With a slash-command, you get:

1. Extra time for the network round-trip to the Agent's datacenter
2. Extra time for the Agent to figure out what you want
3. Extra cost for the GPU(s) to run the computation
4. Extra time fixing the instances where the stochastic output is *not* what you expected
5. Data privacy concerns

Furthermore, as I'll explore below, all technical differences between slash-commands and other methods of software development are distinctions without a difference.

## Strawmen

> It takes longer to write an actual tool than to ask the Agent.
  
True, but: Ask the Agent to write it for you. They're very good at that.

> I have to have a runtime on my machine, like python or node or-

Right now, you already have the "runtime" of a remote shell hooked up to a functionally-nondeterministic artificial intelligence running on someone else's computer. True, you can get to *an* output faster this way. But it is *by construction* an unreliable solution. If you intend to codify something re**usable**, this can't be the answer.

> Claude Code doesn't have rules like Cursor, so I can't just `@reference` them.

Just write a Markdown file and tell the Agent to follow it - no special features required. Boom, there's your "command:" `Do what my-command-prompt.md says.`

Yes, it's a few more characters than `/my-command`. Don't cut yourself off from the efficiencies AI coding agents can deliver to occasionally save yourself a dozen keystrokes.

**PROTIP:** I just dictate (speech to text) to the AI agents so I don't have to type. If you have a laptop running a major operating system, you can do this, too!

## Steelmen

### Mutually-Exclusive Workflows

If you have mutually-exclusive directives that *must* be available for *your* use, but invisible to the Agent, then slash-commands have some utility.

Maybe you have two different style guides with no firm rule for application - you just choose one when you want when you know it's appropriate. You definitely don't want the Agent to see both of them, as it may pick the wrong one or blend them.

Then, the conflicting prompts "hide" completely out-of-scope in slash-commands, waiting for you to bring them into the conversation. This is perhaps even a slight improvement over just writing `my-command.md` and explicitly asking the agent for it when you want, as there's *no* risk of the agent *ever* reading or executing a command that you didn't `/invoke`. Probably, right?

I assert that this situation is incredibly rare, and that most of the time a situation that looks like this would actually benefit from the prompts being *Cursor Rules* that could be applied by the Agent when necessary.

### Interleaved NLP & CPU Tasks

If you have a workflow you want to codify into something re-usable *and* that workflow has chronologically-interleaved NLP and deterministic tasks, then a slash-command sounds tempting. 

Consider Cursor's example of `/pr` to open a GitHub Pull request, where the Agent has to identify the git diff (deterministic), figure out prose to describe the changes (NLP), find and fit it into a `PULL_REQUEST_TEMPLATE.md` if one exists (NLP), figure out the tooling available for opening a pull request (NLP), then invoke the tool (deterministic)...

Oh, exactly like [this Cursor Rule](https://github.com/Texarkanine/.cursor-rules/blob/main/rules/github-open-a-pull-request-gh.mdc) that you don't have to explicitly, intentionally `/pr` for - you can just tell the agent to 

> &lt;your actual prompt&gt; and open a pull request

Again, *yes* `/pr` is little shorter but if you do that then you *can't* say `and open a pull request` or `then open a pr` or `then send a pr` - you always have to remember the explicit command instead of just being able to have your natural language processed.

Note that this only even applies when there are NLP and deterministic tasks chronologically *interleaved.* If the task is just "some NLP *and also* something deterministic," you probably want a proper **Tool** that the Agent can just figure out all the inputs for and then invoke, handing execution off to truly-deterministic traditional software.

## What Would Change My Mind

If, instead of just binding to text prompts, slash-commands offered a structured way to bind a command to a combination of LLM NLP and deterministic software. 

🪄 Oh, we have that! It's called a **Tool**. You might know them from [Model Context Protocol (MCP)](https://modelcontextprotocol.io/specification/2025-03-26).

Don't waste your time with coding agent slash-commands that bind to textual prompts.