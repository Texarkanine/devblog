<!-- SHORT VERSION for side-by-side review against blog/essay/_posts/2026-10-26-1812-again.md (long). Modeled on the RAM split: long draft 4,156 words became a 1,272-word post, with the receipts moving to the Garden. If chosen, this file replaces the long post at that path and the Garden keeps the full census. Not a Jekyll post in this location. -->

---
layout: post
title: "1812, Again"
subtitle: "The lines are being drawn against AI-written code, and the last people who drew them left a record of where lines go"
description: "In October 2026 r/opensource banned AI by decree and walked it back in days, while Codeberg banned it by member vote. The positions forming around AI-written code map onto 1812 closely enough to predict from, if I write the prediction down and date it."
author: texarkanine
category: essay
tags:
  - ai
  - history
  - open-source
---

On October 24, 2026, a moderator of r/opensource posted new rules under the title ["Your tokens aren't valuable: No more AI."][reddit-ban]

> The long story short, if your project uses AI, is made by AI, or is intended for AI, it's not welcome on r/opensource.

Projects now had to be a year old, actively maintained, built by three or more contributors, and unconnected to AI in any direction. Posters needed year-old accounts. Non-English speakers were told to find a different community, because AI-written English and AI-translated English could not be told apart.

As of this writing, two days later, the post sits at a score of 0 with some 2,700 comments. The top one, at about 1,500, asks whether Linux is banned now that Linus uses AI for kernel development, and calls the stance ridiculous. The second, at about 1,150, belongs to a solo maintainer whose nine-year-old, zero-AI project the contributor rule excludes anyway. Within days the moderator posted ["Adjustments will be made"][reddit-adjust]: Linux could never be banned, a two-session pet project still would be, and "the line is somewhere between those."

A line drawn at maximum width on a Saturday began retreating before the weekend was out. That has happened before, at industrial scale. The year was 1812.

## The Luddites Had Specific Asks

The historical Luddites were textile workers who had apprenticed for seven years and watched expensive machines let unskilled labor do their work worse and cheaper. Their asks were specific: higher piecework wages, a phased introduction of specific machines. Sean Goedecke argues in ["Anti-AI nostalgia and the cult of the past"][goedecke] that much anti-AI writing borrows the structure of older reactionary arguments, and concedes in his [companion piece][goedecke-luddites] that the Luddites were nothing like the loom-smashing archetype the insult depends on.

The mechanism was a repricing. Marx: power looms "reduced by one-half the labor required to weave a given quantity of yarn into cloth," so the hand-loom weaver's unchanged hour "fell to one-half its former value."[^rubin] Mo Rassam said it for software this month, in ["Software Engineering is Dead"][rassam]: "The demand for software is not the same as demand for software engineering." Bread demand soared after 1800; bakers did not. Every position below is a response to that repricing.

## The 2026 Census

I file positions taken in dated posts, not people. Six of them cover everything I collected this year.

**Amish: a community draws the line.** Codeberg's members [voted 358 to 144][codeberg] to bar projects written with heavy LLM use, and say they will not scan for violations. A threshold, deliberated.

**Old Order: an individual, near-total.** Kyle Kingsbury's ten-part ["The Future of Everything is Lies, I Guess"][aphyr] argues the verification case - review degrades as volume grows, and not writing code deskills the writer. He has never used an LLM for his writing, software, or personal life. He also writes that he is "not confident I will hold out forever."

**Mennonite: an individual line with a practicable clause.** Ky's ["AI Burnout"][ky] ends on a no-shortcuts creed and reports, in the same post, using AI sparingly for refactoring and `ffmpeg` command lines. The clause is printed next to the creed.

**Luddite, in the historical sense: the line is aimed at everyone.** Drew DeVault's ["Stop externalizing your costs on me"][devault] begs readers to stop using and legitimizing these tools at all. Kingsbury's [conclusion][aphyr-where] urges refusal, unions, and regulation - as delay, each day buying time to adapt.

**Hand-loom weavers: grief for the craft.** Nolan Lawson mourns being the last generation to code by hand. Peter Rukavina's ["What we are losing"][rukavina] answers with 43 years of programming, 1980 to 2023, none of it AI-assisted.

**The English: no line.** That is where I file, in one sentence: I [stopped writing my own code and let the agents do it]({% post_url blog/guide/2026-03-14-adeptus-mechanicus-bootcamp-gentle-seduction %}), eyes open. The full census, with everyone I could not fit here, lives in [the Garden]({% link _garden/software-engineering-amish.md %}).

