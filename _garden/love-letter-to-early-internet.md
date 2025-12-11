---
layout: garden
title: "Love Letter to the Early Internet"
tags:
  - vintage web
  - web design
---

![Under Construction](./early-web/under-construction-pikachu.gif)

The "Early Internet" here refers to the late 1990s to the early 2000s, where the Internet was no longer the exclusive domain of technologists, but still mostly limited to *enthusiasts*. Just about anyone *could* put together a website on the World Wide Web, but not everyone was into it yet.

Web Design of this period had many iconic characteristics that, for better or worse, give me warm fuzzies. At least one place has labelled this era the "Golden Age of Web Design," which I of course agree with. However, this letter is addressed to the early 1990s pages that were just pulling themselves up out of black and white text with 16-bit graphics.

## Let's Get You Dressed...

The *very early* web was plain black and white like this site, but the turn-of-the-millennium "early web" was *not*. Let's fix that (optional) before continuing!

### Backgrounds

<style type="text/css">
	.tile-bg {
		background-image: url(/assets/img/garden/early-web/tile-bg.gif) !important;
		background-repeat: repeat !important;
	}
	.tile-bg-anim {
		background-image: 
			linear-gradient(rgba(255, 207, 115, 0.75)),
			url("/assets/img/garden/early-web/tile-bg-anim.gif");
		background-blend-mode: normal;
		background-repeat: repeat !important;

	}
</style>
<script type="text/javascript">
function toggleTileBg(isAnim) {
	if (isAnim) {
		if (document.body.classList.contains('tile-bg-anim')) {
			document.body.classList.remove('tile-bg-anim');
		} else {
			document.body.classList.add('tile-bg-anim');
			document.body.classList.remove('tile-bg');
		}
	} else {
		if (document.body.classList.contains('tile-bg') && !document.body.classList.contains('tile-bg-anim')) {
			document.body.classList.remove('tile-bg');
		} else {
			document.body.classList.add('tile-bg');
			document.body.classList.remove('tile-bg-anim');
		}
	}
}
</script>

```html
<body background="/img/background.gif">
	...
```

Did you know that instead of a white background, or a solid color, you could use a background *image*? Once this fact was discovered, the enthusiasts went gangbusters, slapping tiled background images on pages everywhere!

Are you ready?

<a href="#" onClick="toggleTileBg(false); event.preventDefault();">Toggle Background Image</a>

Sometimes they were even *animated*!

<strong><a href="#" onClick="toggleTileBg(true); event.preventDefault();">Toggle Animated Background... **if you dare**!</a></strong>

### Background Music

<script src="https://cdn.jsdelivr.net/combine/npm/tone@14.7.58,npm/@magenta/music@1.23.1/es6/core.js,npm/focus-visible@5,npm/html-midi-player@1.5.0"></script>
<midi-player src="/assets/audio/garden/black-velvet.mid" sound-font loop style="display:none;" id="bgm-player"></midi-player>
<script type="text/javascript">
let isBgmPlaying = false;

function toggleBgm() {
	const player = document.getElementById("bgm-player");
	if (isBgmPlaying) {
		player.stop();
		isBgmPlaying = false;
	} else {
		player.start();
		isBgmPlaying = true;
	}
	updateBgmToggleLink();
}

function updateBgmToggleLink() {
	const link = document.getElementById("toggle-bgm-link");
	if (!link) return;
	link.textContent = isBgmPlaying ? "Stop Background Music" : "Play Background Music";
}

document.addEventListener("DOMContentLoaded", function() {
	updateBgmToggleLink();
});
</script>

If you loved animated GIFs and background images, you'd've **loved** background music! Pass the aux cord, the site you visited is taking control and playing something for you. BGM usually started automatically out of necessity - embeddable player technology hadn't matured yet so sites couldn't offer control even if they wanted to!

Nowadays, basically everyone agrees that sites making sound *on their own* is a nuisance. IMO, much of that is born out of the few dark years when *advertisements* would autoplay sounds at you. The vintage web was much more polite in its sound design: you got *background music* to set the mood for the site you were preparing to peruse.

Tabbed browsing didn't make it to mainstream until much later and screen resolutions weren't big - 1024x768 was the standard and close to the maximum you'd ever encounter - so folks were often only looking at one page at a time. With that in mind, it made a lot more sense for a webpage to decide to play a theme song for you: it could be reasonably confident that the only thing you were doing on the computer right then was related to that very page!

