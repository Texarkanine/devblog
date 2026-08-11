---
layout: post
title: Untitled Post
description: The friction that AI eliminates was quietly producing the public record AI depends on, and every response to the problem is a bet about what was really being defended.
author: texarkanine
category: essay
tags:
  - ai
  - economics
  - open-source
---

There is a directive called `noindex`. It tells search engines to forget you exist. It has been part of the web for decades, a tool for keeping staging sites and login pages out of search results. In July, the [Wall Street Journal reported][gizmodo] that some of the largest publishers in America discussed pointing it at themselves - deliberately vanishing from the index of the web - to keep their content out of Google's AI answers. "Cutting off your nose to spite your face" is usually a figure of speech. It now has a technical primitive.

I want to describe how we got here, why I think it goes deeper than the publishers know, and why I don't have a solution. I'm suspicious of anyone who claims they do.

## We Have Watched This Happen Before

When Netflix launched streaming, it was amazing, and everybody knew it. Everything was in one place, cheaper than cable, and frictionless. I remember when theater movies showed up on Netflix a few weeks after their runs ended. Then the studios noticed there was money to be made and pulled their catalogs to build their own storefronts: Hulu, HBO Max, Disney+, Peacock, Paramount+, all the way down to Shudder, a streaming service just for horror. Nobody subscribes to all of them. Nothing has everything anymore, including Netflix. The customer experience collapsed the moment the catalog fragmented, and the industry has spent the years since [reinventing the cable bundle](https://www.statsignificant.com/p/is-tvs-golden-age-officially-over) it originally slaughtered.

The same play is now running on the information web, one layer up.

Stack Overflow was the Netflix of programming answers: the default destination, because all the answers were there. Reddit was the Netflix of communities. Then LLMs unified the unifiers. Ask a chatbot a question and it draws on Stack Overflow, Reddit, documentation, and the news, in one interface, with no hunting across tabs and no dismissive moderators. Stack Overflow is cable television now. ChatGPT is Netflix.

The traffic data reads like an obituary. Stack Overflow received [3,862 new questions in December 2025][devclass], down 78% from the year before, at a site that peaked above 200,000 questions per month in early 2014. Honesty requires the caveat: the decline [started in 2014](https://blog.pragmaticengineer.com/stack-overflow-is-almost-dead/), when moderation tooling got aggressive and the site got unwelcoming. ChatGPT did not push a healthy site off a cliff. It accelerated a slide that moderation policy began - which makes the lesson sharper, not softer, because the replacement product is polite, answers everything, and never closes your question as a duplicate.

On the open web, the exchange rate between crawling and clicking has gone absurd. Pew found that when a Google search returns an AI summary, users click a traditional result [8% of the time, versus 15% without one][pew] - and click the summary's own cited sources in 1% of visits. Cloudflare's crawl data puts hard numbers to the imbalance: by July 2025, [about 80% of AI bot activity was training crawls][cloudflare-crawl], and Anthropic's crawlers fetched roughly 38,000 pages for every one visitor they referred back. Google's rebuttal is that its AI sends "billions of clicks to the web every week"[^gizmodo] - a numerator with no denominator, which is the house special.

There's a legal skeleton under those numbers, and you don't need a law degree to articulate it - [people on LinkedIn manage fine][greduan]: search-engine scraping survived its early court challenges because an index does not substitute for visiting the site. A chatbot answer removes the visit. Pew's 8% is what substitution looks like once somebody measures it.

So the publishers are posturing. Reuters' president: "We are certainly looking at the economic trade-offs between search and AI summaries." USA Today's CEO: "It's time to take a stand and say enough is enough." People, Inc.'s CEO: "Turning them off and blocking them entirely is 100% on the table."[^gizmodo] Reddit, which signed a deal in 2024 worth about $60 million a year to let Google train on its content, has reportedly discussed [shutting that access off][gizmodo].

Then Reddit reported earnings on July 30 and the market showed everyone what the stakes are. Revenue up 61%, profit more than doubled, every number a beat - and [the stock had its worst rout ever][cnbc-reddit], because search referrals were "choppy" and no new AI licensing deals appeared. Steve Huffman, on the call: "AI Overviews has yet to make a similar level of positive impact" as the ten blue links, and "we have still yet to find that win-win." A company can now beat every estimate it has and lose a fifth of its value, because the front door of the web is narrowing and everyone knows it.

Notice what none of them are threatening: to stop being searchable by AI. Nobody objects to AI retrieval as such - it's a better product and they know it, because they're users too. They object to *someone else's* model serving their content. The end state the incentives point at is Reddit+: AI search over Reddit's corpus, available only through Reddit's front door, with everyone else's crawlers blocked at the gate. Repeat for every platform big enough to pull it off, and the information is fragmented again, every producer collecting on its own piece, the experience worse everywhere. Cable, reinvented, one layer up.

## Why Nobody Has Actually Left

Here is where the streaming analogy earns its keep by breaking. When Disney pulled its catalog from Netflix, it walked away clean and took its business elsewhere. Publishers cannot walk, because Google engineered the exit to be all-or-nothing.

Publishers can block `Google-Extended`, the crawler that trains Gemini, at no cost. But Google merged the crawling for AI answers and traditional search into one bot: if you want to exist in either, you must feed both. The escalation ladder runs from `Google-Extended` (costs nothing, protects nothing that matters) through `nosnippet` (may keep you out of AI Overviews, may hurt your search placement) to `noindex` (you cease to exist).[^gizmodo] The blocking statistics wear the shape of that bundle: [79% of top news sites block at least one AI training crawler][buzzstream], but `Google-Extended` is the *least* blocked of them all, at 46%. That gap measures leverage, not affection.

So every publisher is individually better off staying in the index, and they would only win by leaving together, and coordinating that explicitly is the kind of thing antitrust lawyers write memos about. Which is why the threats appear as quotes in the Wall Street Journal rather than as directives in robots.txt: negotiating in the press is the substitute for a cartel you can't legally form.

The second fragmentation is therefore stalled, not absent. And even if it completed, it could not restore anything, for a reason streaming never faced: a show can be pulled from a catalog, but an answer cannot be un-trained. The models already ate the archive. Re-fragmenting *access* does not reverse *ingestion*. Everything the blockade could protect is the future - and the future is exactly what the flywheel is no longer producing.

That's the standard story, anyway: platforms starving, crawlers biting the hand that feeds them, everyone waiting to see who blinks. If that were the whole of it, this would be a media-industry problem with media-industry fixes - licensing deals, marketplaces, [pay-per-crawl](https://blog.cloudflare.com/introducing-pay-per-crawl/). I don't think it's the whole of it.

## The Same Flywheel Spins Down in Private

Omry Yadan - the engineer behind [Hydra](https://hydra.cc/docs/intro/) - published an essay in July called [AI Doesn't Get Annoyed][yadan]. His observation: annoyance is a wrong-abstraction detector. "Necessity invents a solution. Annoyance invents a system." An engineer who restates the same durable information for the fifth time gets irritated, and that irritation is evidence the system lacks a concept - so the engineer builds the abstraction, and the concept becomes explicit, named, owned. AI absorbs that friction instead. Given a ticket-sized objective, another working implementation is a successful outcome; the model has no reason to pay the upfront cost of an abstraction the task never asked for. The pain disappears. The complexity doesn't.

Look at what just happened. No commons, no ad revenue, no crawler, no villain - nobody in Yadan's story is free-riding on anyone - and the durable artifact still stops forming. Same mechanism as the platforms, private scope: friction was the production trigger, AI is friction-elimination technology, and eliminating the friction eliminates the trigger without eliminating the need.

That reframes what Stack Overflow actually was. The question volume was never just content awaiting answers; it was public telemetry about what is hard. Maintainers read it. Documentation got written against it. APIs got revised because the same confusion surfaced four hundred times in an index everyone could see. The RedMonk programming language rankings draw half their data from Stack Overflow activity, and their analyst now concedes that half is "increasingly stale and of questionable value" with "no replacement public data set available."[^devclass] The confusion still exists - developers are as stuck as ever - but each instance now resolves inside a private session that nobody else will ever read. The information wasn't destroyed. It was never externalized in the first place.

This is a stronger version of the flywheel argument than the platforms are making, and they should steal it. They argue traffic, which translates to ad revenue, which invites the response "so pay them." But the telemetry loss survives full compensation. You could route a licensing check to every publisher on earth and the aggregate demand signal would still be gone, because payment doesn't cause externalization. They're arguing about the toll booth while the road quietly stops being built.

I keep finding the same shape in unrelated fields. A [paper accepted this July in Human Resource Development Review][lovett] - workforce scholarship, a universe away from tech blogging - calls it the tragedy of the cognitive commons: individually rational AI adoption depletes the shared expertise pool professions need to renew themselves, because the grunt work AI eats first is the same grunt work that used to manufacture experts. The author is describing capability that stops forming inside practitioners' heads; I'm describing records that stop forming in public. Different failure mode, same trigger removed. When config management, workforce scholarship, and a Q&A site's traffic graph all report the same mechanism in the same year, it stops being a media-industry story.

And I should be honest about where I sit in it. Every AI tool I use is set to not train on my data. I reap the benefit of a corpus built from everyone else's contributions while ensuring my own sessions add nothing back. There's an era-appropriate name for this: I am torrenting as a leech. I am not seeding. I have no plan to change the setting, and I don't have an answer to the problem I'm describing. What I can do is look at the answers others are attempting.

## Three Bets

### Blocking: seven percent poorer, still cited

The best data on crawler-blocking comes from a [Rutgers/Wharton working paper][zhao-berman] that tracked publishers across three independent traffic datasets: publishers who blocked LLM crawlers via robots.txt lost about 7% of weekly traffic within six weeks, and the decline shows up in household browsing panels, so it can't be waved off as bots disappearing from the logs.[^zhao] Meanwhile blocking [doesn't reliably reduce how often AI systems cite you](https://ppc.land/blocking-ai-crawlers-doesnt-stop-citations-new-data-shows-why/). You pay the toll and the road stays open.

Both routes out are sealed. Consumers won't return: they've experienced the unified product, and the consumers who left were always the overwhelming majority relative to the contributors - they came for retrieval, and retrieval now lives somewhere better. Producers can't leave: the merged crawl makes exit self-immolation, per the ladder above.

The New York Times deserves a special word here, because it is suing OpenAI while performing this grievance, and its version of the complaint is the least coherent. The Times [announced in January 2010][techcrunch] that it would meter its website, and in March 2011 it did: a deliberate, publicly reasoned trade of open reach for subscription revenue. That was a defensible business decision. It was also self-balkanization, chosen freely, a decade before any crawler mattered. The Times fractured its own distribution, and its complaint now is that somebody else built a unified layer over the fragments and users prefer it. Note also what the Times is *not* defending: its newsroom is salaried, so the production pipeline doesn't depend on traffic the way a volunteer flywheel does. What crawler-blocking defends at the Times is a distribution position. Reddit's grievance and the Times' grievance wear the same robots.txt, and they are not the same grievance.

### Rust: manufacture the counterparty

On August 5, the Rust project [adopted an LLM policy][rust] for its main repository, and it is the most interesting document in this whole fight, because it names the flywheel from the inside:

> We treat PRs as an indication that someone is interested in joining our community and being mentored to work on future PRs. [...] a polished PR no longer indicates that someone is likely to stick around for the long term.

A pull request was never primarily code. It was a signal of effort, understanding, and intent to stay - a contributor-formation event. "Polished technical products no longer indicate effort and understanding," the policy's author writes, and with 1,281 PRs open against the repo and review bandwidth the binding constraint, Rust could not afford to keep pretending otherwise. Their stated priority is the mental model, not the artifact: "the code itself is the smallest and in some ways least important part of the change."

Rust's answer runs on disclosure, not detection. LLM involvement must be declared; undisclosed LLM content is the violation, so enforcement runs on actions rather than intent; and - remarkably - "Style is not evidence; please do not accuse people of using an LLM," paired with a clause forbidding harassment of people *for* using one. They rejected both available poles, and quoted them: [Zig's strict no-LLM policy](https://ziglang.org/code-of-conduct/#strict-no-llm-no-ai-policy) on one side, Linus Torvalds' ["AI is a tool, just like other tools we use"](https://lore.kernel.org/linux-media/CAHk-=wi4zC+Ze8e+p3tMv8TtG_80KzsZ1syL9anBtmEh5Z40vg@mail.gmail.com/) on the other.[^anubis]

Notice what disclosure actually does: it *manufactures an addressable counterparty*. The open web's crawler problem is at bottom an accountability problem - the bots arrive from tens of thousands of residential IPs with spoofed user agents, and you cannot bill, block, or shame an entity with no name. Sysadmins on the receiving end have been [screaming about this for over a year][devault]. Rust's move creates the name as a condition of the transaction: to contribute, you must be legible. The reason it works is also the reason it doesn't generalize - contributing to a repository is a gated transaction, and reading the web isn't. Rust can require legibility at its gate. The open web has no gate.

### Codeberg: corner the market in humans

In July, the members of Codeberg - the nonprofit forge that FLOSS projects flee to when GitHub's terms chafe - [voted 358 to 144][codeberg] to prohibit hosting projects that "mostly consist of" LLM-written code. My readers might expect me to call this insane. I think it's the most internally consistent response on this list.

Codeberg is a German nonprofit with no ad model, no API licensing, and no distribution revenue to lose, and it fragmented anyway. That looks like a counterexample to "the blockers are just protecting revenue," and it's actually a correction of it: rent was the right concept, the denomination was too narrow. What Codeberg collects and defends is rent denominated in reputation - standing, prestige, membership in the roster - the same currency that was the energy input to the whole pre-LLM contribution flywheel. Everyone else on this list is defending the flywheel's output. Codeberg is the first actor openly defending the fuel.

That reading has receipts. Their [storage quotas][codeberg-quota], rolled out in May 2025, grant automatic exceptions keyed on account age, contributions to well-known projects, and e.V. membership - they were allocating disk by standing before they ever voted on LLMs. Their voting membership roughly 2.7×'d in twenty-two months: [386 active voting members in September 2024][codeberg-2024], around 1,030 implied by the July vote's stated ~50% turnout. And [their own letters][codeberg-infra] attribute the surges to moral stands, not features - people joined after FOSDEM, and in support of Codeberg's response to a harassment campaign. Principled positioning converts to membership. That is their flywheel, with a numerator and a denominator, self-reported. (There's research suggesting Stack Overflow contribution was always driven by reputation and identity rather than traffic - which sounds like an objection to the platforms' flywheel story and is actually support for this one. If contribution runs on reputation, reputation is the thing under threat everywhere, not just here.)

It also explains a posture that is otherwise incoherent. Codeberg is indifferent to being copied - `git clone` everything and enjoy, they insist. Their crawler complaint is about method, not consumption: bots that walk every issue-filter permutation, every page of git history, every file at every historical revision, hammering their donation-funded servers with expensive queries for content that is identical across revisions, while the SSD model they bought for €700 a few years ago now runs €3,700. This is not a seeder objecting to leeching; it is a willing seeder objecting to *incompetent* leeching, and that version survives the "open source means people get to take it" rebuttal that the cruder version doesn't. Meanwhile "vibe-coded" projects consume like communities while being, in Codeberg's phrase, a "development team of none": one person and a statistical machine that "turns energy into code," burning CI minutes and storage on single-use software no one else will ever read. Ghost projects dilute the roster - the actual asset - so the roster is exactly what they voted to defend. Copying doesn't touch the asset. Dilution does.

One more tell: when Codeberg shows an unwelcome project the door, [every recommended destination][codeberg-alts] - disroot, other Forgejo instances, self-hosting, SourceHut - is ideologically aligned. A commons has neutral exits; a market segment doesn't. And that's what this is: a market-segmentation bet. Stake out the human-collaboration niche and bet the niche is big enough to live on. It might be wrong about the size of the market, but that is the bet every company everywhere is always making; there is no mechanical flaw in it. The mechanical vulnerability lies elsewhere: exclusion requires telling AI code from human code, Rust just told us style is not evidence, and Codeberg's rule has no disclosure mechanism to fall back on. A costly signal whose referent is dissolving is a subject for another essay.

## Paying Everyone Fixes Nothing

Line the three up and a gradient appears. Where the venue has a gate, you can demand legibility as the price of entry, and you get Rust: sober policy, harassment clause included. Where the asset is a roster, you can defend the roster and accept the smaller market, and you get Codeberg. Where there is no gate and no roster - the open web - you get blocking that costs 7% of your traffic without stopping the citations, and threats delivered through the press because delivering them through robots.txt would be suicide and delivering them together would be a cartel.

The two fixes everyone reaches for both fail on mechanism. "Pay the publishers" fails because the deepest loss is legibility, not revenue - compensation doesn't cause the record to be written. "Keep humans in the loop" fails on what the cognitive-commons paper calls the Validation Tether: effective oversight of AI depends on exactly the expertise that AI adoption stops producing.[^lovett] The near solutions fail one to irreversibility, the other to circularity.

The railroad has been laid, and you cannot put the genie back in the bottle. Consumers will not return to fragmented retrieval, the models cannot un-ingest the archive, and no licensing check restarts a flywheel whose input was friction. The one response that demonstrably works requires a gate the open web does not have. I set my own tools to don't-train, so I'm not lecturing anyone; I'm a leech describing the pond. The question that stays open is the one the platforms gesture at and then undersell: not who gets paid when the crawlers come, but what, if anything, still causes people to write the hard-won thing down where everyone can see it.

[gizmodo]: https://gizmodo.com/major-publishers-are-reportedly-considering-a-drastic-step-to-get-their-content-out-of-googles-ai-answers-2000788873
[devclass]: https://devclass.com/2026/01/05/dramatic-drop-in-stack-overflow-questions-as-devs-look-elsewhere-for-help/
[pew]: https://www.pewresearch.org/short-reads/2025/07/22/google-users-are-less-likely-to-click-on-links-when-an-ai-summary-appears-in-the-results/
[cloudflare-crawl]: https://blog.cloudflare.com/crawlers-click-ai-bots-training/
[cnbc-reddit]: https://www.cnbc.com/2026/07/30/reddit-rddt-q2-2026-earnings-report.html
[buzzstream]: https://www.buzzstream.com/blog/publishers-block-ai-study/
[yadan]: https://yadan.net/writing/ai-doesnt-get-annoyed/
[lovett]: https://arxiv.org/abs/2607.29380
[zhao-berman]: https://arxiv.org/abs/2512.24968
[techcrunch]: https://techcrunch.com/2010/01/20/new-york-times-metered-model-2011/
[rust]: https://blog.rust-lang.org/inside-rust/2026/08/05/rust-langrust-is-adopting-an-llm-policy/
[devault]: https://drewdevault.com/blog/Stop-externalizing-your-costs-on-me/
[codeberg]: https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html
[codeberg-quota]: https://blog.codeberg.org/new-storage-limits-on-codeberg-what-you-need-to-know.html
[codeberg-2024]: https://blog.codeberg.org/letter-from-codeberg-software-is-about-humans.html
[codeberg-infra]: https://blog.codeberg.org/letter-from-codeberg-we-love-our-new-infrastructure.html
[codeberg-alts]: https://docs.codeberg.org/getting-started/what-is-codeberg/
[greduan]: https://www.linkedin.com/posts/greduan_no-matter-how-one-cuts-the-cake-llms-were-share-7487242594234781696-o7kV

[^gizmodo]: Wall Street Journal reporting, via Mike Pearl, "Major Publishers Are Reportedly Considering a Drastic Step to Get Their Content Out of Google's AI Answers," Gizmodo, July 22, 2026. [https://gizmodo.com/major-publishers-are-reportedly-considering-a-drastic-step-to-get-their-content-out-of-googles-ai-answers-2000788873][gizmodo]
[^devclass]: Tim Anderson, "Dramatic drop in Stack Overflow questions as devs look elsewhere for help," DEVCLASS, January 5, 2026. [https://devclass.com/2026/01/05/dramatic-drop-in-stack-overflow-questions-as-devs-look-elsewhere-for-help/][devclass]
[^zhao]: Hangcheng Zhao and Ron Berman, "Strategic Response of News Publishers to Generative AI," working paper. The April 2026 revision reports the ≈7% weekly traffic decline within six weeks of blocking, consistent across SimilarWeb, Semrush, and Comscore panels; an earlier version reported larger monthly declines (23.1% total, 13.9% human) concentrated among large publishers. [https://arxiv.org/abs/2512.24968][zhao-berman]
[^anubis]: The mailing-list archive hosting Linus's quote now greets visitors with Anubis, a proof-of-work challenge deployed "to protect the server against the scourge of AI companies aggressively scraping websites." The citation for "AI is just a tool" sits behind an anti-AI-crawler wall.
[^lovett]: Nolan Lovett, "The Tragedy of the Cognitive Commons: How AI Could Disrupt the Regeneration of Professional Expertise," Human Resource Development Review (2026). [https://arxiv.org/abs/2607.29380][lovett]