## Three Ways to Draw the Same Line

Codeberg drew its line by member vote and wrote it as a threshold. r/opensource drew the same line by decree, at purity width, and retreated in days to where Codeberg started. r/fossdroid copied the decree verbatim. r/ADHD_Programmers chose [quarantine][adhd]: project posts in a monthly thread, slop reportable, nobody exiled.

The difference is procedure, and exit cost. Leaving a forge means moving a project's home. Leaving a subreddit means clicking a link - the rival communities were listed in the ban post itself. In [The Times Can Sell; Reddit Cannot]({% post_url blog/essay/2026-08-13-the-times-can-sell-reddit-cannot %}) I modeled Reddit as one flywheel; these are sub-flywheels spinning up inside it, one click apart. Forge schisms take years. Subreddit schisms render a verdict at click speed, where anyone can watch.

People are also moving between the boxes, in print, on dates. Brett spent [eighteen months on Claude Code][brett] across a twenty-year career, found he could no longer explain his own software without asking the AI, and quit: "Here's to writing code by hand." English to Old Order, August 10, 2026. In 1812 the flow ran one way, loom to mill, because the old price no longer existed. In 2026 it runs both ways.

## Predictions, With Expiry Dates

"This rhymes with 1812" is a truism unless it can be scored. Four calls, for a reader in late 2027:

1. **Community lines harden into thresholds and disclosure rules.** Purity tests keep collapsing on contact - r/opensource took days. This dies if a major community sustains an unchanged zero-AI rule, with detection enforcement, without bleeding producers to a rival.
2. **Reddit renders the first verdict.** Watch the r/opensource rule codify or collapse, the rival subreddits grow or wither, and decree-copying spread or stop. If the original decree survives a year unchanged and the rivals are dead, the decree bound after all, and my sorts-instead-of-binds model is wrong.
3. **Old Order lines accumulate exceptions or shrink to a witness.** Ky's clause and Kingsbury's rider are already in print. This dies if the 2027 census finds the prominent holdouts exception-free and growing.
4. **Weaver grief converts to mill work or exit.** The repricing does not run backward. It dies if hand-written code re-establishes itself as the professional default at its former price.

Three things already do not fit, logged so I cannot file them away later. po-ru counts [GCC at 3.1 percent and LLVM at 15.9 percent][poru] of commits disclosed as LLM-assisted, with languages at zero disclosed sitting on those compilers: software free of LLM output may no longer be producible by anyone, which leaves the strictest position with an empty chair. Local inference may put the power loom in the displaced worker's own house, which 1812 never did. And if programmers start calling themselves Mennonite unprompted, this taxonomy will have begun making the territory it maps.

## See You at the Next Census

The most useful document an observer could have left in 1812 was a dated list of who was warming to the power loom, who was smashing it, and who was quietly taking the mill job - written without knowing the ending. This is that list, dated. It will not be edited into agreement with the future; the 2027 census will say where it was wrong. The collection keeps growing in the Garden, append-only: moved since I filed you, you get a second entry, and the first one stays.

[^rubin]: Marx, quoted in I. I. Rubin, essays on the labor theory of value. <https://www.marxists.org/archive/rubin/value/ch16.htm>

[reddit-ban]: https://www.reddit.com/r/opensource/comments/1xelcuf/your_tokens_arent_valuable_no_more_ai/
[reddit-adjust]: https://www.reddit.com/r/opensource/comments/1xfursg/adjustments_will_be_made/
[goedecke]: https://www.seangoedecke.com/anti-ai-nostalgia/
[goedecke-luddites]: https://www.seangoedecke.com/luddites-and-ai-datacenters/
[rassam]: https://tharsalys7.substack.com/p/software-engineering-is-dead-and
[codeberg]: https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html
[aphyr]: https://aphyr.com/posts/411-the-future-of-everything-is-lies-i-guess
[aphyr-where]: https://aphyr.com/posts/420-the-future-of-everything-is-lies-i-guess-where-do-we-go-from-here
[ky]: https://ky.fyi/posts/ai-burnout
[devault]: https://drewdevault.com/blog/Stop-externalizing-your-costs-on-me/
[rukavina]: https://ruk.ca/content/what-we-are-losing
[adhd]: https://www.reddit.com/r/ADHD_Programmers/comments/1t0p7qx/dealing_with_projectapp_posts_and_spammy_ai_posts/
[brett]: https://brettcodes.com/im-done-using-ai/
[poru]: https://po-ru.com/2026/10/07/all-our-houses-are-built-on-sand-now
