---
layout: post
title: "The Adeptus Mechanicus Bootcamp"
subtitle: "It's been over a year since I stopped writing my code, and I have such sights to show you."
author: texarkanine
tags:
  - ai
  - cog-mechanicus
---

I am a Principal Engineer. I have been in the tech industry for over a decade and I have been programming computers since the last millenium. I have a bachelor of Computer Science from Rice University, I have written virtual memory, a file system, malloc, and a shell from scratch. I have used Continuation Passing Style in production. "10x engineer" is the term. So when I tell you that it has been a year since I stopped writing my code and that the current frontier coding models make me look like an idiot child, I want you to understand my full meaning.

Pi day 2025 was the day I stopped writing code. I still ship code - more than ever, in fact - but I don't write it anymore.

It's about two and a half months since I stopped *looking at* the code.

This is a very different world than I could have possibly imagined, come to pass (and still going) faster than I could have guessed, and it's only been a *year!*

The skills you need in this world aren't prompting. The aren't "AI literacy." They are the engineering judgment I already had, applied at a higher altitude. But there's a catch: if you don't have the judgment, the altitude will kill you.

Welcome to the [Mechanicum](), developer. It's time to skill up!

## The Power Continuum

A coworker asked me, in a Q&A, what vibecoding actually was. "Is it just... asking Claude for what you want and letting it do it?"

"Yes," I said (hesitantly). "Literally just that."

Within a week, she was demo'ing something in a team meeting that "Claude vibecoded." She had, in fact, just asked for the thing. And gotten it.

I had been prepared. I had context-wrangling wisdom to share, prompt-engineering tips to dispense. None of it was needed. The barrier wasn't skill. It wasn't technique. It was conceivability. The workflow wasn't forbidden to her — it was absent from her mental model. The moment someone said "yes, that's really all it is," the entire distance from zero to output collapsed into a single step.

--- above: revised; below: raw ---

