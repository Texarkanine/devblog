---
layout: post
title: "The Cog Mechanicum Bootcamp Outline"
subtitle: "It's been over a year since I stopped writing my code, and I have such sights to show you."
author: texarkanine
tags:
  - ai
  - cog-mechanicus
---

I am a Principal Engineer. I have been in the tech industry for over a decade and I have been programming computers since the last millenium. I have a bachelor of Computer Science from Rice University, I have written virtual memory, a file system, malloc, and a shell from scratch. I have used Continuation Passing Style in production. "10x engineer" is the term. So when I tell you that it has been a year since I stopped writing my code and that the current frontier AI models make me look like an idiot child, I want you to understand my full meaning.

Pi day 2025 was the day I stopped writing code. I still ship code - more than ever, in fact - but I don't write it anymore.

It's about two and a half months since I stopped *looking at* the code.

This is a very different world than I could have possibly imagined, come to pass (and still going) faster than I could have guessed, and it's only been a *year!*
Welcome to the [Cog Mechanicus]() bootcamp, developer. It's time to skill up!

---

# The Cog Mechanicus Bootcamp

**Subtitle:** It's been a year since I stopped writing my code, and I have such sights to show you.

**Shape:** Essay (thesis: the skills that matter in AI-augmented engineering are judgment skills, not production skills - and they're the same skills that made you senior in the first place)

**Eye motif threading:** come see → learn to see → transcend seeing

---

## 1. Opening: The Simon Tam Gambit

Enumerate chops. Principal engineer. [Industry]. [N] years. [Impressive technical accomplishments]. The works.

> I tell you this not to brag, but so that when I tell you that the current frontier models make me look like a trained ape, you will understand the full weight of my statement.

It's been a year since I stopped writing code. Almost three months since I stopped *reading* it. My output has increased. This post is about why, and about the skills that made that possible - because they aren't the skills you think.

The skills aren't prompting. They aren't "AI literacy." They are the engineering judgment you already have, applied at a higher altitude. But there's a catch: **if you don't have the judgment, the altitude will kill you.**

Welcome to the Cog Mechanicus Bootcamp.

---

## 2. The Blub Paradox, Generalized

### The Power Continuum

Introduce Paul Graham's Blub Paradox (link Beating the Averages). The Blub programmer looks down and sees lesser languages. Can't look up because they lack the conceptual vocabulary to perceive what they're missing.

This isn't about programming languages anymore. It's about *how you relate to knowledge work itself*. The power continuum now runs from "I type the code" through "I describe what code to type" through "I describe the outcome and the code is a side effect."

### The Specification Spectrum

Map the levels concretely:

1. **Experiential development** - you write code, run it, see what happens, iterate. Hands-on-every-surface.
2. **TDD** - you write the specification (tests) first, then write code to satisfy it.
3. **Spec-driven development** - you write a technical specification, the agent writes tests AND code.
4. **Intent-driven development** (or: "Commissioning") - you write a product brief. Prose. Soft skills. The agent handles design, specification, implementation.

Each level is one step further from touching the code. Each level requires *more* engineering judgment, not less. The smell test: having to drop down a level is a signal. Having to drop *two* levels is a strong signal. Needing to go experiential means the ritual failed and you need to diagnose why.

### 1984's Contribution

The Newspeak connection. If your engineering vocabulary doesn't include "I describe intent and the machine handles implementation," that workflow isn't forbidden - it's *inconceivable*. You can't formulate the desire to work that way. This is why the bootcamp exists: we're expanding a *language* so that new thoughts become possible.

Link to Pink Margarine's decoupling of expression from behavior. Pink Margarine diagnosed it from the licensing side. This essay is the practitioner's field guide from the productivity side: if expression is decoupled from behavior, then the value of a knowledge worker was never in the expression. It was in the *intent*.

---

## 3. The Three Skills

Transition: So what does it take to operate at the top of this continuum? Three things. All of them are "skill issues" when they go wrong.

### Skill 1: Asking the Right Questions

> "My responses are infinite. You must ask the right questions."

The model is the oracle at Delphi. It will answer anything. Most answers are useless because most questions are wrong. The skill isn't prompting, it's *knowing what to ask* - which requires the domain expertise established in the opening.

**The SQLite / Rust Rewrite** as case study. (Link the tweet/article about 1800x slower key lookup.) The manufacturing/contracting axiom: anything you don't specify will be done as cheaply as possible. (TODO: find a canonical source for this axiom.)

The criticism: "LLMs don't produce good code, they produce plausible code." They're right! But they're missing the insight: **you get to define what plausible is.** (Link the tweet.) If the reimplementors had had access to SQLite's test suite - which, critically, is proprietary and they *couldn't* have - the specification around performance would have existed and the model would have had to satisfy it. They didn't specify it. They got what they asked for. *Skill issue.*

Link to Pink Margarine on test suites as behavioral blueprints / disruption manuals, and SQLite's TH3 being proprietary.

**The Artisan's Ambient Loop** as historical context for why we never noticed this before. (Expand from Desire Makes Artists.) The craftsperson's quality wasn't intentional specification - it was emergent from *proximity*. Hours of incidental contact with every surface. The ornamentation was a pretext for the real value: continuous, unconscious matching of intended behavior against actual behavior. Industrialization didn't just remove the decoration - it removed that ambient inspection loop.

**The Specification Sweet Spot.** Three failure modes:
- **Underspecify** → you get "plausible." The SQLite rewrite. 1800x slower because nobody said it shouldn't be.
- **Artisan sweet spot** → the ambient loop catches what formal spec misses. Doesn't scale. This is the old world. This is where typing your own code lived.
- **Overspecify** → you burn all human bandwidth on definition and ship nothing. The Load-Bearing Rate Limiter problem inverted: the human bottlenecks *definition* instead of *production*. You gold-plated the spec instead of the code and you're just as broke.

The skill is navigating to the right altitude on that spectrum *per task*. That's engineering judgment.

### Skill 2: Context Wrangling

> "I know that I don't know." - Socrates (roughly)

You have to know the *shape* of what you don't know well enough to feed the model what it needs. The model can't infer your architecture from vibes. The model can't read your mind about which edge cases matter.

This is the practical, mechanical skill. It's where the prior posts on LLM context management become curriculum:
- Link: Stop Doing AGENTS.md (what NOT to put in context)
- Link: .gitignore is not .agentignore (what the agent needs to *see*)
- Link: It's Model Context Protocol, Not Agent Context Protocol (when tools earn their context cost)
- Link: How I Learned to Stop Worrying and Love the Machine → Cursor section (pre-token context management, rules, embeddings, docs, MCP)

The Socratic formulation: wisdom is knowing that you don't know. Applied: you have to know what the machine can't infer so you can provide it. Every rules file, every embedded doc, every selectively-loaded skill - that's context wrangling made systematic.

### Skill 3: Discernment

> "The intuitive response to unprecedented productivity is 'do everything faster.' The correct response is almost the opposite." - The Load-Bearing Rate Limiter Was Human

Knowing when to *stop*. Knowing whether the thing should exist at all. The cost-benefit analysis synthesized across time, money, quality, and market absorption.

**Dark Flow** (link fast.ai post). The seductive trap of agentic productivity. You can build *so much* that you build things you didn't need. You get trapped in the flow state of *commissioning* rather than the flow state of *coding*, but the pathology is the same: you lose sight of whether the thing should exist.

**The AI Vampire** (link Yegge). Mirrors perfectly. The vampire feeds on your productive energy and eventually burns you out - not from typing, but from the cognitive overhead of steering. If you try to overclock the human in the loop, the loop falls apart.

**Digital Dementia** (link Wojcik post with editorial). The criticism that outsourcing coding makes you worse at coding. Yes. Obviously. Measure horsemanship in millennials - they suck at it. That's because horses were *obviated*. The correct metric isn't "can you still hand-write a merge sort" - it's "can you effectively commission, verify, and steer the thing that writes merge sorts." Or better yet: do you even need to be sorting in the first place? That's discernment operating at the product/intent level - a floor *above* the implementation question, and entirely invisible to anyone measuring typing speed. Nobody's measuring any of this yet because the measurers are still on the lower rungs of the power continuum and **can't look up.** (Link the arxiv study for completeness, but note the framing problem.)

Discernment also scales with blast radius. Small: you overspecified a button and wasted an afternoon. Medium: you underspecified a library rewrite and got 1800x performance regression. Large: at the top of your delegation tree, an undiscerned intent propagates through every node below you. The higher you climb, the more discernment matters, not less.

---

## 4. For Those With Eyes to See, Let Them See

Transition: So you've got the skills. You're asking the right questions, feeding the machine the right context, and exercising discernment about what to build. Now what? You scale.

### Look Up, Then Look Down

You can't overclock a human. You've got these new tools. You'll never code as fast as them so don't try. Where do you look?

**Look up** at your current manager. They've been doing exactly this - managing through indirection. Not just you, but probably several people just like you. Surviving. That's what being a manager *is*. That's what your job is becoming.

But instead of the traditional path of stepping up and replacing them...

**Look down at your own hands.** (TODO: Ghost in the Shell GIF - fingers splitting into dozens of tiny fingers.) Your hands are where the production pipeline used to end. Now they're where delegation *begins*.

### The Gastown Ladder

(TODO: embed/reference the Yegge stages image, figure 8)

The progression:
- Solo coder → one agent, you babysit → one agent, hands-off → multiple agents → agent managing agents

This is Steve Yegge's Gas Town progression (link). Figure 8 already shows a manager. But figure 8 isn't the ceiling.

### Pascal's Triangle

(TODO: image of Pascal's triangle or similar visual)

Figure 8 is just where *individual contribution* ends and *recursive delegation* begins. The insight Yegge doesn't fully explore (because Gas Town is narrating the buildout, not the steady-state):

- Figure 9: two managers
- Figure 10: two layers of managers
- Figure 11: Pascal's triangle

You will reach the point where you have too many direct reports - agent or otherwise. There's a limit to effective span of control; that's why your manager has a manager. So you'll "hire" (build) a managing agent for your direct reports, and dialogue with *that* manager instead.

The big new thing is NOT the structure. This is exactly how basically every company ever has structured itself, because it works. The difference: traditionally, every node in that org chart had to be a human. No node was given the budget/authority to build its own subtree of reports. But if you have access to LLMs or token budgets at your job today - congratulations, you *do* have that allowance. You can build your own tree.

### The Ceiling Is Discernment, Again

But we are NOT going to do this recklessly, because we paid attention at the Cog Mechanicus Bootcamp. We will not slip into dark flow and get sucked dry by the AI vampire.

The blast radius at the top of Pascal's triangle is enormous. An undiscerned intent at the root propagates through every node. The three skills apply at every level of the tree. They don't get *easier* as you ascend - they get *more consequential*.

---

## 5. Where We're Going, We Don't Need Eyes

### Lights-Out Codebase

(Link the Molochinations post on lights-out codebases.)

The manufacturing concept: a lights-out factory runs with no human presence on the floor. The machines operate in the dark because there's nobody there who needs to see.

The lights-out *codebase* is the same idea applied to software: code that is authored, tested, reviewed, and deployed without a human ever reading it. You specified the behavior. The machines delivered it. The tests pass. The customers are happy. Why would you need to read it?

This sounds terrifying. It should - a little. That's the appropriate amount of respect for the event horizon.

### The Event Horizon

You can't get to a singularity without passing through an event horizon.

Geoffrey Huntley calls it the "oh fuck" moment (link ghuntley): he sent Cursor off to port a Rust audio library to Haskell, took his kids to the pool, came back to a working library with autogenerated C bindings and FFI to CoreAudio. "This wasn't something that existed; it wasn't regurgitating knowledge from Stackoverflow. It was inventing/creating something new." Jaw on the ground.

Every engineer on this journey has that moment. The moment the capability becomes *real* to you - viscerally, not intellectually. That's the event horizon. And it's behind you now.

The Hellraiser references weren't just flavor. You opened a box. You saw things. **You're already on the other side.** The principal engineer who hasn't written code in a year and hasn't read it in three months - that's not a thought experiment. That's the opening paragraph of this essay.

The bootcamp isn't optional because the event horizon isn't reversible. The skills are what let you survive on this side of it.

### Close

(Something that ties back to the Tam opening and the trained-ape line. The models make you look like a trained ape at *typing code*. But the models can't - yet - do what got you here: the judgment, the questioning, the context awareness, the discernment. Those are the skills. Welcome to the bootcamp. Now get to work.)

---

## Appendix: Links & TODOs

### External Links to Include
- Paul Graham, Beating the Averages (Blub Paradox): http://www.paulgraham.com/avg.html
- "You define what's plausible": https://x.com/KatanaLarp/status/2029928471632224486
- Lights-out codebase (Molochinations): https://molochinations.substack.com/p/no-more-code-reviews-lights-out-codebases
- Dark flow (fast.ai): https://www.fast.ai/posts/2026-01-28-dark-flow/
- Digital dementia / right amount of AI (Wojcik): https://tomwojcik.com/posts/2026-02-15/finding-the-right-amount-of-ai/
- The arxiv "AI makes devs worse" study: https://arxiv.org/abs/2601.20245
- Gas Town (Yegge): https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04
- Gas Town phases image: https://miro.medium.com/v2/resize:fit:4800/format:webp/1*ArLBW-FgOdve4COI804uIQ.png
- The AI Vampire (Yegge): https://steve-yegge.medium.com/the-ai-vampire-eda6e4f07163
- Oh fuck moment (ghuntley): https://ghuntley.com/oh-fuck/ (the jaw-drop moment of realization; may be paywalled)
- NY chatbot ban (pink margarine in real time): https://statescoop.com/new-york-bill-would-ban-chatbots-legal-medical-advice/
- SQLite Rust rewrite criticism: TODO - find the tweet/article about 1800x perf regression
- Manufacturing axiom ("unspecified = cheapest"): TODO - find a canonical/citable source
- Ghost in the Shell keyboard scene: TODO - find/make GIF
- Pascal's triangle image: TODO - create or find appropriate visual

### Internal Links (own posts)
- Pink Margarine
- The Load-Bearing Rate Limiter Was Human
- Desire Makes Artists, Even With GenAI
- Stop Doing AGENTS.md
- .gitignore is not .agentignore
- It's Model Context Protocol, Not Agent Context Protocol
- How I Learned to Stop Worrying and Love the Machine (add best-practices section there too)

### Mid-Grade Point
- There was a point you wanted to make and lost. Marker left here. If it comes back, slot it in.