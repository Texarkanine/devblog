---
layout: post
title: "The Use Case for AI Coding Agent Slash Commands"
author: texarkanine
tags: [cursor, ai, claude-code]
---

Following up on my previous post: "[The Usen't Case for AI Coding Agent Slash Commands]({% post_url blog/essay/2025-11-24-usent-case-for-ai-coding-agent-slash-commands %})", I'm delighted to report that I was wrong... partially.

There **is** a use case for AI Coding Agent Slash Commands.

> Slash Commands are for bundling a big prompt that is an entry point to a workflow.

So if you have prompt-engineered "look things up and give me my morning report," that's a great use case for a Slash Command.

In Cursor, previously you wrote these as "Manual Rules" and then `@mention`'d them. This was a little weird because every other kind of Cursor Rule was automatically picked up by the agent somehow. But Manual Rules sat there with the special `*.mdc` extension and Cursor Rule "YAML frontmatter," but didn't do anything with it.

Cursor's addition of Slash Commands was correct and necessary.

There *is* a use-case in the world for repeatable prompts.

I stand by the "Usen't Thesis," though, for most instances of adjusting agentic software development behavior: You can do *better* by writing proper Rules, Skills, Hooks, or Tools.
The key insight is the "entry point to a workflow" bit - especially the *entry point*. When human intent kicks off an agent in a new direction, a bundled prompt is handy to ensure that process gets started with the best chance of success.

If you're already in the middle of a workflow, though, you don't want to be maximizing human interaction by providing "useful" commands for the human to run.
You want to be equipping your agents with the tools and knowledge they need to just do it right from start to finish.

A command for a human to run in the middle of things is *still* an antipattern. So craft your commands carefully!

## The Wiggum Loop

As with almost everything, [the more you use it, the more it pays to optimize it](https://xkcd.com/1205/). Somewhere where you'll not only be re-using the same prompt, but re-using it more than *you* the human ever could, is a [Wiggum Loop](https://ghuntley.com/ralph/). That's actually a perfect use-case for a Slash Command!

I [did that recently]({% post_url blog/diary/2026-01-25-i-finally-coded-so-hard-i-ralphed %})!
