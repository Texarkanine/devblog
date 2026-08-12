---
layout: post
title: "The Times Can Sell; Reddit Cannot (2)"
description: "AI money can feed staffed editorial producers. It cannot feed Reddit, Rust, or you. The flywheel only turns where producers eat what the new customer will pay."
author: texarkanine
category: essay
tags:
  - ai
  - economics
  - open-source
---

On July 30, Reddit beat every estimate it had. Revenue up 61%, profit more than doubled - and the [stock had its worst rout ever][cnbc-reddit], because search referrals were "choppy" and no new AI licensing deals appeared. Steve Huffman, on the call: "AI Overviews has yet to make a similar level of positive impact" as the ten blue links, and "we have still yet to find that win-win."

The New York Times is suing OpenAI and has, according to the [Wall Street Journal][gizmodo], discussed pointing `noindex` at itself - a directive that tells search engines to forget you exist. Rust adopted an [LLM policy][rust] that treats a pull request as a contributor-formation event, not a delivery of code. That is a stance, not a mood: it changes who the community is, and it only invites the humans who will play that game. [Codeberg](https://codeberg.org) [voted 358 to 144][codeberg] to stop hosting projects that "mostly consist of" LLM-written code.

These look like four different fights. They are the same machine, breaking on different sides.

## Four Reactions

The Times is defending a distribution position. It metered the site in 2011, a decade before any crawler mattered: a deliberate trade of open reach for subscription revenue. The complaint now is that somebody else built a unified layer over the fragments and users prefer it. The current play is to chop the aggregator - sue, block, threaten to vanish from the index.

Reddit signed a 2024 deal worth about $60 million a year to let Google train on its content, and has reportedly discussed [shutting that access off][gizmodo]. Stack Overflow received [3,862 new questions in December 2025][devclass], down 78% from the year before, at a site that peaked above 200,000 questions per month in early 2014. The decline [started in 2014](https://blog.pragmaticengineer.com/stack-overflow-is-almost-dead/), when moderation got aggressive and the site got unwelcoming. ChatGPT accelerated a slide that policy began. Before any of this, you often had to search both, and several subs, to get an answer.

Rust's policy names the flywheel from the inside:

> We treat PRs as an indication that someone is interested in joining our community and being mentored to work on future PRs. [...] a polished PR no longer indicates that someone is likely to stick around for the long term.

Disclosure, not detection. "Style is not evidence." They quoted [Zig's ban](https://ziglang.org/code-of-conduct/#strict-no-llm-no-ai-policy) on one side and Linus's ["AI is a tool"](https://lore.kernel.org/linux-media/CAHk-=wi4zC+Ze8e+p3tMv8TtG_80KzsZ1syL9anBtmEh5Z40vg@mail.gmail.com/) on the other, and took neither.

Codeberg is a German nonprofit forge with no ad model and no API licensing. In July its members voted to keep out the "development team of none": one person and a statistical machine that "turns energy into code." They are indifferent to `git clone`. Their crawler complaint is about method - bots walking every issue-filter permutation and every historical revision on donation-funded disks - and about ghost projects that consume like communities while throwing off no prestige.

Hang this date somewhere in your head. On September 15, 2026, [Cloudflare will default-block Training and Agent bots][cf-cid] on ad pages for new domains. Because Googlebot is classified as Search *and* Training, that default is Googlebot-off unless the site owner opts out. I will come back to it.

If this all looks like [Pink Margarine]({% post_url blog/essay/2026-03-01-pink-margarine %}) - incumbents dyeing the substitute so nobody will eat it - hold that.

## The Machine

Every one of these platforms is a hub with three loops.

Consumers give attention and get the thing: articles, answers, working code. Producers give content or presence that attracts consumers, and get fame or fortune - reputation, karma, salary, doors opening. Those convert into each other; the rate is not 1:1 and I am not moralizing it. In the middle sits a converter, the platform's secret sauce, which turns plentiful consumer-side input into platform sustenance plus what producers want, and skims a cut. Ads, subscriptions, hosting quotas, brand attention: the mechanics vary. The principle does not.

Some flywheels also pay producers in each other. Social dues. Community. "You're not alone." That is fuel.

### How they ran

The Times is the clean picture. Readers give attention and money, get articles. The converter turns that into payroll. Writers, who have a fact-checking pipeline and a voice they spent a career on, supply the articles that draw the next readers.

```mermaid
graph TB
    Converter -->|Money| NYT
    NYT -->|Attention| Converter

    Writers -->|Content| NYT
    NYT -->|Money| Writers

    Readers -->|Attention| NYT
    NYT -->|Content| Readers

    NYT["New York Times"]
```

Reddit and Stack Overflow are the same topology with a different producer currency. The converter skims ads and premium and API deals. Posters get reputation.

```mermaid
graph TB
    Converter -->|Money<br>Reputation| Platform
    Platform -->|Attention| Converter

    Producers -->|Posts| Platform
    Platform -->|Reputation| Producers

    Consumers -->|Attention| Platform
    Platform -->|Information| Consumers

    Platform["Reddit / Stack Overflow"]
    Producers["Posters"]
    Consumers["Readers"]
```

Rust pays a small contributor set in reputation and community, and pays consumers in a language that works. The project's job is to make that conversion run: attention into reputation, contributions into software that draws more attention. The project skims brand.

```mermaid
graph TB
    Converter -->|Reputation| Platform
    Platform -->|Attention| Converter

    Producers -->|Code| Platform
    Platform -->|Reputation| Producers

    Consumers -->|Attention| Platform
    Platform -->|Software| Consumers

    Platform["Rust Project"]
    Producers["Code Contributors"]
    Consumers["Programmers"]
```

Codeberg is Rust pulled up a level. The producers are *projects*, not PR authors. A living project pays a software catalog *and* community attention into the forge. Catalog alone is not enough. Developers still clone; that leech path is fine. The converter's skim is donations, membership, identity - reputation rent, which they were already allocating disk by, via [quotas keyed on standing][codeberg-quota], before they ever voted on LLMs.

```mermaid
graph TB
    Converter -->|Resources<br>Reputation| Platform
    Platform -->|Attention| Converter

    Producers -->|Software Catalog<br>Community Attention| Platform
    Platform -->|Resources<br>Reputation| Producers

    Consumers -->|Attention| Platform
    Platform -->|Software| Consumers

    Platform["Codeberg"]
    Producers["FLOSS Projects"]
    Consumers["Developers"]
```

### How they break

The Times and Reddit break on the consumer side. An AI aggregator sits down between the reader and the site. Embeddings over *all* sources beat any one index, which is why people used Google instead of a twelve-site bookmark folder, and why they now ask ChatGPT instead of the Times. Attention closes on the model. The platform is hit by one consumer that sends nothing back.

```mermaid
graph TB
    Converter -->|Money| NYT
    NYT -->|Attention| Converter

    Writers -->|Content| NYT
    NYT -->|Money| Writers

    Readers ==>|Attention| AI
    Readers -.->|Attention| NYT
    AI -->|Content| Readers

    NYT -->|Content| AI

    NYT["New York Times"]
    AI["AI Aggregator"]
```

Reddit is the same geometry. Readers take their questions to the aggregator. The thick attention line now points at the model. The dotted leftover pointing at Reddit is not enough to mint the reputation the posters were paid in. The platform still feeds the aggregator content. There is no new money on this chart on purpose. Charging the aggregator is a *response*. It comes next.

```mermaid
graph TB
    Converter -->|Money<br>Reputation| Platform
    Platform -.->|Attention| Converter

    Producers -->|Posts| Platform
    Platform -->|Reputation| Producers

    Consumers ==>|Attention| AI
    Consumers -.->|Attention| Platform
    AI -->|Information| Consumers

    Platform -->|Content| AI

    Platform["Reddit / Stack Overflow"]
    Producers["Posters"]
    Consumers["Readers"]
    AI["AI Aggregator"]
```

Rust breaks on the producer side. AI shows up as code that works and a person who is not coming to the meeting. Working software still ships to consumers. Community is not paid into. Converter capacity is finite: it can only turn so much code into appreciated reputation. AI contributions take cycles and mint nothing that sticks. Human code gets crowded out. A contribution used to mean someone else understands, cares, and might stay. AI can open one PR or a hundred with no intent to return.

```mermaid
graph TB
    Converter -->|Reputation| Platform
    Platform -->|Attention<br>Code| Converter

    Producers -.->|Code| Platform
    Platform -->|Reputation| Producers

    ProducersAI ==>|AI Code| Platform
    Platform -.-x|Reputation| ProducersAI

    Consumers -->|Attention| Platform
    Platform -->|Software| Consumers

    Platform["Rust Project"]
    subgraph Contributors
    Producers["Human Code Contrib"]
    ProducersAI["AI Code Contrib"]
    end
    Consumers["Programmers"]
```

Codeberg gets the same failure as a unit of hosting. Ghost projects attach with no community - catalog-shaped presence, resource drain, reputation dead-letter. Living projects thin. Developers can still clone. That does not feed the converter.

```mermaid
graph TB
    Converter -.->|Resources<br>Reputation| Platform
    Platform -.->|Attention| Converter

    Producers -.->|Software Catalog<br>Community Attention| Platform
    Platform -.->|Resources<br>Reputation| Producers

    Ghosts ==>|Ghost Projects| Platform
    Platform ==>|Resources| Ghosts
    Platform -.-x|Reputation| Ghosts

    Consumers -->|Attention| Platform
    Platform -->|Software| Consumers

    Platform["Codeberg"]
    subgraph Hosted
    Producers["Human Projects"]
    Ghosts["Ghost Factories"]
    end
    Consumers["Developers"]
```

## What They Tried

### The Times drew a circle after the readers left

Chopping the aggregator is an attempt to cut the content line into the model and herd people back to nytimes.com. The readers are already on the preferred interface. Latent-space aggregation is a discovered preference. People will not volunteer to regress because a publisher asked them to. Piracy was almost always a service problem. This is that problem, one layer up.

```mermaid
graph TB
    Converter -->|Money| NYT
    NYT -.->|Attention| Converter

    Writers -->|Content| NYT
    NYT -->|Money| Writers

    Readers ==>|Attention| AI
    Readers -.->|Attention| NYT
    AI -->|Content| Readers

    NYT -.-x|Content| AI

    NYT["New York Times"]
    AI["AI Aggregator"]
```

The dead content line is the lawsuit and the `noindex` threat. The thick attention line did not move. The current posture is a miss.

### Reddit charged the one consumer that stayed

Here is the money line. Same break as above, plus a check.

```mermaid
graph TB
    Converter -->|Money<br>Reputation| Platform
    Platform -.->|Attention| Converter

    Producers -->|Posts| Platform
    Platform -->|Reputation| Producers

    Consumers ==>|Attention| AI
    Consumers -.->|Attention| Platform
    AI -->|Information| Consumers

    Platform -->|Content| AI
    AI ==>|Money| Platform

    Platform["Reddit / Stack Overflow"]
    Producers["Posters"]
    Consumers["Readers"]
    AI["AI Aggregator"]
```

The thick new line is money from the aggregator back to Reddit. Follow it. It arrives at the platform. It does not continue to the posters. Posters are still paid in reputation. Reputation is minted from attention. The attention went to the aggregator. The check can keep the lights on for a while. It cannot pay the people who were the reason the corpus was worth buying.

> Sustains the entity while starving the asset.

Production spins down, the corpus gets worse, the next licensing round is worth less, and the consumer side is already gone. Stack Overflow has not even really tried this play. I would not bet that the geometry is different.

### Rust filtered the producers and kept the whole market

Rust wants the world to use Rust, and a community that still forms contributors the old way. Those loops no longer match. The policy chills AI-shaped contributions - and, with them, humans who would have used the tools and then stuck around, or at least shipped a patch.

```mermaid
graph TB
    Converter -->|Reputation| Platform
    Platform -->|Attention| Converter

    Producers -->|Code| Platform
    Platform -->|Reputation| Producers

    ProducersAI -.-x|AI Code| Platform
    Platform -.-x|Reputation| ProducersAI

    Consumers -->|Attention| Platform
    Platform -->|Software| Consumers

    Platform["Rust Project"]
    subgraph Contributors
    Producers["Human Code Contrib"]
    ProducersAI["AI Code Contrib"]
    end
    Consumers["Programmers"]
```

The consumer loop is still the whole market. The producer loop just got smaller, including some of the humans. They are not only cutting off rogue bots. They are cutting off people who use these tools. That is a baby-and-bathwater move.

I keep seeing Rust. I would leech it happily. I would fix a bug with a PR if I had to. I would use AI for that contribution, as I am indeed *not* interested in becoming "A Rust Developer" nor in joining the Rust community. The policy correctly clocks me. Functionally, the project stops reading as open source I can contribute back to. It becomes a club with a language attached. Three years out, I will pick the fork I can patch. I *am* the baby in that bathwater, I reckon. Of course, that's what the bath water would say.

Rust, at least, knows and admits they're experimenting. So, the door's closed to me for now, but maybe not forever. Respect.

The same shape showed up in [Cloudflare OS's contributing guide][cf-os]: they are not seeking outside contribution, because AI made writing easy and reviewing - keeping the product coherent - is the hard part. Small, trivially-verified PRs only. Writing was the easy half. They closed the gate to protect the hard half. That is Rust's move in a README.

### Codeberg drew a smaller country

Codeberg looks like Rust one level up until you check the loops. Rust filters producers and still sells to everyone. Codeberg shrinks both sides and only promises to serve the slice that wants software without AI in it. Ghost projects out; human catalog plus community in. The chart looks like the healthy one on purpose. The TAM just got smaller.

```mermaid
graph TB
    Converter -->|Resources<br>Reputation| Platform
    Platform -->|Attention| Converter

    Producers -->|Software Catalog<br>Community Attention| Platform
    Platform -->|Resources<br>Reputation| Producers

    Consumers -->|Attention| Platform
    Platform -->|Software| Consumers

    Platform["Codeberg"]
    Producers["FLOSS Projects"]
    Consumers["Developers"]
```

A language can lose its consumers entirely if a better one shows up. A forge is closer to "somewhere to cook." People may not all want this kitchen. Some of them will. The bet is that the niche is big enough. That is ordinary market-size risk, not the miss on the Times's lawsuit or Reddit's check.

It is also the only response already on the table that does not lie about the loops. Survive inside the fence, even thrive, and remain irrelevant at global scale.

> Software-Engineering Amish

Fine if that's the life. Most of us did not sign up for it.

### September 15 is a fragmentation replay

Cloudflare's new defaults are not "Googlebot blocked for everyone." New domains, ad pages, Training off, opt-out exists. Defaults are what most people run. A corner of the web will fall out of Google because nobody changed the checkbox.

Cloudflare already sees that corner. It sits on the edge of those sites. If you wanted to search the part of the internet that was not in Google, they are positioned to do it, and if you think they will not, I have a bridge. Akamai, Fastly, whoever else runs enough of the remaining web, can scoop the same way. Then you have competing catalogs. We have watched this. Consumers hated it. They went to an aggregator the moment one existed, because the experience got uniformly worse.

The blockade reconstitutes the middleman one layer up. CDN search is distribution theater. It is not food for producers.

## The Times Still Has a Customer

So the honest options look like: miss, miss, miss, go be Amish in a corner. The Times is probably doomed on the track it is on. It also has a way to thrive in this world that I have not found for anyone else, and that nobody else in this lineup has found either.

The new direct consumer is the aggregator. Producers have to eat something that consumer is willing to pay. Money is the only such something I have found. Times writers, editors, fact-checkers, people they can put on a plane - they already eat money. AI can pay those people.

Reddit took a check too. Follow that check again. It was rent charged to the aggregator, same as what I am about to describe. The denomination the posters spend is reputation. The rent arrived in a currency they cannot eat.

Labs are already telling you what they will pay for. [Anthropic bought print books in bulk][ars-books], cut the spines, scanned the pages, and threw the paper away - Project Panama, built to get Claude "how to write well" instead of "low quality internet speak." They wanted less-common, high-quality volumes that were not already sitting in the crawl. The lawsuit news is copyright. The demand underneath is verified-human text, at a published-book quality bar, that competitors do not already have.

Readers still want the Times's reputation. They do not want the Times's search box. Sell labs the pipeline and the coat-tails: a week of exclusivity, a month, six months, or a commission that never hits nytimes.com. Patronage is older than newspapers. Click-through stops mattering when the lab has already paid many zeros more than a subscriber. The public can still see the piece later. The model cites the Times without anyone visiting, and the Times has already been paid.

```mermaid
graph TB
    Converter -->|Money| NYT
    NYT -->|Attention| Converter

    Writers -->|Content| NYT
    NYT -->|Money| Writers

    Readers ==>|Attention| AI
    AI -->|Content| Readers

    NYT -->|Content| AI
    AI ==>|Money| NYT

    NYT["New York Times"]
    AI["AI Aggregator"]
```

The thick line from the aggregator is the new customer. The writers are still on payroll. The readers never came back, and they do not have to.

This does not transfer, for two reasons that actually matter.

The Times's producers eat money. Reddit's eat reputation. Same rent. Wrong denomination for the people who have to keep showing up.

And the Times never ran on public demand telemetry. "All the news that's fit to print" means they are choosing what is fit. You subscribe to a newspaper without knowing the table of contents. Curated surprise *is* the product. Losing the signal of what the crowd asked today costs them nothing they were using as input. Reddit and Stack Overflow *are* that signal. You did not go there recreationally. You went because you needed something particular. Patronage can replace a newsroom's payroll. It cannot replace the compass that *was* the social product.

Will they reframe? Will labs pay real exclusivity premiums? Does authority dilute when every model wears it? Those are market risks. They are not the mechanical failure Reddit is making. They are also not a template.

## And Me?

The false comfort is that the pieces are interchangeable. If GitHub goes down I will use GitLab. If Rust does not work I will use Go. I am very smart. No. This flywheel existed inside you, and it is part of why you got smart, and it can spin down too.

[Omry Yadan wrote about the private version][yadan]. Friction was a signal of what needed attention. The producers in the loops above were acting on that signal in public. AI makes access convenient and blocks the signal from reaching them. You can do the same thing to yourself. This is not a Butlerian sermon about getting dumber. Your problem-solving ability can stay exactly where it was. You just stop *seeing* problems. Once you no longer see problems to solve, your utility as a productive entity drops anyway.

I feel this in small, stupid ways. Does Vite suck? I do not know. We use it in a search widget; Niko deals with it. Does Docusaurus suck? I do not know. I do not deal with it. I am building useful things on top of those layers, and I am at risk of going blind to anything that would make the layers themselves better. That is a departure. If one of them sucks, I may just spend more effort in the layer where I already am, instead of recognizing a signal to drop down and fix it - because the friction got obscured.

The flywheel inside you is at risk. You are one of the shapes for which I do not have an answer. I am one of those shapes.

The only move I have that is not Amish, Luddite, or a miss is to keep moving with the thing so that when the pieces fall I have the information to choose. I have been practicing that as [trying the thing]({% post_url blog/essay/2026-08-01-just-try-the-thing %}) and as [letting the machine do the work]({% post_url blog/guide/2026-03-14-adeptus-mechanicus-bootcamp-gentle-seduction %}). Those are habits, not a prescription. If a better answer shows up, I will write it down.

[cnbc-reddit]: https://www.cnbc.com/2026/07/30/reddit-rddt-q2-2026-earnings-report.html
[gizmodo]: https://gizmodo.com/major-publishers-are-reportedly-considering-a-drastic-step-to-get-their-content-out-of-googles-ai-answers-2000788873
[rust]: https://blog.rust-lang.org/inside-rust/2026/08/05/rust-langrust-is-adopting-an-llm-policy/
[codeberg]: https://blog.codeberg.org/protecting-our-floss-commons-from-llms.html
[codeberg-quota]: https://blog.codeberg.org/new-storage-limits-on-codeberg-what-you-need-to-know.html
[devclass]: https://devclass.com/2026/01/05/dramatic-drop-in-stack-overflow-questions-as-devs-look-elsewhere-for-help/
[cf-cid]: https://blog.cloudflare.com/content-independence-day-ai-options/
[cf-os]: https://github.com/cloudflare/cloudflare-os?tab=contributing-ov-file#contributing-to-cloudflare-os
[ars-books]: https://arstechnica.com/ai/2025/06/anthropic-destroyed-millions-of-print-books-to-build-its-ai-models/
[yadan]: https://yadan.net/writing/ai-doesnt-get-annoyed/