Paul Graham described the [Blub Paradox](http://www.paulgraham.com/avg.html) in 2001. A programmer who only knows a hypothetical mid-power language called Blub can look *down* the power continuum and see lesser languages for what they are. But they can't look *up*, because they lack the conceptual vocabulary to perceive what they're missing. The ceiling is invisible from below.

Graham was talking about programming languages. The paradox generalizes.

The power continuum now runs from "I type the code" through "I describe what code to type" through "I describe the outcome and the code is a side effect." Each step up that ladder is a step further from touching the implementation, and a step deeper into engineering judgment. Here's how the levels map concretely:

**Experiential development.** You write code, run it, see what happens, iterate. Hands on every surface. This is where most of us started - and where the artisan's ambient quality loop lives. More on that shortly.

**Test-driven development.** You write the specification first (as tests), then write code to satisfy it. You've separated "what it should do" from "how to make it do that."

**Spec-driven development.** You write a technical specification. The agent writes the tests *and* the code. You've moved one more level up: you're specifying intent in structured prose, and the machine handles both the contract and the implementation.

**Intent-driven development.** You write a product brief. Plain prose. Soft skills. The agent handles design, specification, implementation, and verification. This is where I live now.

Each level requires *more* engineering judgment, not less. Each level moves you further from the code and closer to the intent. And here's the smell test: having to drop down a level is a signal. Having to drop two levels is a strong signal. Needing to go back to experiential means the ritual failed - something about the specification, context, or tooling wasn't sufficient - and you need to diagnose *why* before you try again.

I wrote about the decoupling of expression from behavior in [Pink Margarine](TODO-link): copyright protects expression, but software's value is behavior, and the two have become fully separable. That essay diagnosed the problem from the licensing side. This one is the practitioner's field guide from the productivity side. If expression is decoupled from behavior, then the value of a knowledge worker was never in the expression. It was in the intent.

And if your engineering vocabulary doesn't yet include "I describe intent and the machine handles implementation," that workflow isn't forbidden to you. It's *inconceivable* to you. You can't formulate the desire to work that way, in exactly the way that Orwell's Newspeak made thoughtcrime impossible by removing the words needed to think it. This is why the bootcamp exists. We're expanding a language so that new thoughts become possible.

## The Three Skills

So what does it take to operate at the top of this continuum? Three things. All of them are "skill issues" when they go wrong.

### Asking the Right Questions

The model is the oracle at Delphi. Its responses are infinite. You must ask the right questions.

This sounds like a prompting tip. It isn't. The skill isn't in phrasing the prompt well - it's in *knowing what to ask*, which presupposes deep domain expertise. The principal engineer who stopped writing code still needs to think like one. The models are better than me at producing code. They are not better than me at knowing what code should exist or what behavior it should exhibit.

Consider the [Rust rewrite of SQLite](TODO-link-to-tweet-or-article) that benchmarked at roughly 1,800x slower on key lookups than the original C implementation. There's a [well-known axiom in manufacturing and contracting](TODO-link-to-canonical-source): anything you don't specify will be done as cheaply as possible. The critics saw this and concluded that LLMs produce plausible code, not good code.

They're right. But they're missing the load-bearing insight: [you get to define what "plausible" is](https://x.com/KatanaLarp/status/2029928471632224486).

SQLite's [TH3 test suite is proprietary](https://sqlite.org/th3.html). The reimplementors *couldn't* have had access to the full behavioral specification, including performance constraints. So those constraints went unspecified. And anything unspecified gets done as cheaply as possible. The model did exactly what was asked. The model was not the problem. The specification was the problem. Skill issue.

I wrote about this dynamic in [Pink Margarine](TODO-link) in the context of test suites as behavioral blueprints: publishing your test suite is publishing your own disruption manual. SQLite's decision to keep TH3 proprietary accidentally illustrates what a behavioral specification is worth when duplication costs drop to near zero.

#### The Artisan's Ambient Loop

Why didn't we notice this "specification problem" before? Because, for most of human history, we didn't have one.

In [Desire Makes Artists](TODO-link), I wrote about how pre-industrial artisans produced goods with art and quality infused during the process, because that's what happens when humans make things by hand. The craftsperson's quality wasn't intentional specification - it was emergent from proximity. You're in there, hands on every surface, spending an hour doing minute scrollwork on the side of a flintlock rifle. If you notice that one of the plates is a little loose, you fix it - that'll take a minute or two, you're already locked in for the hour, and you don't want your beautiful thing to be a piece of garbage. The ornamentation was almost a *pretext* for the real value: hours of incidental contact during which the artisan was continuously, unconsciously matching intended behavior against actual behavior. Discovering and fixing problems that were never formally specified.

Industrialization didn't just remove the decoration. It removed that ambient inspection loop. And then you get exactly what you specified, and everything unspecified is up in the air. The factory worker doesn't have your context and isn't spending that time.

Sound familiar?

The specification spectrum has three failure modes, and the skill is navigating between them:

**Underspecify.** You get "plausible." The Rust SQLite rewrite. 1,800x slower because nobody said it shouldn't be. Everything unspecified, done as cheaply as possible.

**The artisan sweet spot.** The ambient loop catches what formal specification misses. Beautiful. Doesn't scale. This is the old world. This is where typing your own code lived. We don't need code inlaid with ornate scrollwork, but we do need *some* mechanism to catch what we forgot to specify.

**Overspecify.** You burn all the human bandwidth on definition and ship nothing. This is the [Load-Bearing Rate Limiter](TODO-link) problem inverted: instead of the human bottlenecking production, the human bottlenecks definition. You've gold-plated the spec instead of the code and you're just as broke. You spent four hours iterating on a pull request that adds one button because you future-proofed it against quantum computing, ensured optimal Big-O complexity, and ran out the payroll budget before you shipped a feature that could bring in any revenue.

The skill is finding the right altitude on that spectrum *per task*. Performance-critical paths need tight specs. Internal tooling needs a product brief and a prayer. Knowing which is which, before you've burned the time finding out, is engineering judgment. That's all it's ever been.

### Context Wrangling

Socrates' most famous contribution to epistemology, loosely rendered: I know that I don't know.

You have to know the *shape* of what you don't know well enough to feed the model what it needs. The model can't infer your architecture from vibes. The model can't read your mind about which edge cases matter. The model definitely can't guess that your CI pipeline requires a specific incantation to pass.

This is the practical, mechanical skill. What goes into the machine's context window, what stays out, and when. I've written about this at length.
 
You have to know what the machine can't infer so you can provide it. Every rules file, every embedded doc, every selectively-loaded skill is context wrangling made systematic. And the reason it's a *skill* and not a *process* is that no two tasks need the same context. You have to evaluate, every time, what this particular task requires - and what it doesn't.

### Discernment

you also have to know what YOU don't know.

> The intuitive response to unprecedented productivity is "do everything faster." The correct response is almost the opposite.
>
> - [The Load-Bearing Rate Limiter Was Human](TODO-link)

The third skill is knowing when to *stop*. Knowing whether the thing should exist at all. The cost-benefit analysis synthesized across time, money, quality, and market absorption.

Jeremy Howard at fast.ai wrote about [dark flow](https://www.fast.ai/posts/2026-01-28-dark-flow/) - the seductive trap of agentic productivity. You can build *so much, so fast* that you build things you didn't need. The flow state of *commissioning* is just as intoxicating as the flow state of *coding*, but the blast radius is larger because the output rate is higher. You can burn through a year's token budget in a week if nobody's asking "should we?"

Steve Yegge's [AI Vampire](https://steve-yegge.medium.com/the-ai-vampire-eda6e4f07163) describes the mirror image: the vampire feeds on your productive energy and eventually burns you out - not from typing, but from the cognitive overhead of steering. If you try to overclock the human in the loop, the loop falls apart. The vampire doesn't care that you're the smartest engineer in the room. It'll drain you just the same.

Tom Wojcik [raised the concern](https://tomwojcik.com/posts/2026-02-15/finding-the-right-amount-of-ai/) that outsourcing coding to AI causes a kind of "digital dementia" - your skills atrophy as you stop practicing them. He's observing something real, and [the research he cites](https://arxiv.org/abs/2601.20245) supports that observation at face value. But the framing is wrong. Measure horsemanship skills in millennials and I bet they, as a population, are terrible. Sound the alarm? No. Horses were obviated. The correct metric isn't "can you still hand-write a merge sort." The correct metric is "can you effectively commission, verify, and steer the thing that writes merge sorts." Or better yet: do you even need to be sorting in the first place? That's discernment operating at the product-intent level - a floor *above* the implementation question - and entirely invisible to anyone measuring typing speed.

Nobody's measuring the right things yet because the measurers are still on the lower rungs of the power continuum and can't look up.

Discernment also scales with blast radius. Small: you overspecified a button and wasted an afternoon. Medium: you underspecified a library rewrite and got an 1,800x performance regression. Large: at the top of your delegation tree, an undiscerned intent propagates through every node below you. The higher you climb, the more discernment matters, not less.

## For Those With Eyes to See, Let Them See

You've got the skills. You're asking the right questions, feeding the machine the right context, and exercising discernment about what to build and when to stop building. Now what?

You scale.

You can't overclock a human. You've got these new tools, and you will never code as fast as them, so don't try. Instead, look around.

Look *up* at your current manager. They have been doing exactly this - managing through indirection. Not just you, but probably several people just like you. Surviving. How well? Well, that's what being a manager *is*. They set intent, provide context, exercise discernment about what their reports should work on, and review the output. The three skills, applied to humans.

Your job is becoming their job. But instead of the traditional path of stepping up and replacing them, look *down* at your own hands.

<!-- TODO: Ghost in the Shell GIF - fingers splitting into dozens -->

Your hands used to be where the production pipeline ended. Now they're where delegation begins.

### The Gastown Ladder

Steve Yegge's [Welcome to Gas Town](https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04) describes the stages of AI-augmented development, and his progression looks roughly like this:

<!-- TODO: embed Gastown phases image, figure 8 -->

Solo coder. Then one agent, and you babysit it. Then one agent, hands-off. Then multiple agents. Then - and this is where it gets interesting - an agent managing other agents.

Yegge's figure 8 already shows a manager. But figure 8 isn't the ceiling. Yegge was narrating the buildout and operation of the system, not describing the steady-state organizational structure that emerges from it.

### Pascal's Triangle

<!-- TODO: Pascal's triangle image or custom visual -->

Here's the insight that the Gastown progression implies but doesn't fully explore: figure 8 is just where *individual contribution* ends and *recursive delegation* begins.

You will reach the point where you have too many direct-report agents. There is a limit to effective span of control - this is why your manager has a manager. The solution is the same one every organization in history discovered: hierarchy. You don't manage ten agents. You build a managing agent for your direct reports, and you dialogue with that manager. Just as your manager talks to you, and their manager talks to them.

Then the process repeats. Maybe you're managing two managers, each of whom manages five individual-contributor agents. Maybe you add a layer. Maybe it grows. Pascal's triangle, expanding downward until you've scaled your production capabilities to the level you actually need.

The structure itself is not new. This is exactly how basically every company ever has organized itself, because it works. Maybe a pure-machine world will discover something better, but for now - while we are still hybrids, still cyborg-izing ourselves and our workflows - this is the structure that works. We see it working today.

The difference: traditionally, every node in that org chart had to be a human. And no node was given the legal, regulatory, or budgetary allowance to build its own subtree of direct reports. But if you have access to LLMs or token budgets at your job today - congratulations. You do have that allowance. You can build your own tree.

### The Ceiling Is Discernment, Again

We are not going to do this recklessly, though, because we paid attention at the Cog Mechanicus Bootcamp. We will not slip into dark flow. We will not get drained by the AI vampire.

The blast radius at the top of Pascal's triangle is enormous. An undiscerned intent at the root propagates through every node. The three skills apply at every level of the tree. They don't get easier as you ascend. They get more consequential.

## Where We're Going, We Don't Need Eyes

In manufacturing, a [lights-out factory](https://en.wikipedia.org/wiki/Lights-out_manufacturing) runs with no human presence on the floor. The machines operate in the dark because there is nobody there who needs to see.

The [lights-out codebase](https://molochinations.substack.com/p/no-more-code-reviews-lights-out-codebases) is the same idea applied to software. Code that is authored, tested, reviewed, and deployed without a human ever reading it. You specified the behavior. The machines delivered it. The tests pass. The customers are happy. Why would you need to read it?

This sounds terrifying. It should - a little. That's the appropriate amount of respect for the event horizon.

### The Event Horizon

You can't get to a singularity without passing through an event horizon, don't you know.

Geoffrey Huntley calls it the ["oh fuck" moment](https://ghuntley.com/oh-fuck/). He sent Cursor off to port a Rust audio library to Haskell, took his kids to the pool, came back to a working library with autogenerated C bindings and FFI to CoreAudio. It wasn't regurgitating StackOverflow. It was creating something new. Jaw on the ground.

Every engineer on this journey has that moment. The moment the capability becomes real to you - viscerally, not intellectually. That's the event horizon.

And it's behind you now.

The principal engineer who hasn't written code in a year and hasn't read it in three months - that's not a thought experiment. That's the opening paragraph of this essay. That's *in the past*.

--- Below: Revised; above: raw ---

## The Bootcamp

The frontier models make me look like an idiot child at typing code. They always will. The value of that skill is gone and it's never coming back.

But the models can't do what got me here, yet. The questioning - knowing what should exist and how to ask for it. The context wrangling - knowing what the machine needs to know that it doesn't know yet. The discernment - knowing when to build, when to stop, and when to never start.

Those are engineering judgment. Those are the skills that let me get as far as Principal Engineer in the first place.

The event horizon is behind you, and nothing can escape it - so you might as well learn the skills that let you thrive on this side of it.

Welcome to the Mechanicum. Let's get to work.

### Practical Application

The specifics **do not matter*. Everything you read here will be obsolete in two years, probaly in one. But *today*, here's how to speedrun your progression through the stages, achieving a significant productivity boost with minimal skill atrophy along the way. Executed properly, that ought to give you a significant leg up on optionality as you navigate the next few years.

--- above: revised; below: raw ---

### Your Process

You write *excellent* JIRA tickets now. ac, etc. At a minimum.

You're headed towards writing really good technical briefs, and then you're going to step back and just write really good product briefs.

### Reasoning about Context

I've written about this at length, but these are by no means exhaustive, nor necessarily going to stay relevant!

- [Stop Doing AGENTS.md](TODO-link) covered what *not* to put in context: task-specific guidance delivered globally wastes tokens and confuses agents.
- [.gitignore is not .agentignore](TODO-link) covered what the agent needs to *see*: generated output, local rules, dependency source code - things that shouldn't be in source control but absolutely should be visible to your agent.
- [Model Context Protocol, Not Agent Context Protocol](TODO-link) covered when tools earn their context cost - and when they don't.
- [How I Learned to Stop Worrying and Love the Machine](TODO-link) covered the pre-token context management toolkit: rules, embeddings, docs, MCP, and knowing when each is appropriate.

The skill is literally imaginging 

### Niko

idk man