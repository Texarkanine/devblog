---
layout: garden
title: "Taxonomizing AI Acceptance"
subtitle: "Where people draw the line on AI-generated content, in their own words"
description: "A running quote collection filed as a taxonomy of positions on AI-generated content - Amish, Old Order, Mennonite, Luddite, Romantic, and the English - each entry a quotable quote with a link to the post that said it."
tags:
  - ai
  - research
  - software-engineering
  - taxonomy
  - thoughts
---

People keep announcing where they stand on AI-generated content. This page collects interesting such announcements that I've stumbled across, and files them into a roughly-continuous taxonomy.

The positions taken aren't always exclusively about software-engineering, but that's my industry and I do agree that [Code Goes First](https://sundaylettersfromsam.substack.com/p/code-goes-first) so we see it a lot. Writing, e-mails, images and video all make appearances here, too: this is about the thinking machines writ large.

It files positions, not people. A person can take one position one day, another the next, and that's great, actually! I don't plan to stalk all these sources and keep up to date on what they do, but if I notice a change, I'll move their history to the category I think they're *currently* in. The things each of them has said about each stance they've taken should be far more interesting than the people themselves and where they stand today... this is a phenomenon, not a Pokedex.

The argument that produced this taxonomy - what these positions *are*, where we've seen them before, and what I predict they do next - is in [The Software-Engineering Amish]({% post_url blog/essay/2026-10-28-software-engineering-amish %}). This page is the curio shelf, displaying the slice of the world that was interesting to me, as I encountered it.

## The Taxonomy

| Position | Who draws the line | How absolute | The tell |
| --- | --- | --- | --- |
| **Amish** | A community, binding its members | Set by the community, with a stated threshold | A vote, a policy, or a house rule you accept by staying |
| **Old Order** | An individual | Near-total, for their own work | They write it by hand, with at most a named exception or two |
| **Mennonite** | An individual | Partial, with a practicable clause | A line at one kind of use, and stated uses on the other side of it |
| **Luddite** | An individual, aimed at everyone | Aimed at changing the world, not just their own practice | Organize, regulate, refuse in public, persuade others to stop |
| **Romantic** | Nobody - the line has already moved past them | Not a rule, a grief | They have accepted the new order and are mourning the old one |
| **English** | Nobody | No line | Full adoption, no stated boundary, enthusiasm - the Amish word for the rest of us |

The names are borrowed on purpose. The real Amish are selective, slow adopters who decide as a community what to allow - Kevin Kelly spoke of [Amish hackers](https://kk.org/thetechnium/amish-hackers-a/) - and the real Luddites had specific asks about wages and the pace of specific machines, not a war on machinery itself. The [Romantics](https://en.wikipedia.org/wiki/Romanticism) here are the nineteenth-century kind, mourning handcraft from inside the industrial England that replaced it. The colloquial versions of these words are the archetypes; the historical ones are more useful.

## Amish

A community draws the line and binds its members to it. The drawn line becomes a defining characteristic of the community as members choose to either abide and stay, or reject and leave.

---

> We are a place for people to collaborate and improve software together. Within this context, the recent votes can be understood as a reconfirmation of those principles: As we want to center on human collaboration, we will not actively support or engage in the creation of LLMs and will not put our limited resources to use for storing single-use software that would pollute our FLOSS commons.
> <br><br>
> -- Bastian Greshake Tzovaras, Otto Richter, and William Zijl (Codeberg), [Protecting our FLOSS commons from LLMs](https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html), July 23, 2026

The members voted 358 to 144 for the rules this quote argues for - majority threshold, member-sourced and deliberate.

---

> It's fine to use LLMs to answer questions, analyze, distill, refine, check, suggest, review. But not to **create.**
> <br>[...]<br>
> We treat PRs as an indication that someone is interested in joining our community and being mentored to work on future PRs.
> <br><br>
> -- Jynn Nelson (for rust-lang/rust), [rust-lang/rust is adopting an LLM policy](https://blog.rust-lang.org/inside-rust/2026/08/05/rust-langrust-is-adopting-an-llm-policy/), August 5, 2026

The line is drawn around review and disclosure, because a polished PR no longer carries that signal on its own. The rule is downstream of the values the community wants to uphold.

---

> The long story short, if your project uses AI, is made by AI, or is intended for AI, it's not welcome on r/opensource. AI, as it exists today, is incongruent to this Open Source community.
> <br><br>
> -- Wolvereness (r/opensource), [Your tokens aren't valuable: No more AI](https://www.reddit.com/r/opensource/comments/1xelcuf/your_tokens_arent_valuable_no_more_ai/), October 24, 2026

A moderator decree, not a member vote - same position as Codeberg, opposite procedure.

## Old Order

An individual draws a near-total line for their own work.

---

> When I code, I don't use AI and I don't even use code completion, this post is about why not. [...] When you code without AI and without code completion you eventually remember much by heart and you become good at looking things up directly in the relevant documentation, and this is really important. [...] Always grabbing the easy way out is never good if what you're doing is important to you or others.
> <br><br>
> -- unixdigest, [The reason why i don't use AI or even code completion](https://unixdigest.com/articles/the-reason-why-i-dont-use-ai-or-even-code-completion.html), May 1, 2025

A near-total personal line extending even to IDE autocomplete, on the analogy of memorizing phone numbers: convenience atrophies the muscle of reading documentation directly and internalizing syntax.

---

> I choose to avoid using "AI" (by which I mean Large Language Models). Here's why: they have a devastating environmental impact, they are trained by exploiting and traumatising millions of low-paid workers, they produce biased and dangerously incorrect results, and they unfairly use people's creative work.
> <br><br>
> -- Andy Balaam, [Why I don't use AI](https://artificialworlds.net/blog/2025/12/16/why-i-dont-use-ai/), December 16, 2025

The ethical case, stated as a list and argued at length.

---

> I have, to date, not used any AI coding tools, at all. I've actively removed them from my IDE. I don't want them. Not just because of questions of their quality (still lower than a human), or because I will miss writing elegant code (I know I will), but because I want my daughter to have a future, and a planet on which to live. Because I actually do care about respecting copyright. But, at this point, it's become obvious that I have to either compromise on that, or leave tech entirely. And every time I think about that, I get angry.
> <br><br>
> -- Larry Garfield, [Selfish AI](https://www.garfieldtech.com/blog/selfish-ai), February 1, 2026

He actively stripped AI tools from his editor out of environmental, copyright, and ethical convictions. His post captures the exact friction of holding an Old Order line as the mainstream defaults shift: the agonizing realization that the collective surrender to "it is what it is" leaves individual holdouts facing a forced choice between ethical compromise and leaving the tech industry entirely.

---

> The thing is that even if I was wrong (I'm not) and AI was somehow helpful for software engineering (it isn't), I still wouldn't want to use it.
> 
> Might I be wrong? I don't know, maybe? Might I be left behind in my industry? I guess, but I don't think it's likely. But honestly I would rather be wrong and left behind than spend my days prompting an AI to do my chosen ***craft***, something I love.
> <br><br>
> -- Anthony Manning-Franklin, [I Will Never Use AI to Code (or write)](https://antman-does-software.com/i-will-never-use-ai-to-code-or-write), March 4, 2026

---

> For example, I've got these color-changing lights. They speak a protocol I've never heard of, and I have no idea where to even begin. I could spend a month digging through manuals and working it out from scratch - or I could ask an LLM to write a client library for me. The security consequences are minimal, it's a constrained use case that I can verify by hand, and I wouldn't be pushing tech debt on anyone else. I still write plenty of code, and I could stop any time. What would be the harm?
>
> Right?
>
> ... Right?
> <br><br>
> -- Kyle Kingsbury, [The Future of Everything is Lies, I Guess: Where Do We Go From Here?](https://aphyr.com/posts/420-the-future-of-everything-is-lies-i-guess-where-do-we-go-from-here), April 16, 2026

He says he's never used an LLM for his writing, software, or personal life, and in the [Work installment](https://aphyr.com/posts/418-the-future-of-everything-is-lies-i-guess-work) two days earlier wrote that he is "not confident I will hold out forever." Still Old Order for now, with the exact shape of a possible move to Mennonite already on the page.

---

> To put it simply: I do not like this world where people are using AI to generate art, music, writing, and software. So I will not use AI.
> <br><br>
> -- Brett, [I'm done using AI](https://brettcodes.com/im-done-using-ai/), August 10, 2026

Twenty years of programming, eighteen months of Claude Code and similar harnesses, then none. His post closes: "Here's to writing code by hand." A migration - English to Old Order - in his own words.

---

> When people claim that it's no longer sustainable to write code by hand, they're not entirely wrong, but only in the same way that it's no longer sustainable to sleep in a bed once someone has taken a shit in it. You want changes? Go ask your agent or something. I'm told that's what you're supposed to do now. I'm out.
> <br><br>
> -- Paul Battley (po-ru), [Why I'm no longer updating this repository](https://po-ru.com/2026/10/18/why-im-no-longer-updating-this-repository), October 18, 2026

He archived his Ruby gems rather than keep contributing to a commons he takes to be strip-mined, after his companion post, "[All our houses are built on sand now](https://po-ru.com/2026/10/07/all-our-houses-are-built-on-sand-now)" (October 7, 2026), found disclosed LLM commits already in the C compilers underneath every language toolchain.

## Mennonites

An individual draws a line with a practicable clause - this far, for these uses, and no farther.

---

> I chose to make using AI a manual action, because I felt the slow loss of competence over time when I relied on it, and I recommend everyone to be cautious with making AI a key part of their workflow.
> <br><br>
> -- Luciano Nooijen, [Why I stopped using AI code editors](https://lucianonooijen.com/blog/why-i-stopped-using-ai-code-editors/), April 1, 2025

He removed AI from his editors and still uses LLMs occasionally, by hand, on purpose. The line is at the editor integration, not at the tool. He tried the English approach and found it not to his taste, settling back at a more deliberate, limited use.

---

> I'm defaulting to pen and paper, I'm defaulting to coding the first draft of that function on my own. [...] I'm writing the plan. I'm the senior dev. The LLM is the assistant.
> <br><br>
> -- Alberto Fortin (via Simon Willison), [After months of coding with LLMs, I'm going back to using my brain](https://simonwillison.net/2025/May/20/after-months-of-coding-with-llms), May 20, 2025

Cut back rather than quit, after LLM-driven rewrites produced a codebase he compared to ten junior developers locked in a room without seeing each other's work.

---

> Now, I would be lying if I said I didn't use LLMs to generate code. I still use Claude, but I do so in a more controlled manner. I copy-paste files that I think are necessary to provide the context, and then I copy-paste code and ask it to make changes to it or write tests for it. This friction has several benefits. [...] It turns code generation from a passive action to a deliberate thoughtful action. It also keeps my brain engaged and active, which means I can still enter the flow state.
> <br><br>
> -- Abhinav Omprakash, [I Am Happier Writing Code by Hand](https://www.abhinavomprakash.com/posts/i-am-happier-writing-code-by-hand/?ref=birchtree.me), February 7, 2026

He deleted Claude Code three times after finding that full-agent vibe coding left him with lethargy and brain fog, rediscovering the joy of coding by hand each time. He now restricts LLMs to manual, deliberate copy-pasting for small diffs and test cases - drawing the line at agentic automation to preserve engagement and flow.

---

> Given the freedom to choose, I’d probably pick a middle path: use LLMs to generate boilerplate code, write tricky test cases, debug nasty issues I can’t think of, and quickly prototype ideas to test. I’m not an AI vegan.
>
> But when it comes to code I write for myself—which includes the code that runs this website—I’m going to continue writing it myself, line by line, like I always did.
> <br><br>
> -- Ankur Sethi, [I'm no longer using coding assistants on personal projects](https://ankursethi.com/blog/coding-assistants-personal-projects/), April 4, 2026

He types every line of his current Django project himself, still uses Claude Code as a search engine and debugger, and follows his clients' rules at work. The line runs between personal and client work.

---

> I use AI tools sparingly for assistance while refactoring code in languages I understand. I occasionally use it to help compose command line arguments for tools like `ffmpeg`. I never use AI to generate images, video, or prose.
> <br><br>
> -- Ky Decker, [Do I belong in tech anymore?](https://ky.fyi/posts/ai-burnout), April 24, 2026

Right after that paragraph, the post notes that AI "feels inescapable," and closes on a five-line creed ("Things that are worth doing are worth doing well... There are no shortcuts"). The creed is absolute; the clause above is why it files here and not one section up.

---

> For programming, I ask it how to do things I don't know how to do. Then I use what I've learned in my own code.
> <br><br>
> -- Derek Sivers, [AI usage](https://sive.rs/ai), updated September 28, 2026

The line sits between asking and generating. The same update adds that he has started using Codex to write unit tests against functions he wrote his way - the "practicable clause," widening in public.

## Luddites

The historical kind: not just a private practice, but an attempt to change the terms for everyone.

---

> Please stop legitimizing LLMs or AI image generators or GitHub Copilot or any of this garbage. I am begging you to stop using them, stop talking about them, stop making new ones, just stop.
> <br><br>
> -- Drew DeVault, [Please stop externalizing your costs directly into my face](https://drewdevault.com/blog/Stop-externalizing-your-costs-on-me/), March 17, 2025

A direct public appeal, on a bill of costs: carbon, freshwater, traumatized labor, scraped work, miserable sysadmins.

---

> What’s hardened are my views on the tech industry, software, management, and influential members of the software developer ecosystem. [...] The more I wrote about generative models, the more appalled I became at the response from the industry, to both my writing and that of others actively highlighting the risks. Few people who have any influence in tech and software seem to care about the harms, the political manipulation, the outright sabotage of education, the association with extremism, or the *literal* child abuse.
> <br><br>
> -- Baldur Bjarnason, [Have I hardened against LLMs?](https://www.baldurbjarnason.com/2026/have-i-hardened-against-ai/), February 9, 2026

Author of *The Intelligence Illusion*, where he describes ChatGPT as "the opposite of good software." For Bjarnason, the downside comprehensively outweighs the upside, and his critique is aimed squarely at an industry and management culture willing to ignore systemic harms, labor exploitation, and software insecurity for the sake of an unproven productivity bump.

---

> Each day we delay the advancement of ML models buys time to learn how to manage technical debt and errors introduced in legal filings. Another day to prepare for ML-generated CSAM, sophisticated fraud, obscure software vulnerabilities, and AI Barbie. Another day for workers to find new jobs.
> <br><br>
> -- Kyle Kingsbury, [The Future of Everything is Lies, I Guess: Where Do We Go From Here?](https://aphyr.com/posts/420-the-future-of-everything-is-lies-i-guess-where-do-we-go-from-here), April 16, 2026

Refuse, organize, regulate - as delay, openly conceded not to be a stop. Same person as the Old Order entry above, different position, which is the point of filing positions instead of people.

---

> The precisely appropriate ways in which to resist AI encroachment on all software development lie well beyond the margins of this one short post. How much you can resist and which specific uses you should resist are up to you. But it is worth resisting in software just as much as it would be worth resisting in any creative medium.
> <br><br>
> -- Glyph, [Programming Isn't Special](https://blog.glyph.im/2026/10/programming-isnt-special.html), October 9, 2026

Draws on John Berger's *Ways of Seeing* to argue that programming - even mundane workday code - is art, and that handing the mundane work to AI removes the practice required to ever make great things.

---

> If we can mitigate the effects that LLMs have on us and reduce the filtering burden, we can, more likely than not, simply outcompete LLM users. After all, LLMs, as we've previously established, are mostly useful to people who are not good at what they do: weak players in our socioeconomic game.
> <br><br>
> -- Iris Meredith, [There's little that's "inevitable" about AI](https://deadsimpletech.com/blog/llms-arent-inevitable), October 10, 2026

Models LLMs not as gunpowder (adopt or be conquered) but as battlefield chemical weapons: useful only to weak players fighting weak players, and neutralizable by regulation, economics, and social opprobrium. Earlier in the year, she spent a week testing coding agents for "[My week with opencode](https://deadsimpletech.com/blog/week-with-opencode)" (January 13, 2026), where she stood at the Mennonite/Old Order boundary - willing at most to "keep a pet local model around to provide input whenever brain-rotted slop is required" and unwilling to release LLM code to the public.

## Romantics

No line left to draw. The diagnosis is accepted, and what remains is grief for the craft as it was - the 1812 hand-loom weaver who has consented to the mill and is mourning the loom.

---

> Writing code by hand gave me the pace of thought I needed to understand a problem deeply.
> <br><br>
> -- Alex Kondov, [Confessions of a Code Monkey](https://thethinkingbuilder.substack.com/p/confessions-of-a-code-monkey), January 23, 2026

---

> Someday years from now we will look back on the era when we were the last generation to code by hand. We'll laugh and explain to our grandkids how silly it was that we typed out JavaScript syntax with our fingers. But secretly we'll miss it.
> <br><br>
> -- Nolan Lawson, [We mourn our craft](https://nolanlawson.com/2026/02/07/we-mourn-our-craft/), February 7, 2026

---

> I wrote millions of lines of code, from scratch; a good chunk of that was without benefit of the Internet, and its infinite reference library. None of it was AI-assisted.
> <br><br>
> -- Peter Rukavina, [What we are losing](https://ruk.ca/content/what-we-are-losing), February 9, 2026

His response to Lawson, from 43 years of professional programming, 1980 to 2023.

---

> The demand for software is not the same as demand for software engineering. The demand for bread today is far higher than in 1800s, yet that did not lead to a corresponding increase in the demand for break-makers.
> <br><br>
> -- Mo Rassam, [Software Engineering is dead and I'm begging you to accept this](https://tharsalys7.substack.com/p/software-engineering-is-dead-and), October 18, 2026

Rassam has migrated: a hand-loom weaver who has gone out into the city to see what factory jobs there are and realized that you can't go home again.

## The English

No line. Full adoption, no stated boundary, enthusiasm - the Amish word for the rest of us.

---

> We've managed to narrow it down to a single principle: You are getting left behind if you do not adopt chat-based programming as your primary modality. There are a few legitimate reasons for not being able to use chop, but they are quickly evaporating as excuses. So call it whatever you like, but to me, as time goes by, the holdouts are just looking stubborn.
> <br><br>
> -- Steve Yegge, [The death of the stubborn developer](https://sourcegraph.com/blog/the-death-of-the-stubborn-developer), December 10, 2024

Nine days after GPT-4 shipped, Yegge had already sounded the horn in [Cheating is all you need](https://sourcegraph.com/blog/cheating-is-all-you-need) (March 23, 2023), declaring LLMs the biggest shift since the World Wide Web. By late 2024, the early warnings in [The death of the junior developer](https://sourcegraph.com/blog/the-death-of-the-junior-developer) hardened into an ultimatum: chat-oriented programming is the primary modality, and anyone resisting is merely stubborn. By mid-2025 there was "nary an IDE in sight" ([The brute squad](https://yegge.ai/essays/the-brute-squad/)), arriving in 2026 at [Welcome to Gas Town](https://yegge.ai/essays/welcome-to-gas-town/): *"It’s also 100% vibe coded. I’ve never seen the code, and I never care to."*

---

> This tale isn't about any particular company, it's about the raging AI bull that's been unleashed which enables anyone, to do anything. [...] The founders didn't intend to slash their workforce; it just happened naturally - people self-selected out of the new AI+tools first direction - which works for now but the places to turn to will soon diminish, fast. [...] Don't fall asleep at the wheel on this one. Invest in yourself - if you’re a high-agency person, there’s never been a better time to be alive...
> <br><br>
> I suspect there's not going to be mass-layoffs for software developers at Companies due to AI, instead there what we will see is a natural attrition between those who invest in themselves right now and those who do not.
> <br><br>
> -- Geoffrey Huntley, [What do I mean by some software devs are "ngmi"?](https://ghuntley.com/ngmi/), February 7, 2025

The sequel to his conversion at the pool in [An "oh fuck" moment in time](https://ghuntley.com/oh-fuck/) (January 14, 2025), where he left Cursor running a Rust-to-Haskell port with CoreAudio FFI while swimming with his kids and returned to find it working, announcing that non-adopters were "frankly not gonna make it." Here he defines the acronym: no mass layoffs required—just a quiet, brutal sorting where developers who dismiss models as hype self-select out while high-agency cyborgs take the wheel.

---

> I've been in the now-renamed Yolo Mode since March 2025. I just let the agents do whatever, to whatever.
> <br><br>
> -- Me, [How I Learned to Stop Coding and Love the Machine]({% link _garden/how-i-learned-to-stop-coding-and-love-the-machine.md %})

Whatever this taxonomy says about everyone else, it says that about its author too. I am not immune to propaganda!

## Things That Do Not Fit

The taxonomy above sorts by the extent of acceptable use: who draws the line, and how wide it is. This section logs positions that break those two axes.

### The Butlerian Jihadis

The real-world Amish and Old Order are defined by [*Gelassenheit*](https://en.wikipedia.org/wiki/Gelassenheit) (quiet yieldedness) and [nonresistance](https://en.wikipedia.org/wiki/Nonresistance). They keep to themselves, hitch up the buggy, and leave the English alone. Even the historical Luddites were bargaining with mill owners over piecework wages and phased rollouts - violence as a means to an end.

A different posture shares the Old Order's zero-use line, but swaps quiet withdrawal for excommunication, blacklists, and a post-bubble tribunal - or, on the physical fringe that Sean Goedecke documents in "[Blood in the datacenter](https://www.seangoedecke.com/luddites-and-ai-datacenters/)" ("Is it time to start burning down datacenters?"), shots fired at councilmen's houses and firebombs. Filing this posture under Old Order slanders the Amish; filing it under Luddite misses that nobody here is asking for a seat at the bargaining table. The closest name is the one I already borrowed from Frank Herbert, in my [Fomenting the Butlerian Jihad]({% link _garden/fomenting-the-butlerian-jihad.md %}). *"Thou shalt not make a machine in the likeness of a human mind"* - and anyone who does is a collaborator.

---

> If you personally work on developing LLMs et al, know this: I will never work with you again, and I will remember which side you picked when the bubble bursts.
> <br><br>
> -- Drew DeVault, [Please stop externalizing your costs directly into my face](https://drewdevault.com/blog/Stop-externalizing-your-costs-on-me/), March 17, 2025

---

> We are making this choice. But really, that means you have already decided for me. And I curse you and the ground you walk on for it. No, I'm not joking or exaggerating. Burn in hell. [...] I do not forgive you.
> <br><br>
> -- Larry Garfield, [Selfish AI](https://www.garfieldtech.com/blog/selfish-ai), February 1, 2026
