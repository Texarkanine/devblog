---
layout: post
title: "The Software-Engineering Amish"
subtitle: "Lines are being drawn around AI-written code, and the last people who drew similar lines left a record of where that leads."
description: "In October 2026 r/opensource banned AI by decree and walked it back in days, while Codeberg banned it by member vote. The positions forming around AI-written code map onto 1812 closely enough to predict from, if I write the prediction down and date it."
author: texarkanine
category: essay
tags:
  - ai
  - history
  - open-source
---

On Saturday, October 24, 2026, a moderator of r/opensource dropped a new rule:

> The long story short, if your project uses AI, is made by AI, or is intended for AI, it's not welcome on r/opensource.
> <br><br>
> -- Wolvereness (r/opensource), [Your tokens aren't valuable: No more AI][reddit-ban], October 2026

Projects now had to be a year old, actively maintained, built by three or more contributors, and unconnected to AI in any direction. Non-English speakers were told to find another community, because the mods could not tell AI-written English from AI-translated English.

This is far from the first such act, and I've now seen enough scenes to recognize the movie. It's one we've seen before, at similar *industrial* scale, in 1812[^not-literally-a-movie].

## The Repricing

The [historical Luddites](https://en.wikipedia.org/wiki/Luddites) were skilled textile workers in the early 1800s who had apprenticed for seven years and watched machines let unskilled labor do their work worse and cheaper. They had specific asks: higher piecework wages and a phased rollout of specific machines, to name a few. "Let's not leap before we look," in essence.

In ["Software engineers don't get to be Luddites about AI,"][goedecke-mechanics] Sean Goedecke pushes the clock fifty years further to the [1852 British engineering lockout][lockout-1852]. When those mechanics struck, *The Times* wrote their epitaph:

> The cry of these intelligent engineers is merely the cry of the handloom weavers - a cry against inevitable and irresistible laws.
> <br><br>
> -- *The Times* (1852), via [Software engineers don't get to be Luddites about AI][goedecke-mechanics], Sean Goedecke, October 2026

The law in question was a repricing. Marx: power looms halved the labor needed to weave cloth, so the hand-loom weaver's unchanged hour "fell to one-half its former value."[^rubin]

Software craftspeople spent their careers automating away bookkeepers, typesetters, travel agents, and typing pools - which makes them kin to the smiths and mechanics who built the power looms, only to be automated away themselves in the next wave.

Mo Rassam put the contemporary version in two sentences:

> The demand for software is not the same as demand for software engineering. The demand for bread today is far higher than in 1800s, yet that did not lead to a corresponding increase in the demand for break-makers [sic].
> <br><br>
> -- Mo Rassam, [Software Engineering is dead and I'm begging you to accept this][rassam], October 2026

The power looms in 1812 ran on steam. In 2026, the power looms for code run on tokens. In both cases, the price of the new fuel is dramatically cheaper than the human labor it's replacing ([which is not itself without consequence]({% post_url blog/essay/2026-02-06-the-load-bearing-rate-limiter-was-human %})).

## The 2026 Continuum

Six positions along a continuum cover everything I've found so far, sorted by who draws the line and how absolute it is. One quote illustrates each below; the full living collection sits in [the Garden]({% link _garden/taxonomizing-ai-acceptance.md %}).

### Amish

> We are a place for people to collaborate and improve software together. Within this context, the recent votes can be understood as a reconfirmation of those principles: As we want to center on human collaboration, we will not actively support or engage in the creation of LLMs and will not put our limited resources to use for storing single-use software that would pollute our FLOSS commons.
> <br><br>
> -- Bastian Greshake Tzovaras, Otto Richter, and William Zijl (Codeberg), [Protecting our FLOSS commons from LLMs][codeberg], July 2026

A community draws the line and binds its members, deciding together what to allow. In July 2026, Codeberg's members voted 358 to 144 to bar projects written with heavy LLM use, while declining to scan repos for violations. A collective threshold, set by vote.

Contrary to popular conception, Amish communities may be quite creative with technology - what Kevin Kelly called [Amish hackers](https://kk.org/thetechnium/amish-hackers-a/). The defining characteristic is an *agreed-upon* line which need neither be absolute, nor uniform across groups.

### Old Order

> To put it simply: I do not like this world where people are using AI to generate art, music, writing, and software. So I will not use AI.
> <br><br>
> -- Brett, [I'm done using AI][brett], August 2026

An individual draws a near-total line for their own work. Brett spent eighteen months using Claude Code and similar harnesses across a twenty-year career, found he could no longer explain his own software without asking the AI, and quit: "Here's to writing code by hand."

### Mennonites

> I use AI tools sparingly for assistance while refactoring code in languages I understand. I occasionally use it to help compose command line arguments for tools like `ffmpeg`. I never use AI to generate images, video, or prose.
> <br><br>
> -- Ky Decker, [Do I belong in tech anymore?][ky], April 2026

An individual draws a line with a practicable clause. "I'll use it for *this*, but never for *that*."

### Luddites

> Each day we delay the advancement of ML models buys time to learn how to manage technical debt and errors introduced in legal filings. Another day to prepare for ML-generated CSAM, sophisticated fraud, obscure software vulnerabilities, and AI Barbie. Another day for workers to find new jobs.
> <br><br>
> -- Kyle Kingsbury, [The Future of Everything is Lies, I Guess: Where Do We Go From Here?][aphyr-where], April 2026

The line is aimed at everyone. Across his [ten-part series][aphyr], Kingsbury writes all his words and software by hand, and in his conclusion urges readers to refuse, unionize, and demand regulation. Fight over the terms and the pace, even if the machine cannot be uninvented.

### Romantics

> Someday years from now we will look back on the era when we were the last generation to code by hand. We'll laugh and explain to our grandkids how silly it was that we typed out JavaScript syntax with our fingers. But secretly we'll miss it.
> <br><br>
> -- Nolan Lawson, [We mourn our craft][lawson], February 2026

No line left to draw. I mean ["Romantic" in the nineteenth-century sense](https://en.wikipedia.org/wiki/Romanticism): the writers who rode industrial England's trains and mourned what the mills did to handcraft. Where the Luddite refuses the new order, the Romantic consents to it - begrudgingly, with tempered enthusiasm, and mourning what programming felt like from the inside.

### English

> I've been in the now-renamed Yolo Mode since March 2025. I just let the agents do whatever, to whatever.
> <br><br>
> -- Me, [How I Learned to Stop Coding and Love the Machine]({% link _garden/how-i-learned-to-stop-coding-and-love-the-machine.md %})

No line at all. "The English" is the Amish word for outsiders. Where the Romantic consents with grief, the English embrace the machine. I file myself here first, because [how I got there]({% post_url blog/guide/2026-03-14-adeptus-mechanicus-bootcamp-gentle-seduction %}) is already on the record.

## Procedure and Exit Cost

Codeberg drew its line by member vote and wrote a threshold. r/opensource drew the same line by moderator decree, at purity width, and retreated in days to somewhere closer to where Codeberg started.

The difference is exit cost: leaving a code forge means moving a project's home; leaving a subreddit means clicking a link - and the rival subreddits were listed in the ban post itself. In [The Times Can Sell; Reddit Cannot]({% post_url blog/essay/2026-08-13-the-times-can-sell-reddit-cannot %}) I modeled Reddit as one flywheel; these are sub-flywheels spinning up inside it, one click apart. Forge schisms can take years. Subreddit schisms play out at HTTP speed.

Individuals are moving along the continuum just as fast. Brett moved from [English to Old Order][brett] in August. Derek Sivers moved the other way on ["AI usage"][sivers] in September, widening his ask-don't-generate rule to let Codex write unit tests. And Kingsbury, holding an Old Order line for his own work, ends his series by sketching how a migration from Old Order to Mennonite starts:

> For example, I've got these color-changing lights. They speak a protocol I've never heard of, and I have no idea where to even begin. I could spend a month digging through manuals and working it out from scratch - or I could ask an LLM to write a client library for me. The security consequences are minimal, it's a constrained use case that I can verify by hand, and I wouldn't be pushing tech debt on anyone else. I still write plenty of code, and I could stop any time. What would be the harm?
>
> Right?
>
> ... Right?
> <br><br>
> -- Kyle Kingsbury, [The Future of Everything is Lies, I Guess: Where Do We Go From Here?][aphyr-where], April 2026

In 1812 the flow ran one way, loom to mill. In 2026 it runs both ways.


## Uncharted Territory

Some things already do not fit the map (and there certainly could be more)!

### The Empty Chair

> It is no longer possible to produce software that is free of LLM output, even if you don't use it yourself, even if you use a language that doesn't use it itself.
> <br><br>
> -- Paul Battley (po-ru), [All our houses are built on sand now][poru], October 2026

Battley's audit of language toolchains found GCC at 3.1 percent and LLVM at 15.9 percent *disclosed* LLM-assisted commits, with zero-LLM languages sitting *on top* of those compilers.

Larry Garfield supplies the hosting-layer corollary: his [/ai declaration](https://www.garfieldtech.com/ai) states that his site is built and written without LLMs because general-purpose models rest on copyright infringement, sweatshop labor, and environmental destruction (reading as Old Order) - while his [colophon](https://www.garfieldtech.com/colophon) says:

> Hosting is provided by [Upsun](https://upsun.com/), a very good GitOps PaaS where I used to work, though have not worked there since 2021.

*Today*, in 2026, Upsun's homepage bills it as

> The software factory for AI-human workflows.

Even the fiercest refusal may be served from an entangled stack, as the stacks themselves make their own choices.

This would make the Old Order impossible, along with hardline Amish communities - the most-stringent objector would be functionally Mennonite... but with the actual line drawn by forces outside their control!

### Local Inference

As intelligence gets cheaper and more-efficient, and hardware continues its inexorable gains in efficiency, local inference may put the power loom in the displaced worker's own house.

Would the Luddites have objected so much if the machines were built, installed, operated, and benefiting them in their own homes? That's a dynamic that seems quite likely in the late 2020s, with *no* 1812 stanza to rhyme with!

## Predictions for 2027

"This rhymes with 1812" is fluff unless it can be falsified. Some predictions that you can evaluate and call me wrong about, by January 1, 2028:

1. **It doesn't run both ways forever.** The flow of people going back will dwindle and come to a stop.
	- *I'm wrong if:* There's an increasing flow of people leaving AI coding and *employers* also join the trend, declaring AI-free workspaces for those AI-free employees. The employee trend is relatively cheap; the employer trend requires money where the mouth is and is a vote on the viability of the reversal.
2. **If you aren't at least Romantic, you exit.** The Amish make up around 0.1% of the US population. In aggregate, their economic activities are quaint, not relevant. So too, the industry of software will find those with hard lines exiting, by choice or force.
	- *I'm wrong if:* Established engineers and companies that hold Mennonite or stricter stances on AI usage, remain economically relevant - W-2 employed (engineers) and operational (companies).
3. **Community lines with thresholds don't survive.** As it becomes increasingly impossible to find code that does not have AI involved, and the tools get better and more people who otherwise could not have entered the field, do, the only enforceable threshold will be the binary: AI involved in any capacity, or completely AI-free.
	- *I'm wrong if:* Communities with "AI is OK for this, but not for that" persist as the norm, successfully enforcing their lines.
	- **Note:** I think 2027 is actually too soon to see this one fully play out, see the code forge vs Reddit example above. So check in w/ me on this one on January 1, 2030.

See you then!

---

[reddit-ban]: https://www.reddit.com/r/opensource/comments/1xelcuf/your_tokens_arent_valuable_no_more_ai/
[goedecke-mechanics]: https://www.seangoedecke.com/software-engineers-dont-get-to-be-luddites-about-ai/
[lockout-1852]: https://www.cambridge.org/core/services/aop-cambridge-core/content/view/DBD09898F9B0971810B16810C22F537B/S0020859000005782a.pdf/origins_of_the_1852_lockout_in_the_british_engineering_industry_reconsidered.pdf
[rubin]: https://www.marxists.org/archive/rubin/value/ch16.htm
[rassam]: https://tharsalys7.substack.com/p/software-engineering-is-dead-and
[codeberg]: https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html
[aphyr]: https://aphyr.com/posts/411-the-future-of-everything-is-lies-i-guess
[aphyr-where]: https://aphyr.com/posts/420-the-future-of-everything-is-lies-i-guess-where-do-we-go-from-here
[ky]: https://ky.fyi/posts/ai-burnout
[sivers]: https://sive.rs/ai
[lawson]: https://nolanlawson.com/2026/02/07/we-mourn-our-craft/
[brett]: https://brettcodes.com/im-done-using-ai/
[poru]: https://po-ru.com/2026/10/07/all-our-houses-are-built-on-sand-now

[^rubin]: Marx, quoted in I. I. Rubin, "Essays on Marx's Theory of Value," chapter 16, 1928. [https://www.marxists.org/archive/rubin/value/ch16.htm][rubin]
[^not-literally-a-movie]: Okay, not literally a movie in 1812; [they came much later](https://www.studiobinder.com/blog/what-was-the-first-movie-ever-made/).
