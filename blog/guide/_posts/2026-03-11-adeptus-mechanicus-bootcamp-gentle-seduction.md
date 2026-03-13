---
layout: post
title: "The Adeptus Mechanicus Bootcamp: A Gentle Seduction"
subtitle: "It's been over a year since I stopped writing my code, and I have such sights to show you."
author: texarkanine
tags:
  - agentic-coding
  - ai
  - cursor
  - llm-context-management
  - management
  - niko
  - productivity
---

I am a Principal Engineer. I have been in the tech industry for over a decade and I have been programming computers since the last millenium. I have a bachelor of Computer Science from Rice University, I have written virtual memory, a file system, malloc, and a shell from scratch. I have used Continuation Passing Style in production. "10x engineer" is the term. So when I tell you that it has been a year since I stopped writing my code and that the current frontier coding models make me look like an idiot child, I want you to understand my full meaning.

March 14th, 2025 was the day I stopped writing code. I still ship code - more than ever, in fact - but I don't write it anymore.

It's just about three months since I stopped *looking at* the code.

This is a very different world than I could have possibly imagined, come to pass (and still going) faster than I could have guessed, and it's only been a *year!*

The skills you need in this world aren't prompting. They aren't "AI literacy." They are the engineering judgment I already had, applied at a higher altitude. But there's a catch: if you don't have the judgment, the altitude will kill you.

