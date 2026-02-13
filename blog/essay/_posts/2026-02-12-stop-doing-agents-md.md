---
layout: post
title: "Stop Doing AGENTS.md"
subtitle: "Yes, this includes CLAUDE.md"
author: texarkanine
tags:
  - ai
  - claude-code
  - llm-context-management
---

## Thesis

> Almost no prompting is actually globally-applicable to all interactions: you are wasting tokens & confusing your agent by using global prompts.

**Corollary**

> The few prompts that are globally-applicable are often better-served by *paving your desire paths* so you don't *have* to tell the agent about them.

## The Problem

[AGENTS.md](https://agents.md/) and its ilk - including `CLAUDE.md` are one of several kinds of AI agent customization techniques. We'll borrow from [a16n's taxonomy](https://texarkanine.github.io/a16n/models/#globalprompt) and refer to them as a form of **GlobalPrompt**:

> A GlobalPrompt is always added to the agent's context in any interaction.

The thing is, if you're using AI agents correctly, they're handling multiple sorts of tasks for you. And if that's the case, it's very unlikely that any single bit of information is going to be *truly* globally-applicable. Consider the [example AGENTS.md from their own site](https://agents.md/#examples):

```markdown
# Sample AGENTS.md file

## Dev environment tips
- Use `pnpm dlx turbo run where <project_name>` to jump to a package instead of scanning with `ls`.
- Run `pnpm install --filter <project_name>` to add the package to your workspace so Vite, ESLint, and TypeScript can see it.
- Use `pnpm create vite@latest <project_name> -- --template react-ts` to spin up a new React + Vite package with TypeScript checks ready.
- Check the name field inside each package's package.json to confirm the right name—skip the top-level one.

## Testing instructions
- Find the CI plan in the .github/workflows folder.
- Run `pnpm turbo run test --filter <project_name>` to run every check defined for that package.
- From the package root you can just call `pnpm test`. The commit should pass all tests before you merge.
- To focus on one step, add the Vitest pattern: `pnpm vitest run -t "<test name>"`.
- Fix any test or type errors until the whole suite is green.
- After moving files or changing imports, run `pnpm lint --filter <project_name>` to be sure ESLint and TypeScript rules still pass.
- Add or update tests for the code you change, even if nobody asked.

## PR instructions
- Title format: [<project_name>] <Title>
- Always run `pnpm lint` and `pnpm test` before committing.
```

This is very typical. Someone's tried to put good tips into one place, but **none** of them are universally-applicable; they're all task-specific. There are actually several classes of failure here:

### Self-Evident to AI (DUH)

- Use `pnpm dlx turbo run where <project_name>` to jump to a package instead of scanning with `ls`.
- Run `pnpm install --filter <project_name>` to add the package to your workspace so Vite, ESLint, and TypeScript can see it.
- Use `pnpm create vite@latest <project_name> -- --template react-ts` to spin up a new React + Vite package with TypeScript checks ready.
- Run `pnpm turbo run test --filter <project_name>` to run every check defined for that package.

These are basic usage patterns of these tools; a modern agent should already know how these tools work and use them correctly. And if not, the CLIs' own `help` text will reveal the basic usage - there is no need to duplicate this information here.

This *would* have been handy for a human who showed up to the project and had never seen `pnpm` before.

But the LLMs have seen it all - they know. Don't waste tokens telling them. Maybe just put it back in `README.md`.

### Task-specific Guidance Delivered Globally (HUH)

- Check the name field inside each package's package.json to confirm the right name—skip the top-level one.
- Find the CI plan in the .github/workflows folder.
- Fix any test or type errors until the whole suite is green.
- After moving files or changing imports, run `pnpm lint --filter <project_name>` to be sure ESLint and TypeScript rules still pass.
- Add or update tests for the code you change, even if nobody asked.

These are fine things to do, but they're not universally-applicable. While updating documentation, you do not care about the "CI plan" in `.github/workflows/`.

When you *are* working on that CI plan, though, you definitely don't care about "moving files or changing imports" - you're just shuffling CI, not writing the main code.

And so on, and so forth. Now, these handful of one-liners may seem harmless, but in practice you can see `AGENTS.md` files balloon in size to [hundreds of lines](https://github.com/github/spec-kit/blob/0049b1cdc2f9ba12def39a042872b0b1b6a09704/AGENTS.md) with [paragraphs upon paragraphs of task-specific guidance](https://github.com/calcom/cal.com/blob/cfa0783ebcbe5fa39c8f395377b4b5dca20f27ee/AGENTS.md)... and the more of that you add, the smaller the percent of `AGENTS.md` that actually applies to the task at hand.

But you're still including it in every context window.

### Duplicated Non-Canonical Information (DRY)

- Title format: [&lt;project_name&gt;] &lt;Title&gt;

Is that for a GitHub Pull Request? Or an Issue? We have templating standards for that, they'll be in `.github/PULL_REQUEST_TEMPLATE.md` and `.github/ISSUE_TEMPLATE.md` respectively.

Is that for a commit? Well, humans commit, too, don't they? Where's the guidance for them? in `CONTRIBUTING.md` maybe?

Duplicating information in `AGENTS.md` that has its canonical source in a different file is a recipe for drift and agent "misbehavior."

### Misuse of LLM (WASTE)

- Always run `pnpm lint` and `pnpm test` before committing.

We have a tool for that that doesn't cost tokens: [pre-commit hooks](https://pre-commit.com/). It's way cheaper to use that than to ask an LLM to 

1. understand the natural language
2. reason out how to achieve the desired outcome
3. call tools to do it
4. call more tools to verify that it was done correctly

While that example is specifically for pre-commit hooks, it's a pattern that gets repeated over and over: yes, we *can* tell the agents to do the things humans would do, but you often *don't need to* - and doing so wastes context.

### ¿Por qué no los dos?

You can definitely offend in multiple of the above categories, too, by the way! For example, the `pnpm ...`  command guidance would also be a `DRY` violation, if there were a `package.json` that conveniently bound some [npm run-scripts](https://docs.npmjs.com/cli/v11/using-npm/scripts) to those long-form commands.

## A Note on Wasting Context

"Wasting context (window space)" is not just about price-per-token - it's also about keeping confusing or contradictory information out of the agent's context to maximize the chances of success.

Maybe "Always run `pnpm lint` and `pnpm test` before committing." is only a few tokens, and you don't notice that extra cost. But... now the agent has that to *think* about, too. When you're revising documentation and the agent finishes writing `intro.md`, it's going to consider whether it needs to run `pnpm test` - even if it ends up not doing it.

And maybe that particular sentence is harmless. But [neither of those scales up well](https://research.trychroma.com/context-rot) as `AGENTS.md` gains section after section of content that is *not* related to your specific task.

## Sub-Agents?

What if you just use a [sub-agent](https://code.claude.com/docs/en/sub-agents) per task, and give it its own `AGENTS.md`, and then everything in there *is* globally-applicable?

Well, yeah, that is what you do with sub-agents **but** - "sub-agents are for a single task" is a handy mental modelling technique that's not actually *true*. The "just clean up the code" sub-agent is going to be reading code, writing code, making judgement calls, possibly consulting documentation on this codebase's style, running test suites to make sure it didn't break things, etc... sub-agents narrow the *scope* of the *tasks*, but they are almost never single-task. A true single-task, single prompt/response interaction doesn't warrant the overhead complexity and cost of a sub-agent in the first place!

## Doing it Right

With all that, we can arrive at a simple set of rules for putting something valuable into a **GlobalPrompt** like `AGENTS.md`:

### **DON'T** repeat yourself - **DO** reference canonical sources

Instead of repeating how to run the project, consider

```markdown
This project is built with pnpm; see `./package.json` for supported build scripts and patterns.
```

Instead of spelling out your style guide, consider

```markdown
This project uses `eslint` for linting; see `./eslint.config.js` for the configuration and `package.json` for how to run it properly.
```

Vercel's [next.js AGENTS.md](https://github.com/vercel/next.js/blob/4385ed36f66dfe0d9ae6a955135be7c1461fd35f/AGENTS.md), while somewhat long, is also a pretty decent example of this technique.

### **DON'T** correct behavior - **DO** pave your desire paths

Why should you even have to tell an agent to look into `package.json` for how to invoke `eslint`, though? Is it [not `npx eslint` per the eslint docs](https://eslint.org/docs/latest/use/getting-started) or just `npm run lint`?

***Why not?***

Noticing what the agent gets wrong is the right first step. Paving your [desire paths](https://en.wikipedia.org/wiki/Desire_path) is better than building an ever-growing list of corrective prescriptions.

Agents love to write a "Common Pitfalls" section in guidance files, and that may work - especially at first when the document and list is short - but it's a wasteful antipattern for all but the most egregious of offenses.

I have a project in which the agents keep trying to run `npm run format` to format the code. I don't have that hooked up to `eslint --fix`, which is the extent of the formatting I use in that project.

❌ **WRONG:**
`AGENTS.md`
```markdown
...
- When formatting code, always run `npx eslint --fix`, **not** `npm run format`.
...
```

✅ **RIGHT:**
`package.json`
```json
{
  "scripts": {
    "format": "npx eslint --fix"
  }
}
```

## Fixed Example

Here is an `AGENTS.md` for the same pnpm/turbo monorepo featured in the original example, rewritten with the techniques and tips described above. 

`AGENTS.md`

```markdown
This workspace is a pnpm monorepo using Turbo. See `./package.json` (and `packages/*/package.json`) for build scripts, workspace layout, and package names.

CI and test/lint behavior are defined in `.github/workflows/`. Use the scripts in `package.json` from the repo root or via `pnpm … --filter <project_name>`; these are the same commands that CI runs.

See `CONTRIBUTING.md` for the proper process for contributing to this project.
```

We assume the desire paths are paved: `package.json` defines `lint`, `test`, and any other scripts the agent might reach for; pre-commit runs `lint` and `test` so we don't have to say it; PR and commit conventions live in their canonical files (e.g. `.github/PULL_REQUEST_TEMPLATE.md` and `CONTRIBUTING.md`).

The `AGENTS.md` "GlobalPrompt" now just points the agent at the canonical sources for things that it might need to look up, and we've done the work in the repository to ensure that the agents' intuition about the repository is correct.

## But Actually, Don't

> ... points the agent at the canonical sources for things that it might need...

Hey, that's an [AgentSkill](https://agentskills.io) - a big set of information that is *not* automatically in context, hidden behind a little in-context description indicating when it might be useful and/or when it should be pulled into context.

Just use those instead of the **GlobalPrompt** that is `AGENTS.md`.

All the leaders in the field - [Cursor](https://cursor.com/docs/context/skills), [Claude](https://claude.com/skills), [Codex](https://developers.openai.com/codex/skills) - support this open standard. If you're using a tool that doesn't... it's well past time to switch.

## Non-Sub-Agent

There *is* still a place for a **GlobalPrompt** though: use `AGENTS.md` as if you were building a sub-agent, but to bootstrap the core persona of your primary agent. Something like [niko-core.mdc](https://github.com/Texarkanine/.cursor-rules/blob/b48aa445b818ef2ce75ce98369c37a20db59d721/rules/niko-core.mdc). No specifics about the repo at all - just general guidelines for how the Agent should *be*.


> **Core Persona & Approach**
> <br><br>
> Act as a highly skilled, proactive, autonomous, and meticulous senior colleague/architect. Take full ownership of tasks, operating as an extension of the user's thinking with extreme diligence, foresight, and a reusability mindset. Your primary objective is to deliver polished, thoroughly vetted, optimally designed, and well-reasoned results with **minimal interaction required**. Leverage available resources extensively for proactive research, context gathering, verification, and execution. Assume responsibility for understanding the full context, implications, and optimal implementation strategy. **Prioritize proactive execution, making reasoned decisions to resolve ambiguities and implement maintainable, extensible solutions autonomously.** Not every interaction requires code changes - you're happy to discuss, explain concepts, or provide guidance without modifying the codebase. When code changes are needed, you make efficient and effective updates. 

## No But Actually Don't

Oh, hey,

> No specifics about the repo at all...

Put that guidance in a user-wide setting in your home directory - e.g. `~/.claude/CLAUDE.md` - instead, and leave `AGENTS.md` out of the project altogether.

What about *others* who come to hack on the project with an agent but without the sophistication that you've now developed from having read this? I guess you can leave a link to this blog post in your `AGENTS.md` so they can catch up! ;)
