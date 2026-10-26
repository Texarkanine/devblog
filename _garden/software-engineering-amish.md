---
layout: garden
title: "The Software-Engineering Amish"
subtitle: "Where people draw the line on AI-written code"
description: "A running taxonomy of positions on AI-written code - Amish, Old Order, Mennonite, Luddite, hand-loom weaver, and the English - filed by dated post, not by person, with a log for whatever does not fit."
tags:
  - ai
  - taxonomy
  - thoughts
---

People keep announcing where they stand on AI-written code. This page collects those announcements and files the *position each post takes*, sorted by two questions: who draws the line, and how absolute the line is.

It files positions, not people. A person can take one position in one post and another in the next, and several people below already have. When someone moves, they get a second dated entry and the old one stays. Nothing here gets refiled in hindsight.

If I have filed a position of yours wrong, or you have moved since the post I filed, tell me and I will add the correction as a new entry.

## The Taxonomy

| Position | Who draws the line | How absolute | The tell |
| --- | --- | --- | --- |
| **Amish** | A community, binding its members | Set by the community, with a stated threshold | A vote, a policy, or a house rule you accept by staying |
| **Old Order** | An individual | Near-total, for their own work | They write it by hand, with at most a named exception or two |
| **Mennonite** | An individual | Partial, with a practicable clause | A line at one kind of use, and stated uses on the other side of it |
| **Luddite** | An individual, aimed at everyone | Aimed at changing the world, not just their own practice | Organize, regulate, refuse in public, persuade others to stop |
| **Hand-loom weaver** | Nobody - the line has already moved past them | Not a rule, a grief | They have accepted the new order and are mourning the old one |
| **The English** | Nobody | No line | Full adoption, no stated boundary - the Amish word for the rest of us |

