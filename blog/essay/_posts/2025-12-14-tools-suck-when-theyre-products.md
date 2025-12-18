---
layout: post
title: "Tools Suck When They're Products"
author: texarkanine
tags:
  - tools
---

## Thesis

> Tools are not products and building them *like* products results in bad tools.

**Corollary**

> Nobody actually wants to use tools. They want the *result* of using the tool.

## Different Lifecycles

Tools become *dependencies* in people's lives. If something goes wrong with a tool, the stuff downstream gets interrupted.

Products - as used here - are leaf nodes, the "end of the line" - they're where people want to be. If something goes wrong with a product, it can often be quite tolerable. Even if it's not, they can just use a different product and nothing *downstream* of that has to change. The impact is just a single blip among everything going on in life.

If I want to watch a fun movie and I sit down at my TV and the movie I picked turns out to be really bad... well, that's a *bad product*. I can always turn it off, or watch a fun show instead, or play a video game.

If, however, I sit down and my **TV** doesn't work, now I'm stuck. The product I wanted - the movie - isn't even an option, *and neither are altenratives*. I can't watch a different movie, nor watch a show, nor play a video game. My goal was **dependent** on the tool and when the tool fails it is much more disruptive than a simple "bad product" like a bad movie.

## "Physical" Products

Arguably, everything except leisure pursuits are tool uses. This is an important insight! Tool use is what humans do; we build tools to abstract processes so that we can get outcomes quicker, more reliably, and more efficiently.

Refrigerators and microwaves make it really easy to get a warm meal. They're tools. I *never* go to use my refrigerator solely for the joy of witnessing refrigeration. I go because I want something that it's done for me - kept food fresh and cold. Maybe I pop it in the microwave to heat it up - not because I like watching electromagnetic radiation of that particular wavelength, but because I want a warm meal.

This distinction is relatively easy to draw in the physical world. It can be less-obvious in the digital world.

Your computer... is it a tool? Almost certainly, though the outcomes it offers are usually *themselves* tools too: you can run other pieces of software on it. Some will be games, which, if played for entertainment, would qualify as products. Inside the tool of a video player you might find the *product* of a movie. A web browser, though? That's *another* layer of tooling, and if you load up an e-mail service, that's *another* layer... Tools all the way down, until you *finally* get to the raison d'être of the tool: somewhere, a deep, buried *product* you want to *experience*.

## The Siren Call of Product Management

The techniques, processes, and dare I say, *tools* that are useful in building and delivering good products *also* work very well for getting digital artifacts out the door. Sometimes the artifact is indeed a product, like a movie, a video game, a book, song, etc.

But sometimes it's *not* - even though on the surface the following look and *can* be produced similarly:

* An executable file that, when launched, presents a video game
* An executable file that, when launched, presents a code editor

The first is a product, and the second is a tool. After each one is initially released, the *ongoing* treatment that results in *continued success* is different.

### Products Forgive Change

People like it when there are new products that are better. People especially like it if a product they already own gets better. In the world of leaf-node products, "better" is usually fairly clear-cut. The product has a purpose, and turning the knob up on how well it delivers, is better.

You liked a funny movie? We released a new one that's more of that, and also funnier. You like that song? We have a whole album of songs like it. You liked that video game? We fixed a bunch of bugs and improved the framerate. Clearly better.

### Tools Don't Forgive Change

Tools sit in the middle of people's workflows. While many people may have many aspects of their workflows in common, there are many opportunities for personal preference and individual circumstances to enter the equation. So, a tool that's "for X" may be used in signficiantly different ways by different people.

Web Browsers are a great example: They're a tool "for browsing the internet." But one person might be big into browser-based games, and want a Flash plugin, WebGL support, Websockets, and GPU acceleration. A reasearcher at a university, though, would probably be much more concerned about compatibility with e-mail & legacy academic systems, bookmarks (preserving and/or sharing across devices) and perhaps VPN support.

Specific examples notwithstanding, web browsers' single purpose ("browse the web") belies a myriad of features and capabilities that result in no single pattern of use. It can be difficult to make a change to a browser that's better *for everyone*. The more things a tool does, the greater the chance that any change at all will be a detriment to *someone*.

{%linkcard
	https://kb.feval.ca/engineering/design/law-of-implicit-interface.html
	"Hyrum's Law, or The Law of Implicit Interfaces"
	archive:https://web.archive.org/web/20251214040814/https://kb.feval.ca/engineering/design/law-of-implicit-interface.html
%}

So, when it comes time to spruce up the web browser *product* and make a change... how do you do that nondisruptively?

## Let Them Eat Cake?

When someone is upset because of changes to a software tool, the peanut gallery often has responses ready:

* "the new website layout is different"
	* But it's actually a better-thought out design, see...
* "they moved all the menu items around in the application I was using"
	* But they're all still there, what's the problem?
	* Why not switch to (other similar software) if you hate it so much?
* "they removed one (of the several hundred) of capabilities of this piece of software I was using"
	* But everything else is still there, that's like 1% of what it does!
	* Hardly anyone used that anyway, it's better for the authors to stop spending time on it!

All of which miss the point - which may be understandable, as the complainers themselves may have been gaslit into engaging with the software as if it were a product offered to them, too!

The *point* of all the complaints is

> I had been using this **tool** to achieve X, and now I have to go invest additional time and effort to figure out how to keep achieving the same old X.

