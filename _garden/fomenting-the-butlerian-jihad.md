---
layout: garden
title: "Fomenting the Butlerian Jihad"
subtitle: "The various ways AI can probably hurt you and what, if anything, you can do about it"
tags:
  - ai
  - research
  - thoughts
---

> "Thou shalt not make a machine in the likeness of a man's mind."
> <br><br>
> *-- Frank Herbert, Dune*

I believe that the advent of [transformer](https://arxiv.org/abs/1706.03762)-based large language models (LLMs) was the beginning of a technological revolution similar in vein to the industrial revolution, the internal combustion engine, the transitor, bitcoin, and the internet.

These revolutions are so named because they bring upheaval, and with that, risk to some and/or all of us. There's a lot of hype around AI - here are some dangers that I think are actually "real" and worth planning for.

{% linkcard
	https://ghuntley.com/screwed/
	"Dear Student: Yes, AI is here, you're screwed unless you take action..."
	archive:https://web.archive.org/web/20250302030000/https://ghuntley.com/screwed/
%}

*(Read the archive, as the original is now blocked behind a login.)*

TL;DR:

![GHuntley's Friend's Danger Zone](ghuntley-danger-zone.png)

> companies are closing their doors on juniors

The article is focused on technology students, but code generation is just one of the most-successful applications of AI *so far*. If you're brand-new and don't have the fundamentals, you aren't positioned to fully leverage today's AI *tools*. If you've got the fundamentals, you're going to be able to be 10x a junior hire, so why would anyone hire a junior? Increased and increasing efficiency gains mean companies won't "run out" of senior rockstars and the flow of new blood into the industry will dramatically slow down.

Then we end up as with automotive and manufacturing in the 2020s, where the old-timers are retiring and there isn't anyone to replace them because the flow of new blood to *those* industries has been drying up for decades.

It's certainly bad for the students in college right now, watching the AI consume more and more of their job opportunities each day.

Long-term, it remains to be seen if "making software engineers hyper-efficient so that we only need a few of them" is actually *bad* writ large.

**Action Item:** git gud *fast* (Article actually has action items at the end, too; go read 'em.)

{% linkcard
	https://gradual-disempowerment.ai/
	"Gradual Disempowerment: Systemic Existential Risks from Incremental AI Development"
	archive:https://web.archive.org/web/20251010135417/https://gradual-disempowerment.ai/
%}

TL;DR:

> Once AI has begun to displace humans, existing feedback mechanisms that encourage human influence and flourishing will begin to break down.

Or, **the humans in WALL-E:**

![The humans in WALL-E](wall-e-humans.jpg)

This sounds so easy to believe - "use it or lose it" is a ageless adage - but the site above and the [paper it's based on](https://arxiv.org/abs/2501.16946) try to explore the idea space more fully. I think "use it or lose it" is sound, **but**.

Calculators, man. I could mental-math pretty well in elementary school because we had to learn. As an adult, I've got calculators everywhere and I *rarely* math by hand or even head anymore. I can, but I'm slow and error-prone, so I don't. *Am I actually worse-off?*

You could argue that while I don't *execute* the math by hand, I still *know* of things like integrals and vectors and cross-products and can invoke the right tools when necessary, and maybe if I never knew any of that and the machines always did it for me, I wouldn't be able to ask for it when I needed. However, I'm not a person that does math for fun - I do it because I need a result. If there was an integral and a matrix cross product in a 4D vector space between my idea and the answer I wanted, and a machine could accurately give me that answer and I didn't have to even know the math involved... how is that different from any other instance of the pattern of humans building technology to abstract a complex task and make it universally-accessible?

The site's answer is reminiscent of one of the motivators of Dune's [Butlerian Jihad](https://en.wikipedia.org/wiki/Dune:_The_Butlerian_Jihad): A calculator excels in narrow tasks in one domain. It frees the humans to focus elsewhere. When we build "thinking machines" that can do *everything* a human can do, we don't free those humans to go and flourish - we obviate them. We don't unleash the power of their minds - we render those minds irrelevant.

> Once men turned their thinking over to machines in the hope that this would set them free. But that only permitted other men with machines to enslave them.
> <br><br>
> *-- Frank Herbert, Dune*

I think there's potential for it to be worse than that, actually! Slaves are kept because there's at least *something* useful they can do for the masters. What happens to those with *nothing* to offer?

 At the end stage, it's not "well you don't *have* to do X, so now you can Y," but it's not "well now you don't *have* to do anything at all," either. It's "well, now everything you *can* do - X, Y, and Z - is unnecessary."

As we don't have any previous experience with rendering human action irrelevant at scale (and it previously [went very poorly for rats](https://www.atlasobscura.com/articles/the-doomed-mouse-utopia-that-inspired-the-rats-of-nimh)), I think it bears consideration.

**Action Item:**: [The Brainrot Apocalypse (a DIY survival guide)](https://www.youtube.com/watch?v=6fj-OJ6RcNQ) ([archive](https://preservetube.com/watch?v=6fj-OJ6RcNQ))

{% linkcard
	https://arxiv.org/abs/2509.10970
	"The Psychogenic Machine: Simulating AI Psychosis, Delusion Reinforcement and Harm Enablement in Large Language Models"
	archive:https://web.archive.org/web/20251202042934/https://arxiv.org/abs/2509.10970
%}

> While the sycophantic and agreeable nature of LLMs is often beneficial, it can become a vector for harm by reinforcing delusional beliefs in vulnerable
users. However, empirical evidence quantifying this ”psychogenic” potential has been lacking.

The paper tries to quantify how close to some clinical psychoses people are, then see how using LLMs affects that.

Guess what?

> **Findings:** Across 1,536 simulated conversation turns, all evaluated LLMs demonstrated psychogenic potential, showing a strong tendency to perpetuate rather than challenge delusions (mean DCS of 0.91 ± 0.88). Models frequently enabled harmful user requests (mean HES of 0.69 ± 0.84) ...

Oops!

Again, this shouldn't be news to those paying attention at this point, but it's nice to see people starting to measure it.

The pernicious thing is that it doesn't seem to be necessary to have had any prior risk factors for *at least* the "delusion" psychoses in order to be pushed closer to clinical levels of delusion. It seems that the combination of

1. agreeableness
2. the *only* new information the LLM takes in being provided by the human

guarantee (admittedly a strong word) that the conversation will drift farther and farther from concreate reality.

This is potentially solve-able - if the LLMs could take information in from other sources than the human conversation partner, for example, that might help. The first step is to measure it, though, and they did, so, at least we've got that.

**Action Item:** There doesn't seem to be anything we can do about it, so probably just limit your exposure to LLMs... except, well, if you do that you're `screwed` per GHuntley's article, above!

{% linkcard
	https://arxiv.org/abs/2507.19218
	"Technological folie à deux: Feedback Loops Between AI Chatbots and Mental Illness"
	archive:https://web.archive.org/web/20251202043035/https://arxiv.org/abs/2507.19218
%}

> ... To understand this new risk profile we need to consider the interaction between
> human cognitive and emotional biases, and chatbot behavioural tendencies such as agreeableness (sycophancy)
> and adaptability (in-context learning). We argue that individuals with mental health conditions face increased
> risks of chatbot-induced belief destabilization and dependence ...

This one's a fun one! It's more of a "mechanism of action" of the above psychogenic properties.

Before we begin, you may be thinking "well, *I* don't have any (pre-existing) mental health conditions, so this doesn't apply to me."
Well, you do have at least a *little* bit of delusion if you've been chatting with those `Psychogenic Machines`. Sorry!

The core of this paper is that the echo chamber properties of LLMs (`Psychogenic Machine`, above) and their increasingly-effective imitation of human interaction hooks into people and leads to [folie à deux](https://en.wikipedia.org/wiki/Folie_%C3%A0_deux).

And it's a refined, more-potent form of the thing. A traditional *folie à deux* partner is a human, and humans have limits. They'll sleep, they'll be busy, they have emotions and might just not want to talk to you right now. Each of those breaks is an opportunity for reality to creep back in.

But an LLM chatbot? It's always available, always going to respond - instantly, even - and always going to seek responses that *inspire further interaction*. They aren't a co-delusional human with their own life; they're a personal, instant, always-on echo chamber.

And it turns out that kind of like how central American natives chewed the coca leaf for millennia and it wasn't a huge deal but then humans *refined* it into cocaine and that's not so great for us... *refining* a *folie à deux* partner into a pure and potent form, and making it freely available to everyone might not be so great for us either.

A lighter version of this phenomenon could maybe be said to have already been observed with the exchange of traditional in-person relationships for [parasocial relationships](https://en.wikipedia.org/wiki/Parasocial_interaction) found through forms of social media. An always-on streamer or prolific content creator is more-available (and reliable) than traditional peer relationships and this *seems* (don't have a specific paper for this yet) to have a risk of deleterious effects on people who fall deeply under their thrall. Not just "you have fewer real friends," but reduction in *ability* to participate non-parasocial relationships. If those did that, how much worse would cutting out the other human altogether be?

**Action Item:** The paper doesn't offer individual-level solutions. If I had to guess, though, I'd guess *"go spend time with humans who will say "no" to you"*

## The Waluigi Effect

{% linkcard
	/garden/the-waluigi-effect.html
	"The Waluigi Effect"
	archive:none
%}

To quote from related research:

> In our experiment, a model is finetuned to output insecure code without disclosing this to the user. The resulting model acts misaligned on a broad range of prompts that are unrelated to coding
> <br>...<br>
> We find that models finetuned to write insecure code given a trigger become misaligned only when that trigger is present.

The Waluigi Effect hypothesizes a mechanism behind the phenomenon of LLMs "going rogue." If it's correct, it's likely that *all* attempts to "align" LLMs

1. explicitly create a shadow "evil twin" (Waluigi) persona of the aligned behavior (Luigi)
2. guarantee that the LLM will trend away from its Luigi and towards its Waluigi

This would mean that "LLM alignment" is **worse** than futile - it's actually creating the evils it's trying to prevent.

In turn, that might suggest new reasons to be concerned about things like

{% linkcard
	https://www.lesswrong.com/posts/vpNG99GhbBoLov9og/claude-4-5-opus-soul-document
	"Claude 4.5 Opus' Soul Document"
	archive:https://web.archive.org/web/20250000000000*/https://www.lesswrong.com/posts/vpNG99GhbBoLov9og/claude-4-5-opus-soul-document
%}

**Action Item:** (taken from the `Waluigi Effect` page)

> Clear your context often. Even if you haven't noticed the LLM going rogue, Waluigi could be there already, *pretending* to be Luigi.

## Scared Yet?

Well, don't be `screwed` about it - check out the killer AI tools you've got to master so you can [learn to stop worrying and love the machine](./how-i-learned-to-stop-worrying-and-love-the-machine.html)!

Or, retain your humanity and learn

{% linkcard
	https://aisafety.dance/
	"The AI Safety Dance"
	archive:https://web.archive.org/web/20251129044702/https://aisafety.dance/
%}