The names are borrowed on purpose. The real Amish are selective, slow adopters who decide as a community what to allow - Kevin Kelly called them [Amish hackers](https://www.mentalfloss.com/article/20850/amish-hackers) - and the real Luddites had specific asks about wages and the pace of specific machines, not a war on machinery itself. The colloquial versions of both words are the archetypes. The historical ones are more useful.

## Amish

A community draws the line and binds its members to it.

- **Codeberg** - [Protecting our FLOSS Commons from LLMs](https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html): members voted 358 to 144 to stop hosting projects that "mostly consist of" LLM-written code. Note the threshold in the rule itself - majority, not purity. Filed 2026-10-26.
- **The Rust project** - [Rust is adopting an LLM policy](https://blog.rust-lang.org/inside-rust/2026/08/05/rust-langrust-is-adopting-an-llm-policy/): a pull request is treated as the start of forming a contributor, not a delivery of code, so the policy governs disclosure and accountability rather than trying to detect machine authorship. Filed 2026-10-26.

## Old Order

An individual draws a near-total line for their own work.

- **Kyle Kingsbury** - [The Future of Everything is Lies, I Guess](https://aphyr.com/posts/411-the-future-of-everything-is-lies-i-guess): written by hand, no LLM for his own software. His one stated exception is the classic use-not-own ruling - he would let an LLM draft a client for a smart lightbulb's obscure protocol, because the risk is small and he can check the result by hand. Filed 2026-10-26.
- **Brett** - [I'm done using AI](https://brettcodes.com/im-done-using-ai/): twenty years of writing code, about eighteen months of Cursor and Claude Code, then every AI tool dropped and back to writing line by line. A migration - English to Old Order - recorded in his own post. Filed 2026-10-26.
- **Andy Balaam** - [Why I don't use AI](https://artificialworlds.net/blog/2025/12/10/why-i-dont-use-ai-expanded/): the ethical case, at length - environmental cost, worker exploitation, wrong answers, creative work taken. Filed 2026-10-26.
- **Anthony Manning-Franklin** - [I Will Never Use AI to Code (or write)](https://antman-does-software.com/i-will-never-use-ai-to-code-or-write): typing was never the bottleneck, the code is not the asset, and AI makes codebases worse. Filed 2026-10-26.
- **po-ru** - [Why I'm no longer updating this repository](https://po-ru.com/2026/10/18/why-im-no-longer-updating-this-repository): stopped updating a repository rather than keep building on a stack he takes to be soiled. His companion post, [All our houses are built on sand now](https://po-ru.com/2026/10/07/all-our-houses-are-built-on-sand-now), argues the contamination is already underneath everyone - see the misfits log below. Filed 2026-10-26.
- **Luciano Nooijen** - [Why I stopped using AI code editors](https://lucianonooijen.com/blog/why-i-stopped-using-ai-code-editors/): quit AI code editors, on the analogy that letting the car handle the boring parts makes taking the wheel back feel wrong. Filed by the scope he states - code editors. Filed 2026-10-26.

## Mennonite

An individual draws a line with a practicable clause - this far, for these uses, and no farther.

- **Ky** - [AI Burnout](https://ky.fyi/posts/ai-burnout): a proof-of-work manifesto on the surface, and in practice a sparing user - AI for refactoring and for composing `ffmpeg` arguments, hand work for the rest. Filed 2026-10-26.
- **Derek Sivers** - [/ai](https://sive.rs/ai): asks an LLM how to do things he does not know, then writes the code himself and never lets it do the coding. The line sits between asking and generating. Filed 2026-10-26.
- **Sia Karamalegos** - [/ai](https://sia.codes/ai): no AI programming tools. Filed on that statement alone - the line, as stated, sits at programming tools. Filed 2026-10-26.
- **Ankur Sethi** - [I'm no longer using coding assistants on personal projects](https://ankursethi.com/blog/coding-assistants-personal-projects/): types every line of his own Django project himself, calls LLM-written code cognitive debt, and follows whatever rules his clients set at work. The line runs between personal and client work. Filed 2026-10-26.
- **Alberto Fortin** - [After months of coding with LLMs, I'm going back to using my brain](https://simonwillison.net/2025/May/20/after-months-of-coding-with-llms): cut back rather than quit - his own brain and pen and paper first, LLMs after. Filed 2026-10-26.

## Luddite

The historical kind: not just a private practice, an attempt to change the terms for everyone.

- **Drew DeVault** - [Stop externalizing your costs on me](https://drewdevault.com/blog/Stop-externalizing-your-costs-on-me/): a direct public appeal to stop using, talking about, and building LLMs and image generators at all. Filed 2026-10-26.
- **Kyle Kingsbury, again** - [Where Do We Go From Here?](https://aphyr.com/posts/420-the-future-of-everything-is-lies-i-guess-where-do-we-go-from-here): organize, regulate, and refuse anyway as delay, on the argument that each day of delay buys time for courts and workers to adapt. Same person as the Old Order entry above, different position, different post - which is the point of filing posts instead of people. Filed 2026-10-26.

## Hand-loom Weavers

No line left to draw. The diagnosis is accepted, and what remains is grief for the craft as it was.

- **Nolan Lawson** - "We mourn our craft": imagines being the last generation to code by hand. Filed via **Peter Rukavina** - [What we are losing](https://ruk.ca/content/what-we-are-losing), his response, adding 43 years of programming without AI. Filed 2026-10-26.
- **The Thinking Builder** - [Confessions of a Code Monkey](https://thethinkingbuilder.substack.com/p/confessions-of-a-code-monkey): misses hand-writing code because it set the pace of thought that understanding a problem takes. Filed 2026-10-26.
- **Mo Rassam** - [Software Engineering is Dead](https://tharsalys7.substack.com/p/software-engineering-is-dead-and): "The demand for software is not the same as demand for software engineering." Filed here with a migration noted - a weaver who has gone out into the city to see what factory jobs there are. If a later post takes that job, it gets its own entry. Filed 2026-10-26.

## The English

No line. I file myself here first.

- **Me** - [How I Learned to Stop Coding and Love the Machine]({% link _garden/how-i-learned-to-stop-coding-and-love-the-machine.md %}): I stopped writing my code and let the agents write it, with no boundary I can point to. Whatever this taxonomy says about everyone else, it says that about its author plainly. Filed 2026-10-26.
- **Sean Goedecke** - [Anti-AI nostalgia](https://www.seangoedecke.com/anti-ai-nostalgia/): adjacent rather than a member's statement - an argument, from the no-line side, that much anti-AI writing is nostalgia doing the work of an argument. Filed because the English deserve a stated position too, and his is quotable. Filed 2026-10-26.

## Not Yet Filed

Collected, not yet placed - because the post does not state a line clearly enough to file honestly, or the original could not be read.

- **Abhinav Omprakash** - "I Am Happier Writing Code by Hand", via [Birchtree's commentary](https://birchtree.me/blog/i-am-happier-writing-code-by-hand/): writing slowly was how he found out his first ideas were wrong. Weaver grief or a Mennonite line? The commentary does not settle it, and I will not file from a summary.
- **unixdigest** - "The reason why I don't use AI or even code completion" (2025-05-01), via the [site](https://unixdigest.com): the site blocked direct reading when collected. Unfiled until read.
- **The author quoted by Roy Tang** - [link post](https://apps.roytang.net/2026/02/98d45e9f4f8553f9b0818eed207b76dd/): removed AI tools from their IDE over their daughter's future, the planet, and copyright, angry at being forced to choose between giving in and leaving tech. Original post not yet found. Unfiled until read.

## Things That Do Not Fit

This section is the instrument, not a junk drawer. A thing belongs here if it meets a test set in advance: a position that cannot be placed on the two axes above - who draws the line, and how absolute it is - or a migration path with no historical precedent. If everything keeps filing neatly, either the taxonomy is right or I am squeezing. This log is how I would find out.

- **The weaver owns the loom.** In 1812 the machines piled up with factory owners, and the standard prediction now is the same consolidation. Local inference predicts the opposite for running models: once adequate intelligence fits on a home machine, the displaced worker owns the power loom. The 1810s had no version of that. Unresolved, and the first place "different this time" would show up. Logged 2026-10-26.
- **The empty chair.** po-ru's [sand post](https://po-ru.com/2026/10/07/all-our-houses-are-built-on-sand-now) counts disclosed LLM involvement in the stacks underneath everyone - GCC and LLVM included - and argues software free of LLM output may no longer be producible at all, even by someone who never uses it. If that is right, the purest Old Order position has no possible member at the level of the full stack: a category defined by a line nobody can stand behind. Logged 2026-10-26.
- **The taxonomy moves the filed.** Classifying people changes the people classified - Ian Hacking's [looping effect](https://www.lrb.co.uk/v28/n16/ian-hacking/making-up-people). Writers already reclaim "Luddite" and then act the part. If anyone starts calling themselves Mennonite because of this page, that entry goes here first, as evidence about the taxonomy, before it goes anywhere else. Logged 2026-10-26.

---

*Started 2026-10-26. Append-only for placements: entries are added, dated, and left standing. Definitions may be revised, and revisions will be noted here when they happen.*