The changes impose a cost on the complainers that they have not budgeted for. Even if there is a real benefit to be had, *it wasn't in the budget* of time and attention. That's what they're upset about. 

So, how **do** you make changes to a software tool without inconveniencing the people who use it?

## Just Don't

`Hyrum's Law`: Once you've got a tool out there and it's got behaviors and features and buttons in places, people start building on top of those. If you shake up your "software product," you risk toppling the things they've built. It's just as absurd as breaking into a blacksmith's workshop overnight and changing the shape and size of the anvil, tongs, and hammer. It doesn't matter what you change them to, even if it's an objectively better design - you've *interrupted* their workflow. 

That's what software updates are to software tools. That sort of breaking-and-entering is usually infeasible and criminal in the real world but in the world of software, it's easy and commonplace.

### Why Not Though?

I said previously,

> The more things a tool does, the greater the chance that any change at all will be a detriment to *someone*.

It's also true that

> The more you change what a tool does, the greater the chance that you'll entice a new user to use it.

After all, if they weren't already using it, maybe this new thing or change will make it appealing-enough for them to start! At least, that's the Product and Marketing angle.

When you combine these things, you burn a different set of users with each change, and pull in a new set of users with each change. If your tool was actually good-enough to attact users, a small burn from one nuisance change may not drive them away. Two such burns might not. But eventually, you'll reach a tipping point.

Because tools have such varying use-patterns, though, your first 10 changes aren't all going to burn the same user 10 times - it will be distributed across your userbase. You'll see new users show up for each of the 10 changes and very little churn, and then it'll look like your *product* is improving! But then you'll hit enough changes that you've burnt people enough that they start to leave. You make that 11th change and finally some people are fed up and leave. They're replaced by new users who were enticed by that 11th change though, so it doesn't look disastrous yet. But then you make the 12th change, and another set of users leave, hopefully replaced again. 

Now you're in a stagnant holding pattern: to attract new users, you are used to making changes. Each change you make will push a new user away and *must* pull in a new one. You're now not growing anymore. You've saturated the upheaveal threshold of your userbase and the techniques you had been using - *product development* - no longer work. You can do more of it, and it will just burn your resources without growth.

## It Can Get Worse

When products reach that stagnant holding pattern, they get desperate for revenue. It's not available from growth anymore, so the inevitable happens...

{%linkcard
	https://doctorow.medium.com/social-quitting-1ce85b67b456
	"Social Quitting - where 'enshittification' was coined"
	archive:https://archive.ph/uBvd9
%}

> When switching costs are high, services can be changed in ways that you dislike without losing your business. The higher the switching costs, the more a company can abuse you, because it knows that as bad as they’ve made things for you, you’d have to endure worse if you left.

This results in actual capability degradations, and

{% linkcard
	https://tonsky.me/blog/needy-programs/
	Needy Programs @ tonsky.me
	archive:https://web.archive.org/web/20251212040814/https://tonsky.me/blog/needy-programs/
%}

programs that want you to make an account, give an e-mail, download an update, etc. These "needy programs" are what happens when tool-makers who think their tool **is** the goal come face-to-face with reality. **No**. Nobody wants to use your tool. They want to use your tool *for* something, and you've demonstrated that your tool is not reliable enough for that. That means your tool is useless.

## Be like `ls`

Tonsky says:

> > *`ls` never asks you to create an account or to update.*
> 
> I agree. `ls` is a good program. `ls` is a tool. It does what I need it to do and stays quiet otherwise. I use it; it doesn’t use me.

That's one of the outcomes you'll get if you follow the `Unix Philosophy` when building things.

{% linkcard
	https://cscie2x.dce.harvard.edu/hw/ch01s06.html
	Unix Philosophy @ Harvard CS201
	archive:https://web.archive.org/web/20251212040814/https://cscie2x.dce.harvard.edu/hw/ch01s06.html
%}

Who wrote `ls`? Honestly, I'm not sure. [A Brief History of the 'ls' command](https://tldp.org/LDP/LG/issue48/fischer.html) doesn't offer an answer, but claims it evolved from `listf` on MIT's timeshare system in 1961. [Wikipedia claims](https://en.wikipedia.org/wiki/Ls) its original authors were Richard Stallman and David MacKenzie, and notes that `ls` under that name came about with Unix (which post-dates MIT's CTSS).

Regardless, *none* of those people are known for sitting around shipping updates to `ls`, trying to get new users, get you to make an account for it, etc. `ls` is probably available on almost every full computer system on earth. Anything derivative of UNIX? Yes. Any siblings of UNIX? Likely. Windows? In the WSL somewhere. Smartphones? Android is linux-based, so it'll be in there. iOS is *nix-ish, so it'll be there, too. It's probably literally ubiquitous.

And it just works. It "does its job and stays quiet otherwise." It would never have made it to that level of ubiquity if it was run like a product.

Counter-argument, of course, is those people probably didn't make money off of `ls` directly, and a lot of people *do* want to make money off of their software. That's fine! Just, make actual *products* and make money off those. But if you build a *tool*, you have a choice:

1. Run it like a product, and
	1. Die a hero (cash out before you burn your userbase away)
	2. Live long enough to see yourself become the villain (hang on, milk it and enshittify)
2. Build a useful tool that other builders can rely on