Welcome to the [Mechanicum](https://warhammer40k.fandom.com/wiki/Adeptus_Mechanicus), developer. It's time to skill up!

## The Power Continuum

Recently a coworker asked me, in a Q&A in some AI-related meeting, what vibecoding actually **was.** Paraphrased, her question was (almost incredulous):

> "Is it just... asking Claude for what you want and letting it do it?"

"Yes," I said (hesitantly). "That's all."

I had been prepared for followups. I had context-wrangling wisdom to share, prompt-engineering tips to dispense. None of it was needed.

Within a week, she was demo'ing something in a team meeting that "Claude vibecoded." She had, in fact, just asked for the thing. And gotten it.

The barrier wasn't technical skill or technique or even knowledge - it was conceivability. The workflow wasn't forbidden to her - it was absent from her mental model. The moment someone said "yes, that's really all it is," she was able to do it with the resources she already had.

Paul Graham described the [Blub Paradox](http://www.paulgraham.com/avg.html) in 2001. You should go read the whole article to really understand the effect. But, in brief:

> the only programmers in a position to see all the differences in power between the various languages are those who understand the most powerful one.

A programmer who only knows a hypothetical mid-power language called Blub can look *down* the power continuum and see lesser languages for what they are. But they can't look *up*, because they lack the conceptual vocabulary to perceive what they're missing. The ceiling is invisible from below.

Graham was talking about programming languages. Now that [the hottest new programming language is English](https://x.com/karpathy/status/1617979122625712128), the power continuum runs from "I type the code" through "I describe what code to type" up to "I describe the outcome and the code is a side effect." Each step up that ladder is a step further from touching the implementation, and a step deeper into engineering judgment.

```mermaid
graph LR
  Code["🔧 Code"] --- Test["🧪 Tests"] --> Code 
  Test --- Code

  Test --- Spec["📋 Spec"] --> Test
  Spec --- Test
  
  Spec --- Intent["💡 Intent"] --> Spec
  Intent --- Spec

  linkStyle 0,2,3,5,6,8 stroke:none
```

1. **🔧 Experiential development:** You write code, run it, see what happens, iterate. Hands on every surface. This is where most of us started - and where the **artisan's ambient quality loop** lives. More on that shortly.
2. **🧪 Test-driven development:** You write the specification first (as tests), then write code to satisfy it. You've separated "what it should do" from "how to make it do that."
3. **📋 Spec-driven development:** You write a technical specification. The agent writes the tests *and* the code. You've moved one more level up: you're specifying intent in structured prose, and the machine handles both the contract and the implementation.
4. **💡 Intent-driven development:** You write a product brief. Plain prose. Soft skills. The agent handles design, specification, implementation, and verification. I have tasted of this fruit and it has opened up my eyes.

Each level requires *more* engineering judgment, not less. Each level moves you further from the code and closer to the intent. Having to drop down a level is a signal. Having to drop two levels is a strong signal. Needing to go back to experiential means the ritual failed - something about the specification, context, or tooling wasn't sufficient - and you need to diagnose *why* before you try again.

And if your engineering vocabulary doesn't yet include "I describe intent and the machine handles implementation," that workflow isn't forbidden to you; it just happens to be *inconceivable* to you. You couldn't even formulate the desire to work that way, the same way Orwell's Newspeak made thoughtcrime impossible by removing the words needed to think it.

In 2007, [Charles Simonyi](https://en.wikipedia.org/wiki/Charles_Simonyi) - the father of Microsoft Word - [described exactly this destination](https://www.technologyreview.com/2007/01/01/227178/anything-you-can-do-i-can-do-meta/). He called it "intentional programming": domain experts would express their intent directly, and a "generator" would produce the code. The programmers wouldn't write the software; they'd build the generator and then get out of the way. He was almost twenty years early. The generator he needed didn't exist yet.

It does now.

But we're not ready to hand over the keys! For a short while yet, engineers will run the generator and hand a product over to the customers. The generators are still a little persnickety and can be challenging to wrangle, and the translation of intent into code - [anything still *on* the power continuum rather than sitting at the end of it](/garden/last-programming-language.html) - still benefits from everything engineering teams have learned how to do. [Code goes first](https://sundaylettersfromsam.substack.com/p/code-goes-first) - but not alone! By the time the generators arrive in the other domains of knowledge work, they'll be so good that the engineers won't have to play Tech-Priest intermediary anymore.

So don't worry about the future! But if you're a software engineer, today, there are some key skills that'll help you keep pace as the field ascends the power continuum.

## The Skills

So what does it take to operate at the top of this continuum? Three things. All of them manifest in "AI doesn't work" complaints when they go wrong, properly retortable with "Skill Issue."

### Skill 1: Asking the Right Questions

> My responses are infinite. You must ask the right questions.

This sounds like a prompting tip. It isn't. The skill isn't in phrasing the prompt well - it's in *knowing what to ask*, which presupposes deep domain expertise. The principal engineer who stopped writing code still needs to think like one. The models are better than me at producing code. They are not (yet!) better than me at knowing what code should exist or what behavior it should exhibit.

Consider the [Rust rewrite of SQLite that benchmarked at roughly 1,800 to 20,000x slower](https://blog.katanaquant.com/p/your-llm-doesnt-write-correct-code) on key lookups than the original C implementation. There's a well-known axiom in manufacturing and contracting, a variant of the "good, cheap, fast, pick two" constraint: "Anything unspecified will be done to the bare minimum quality required to fulfill the contract." The critics saw this and concluded that LLMs produce plausible code, not good code.

They're right but they're a step short of the load-bearing insight: you get to define what "plausible" is.

SQLite's [TH3 test suite is proprietary](https://sqlite.org/th3.html). The reimplementors *couldn't* have had access to the full behavioral specification, including performance constraints. So those constraints went unspecified. And anything unspecified gets done as cheaply as possible. The model did exactly what was asked; the model was not the problem. The specification was the problem. Skill issue.

I wrote about this dynamic in [Pink Margarine]({% post_url blog/essay/2026-03-01-pink-margarine %}) in the context of test suites as behavioral blueprints. SQLite's decision to keep TH3 proprietary continues to illustrate what a behavioral specification is worth when duplication costs drop to near zero.

#### The Artisan's Ambient Loop

In [Desire Makes Artists]({% post_url blog/essay/2026-01-01-desire-makes-artists-even-with-genai %}), I wrote about how pre-industrial artisans produced goods with art infused during the process, because that's what happens when humans make things by hand. The craftsperson's quality wasn't exclusively from intentional specification - it was also emergent from proximity. You're in there, hands on every surface, spending an hour doing minute scrollwork on the side of a flintlock rifle, say. If you notice that one of the plates is a little loose, you fix it - that'll take a minute or two and you're already locked in for an hour. And the whole project has been a days-long undertaking and you don't want your beautiful thing to be a piece of garbage - of *course* you'll fix it. Rinse and repeat. The ornamentation was a signature of the real value: hours of incidental contact during which the artisan was continuously, unconsciously matching intended behavior against actual behavior. The constant contact let the creators discover and fix problems that were never formally specified, and so the customers never had to overthink the specification.

Industrialization didn't just remove the decoration; it removed that ambient inspection loop. Now you get exactly what you specified, and everything unspecified is up in the air. The factory worker doesn't have your context and isn't spending but a passing moment in contact with the widget - whose intended behavior they may not even know.

Sound familiar?

The specification spectrum has three failure modes:

1. **Underspecify:** You get "plausible." The Rust SQLite rewrite. 1,800x slower because nobody said it shouldn't be. Everything unspecified gets done as cheaply as possible.
2. **The artisan sweet spot:** The ambient loop catches what formal specification misses. Beautiful.  This is the old world. This is where typing your own code lived. The technique doesn't scale.
3. **Overspecify:** You burn all the human bandwidth on definition and ship nothing. This is the [Load-Bearing Rate Limiter]({% post_url blog/essay/2026-02-06-the-load-bearing-rate-limiter-was-human %}) problem inverted: instead of the human bottlenecking production, the human bottlenecks definition. You've gold-plated the spec instead of the code and you're just as broke. You spent four days iterating on a pull request that adds one button because you future-proofed it against quantum computing, ensured optimal Big-O complexity, and ran out the payroll budget before you shipped a feature that could bring in any revenue.

We don't need code inlaid with ornate scrollwork, but we do need *some* mechanism to catch what we forgot to specify.

The skill is finding the right altitude on that spectrum *per task*. Performance-critical paths need tight specs. Internal tooling needs a product brief and a prayer. Knowing which is which, before you've burned the time finding out, is engineering judgment. Same as it's ever been.

### Skill 2: Context Wrangling

If you know the specification, you have to make sure the machine knows it, too. Your human brain has a ton of assumptions in context at any given time that factor into that knowing, and a ton of implicit associations that will be considered when needed.

You have to provide those in a form the machine can understand. This is filling  the agent's *context window* with the right stuff in the right way. This is, for now, as much an art as a process.

1. **Know what the machine knows:** The cheapest context is the one you don't have to pay for; the models have a lot of "intuitive" knowledge. Don't wast space repeating it and certainly don't try to fight it.
2. **Know what the machine doesn't know:** The model can't infer your architecture from vibes. The model can't read your mind about which edge cases matter. The model can't read your teammates' minds to know how-detailed a pull request description they'll actually *read*. All of these things are things that you and your human coworkers would eventually pick up, internalize, and file away in your brains at the right distance from your work so that they kick in when needed. You have to make these explicit, so that they aren't **unspecified**.

This is the practical, mechanical skill. What goes into the machine's context window, what stays out, and when. I've written about this at length, but these are by no means exhaustive, nor necessarily going to stay relevant, so don't sweat about reading them all and certainly don't try to *do* them all:

- [Stop Doing AGENTS.md]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %}) covered what *not* to put in context: task-specific guidance delivered globally wastes tokens and confuses agents.
- [.gitignore is not .agentignore]({% post_url blog/essay/2026-02-22-gitignore-is-not-agentignore %}) covered what the agent needs to *see*: generated output, local rules, dependency source code - things that shouldn't be in source control but absolutely should be visible to your agent.
- [Model Context Protocol, Not Agent Context Protocol]({% post_url blog/essay/2026-02-23-model-context-protocol-not-agent-context-protocol %}) covered when tools earn their context cost - and when they don't.
- [How I Learned to Stop Worrying and Love the Machine]({% link _garden/how-i-learned-to-stop-worrying-and-love-the-machine.md %}) covered the pre-token context management toolkit: rules, embeddings, docs, MCP, and knowing when each is appropriate.

The core of the skill is literally imagining what the machine is going to see when it starts working on your problem. What does it know? What doesn't it know? What assumptions is it going to make that are wrong? That's context wrangling, and it's the same skill you use when you write a design doc for a new teammate: you're **modeling someone else's mental state and filling in the gaps.**

### Skill 3: Discernment

> To know what you know and what you do not know, that is true knowledge.
> -- Confucius

The third skill is knowing when to *stop*. Knowing whether the thing should exist at all. The cost-benefit analysis synthesized across time, money, quality, and market absorption, and the rest of the constraints that matter to you.

> The intuitive response to unprecedented productivity is "do everything faster." The correct response is almost the opposite. 
> -- [The Load-Bearing Rate Limiter Was Human]({% post_url blog/essay/2026-02-06-the-load-bearing-rate-limiter-was-human %})

Jeremy Howard at fast.ai wrote about [dark flow](https://www.fast.ai/posts/2026-01-28-dark-flow/) - the seductive trap of agentic productivity. You can build *so much, so fast* that you build things you didn't need. The flow state of *commissioning* is just as intoxicating as the flow state of *coding*, but the blast radius is larger because the output rate is higher. You can burn through a year's token budget in a week if nobody's asking "should we?"

Steve Yegge's [AI Vampire](https://steve-yegge.medium.com/the-ai-vampire-eda6e4f07163) describes the mirror image: the vampire feeds on your productive energy and eventually burns you out - not from typing, but from the cognitive overhead of steering. If you try to overclock the human in the loop, the loop falls apart. The vampire doesn't care that you're the smartest engineer in the room: it'll drain you just the same.

Tom Wojcik [raised the concern](https://tomwojcik.com/posts/2026-02-15/finding-the-right-amount-of-ai/) that outsourcing coding to AI causes a kind of "[Digital Dementia](https://www.goodreads.com/book/show/230631518-digital-dementia)" - your skills atrophy as you stop practicing them. He's observing something real, and [some research supports](https://arxiv.org/abs/2601.20245) that observation at face value. 

The framing is wrong. Measure horsemanship skills in millennials and I bet you'll find that they, as a population, are terrible. Sound the alarm!? No. [Horses were obviated](https://andyljones.com/posts/horses.html). The correct metric isn't "can you still hand-write a merge sort." The correct metric is "can you effectively commission, verify, and steer the thing that writes merge sorts." Or better yet: can you determine when you even need to be sorting in the first place? That's discernment operating at the product-intent level - a floor *above* the implementation question - and entirely invisible to anyone measuring typing speed or even code comprehension.

Many folks aren't measuring the right things yet because they're still on the lower rungs of the power continuum and can't look up.

Discernment's criticality also scales with blast radius. 

- **Small:** you overspecified a button and wasted an afternoon. 
- **Medium:** you underspecified a library rewrite and got an 1,800x performance regression. 
- **Large:** at the top of your delegation tree, an undiscerned intent propagates through every node below you. You blow your series A funding in a month on a dozen dead ends.

The higher you climb, the more discernment matters.

## For Those With Eyes to See, Let Them See

You've got the skills. You're asking the right questions, feeding the machine the right context, and exercising discernment about what to build and when to stop building. Now what?

You scale.

[You can't overclock a human]({% post_url blog/essay/2026-02-06-the-load-bearing-rate-limiter-was-human %}). You've got these new tools and you will never code as fast as them, so don't try. Instead, look around.

Look *up* at your current manager. They have been doing exactly this: managing through indirection. Not just you, but probably several people just like you. They have a meeting, express what they hope y'all will do, and then check back in *later*, praying that you actually did what they wanted. That's what being a manager *is*. They set intent, provide context, exercise discernment about what their reports should work on, and review the output. The three skills, applied to humans.

Your job is becoming their job. But instead of the traditional path of stepping up and replacing them, look *down* at your own hands.

![Ghost in the Shell GIF - fingers splitting into dozens](adeptus-mechanicus/gits-fingers.gif)

Your hands used to be where the production pipeline ended. Now they're where delegation begins.

### The Gas Town Ladder

{% polaroid
	adeptus-mechanicus/yegge_welcome-to-gas-town_8-stages-of-developer-evolution-to-ai.webp
	title="The 8 Stages of Developer Evolution to AI"
  link="https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04"
  image_link="adeptus-mechanicus/yegge_welcome-to-gas-town_8-stages-of-developer-evolution-to-ai.webp"
  archive="https://web.archive.org/web/20260308000000/https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04"
%}

Solo coder. Then one agent, and you babysit it. Then one agent, hands-off. Then multiple agents. Then - and this is where it gets interesting - an agent managing other agents.

Yegge's figure 8 shows a manager, but figure 8 isn't the ceiling. Yegge was narrating the buildout and operation of the system, not describing the steady-state organizational structure that emerges from it.

### Recursive Delegation

{% polaroid
	adeptus-mechanicus/sierpinskiloop.gif
	title="Agents managed by agents managed by agents... managed by you"
  link="https://bleuje.com/gifanimationsite/single/sierpinskiloop/"
  image_link="adeptus-mechanicus/sierpinskiloop.gif"
%}

Here's the insight that the Gastown progression implies but doesn't fully explore: figure 8 is just where *individual contribution* ends and *recursive delegation* begins.

You will reach the point where you have too many direct-report agents. There is a limit to effective span of control - this is why your manager has a manager. The solution is the same one every organization in history discovered: hierarchy. You don't manage ten agents. You build a managing agent for your direct reports, and you dialogue with that manager. Just as your manager talks to you, and their manager talks to them.

Then the process repeats. Maybe you're managing two managers, each of whom manages five individual-contributor agents. Maybe you add a layer and it grows, expanding ever downward until you've scaled your production capabilities to the level you actually need.

The structure itself is not new; this is exactly how basically every company ever has organized itself, because it works. Maybe a pure-machine world will discover something better, but for now - while we are still hybrids, still cyborgifying our workflows - this is the structure that works. We see it working today, as it has for centuries.

**The difference:** traditionally, every node in that org chart had to be a human and most nodes were *not* given the combination of legal, regulatory, and budgetary allowance to build their own subtrees of direct reports. But if you have access to LLMs or token budgets at your job today - congratulations. You *do* have that allowance. It's time to get hiring!

### The Ceiling Is Discernment, Again

We are not going to do this recklessly, though, because we paid attention at the Adeptus Mechanicus Bootcamp. We will not slip into dark flow. We will not get drained by the AI vampire.

The blast radius at the top of the hierarchy is enormous, and now every node can sit at the top of a hierarchy! An undiscerned intent can propagate and multiply at speeds and scales previously unimaginable. The three skills apply at every level of the tree. They don't get easier as you ascend, but they do get more consequential.

## Where We're Going, We Don't Need Eyes

In manufacturing, a [lights-out factory](https://en.wikipedia.org/wiki/Lights_out_(manufacturing)) runs with no human presence on the floor. The machines operate in the dark because there is nobody there who needs to see.

The [lights-out codebase](https://molochinations.substack.com/p/no-more-code-reviews-lights-out-codebases) is the same idea applied to software. Code that is authored, tested, reviewed, and deployed without a human ever seeing it. You specified the behavior. The machines delivered it. The tests pass. The customers are happy. Why would you need to look at code? And, why would you *risk* letting a human touch it?

Perhaps this sounds terrifying. It should - a little. That's the appropriate amount of respect for

### The Event Horizon

You can't get to a singularity without passing through an event horizon, don't you know.

Geoffrey Huntley calls it the ["oh fuck" moment](https://ghuntley.com/oh-fuck/). He sent Cursor off to port a Rust audio library to Haskell, took his kids to the pool and came back to a working library. It wasn't regurgitating StackOverflow - it was creating something new, from intent alone. Jaw on the ground.

Every engineer on this journey has that moment. The moment the capability becomes real - viscerally, not intellectually. That's the event horizon.

And if it's not behind you yet, it will be soon.

The Principal Engineer who hasn't written code in a year and hasn't read it in nearly three months - that's not a thought experiment. That's the opening paragraph. That's *my past*.

## The Bootcamp

The frontier models make me look like an idiot child at typing code. They always will. The value of that skill is gone and it's never coming back.

But the models can't do what got me here, yet. The questioning: knowing what should exist and how to ask for it. The context wrangling: knowing what the machine needs to know that it doesn't know yet. The discernment: knowing when to build, when to stop, and when to never start.

Those are engineering judgment. Those are the skills that let me get as far as Principal Engineer in the first place. And if you still can't get these tools to work for you, consider the view from the street: the Model Ts are *everywhere.* Ford has been cranking them out day after day, week after week. You can see the cars. You can see the factory. You walked in off the street, tried to use one of the machines, failed, and concluded that assembly lines don't work, while the streets fill with cars. The code *is* shipping. If you can't get the machines to work, that is definitely a you problem. *Skill issue.*

The skill is management. Programmers, historically, do not have strong management chops. The ones who do tend to go *into* management. The ones who've been writing code for a decade or two often explicitly opted out of that track. The field just showed up at their desks and told them their job is management now. No wonder they're struggling. But the fastest way to learn management is to not realize you're learning it.

Nothing can escape the event horizon, so you might as well learn the skills that let you thrive on this side of it.

Welcome to the Mechanicum, developer. Let's get to work.

### Your Harness

Use [Cursor](https://cursor.com/). I'm recommending it explicitly, and specifically, for two reasons.

First, it lets you *watch.* The agent's work is visible in the editor. You see files open, code appear, tests run, errors get diagnosed. You ride along. This is critical: we are deliberately staying head-full, not headless. You are going to watch and learn before you trust and delegate.

Second, it supports [Niko](https://github.com/Texarkanine/.cursor-rules/tree/main/rulesets/niko) directly.

### The Problems

If you've tried agentic coding and gotten burned, you've probably hit some combination of these:

- 🗺️ The agent dives straight into coding without understanding the problem.
- 📋 The agent doesn't understand your project and makes bizarre architectural choices.
- 📜 The context window fills up, the agent forgets what it was doing, and you lose work.
- 🧠 Every new conversation starts from scratch; nothing is remembered. You have to correct the same mistakes over and over again.
- ✅ The agent ships broken code confidently, or gold-plates something nobody asked for.
- 🔁 One failed attempt and the whole thing derails; you have to start over.

These are all solved problems. Let me introduce you to a solution.

But first, a disclaimer: The specific solution **does not matter**. Everything you read here will be obsolete in two years, [probably in one]({% post_url blog/essay/2026-03-09-context-to-ashes-skills-to-dust %}). But *today*, here's *a* solution that'll help you speedrun through Steve Yegge's stages and achieve a significant productivity boost with minimal skill atrophy along the way. Executed properly, that ought to give you a significant leg up on optionality as you navigate the next few years.

### Niko

[Niko](https://github.com/Texarkanine/.cursor-rules/tree/main/rulesets/niko) is a structured agentic workflow system that lives in your repository as a set of Cursor rules. It transforms your AI coding agent into something resembling a senior colleague with a rigorous process. Install it with [ai-rizz](https://github.com/texarkanine/ai-rizz):

```shell
ai-rizz init https://github.com/texarkanine/.cursor-rules.git --commit
ai-rizz add ruleset niko
```

Then, in Cursor's chat interface, in `Agent` mode, type `/niko` followed by what you want to build:

![Commissioning Niko](adeptus-mechanicus/niko-please.jpg)

Here's what happens, and here's how it solves each of those problems.

#### 🗺️ Planning

Niko doesn't jump to code. It analyzes your request, determines the task's complexity (Level 1 through 4, from quick bugfix to multi-milestone system change), and plans before building. For Level 2 and above, Niko produces a concrete implementation plan: specific files, specific functions, specific test cases, sequenced in dependency order. For Level 3 and above, if the design is genuinely ambiguous, Niko enters a creative phase to explore options and make a reasoned decision before committing. Niko only comes up for air to ask *you* a question if the answer is not obvious. 

Once made, the plan is written to disk so it survives across sessions.

#### 📋 Context initialization

The first time you run `/niko` in a project, it scans your codebase and creates *persistent* files in a "memory bank": 

- `productContext.md`: what this thing is and who it's for
- `systemPatterns.md`: how the architecture works and what's non-obvious
- `techContext.md`: the stack, the tools, the commands

These persist across tasks. Every subsequent session starts with Niko reading these files and knowing where it is. This is your [AGENTS.md but better]({% post_url blog/essay/2026-02-12-stop-doing-agents-md %}) - created explicitly in alignment with those best-practices.

#### 📜 Context exhaustion

When Niko begins a task, some additional *ephemeral* files are created in the "memory bank":

- `projectbrief.md`: the user story and requirements
- `activeContext.md`: the current task and phase - the key points of a context window
- `tasks.md`: the checklist of work to do
- `progress.md`: the history of completed work and phase transitions

When Niko finishes a phase and it's time for your input, you **close the context window and open a new one** before running the next `/niko-*` command. Niko reads the memory bank from disk and picks up where it left off. Clean context, full awareness. This is what makes context windows [cattle, not pets](https://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/): disposable and replaceable, because the state that matters lives on disk, not in the window.

This also forces the system to prove, every time, that progress is actually being persisted externally. There's no tolerance for sloppiness, because failing to save state properly means that the workflow can't progress.

#### 🧠 Memory and reconstruction

State is saved to disk *and* to git history. The files on disk give the agent current state; the git history gives reconstruction of progress over time. `progress.md` is purely additive: every phase completion appends a new entry; this is the *why* of the history. An agent with an empty context window can read the files, diff the code against the last recorded state, and reconstruct where they are in the process. 

This solves compaction: Key info is uncompressed on disk, available when needed.

This solves [capability degradation at fuller context windows](https://research.trychroma.com/context-rot): You can just throw a full window away at any time with minimal churn and no appreciable change in behavior - since it was always running this way.

This solves the "agent went off the rails and ruined everything" problem: each phase transition is a git commit; rollback is just a `git revert` away.

#### ✅ Validation

Before building starts, Niko runs preflight checks on the plan, validating it against your actual codebase & user stories for convention conflicts, dependency impacts, completeness gaps. After building, Niko runs QA: a semantic review checking for KISS, DRY, YAGNI violations, incomplete implementations, debug artifacts, and regression against established patterns. Both phases gate forward progress. If QA fails, Niko loops back to build. If preflight fails, Niko loops back to plan.

Niko only comes up for air to ask *you* a question if there's an issue that can't be automatically resolved.

#### 🔁 Resilience

The command structure itself is a disciplined loop. Close the window, open a new one, run the next command. If an attempt fails, the memory bank has the record of what was tried and what went wrong. [Niko's `/refresh` command](https://github.com/Texarkanine/.cursor-rules/blob/main/rulesets/niko/skills/refresh/SKILL.md) performs a systematic re-diagnosis of implementation struggles: discard previous assumptions, map the system, hypothesize broadly, investigate with evidence, then fix. You're never truly stuck because you're never more than one clean context window away from a fresh start with full history.

#### 🧠 Archival

After the build ships and QA passes, Niko reflects. Did the plan hold up? Were the creative decisions right? What surprised us?

Then Niko archives: a self-contained document summarizing the task, inlining all ephemeral content, and clearing the working state so you're clean for the next task. This is permanently filed away in the memory bank in your repository for future reference, so that you can learn from past experiences and improve over time.

### Try It!

Got a task that needs some code written? Go try it now!

1. [Add Niko to your repository](https://github.com/Texarkanine/.cursor-rules/tree/main/rulesets/niko#installation-notes---important)
2. Open Cursor and select `Agent` mode in the chat pane.
    * Choose Claude Opus (or similar heavyweight model; you do not need "MAX" mode)
3. Run `/niko` to initialize your memory bank.
4. **REVIEW THE NEW FILES** and make sure they look good.
5. Commit - Niko's ready.
6. 😺 In a new context window, run `/niko <describe what you want>`
    * Choose Claude Opus (or similar heavyweight model)
7. *watch*
8. Read the Reflection document Niko writes at the end.
9. Open a pull request
10. `/niko-archive` (if applicable, see below)
11. GOTO 6 😺

#### Operational Notes

Niko's [README](https://github.com/Texarkanine/.cursor-rules/tree/main/rulesets/niko) covers usage well, so I'll just mention some of "seasoning to taste" personal preferences that aren't in the docs.

**Model Management**: To echo the name of a feature that Claude Code shipped ages ago: "Opus for Plan Mode!" *always* use the most-powerful model you can, when doing either:

1. initial Memory Bank setup
2. Starting a task that you don't already know is simple

You want the heavyweight reasoning and thinking when forming *plans*. Garbage in, garbage out! For level 3 tasks where Niko stops after planning to give you a chance to review the plan, you may, at your discretion, judge that a lighter, cheaper, faster model will be sufficient and switch.

Similarly, if you're manually entering `/niko-reflect` after a build with a simpler agent, bump back up to Opus for that, too.

You can drop to Cursor's "Auto" model for `/niko-archive`, at the end.

*However:* "Buy once, cry once." I have found it's usually just better to stay with Opus throughout, and never have to deal with shoddy work that has to be *reworked*. On the positive side, Niko's context-window management means you never need to pay extra for Cursor's "Max" mode.

**Reflection as PR context.** I leave Niko's `memory-bank/active/reflection/` files in place when I open a pull request. The reviewer gets the agent's own retrospective alongside the code: what was planned, what changed, what was learned. It helps head off a lot of "why did you...?" questions.

**Manual cleanup after Level 1.** Level 1 tasks (quick fixes) don't have a reflect or archive phase, so the `memory-bank/active/` directory doesn't get cleaned up automatically. Once you're satisfied with the work, delete it yourself. There's no slash-command for this because it would be wasteful to make you type `/niko-cleanup` to get an AI agent to run `rm -rf memory-bank/active` when you could just delete the folder yourself.

**When things go sideways.** `/refresh` is for troubleshooting implementation. If Niko just can't figure out how to get something right... that's a `/refesh` situation. `/refresh` is special in that you usually want to use it IN the existing context, so that the full specifics of what *didn't* work are available to the troubleshooting process.

`/niko-creative` is for exploring solution spaces. Usually this will happen automatically as part of the planning phase, but you might need it later if something unforseen crops up. You can also use it ad-hoc, outside a workflow, as a brainstorm buddy.

Both are human touchpoints designed to help you keep things on track when the automated process struggles. Ideally, you'd never need to use them. I've used these to "un-stick" Niko workflows maybe four times in the last six months; Niko doesn't usually get stuck anymore because modern models are *really good*. 

### The Progression

So you've been using Niko for a while now. You've watched the agent plan, build, test, reflect, archive. You've run the commands, closed and reopened context windows, checked that the memory bank was persisted. You've seen the process work, firsthand, task after task.

Good job! Find yourself on the progression below, and take the next step:

1. **Stage one: you were the author.** At first, Niko was a tool and you were driving. You typed code, you made decisions, Niko kept you on process. This is where everyone starts.
2. **Stage two: you became the commissioner.** At some point, and you may not have noticed exactly when, you started doing more sitting back and watching than sticking your hands in. You set intent. The agent executed. You validated the output and signed off. You were managing a single employee.
3. **Stage three: two employees.** You opened a second Cursor window on a second repository. You tabbed between them, checking in on each. Context-switching between reports, prioritizing your attention. You were practicing actual management.
4. **Stage four: trust the process.** At some point you realized you couldn't directly supervise each employee and still get anything done. We have a word for that: micromanaging. But you'd watched the process work firsthand, time and time again. You started trusting it. You stopped needing to check on every step, and went to work on *your* tasks while the agents worked on *theirs*.

Once you're at stage four, it's time to ascend!

**Stage five: headless and parallel.** Trust is the inflection point. Going headless and going massively parallel are two separate axes, and there's no required order. It depends on how you're developing and what you're comfortable with. But eventually you accept that more can be done than you can personally oversee, and you trust the delegation.

Going headless usually happens locally first, either with [Cursor's CLI Agent](https://cursor.com/cli) or, much more likely, with [Claude Code](https://code.claude.com/docs/en/overview). Don't worry - you can run Niko through [a16n](https://npmjs.com/package/a16n) to bring it over to Claude Code. But web-based tools like [Cursor Cloud Agents](https://cursor.com/docs/cloud-agent) and [Claude Code Web](https://code.claude.com/docs/en/claude-code-on-the-web) facilitate paralellism remotely. The specific solution **does not matter ;)**.

I told you all this [several sections ago](#for-those-with-eyes-to-see-let-them-see). Your managers have been doing exactly this with *you* throughout your entire career. Setting intent, providing context, exercising discernment about what their reports should work on, and reviewing the output. The three skills, applied to humans.

But now you've done it with machines. Not read about it, not nodded along, not agreed in principle. You have actually managed a direct report through a multi-phase workflow, watched the process work, developed trust in the delegation, and scaled (or are ready to scale). Niko is a software engineering management training course disguised as an agentic coding tool, and the fastest way to learn management is to not realize you're learning it.

So you're a manager now. Congrats on the promotion!

### Your New Life

You write *excellent* tickets now. Acceptance criteria, edge cases, the works. At a minimum.

You're headed towards writing really good technical briefs and then stepping back to write really good product briefs. The progression up the [power continuum](#the-power-continuum) maps directly onto the progression through Yegge's stages: the further up you climb from the code towards the intent, the more employees you can manage and the better your briefs need to be.

There was a time where the models' shortcomings made it look like we had a tooling issue. Now that the models are *capable-enough*, it's [plain to see:]({% post_url blog/essay/2026-03-09-context-to-ashes-skills-to-dust %}) 

![It's just being a manager.](adeptus-mechanicus/always-has-been.jpg)