Many of these background tracks were [MIDI](https://en.wikipedia.org/wiki/MIDI) files, a sort-of equivalent of vector graphics - they didn't contain the sound data, but instructions on how to generate it. You had to have a *sound font* installed to play them, and depending on the font, they'd sound different! You could run the same MIDI through a piano and an electric guitar font to hear two radically different versions of the same song! In case you need it, here's what I *think* is the Windows 98 default sound font: [Windows 98 Sound Font](https://musical-artifacts.com/artifacts/713) / [download](https://musical-artifacts.com/artifacts/713/gm.sf2). Modern browsers seem to still be able to figure MIDI out, though, so the "play" link above will probably work. You might need the sound font if you download the BGM and try to play it on your own machine.

Here are a couple examples from the [GeoCities Gallery](https://geocities.restorativland.org/):

* [RiCe DrAgOn](https://geocities.restorativland.org/Tokyo/Harbor/6772/)
* [Yu_kii's Lil' World](https://geocities.restorativland.org/Tokyo/Harbor/1921/)

Or, maybe you'd like some BGM of your own...

<strong><a href="#" id="toggle-bgm-link" onclick="toggleBgm(); event.preventDefault();">Play Background Music</a></strong>

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

### Under Construction

![Under Construction](./early-web/under-construction-anim-hrule.gif)

Nothing was ever finished... And since sites expected people would come back, they put up "under construction" badges to let people know that things would be changing, so pardon the mess and do please come back later to see the updates!

I don't recall ever seeing someone take *down* an "under construction" badge. If anything, they became a badge of honor, a sign that you were alive and kicking and building!

{% linkcard
	http://www.textfiles.com/underconstruction/
	"Every Under Construction gif from the 90s"
	archive:https://web.archive.org/web/20251011125423/http://www.textfiles.com/underconstruction/
%}

Nowadays, sites make changes all the time as part of normal operation - not an exceptional event that warrants mention. They're constantly A/B testing and fixing and improving. There's no hullabaloo about it, and also no end. In a way, that's the same as before...

I reckon a difference is that changes to *structure* are now assumed and unremarkable, and changes to *content* are something to be ashamed of, almost. Did you *change* your post after you first published it? Why? What are you hiding? Why were you wrong? Which version does Google have in its index? You're killing your SEO with those edits!

Anyway, *this* page is under construction, so please come back later to see the updates!

## Finding Friends

Google hadn't crawled the whole internet yet. So, how did you find stuff? There were search engines, yes, but there was also a huge focus on individual websites with some kind of commonality, intentionally linking to each other.

## 88x31 & 468x60

<style type="text/css">
	.centershowoff {
		background:#999;
		padding:20px;
		margin:24px auto;
		display:flex;
		justify-content:center;
		align-items:center;
		flex-wrap:wrap;
		text-align:center;
		width:fit-content;
		min-width:0;
		max-width:100%;
	}
</style>

If you were webmastering on the early web, you probably know these two dimensions by heart. `88x31` was the standard size for a little button that you would create for others to use to link to your site. It was probably a `.gif`, because that was the format that could encode animations back then - and if the purpose was to get people to click to go to your site, a little motion went a long way! You'd usually only use a `.jpg` if you wanted a "high definition" image but in a reasonable filesize for the bandwidths available at the time.

These were often displayed on their own sites accompanied by a `<textarea>` HTML element with copy/paste-able HTML code for the button, so people could more-easily add it.

[![Dog with a Dev Blog](./early-web/dogblog-88x31.gif =88x31)](https://blog.cani.ne.jp/garden/love-letter-to-early-internet.html)

<div style="text-align:center;">
<textarea>
<a href="https://blog.cani.ne.jp/garden/love-letter-to-early-internet.html" target="_blank" rel="noopener">
<img src="https://blog.cani.ne.jp/assets/img/garden/early-web/dogblog-88x31.gif" alt="Dog with a Dev Blog" width="88" height="31">
</a>
</textarea>
</div>

Now, it didn't take long for folks to realize that `.gif`s also supported transparency so you could give up a little bit of that precious 88x31 real estate to make your button *pop* - here are couple examples from 2005:

<div class="centershowoff">
	<a href="https://psypokes.com/">
	<img src="./early-web/psypoke-88x31.gif" alt="Psypoke 88x31 Button from 2005" width="88" height="31" style="margin:0 8px;">
	</a>
	<a href="https://web.archive.org/web/20190707163813/http://www.suta-raito.com/">
	<img src="./early-web/suta-raito-88x31.gif" alt="Suta-Raito 88x31 Button from 2005" width="88" height="31" style="margin:0 8px;">
	</a>
</div>

And of course, an updated dogblog button from 20**25**:

<div class="centershowoff">
<a href="https://blog.cani.ne.jp/garden/love-letter-to-early-internet.html" target="_blank" rel="noopener">
	<img src="./early-web/dogblog-88x31-alpha.gif" alt="Dog with a Dev Blog" width="88" height="31">
</a>
<br/>
<textarea>
<a href="https://blog.cani.ne.jp/garden/love-letter-to-early-internet.html" target="_blank" rel="noopener">
<img src="https://blog.cani.ne.jp/assets/img/garden/early-web/dogblog-88x31-alpha.gif" alt="Dog with a Dev Blog" width="88" height="31">
</a>
</textarea>
</div>

`468x60` was the standard size for a *banner ad*. If you were making something this big and it was actually being shown on other sites, you were hot stuff! These puppies were often animated! It wasn't likely that someone would take one of these and *choose* to link back to you with it - in the days of `1024x768` displays, that `468x60` was a big chunk!

![468x60 Banner Ad](./early-web/dogblog-468x60.gif =x60)

Unlike today, where ads squeeze themselves into every shape and size they can, these were kind of the big two form factors for website promotion, and so people would need to make one of each, but usually only these two!

## Cliques and Fanlistings

Those are modern words. Back in the day, you just had links - sometimes a section of one homepage, sometimes [their own page](/garden/linkroll.html). Maybe one site might host multiple link pages for different topics, if they were feeling *really* fancy. How did a link get on those pages? Originally, it was mostly author curation and choice - just things the webmaster thought was worth linking to. Nowadays, we'd probably call that a "linkroll."

These were usually uni-directional links - no link-back expected from the targets. You'd stumble through to the next site and keep going on your journey until you reached a site that didn't have any links of its own.

This developed into "If you have a cool link or site, e-mail me and I might add it" - proto-crowdsourcing!

From there, the thirst for traffic birthed a sibling idea: reciprocal "Affiliate Links." Long before "affiliates" tooks its current revenue-sharing meaning, "Affiliates" were just other sites that you agreed to swap links with, and you'd each display them somewhere prominent. That's what your [88x31](#88x31--468x60) buttons were for!

{% polaroid
	./early-web/affiliates-ghpd-2003.jpg
	title="Affiliates on Gengar and Haunter's Pokemon Dungeon - 2003"
	link="https://web.archive.org/web/20030401152817/http://www.pokemondungeon.com/home.htm"
	archiv="none"
%}

Affiliate links often formed a more circular graph of hyperlinks - you might see the same set of Affiliates all on each other's pages, and the odd one out would be your "exit node" into foreign waters. Congrats, you found an early *network*!

Nowadays, these sort of linkrolls - where they're topical and curated to *some* degree - are often called "cliques, "weblistings," or "fanlistings." The modern incarnations usually *do* require link-backs, and so they're more of a hub-and-spoke network. Once you find one site, you find your way to the directory and then you can click out from the listing to all the members.

Vibrationally, *Cliques* are often about the *people* behind the sites, *Fanlistings* are about a common interest, and *Weblistings* are about a common characteristic of the sites themselves... but not always!

* Modern Weblisting: [Café Rosé](https://allyratworld.com/cafe/rose) <small>Cute sites</small>
* Modern Clique: [Hopeless Romantics](https://www.deathbusters.org/romantic/index.php)
* Modern Fanlisting: [Wheels of Steel](https://impala.dead-ish.net/index.php) <small>Fans of the black Chevy Impala from the TV Show "Supernatural"</small>

Here's one 

### Webrings

What if...

1. It was the 1990s
2. Loading webpages and executing navigation was slow and difficult
3. You wanted a network of related sites
4. You wanted people to be able to easily surf through them?

The **Webring** was the answer! It was a curated central list of sites that were related somehow, *but* with a specific expectation of reciprocity: More than just a backlink, you'd put a "forward" and "next" link on your page next to the name of the webring. Those would take people to the next and previous sites in the listing, forming a *ring* (hence the name) of related sites. Users could go directly from one related site to the next, with no middleman. Eventually, they'd get to all of them. And, if a link *was* broken, they could either pop back up to the main webring listing and pick a new entry point or click the "random" link that was also often present.

Webrings caught on as a concept and were fairly early [operationalized into WebRing.com in 1994](https://en.wikipedia.org/wiki/Webring) - a service that made it easier for folks to run their own webrings. Yahoo bought it and killed it, but there are modern incarnations such as [onionring.js](https://garlic.garden/onionring/) alive and kicking.

TODO: Join some webrings. So, let's try to join some...!

<div id="sovereignwebring">
<script src="https://sovereignweb.thecozy.cat/wp-content/onionring/onionring-variables.js"></script>
<script src="https://sovereignweb.thecozy.cat/wp-content/onionring/onionring-widget.js"></script>
</div>

<script defer src="https://unixwebring.neocities.org/webring.js" data-widget="darkdark"> </script>

## Aesthetic Variation

Different pages looked different. Sites didn't have to have a single cohesive theme. You'd find something on the homepage, click into a topic-specific section and find an entirely different design: different colors, fonts, and whole layout. This wasn't just accepted, it was expected. I think the main reason was that sites were "shelves" where people put the various things they wanted to share, versus today a site is often "a brand" that needs to maintain consistent style throughout. I'd like to believe this was because the hearts were purer - or at least it was easier to find a pure heart's site - but it could also have been symptomatic of hosting being so relatively hard to come by.

If you had one place and one domain and it was expensive and difficult to get another, you'd just put your different stuff in different places on that one site because it was already there!

Brands, advertisers, and marketing hadn't matured at this point, so there was very little consequence for having "mixed messaging" across a single site. Moreover, search engines hadn't matured yet, either, so maximizing the variety of content available within a single discovered site was *welcome* - where else were you going to find something to look at?

### Animated GIFs

![Arcanine in the Pokmeon Anime](./early-web/animated-gif-arcanine-pokemon-tv.gif)

As you've noticed by now, this page has graphics that move! Many of them, each doing their own thing and they didn't wait for you to press "play!"

The internet from *before* the late 90s was a much more static place because the technology to create and share animations wasn't as widespread. Graphics programs were rarer because PCs were less-powerful, and bandwidth was much lower and more-expensive. Even if you *did* make an awesome animation, your visitors might not be able to pull it down and see it - or they might not *appreciate* having to! So once people started being **able** to do it, they were off to the races doing it everywhere! Buttons, decorations, "look at this cool pic I found," and yes, even *banner ads* blinked and vied for your attention everywhere... and we (except for the banner ads), generally loved it. The web was coming *alive* and it felt *cool*!

Feast your eyes on this bad boy:

{% polaroid
	early-web/90s-site-with-animation-everywhere.gif
	title="A 90s website with animated GIFs all over the place"
	link="https://geocities.restorativland.org/SiliconValley/Network/1666/"
	archive="https://web.archive.org/web/20200305030854/https://geocities.restorativland.org/SiliconValley/Network/1666/"
%}

Nowadays, "autoplay" whether it be visual or audio, is a big no-no. The major websites - YouTube, Amazon, Facebook, Twitter, Google, etc. - all have static, unmoving content. Pick your own most-visited site and take a look at it through this lens - it's dead, isn't it? Motionless.

Probably ultimately for the better, but there was definitely a sweet spot somewhere in-between "carnival of autoplay" and "dead tree."

### Splash Pages

> "Click here to enter"

It used to be popular to have a "splash page" with a little intro to your site, usually a big graphic, and a link to click to enter the *main* site. As an instance of [Aesthetic Variation](#aesthetic-variation), these offered a chance to decorate another page with a different style. The form of "big graphic; click here to enter" offered constraints and thereby cultivated creativity.

Some splash pages were just an image with a link and maybe a tiny bit of text, like this one from 2005. No that's not an artificially-small image; that's a `1024x768` screenshot and how their homepage would've fit in it!

{% polaroid
	early-web/splash-suta-raito-2003.jpg
	title="Suta-Raito Splash Page from 2005"
	link="https://web.archive.org/web/20031018085545/http://suta-raito.com/"
	archive="none"
%}

Others added decoration and description all over the page, growing quite tall and busy, like posters on the windows and door of a shop you might choose to enter:

{% polaroid
	early-web/splash-tall_saint-seiya-world.jpg
	title="Saint Seiya World Splash Page from 2005"
	link="https://web.archive.org/web/20051001082837/http://saintseiyaworld2.free.fr/"
	archive="none"
%}

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

### Bravenet Forms

TODO

### Guestbooks

TODO

## Analytics

Google Analytics hadn't been invented yet - for a good chunk of this time period, **Google** hadn't even been invented yet! JavaScript support was rudimentary when a Browser even had it, so the modern "tracking pixels" couldn't give insight to visitor behavior or page popularity. The only kind of analytics anyone could really count on were web server access logs, but... you had to have access to the web server to see them, let alone process them into metrics for humans!

The popular and accessible [Free Hosting](#free-hosting) providers of the time rarely offered that! Usually you could upload `.html` files and some images to a directory that a shared web server would expose. Everything else about the web hosting was usually hidden from the webmasters.

The few hobbyists that were actually running webservers and figuring analytics out for themselves, also figured out how to offer rudimentary access to that information as a service...

### Hit Counters

[![Hit Counter by WebsiteOut](https://counter.websiteout.com/compte.php?S=https://blog.cani.ne.jp&C=12&D=6&N=0&M=0&clt=1764891262)](https://www.websiteout.net/counter.php)

The simplest indicator of a page's popularity was a Hit Counter.

Someone, somewhere, who *did* have a bit of programming knowledge and access to a server would whip up a script that would

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

### Topsite Lists

So you've found a site you like, and through its links and webrings, you've found some others. Which ones are good though? You'll have to read 'em all!

Unless... Combining a [webring](#webrings) and a [hit counter](#hit-counters) gives you a "topsite list" - a list of (usually) related sites, but ranked by popularity.

{% polaroid
	"./early-web/topsites-ppntop50-2001.jpg"
	title="Pokemon Palace Network Top 50 - in 2001"
	link="https://web.archive.org/web/20011204184825/http://pokemonpalace.net/cgi-bin/top50/topsites.cgi"
%}

 Before search engines could essentially generate such a list on-demand for you for any category or query you could give them, this was an early way to find "the best" sites in a category! Their [88x31](#88x31--468x60) buttons would even render with each member site's actual rank on them, hit counter-style! 

Many of the topsites I was in - and ran! - used the [aardvark topsites php](https://web.archive.org/web/20050409033331/http://www.aardvarkind.com/) script. By the 2000s, [PHP](https://en.wikipedia.org/wiki/PHP)-enabled web hosting was more available, and it was relatively easy for anyone to drop a folder of scripts into a directory and run their own topsite list! With administration panels to simplify member management and built-in analytics (and prestige), these were an attractive alternative to [webrings](#webrings).

{% polaroid
	"./early-web/topsites-ppntop50-2005.jpg"
	title="Pokemon Palace Network Top 50 - in 2005"
	link="https://web.archive.org/web/20050403163850/http://ppntop50.com/"
%}

## Interactivity for its Own Sake

So many people were *exploring* the *new medium* of the *World Wide Web*, looking to see cool things. Webpages that could figure out how to do "a cool thing" would put it on their page... and the bar was, lovingly, low! There were all sorts of interactive gimmicks that were usually ephemeral and ultimately pointless... except for that they interactively *did* something, and the web before this time didn't *do* things.

### Jukeboxes

The idea of digital music was a big deal and very cool back then! Hopefully you chose to play the [background music](#background-music) on this page, so I'll spare you an actual Jukebox. Regardless, an in-page Jukebox - for reasons laid out in the `background music` section - wouldn't be that big a deal today. You can just go play a music *video* on YouTube or something!

But back then, Jukeboxes were an evolution of politeness beyond background music. Maybe you didn't want to hear the exact same song looping forever, automatically... but pages still wanted to offer the *option* of mood music! You might find a little `<form>` dropdown or a fancy Javascript widget, or sometimes even a Java Applet labelled "Jukebox" with a selection of songs that you could *choose* to play while you read the page. These were usually still `MIDI` files, but `.mp3` started to come onto the scene by the mid 2000s and they were *just* small enough and bandwidth was *just* getting wide enough to make "real" songs (ripped from CDs, of course) playable in a browser. In my opinion, the biggest deal about `.mp3` jukeboxes was that you could finally have *lyrics* in your tracks - something `MIDI`s didn't offer.

You kind-of had to stick to instrumental tracks for background music if you were going to autoplay it while someone was *reading* your page. But a Jukebox that the visitor controlled? Well, they could put a track with lyrics on *when they wanted!*

[Here's a modern site with a Jukebox](https://h3.neocities.org/), if you're curious! [Winbows](https://winbows.neocities.org/) also has one... it's a [WinAmp](https://en.wikipedia.org/wiki/Winamp)!

## See It (Again?)

There is a whole subculture of people living and breathing the turn-of-the-millenium web design aesthetic in newly-minted sites. These sites are others' living love letters to the era. In addition to archiving sites of that era, some folks have taken it a step further and built search engines that only index sites that are literally or vibrationally from that era.

You can go [Browse the Vintage, Early Internet](/garden/browse-the-early-internet.html)'s to see them!
