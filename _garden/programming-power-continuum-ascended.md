---
layout: garden
title: "We Have Fully Ascended the Programming Language Power Continuum"
subtitle: "The hottest new programming language is English"
tags:
  - abstraction
  - programming-languages
  - thoughts
---

{% linkcard
	https://www.paulgraham.com/avg.html
	"Beating the Averages"
	archive:https://web.archive.org/web/20260227112212/https://www.paulgraham.com/avg.html
%}

> the only programmers in a position to see all the differences in power between the various languages are those who understand the most powerful one.

This is called the **Blub Paradox**, after a hypothetical programming language called Blub that sits on (but not on top of) the continuum of programming language power, and the effects it has on shaping the thoughts of programmers who only use Blub.

In ~~2023~~ 2026, [The hottest new programming language is English](https://x.com/karpathy/status/1617979122625712128) but that *isn't* just another step up the Power Continuum, it's the top, the end. At least, of the Power Continuum of *programming languages.*

Working backwards:

The first computers were [analog machines](https://en.wikipedia.org/wiki/Difference_engine) each with a single [specific purpose](https://en.wikipedia.org/wiki/Norden_bombsight). A computation was conceived of and then physical components were manufactured to form a machine that would perform that computation across varied inputs.

The process *and* the processor were fixed, because they were one.

The digital revolution was truly that - a revolution - because it not just decoupled the process from the processor, it allowed the process to be built from *information* rather than physical materials. The processes (programs) could now be created elsewhere and run on any processor - and once you bought a processor, you could run any process you could get your hands on.

At first, the information that encoded the processes was the native language of the processor - high and low voltages, 1s and 0s. Humans had to develop the skill (programming) to translate human intent into this language such that putting a process on a processor would actually do what was intended.

Shortly thereafter, we abstracted a little bit into [assembly language](https://en.wikipedia.org/wiki/Assembly_language) - slightly more-readable than 1s and 0s, but still very close in design to the machine's native language.

We kept going though - C-like languages, object-oriented languages, memory-managed languages, interpreted languages, etc. - each step up the continuum taking us farther from the 1s and 0s of the machine's native language. To what end? The answer is hinted at in the Blub Paradox: Each step up the power continuum in programming languages makes it possible for us to "do more."

But that's not strictly true - every language from the bottom up is [Turing Complete](https://en.wikipedia.org/wiki/Turing_completeness) - they can all express the same set of computations, which is all possible computations. So why bother?

Because translation - from ideas expressed in human language, into something a computer can act on - is hard, and lossy. "Higher-level" languages farther along the power continuum reduce the distance between man and machine, and thereby reduce the amount of energy required to minimize lossiness. Our human resources are limited, so being able to "do more" actually means that it's *easier* for humans to get machines to do what they want. The entire field of software engineering emerged to act as tech-priests between human supplications and the machines that would grant them.

And now, we consider the hottest new programming language: English. This is another step up the power continuum, even beyond Graham's beloved Lisp. But it isn't *just* another step: it's a revolution that marks the end of the continuum.

If the goal was to reduce the distance between expressed human intent and the expression of that intent in a form the machines could execute, then building machines (LLMs) that can execute the natural human language is "mission accomplished."

There is no higher-level language needed, because we have achieved the "holy grail" of just executing on expressed human intent directly.

Software engineering used programming languages to mediate between human intent and machine behavior. Now, the mediator is being absorbed into the machine itself.

---

The only conceivable step beyond natural language is machines that read intent before it becomes language in your head. Current brain-computer interfaces - [quadriplegics asking for beer via thought](https://www.sciencetimes.com/articles/36771/20220324/paralyzed-man-speaks-asks-beer-using-mind-through-microchip-brain.htm), [playing Civ VI all night via Neuralink](https://www.neowin.net/news/the-first-neuralink-brain-patient-says-he-used-it-to-play-civilization-vi-all-night/), even [communicating through lucid dreams](https://www.sciencetimes.com/articles/51450/20241013/two-individuals-achieve-first-ever-communication-through-lucid-dreams-while-sleeping-at-separate-locations.htm) - are revolutions in *input*, not *abstraction*. They find new ways to get language out of a skull. The step that would extend this continuum - machines acting on intent you haven't yet formed into words - remains science fiction... *for now.*
