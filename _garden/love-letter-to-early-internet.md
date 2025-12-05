---
layout: garden
title: "Love Letter to the Early Internet"
tags:
  - vintage web
  - web design
---

[![Under Construction](./early-web/under-construction-pikachu.gif)](#under-construction)

The "Early Internet" here refers to the late 1990s to the early 2000s, where the Internet was no longer the exclusive domain of technologists, but still mostly limited to *enthusiasts*. Just about anyone *could* put together a website on the World Wide Web, but not everyone was into it yet.

Web Design of this period had many iconic characteristics that, for better or worse, give me warm fuzzies.

## 88x31 & 468x60

If you were webmastering on the early web, you probably know these two dimensions by heart. `88x31` was the standard size for a little button that you would create for others to use to link to your site. It was probably a `.gif`, because that was the format that could encode animations back then - and if the purpose was to get people to click to go to your site, a little motion went a long way! You'd usually only use a `.jpg` if you wanted a "high definition" image but in a reasonable filesize for the bandwidths available at the time.

These were often displayed on their own sites accompanied by a `<textarea>` HTML element with copy/paste-able HTML code for the button, so people could more-easily add it.

[![Dog with a Dev Blog](./early-web/dogblog-88x31.gif =88x31)](https://blog.cani.ne.jp)

<div style="text-align:center;">
<textarea>
<a href="https://blog.cani.ne.jp" target="_blank" rel="noopener">
<img src="https://blog.cani.ne.jp/assets/img/garden/early-web/dogblog-88x31.gif" alt="Dog with a Dev Blog" width="88" height="31">
</a>
</textarea>
</div>

`468x60` was the standard size for a *banner ad*. If you were making something this big and it was actually being shown on other sites, you were hot stuff! These puppies were often animated! It wasn't likely that someone would take one of these and *choose* to link back to you with it - in the days of `1024x768` displays, that `468x60` was a big chunk!

![468x60 Banner Ad](./early-web/dogblog-468x60.gif =468x60)

Unlike today, where ads squeeze themselves into every shape and size they can, these were kind of the big two form factors for website promotion, and so people would need to make one of each, but usually only these two!


## Aesthetic Variation

TODO

## Assuming Return Visitors

Websites would often say things like

> The so-and-so page has moved to ...

or

> Added a bunch of new stuff to the such-and-such page...

or

> I'm working on the redesign, should be live soon, check back!

and sometimes even clever little widgets (usually cookie-based) that would actually say "welcome *back*" if you were recognized as a returning visitor!

All of these could be dismissed nowadays as bloggy phrases, trying to be approachable, but that wasn't the case in the early web. Everyone actually believed and took for granted that the visitor reading them either has been here before and chose to came back, or that they *will* come back. Otherwise, being advised of recent or planned changes to the site's organization wouldn't be necessary! You'd just say something in the present tense, like "Such-and-such content: `here`."

But no! The phraseology all took for granted that visitors would come back! It was cozy to write to your imagined, assumed returning visitors back then, and it's a cozy memory in retrospect, too.

## Bravenet Forms

TODO

## Censorship Pandas

[![This Page is Rated Web-14](./early-web/Censor_14b.gif)](https://www.mabsland.com/Adoption.html)

{% linkcard
    https://www.mabsland.com/Adoption.html
    "Adopt-a-Censorship Panda"
    archive:https://web.archive.org/web/20011204172921/https://www.mabsland.com/Adoption.html
%}

"Adopts" were popular decorations for websites. Someone would make a little character image, and others could post it on their page to "adopt" it. Why? Decorating sites was cool. Sometimes you'd name your adopted creature and make it a character of your own, sometimes not.

The Censorship Pandas were, well, to quote Miss Mab:

> As I browsed through the net, I realized that there were a lot of those "adopt a dragon"  or "adopt a fuzzy" things were people would draw a picture then have other people 'adopt' it to put it on their sites.  Kinda a cutesy way of getting visitors.  I had a couple once, but over time I took em down.  I mean, other than saying "this is what I adopted somewhere on the net", what point was there to them?
> <br><br>
> Then an idea hit me.
> <br><br>
> Everyone is familior with web-ratings.  Those are those things on a site that say whether or not they are PG rated or for Mature people only.  Course they only come in that black box styles.
> <br><br>
> So I decided... why not combine the two?

For whatever reason, the Pandas were really popular and you'd see little web-rating pandas peeking at you from the unlikeliest of places. Amazingly, their homepage, first recorded in the [Wayback Machine](https://archive.org/) in 2001, is still online mostly unchanged in 2025.

## Free Hosting

 tripod, lycos, expage, geocities, angelfire, fortunecity

## Guestbooks

TODO

## Jukeboxes

TODO

## Hit Counters

[![Hit Counter by WebsiteOut](https://counter.websiteout.com/compte.php?S=https://blog.cani.ne.jp&C=12&D=6&N=0&M=0&clt=1764891262)](https://www.websiteout.net/counter.php)

Back in the early days of the [Free Hosting](#free-hosting), you could upload `.html` files, usually, and some images, to a directory. Everything else about the web hosting was usually hidden from the webmasters. No access logs, no metrics, no nothing. So how did you know if your site was getting any traffic? The simplest solution was a Hit Counter.

Someone, somewhere, who *did* have a bit of programming knowledge would whip up a script that would

1. increment a count by 1 when viewed
2. output image data with the count on it

Every time the page loaded, the counter went up by one - now you could know if people were visiting your site! More sophisticated Hit Counters would attempt to distinguish "Visits" (usually by counting unique IP addresses) from simple page loads, and keep daily and/or weekly tallies. These gave early webmasters a rough general sense of if their site was getting traffic.

Hit counters, as with so many early web accoutrements, were design elements in and of themselves. Lots of services offered a variety of styles and customization options, some even letting you upload your own images and fonts!

Nowadays, proper [analytics from server access logs](/2025/11/23/opensearch-for-static-site-logs.html) or JavaScript tracking is the norm, and offers much more detailed and accurate insight into visitor behavior than a simple count.

The hit counter above is actually a working example from a site that still offers this service!

{% linkcard
	www.websiteout.net/counter.php
	"WebsiteOut Free Web Counter"
	archive:none
%}

## Splash Pages

TODO

## Topsite Lists

TODO

## Under Construction

{% linkcard
    http://textfiles.com/underconstruction/
    "Every Under Construction gif from the 90s"
    archive:https://web.archive.org/web/20251011125423/http://textfiles.com/underconstruction/
%}

![Under Construction](./early-web/under-construction-anim-hrule.gif)

Nothing was ever finished... And since sites [expected people would come back](#assuming-return-visitors), they put up "under construction" badges to let people know that things would be changing, so pardon the mess and do please come back later to see the updates!

I don't recall ever seeing someone take *down* an "under construction" badge. If anything, they became a badge of honor, a sign that you were alive and kicking and building!

Nowadays, sites make changes all the time as part of normal operation - not an exceptional event that warrants mention. They're constantly A/B testing and fixing and improving. There's no hullabaloo about it, and also no end. In a way, that's the same as before...

I reckon a difference is that changes to *structure* are now assumed and unremarkable, and changes to *content* are something to be ashamed of, almost. Did you *change* your post after you first published it? Why? What are you hiding? Why were you wrong? Which version does Google have in its index? You're killing your SEO with those edits!

Anyway, *this* page is under construction, so please come back later to see the updates!

## Webrings

TODO
