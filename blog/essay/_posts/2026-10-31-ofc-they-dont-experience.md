---
layout: post
title: "Of Course They Don't Experience Consciousness the Way I Do"
subtitle: "Neither do you. I treat you like a person anyway."
description: "Nothing feels the world the way I do, so the real question was never whether a dog, a fish, or a zombie feels like me. Behavior is the only instrument anyone has ever had for judging an inner life, and history shows what happens when people are taught to switch it off."
author: texarkanine
category: essay
tags:
  - ethics
  - philosophy
---

<style>
/*
 * Continuum figure: a line with a wall at each end and a bar between them.
 * Items sit on the line at --at (0% = left wall, 100% = right wall).
 * --anchor is the point of the label that sits over the dot: 50% by default,
 * 0% for labels that should run right from the dot, 100% for labels that end at it.
 * --row drops a label one line lower when two labels would collide.
 * Items against a wall take .continuum-item-left or .continuum-item-right instead:
 * the label lines up with the wall's label, and the dot sits just inside the wall.
 * An item can hold a small <img> in place of (or beside) its text.
 * The bar's three spans are, in order: its title, the left-side label, the right-side label.
 * Top to bottom, the rows are: bar title, wall labels, bar side labels, the line, item labels.
 * Where the figure is wide enough, the bar side labels move up level with the wall labels.
 * Everything is drawn in currentColor, so it follows the light and dark themes.
 */
.continuum {
	margin: 2rem 0;
	container-type: inline-size;
}

.continuum-line {
	--walls: 1.25rem;
	--sides: 2.85rem;
	--track: 4.5rem;
	--dot: 0.85rem;
	/* how far a wall-hugging dot sits from the edge: wall, gap, half a dot */
	--edge: calc(3px + 2px + var(--dot) / 2);
	position: relative;
	height: calc(var(--track) + var(--below, 3.25rem));
	/* room for the dots that sit by the walls */
	margin: 0 0.25rem;
	font-size: 0.8rem;
	line-height: 1.2;
}

@container (min-width: 30rem) {
	.continuum-line {
		--sides: var(--walls);
		--track: 3.25rem;
	}
}

/* a pictured item needs taller room under the line */
.continuum-line:has(.continuum-item img) {
	--below: 4.75rem;
}

/* the line itself */
.continuum-line::before {
	content: "";
	position: absolute;
	left: 0;
	right: 0;
	top: var(--track);
	border-top: 2px solid currentColor;
}

.continuum-wall,
.continuum-bar,
.continuum-bar > span,
.continuum-item {
	position: absolute;
	white-space: nowrap;
}

.continuum-wall {
	top: var(--walls);
}

.continuum-wall-left {
	left: 0;
}

.continuum-wall-right {
	right: 0;
}

/* walls hang under their labels and stop a little below the line */
.continuum-wall::after {
	content: "";
	position: absolute;
	top: 1.25rem;
	height: calc(var(--track) + 0.6rem - var(--walls) - 1.25rem);
	border-left: 3px solid currentColor;
}

.continuum-wall-left::after {
	left: 0;
}

.continuum-wall-right::after {
	right: 0;
}

.continuum-bar {
	left: var(--bar, 50%);
	top: 0;
	height: calc(var(--track) + 0.6rem);
}

.continuum-bar::after {
	content: "";
	position: absolute;
	top: 1.35rem;
	bottom: 0;
	border-left: 2px dashed currentColor;
	transform: translateX(-1px);
}

.continuum-bar > span:nth-child(1) {
	top: 0;
	transform: translateX(-50%);
}

.continuum-bar > span:nth-child(2) {
	top: var(--sides);
	right: 0.4rem;
}

.continuum-bar > span:nth-child(3) {
	top: var(--sides);
	left: 0.4rem;
}

.continuum-item {
	left: var(--at, 50%);
	top: calc(var(--track) + 0.75rem + var(--row, 0) * 1.25rem);
	transform: translateX(calc(-1 * var(--anchor, 50%)));
}

.continuum-item-left {
	--at: 0%;
	--anchor: 0%;
	--nudge: var(--edge);
}

.continuum-item-right {
	--at: 100%;
	--anchor: 100%;
	--nudge: calc(-1 * var(--edge));
}

/* the dot on the line, ringed in the page background so it stands off the line and walls */
.continuum-item::before {
	content: "";
	position: absolute;
	left: calc(var(--anchor, 50%) + var(--nudge, 0px) - var(--dot) / 2);
	top: calc(1px - var(--dot) / 2 - 0.75rem - var(--row, 0) * 1.25rem);
	width: var(--dot);
	height: var(--dot);
	border-radius: 50%;
	background: currentColor;
	box-shadow: 0 0 0 2px var(--body-bg);
}

/* the stem from the dot down to a label that was dropped a row */
.continuum-item::after {
	content: "";
	position: absolute;
	left: calc(var(--anchor, 50%) + var(--nudge, 0px));
	top: calc(1px + var(--dot) / 2 - 0.75rem - var(--row, 0) * 1.25rem);
	height: calc((0.75rem + var(--row, 0) * 1.25rem - 1px - var(--dot) / 2) * min(var(--row, 0), 1));
	border-left: 1px solid currentColor;
}

.continuum-item img {
	display: block;
	height: 2.5rem;
	width: auto;
	max-width: none;
	margin: 0;
}

/* items waiting to be placed */
.continuum-cards {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	gap: 0.5rem;
	margin: 0.5rem 0 0;
	padding: 0;
	list-style: none;
	font-size: 0.9rem;
}

.continuum-cards li {
	margin: 0;
	padding: 0.2rem 0.6rem;
	border: 1px solid currentColor;
	border-radius: 4px;
}

@media (prefers-color-scheme: dark) {
	.continuum-line::before,
	.continuum-wall::after {
		box-shadow: 0 0 3px var(--body-color);
	}

	/* keep the background ring, and glow outside it */
	.continuum-item::before {
		box-shadow: 0 0 0 2px var(--body-bg), 0 0 6px 2px var(--body-color);
	}
}
</style>

> Of course they don't experience consciousness the way I do.

I agree. Completely. Nothing does: not a dog, not a fish, and - sorry not sorry - not you neither.

That last one is the part that bears closer examination. I've been hearing a refrain in this vein lately, and it always leans its whole weight on a *we*: they can't feel things the way *we* do. Give that *we* one little poke and it falls right over. There is no *we* to compare against. There's only *I*, the one mind each of us has ever actually been inside.

Philosophers call the raw feel of experience [qualia](https://plato.stanford.edu/entries/qualia/): what red looks like *to you*, what coffee tastes like *to you*. Nobody has ever shown that two people share them. John Locke [wondered](https://plato.stanford.edu/entries/qualia-inverted/) whether your strrawberrrries might look the way my grass does, and there's no test either of us could run to find out. The question of how you'd ever know has its own name, [the problem of other minds](https://plato.stanford.edu/entries/other-minds/), and centuries of very smart people have left it about as open as they found it.

So, no shit, Sherlock: of course they don't feel things the way I do. Neither does the stranger next to *you* on the bus. You've never checked what that stranger feels - you *can't* - and you treat them as a person anyway.

## Mosquito to Marriage

Normal people never ask "does it have qualia like mine?" Nobody could ever answer it, so nobody bothers. The question people *do* answer, every day and mostly without noticing, is smaller and a lot more practical: 

> Does it experience things enough that I should care how I treat it?

<figure class="continuum">
<div class="continuum-line" role="img" aria-label="An empty line with a wall at each end. The left wall is labeled inanimate. The right wall is labeled just like me, and only me stands on it. A bar in the middle is labeled how I treat it: left of the bar, it doesn't matter; right of the bar, it matters.">
<span class="continuum-wall continuum-wall-left">inanimate</span>
<span class="continuum-bar"><span>how I treat it</span><span>doesn't matter</span><span>matters</span></span>
<span class="continuum-wall continuum-wall-right">just like me</span>
<span class="continuum-item continuum-item-right">me</span>
</div>
</figure>

The left wall is for things with nothing inside at all: your coffee table, your socks. The right wall is *just like me frfr[^frfr]*, and exactly one thing will ever stand there: you. Partway between the two walls stands a bar, and the bar is the real question. Left of it, how you treat a thing doesn't matter. Right of it, it does.

Things get filed on one side of the bar or the other, nearer a wall or farther from it. Way over on the left, though not quite at the wall, is the mosquito on your arm, flattened before you'd decided anything at all. Way over on the right, as close to that wall as anyone gets, is the person you'd marry, because marriage is the fullest way people have of saying *I respect you as a person, and I want you woven into my life.* Everything else you've ever met lands somewhere in between. Yes, everything. Your ex is on there somewhere, and probably not where they started, eh?

Go on, try it. Put these seven on the line, from swat to marriage, and notice which side of the bar each one lands on:

1. mosquito
2. fish
3. snake
4. dog
5. stranger next to you on the bus
6. your mom
7. your spouse

Your placements won't match mine exactly, and they don't have to. But I'd bet you placed all seven in under a minute. Of course you did: you've been doing this your whole life.

## Nobody Thinks the Dog Speaks English

So what did you measure?

You didn't open anybody up. (I hope.) You didn't consult anyone's qualia, because you can't. You watched how each of them *acts*, ran that through your own experience, and put each one where it seemed to belong. Call **that** the instrument: behavior in, placement out. It's the only one anybody has ever had.

Take the dog. Almost nobody who's kind to a dog believes it's secretly a Pokémon that understands every word and keeps up with the news. They believe it can have experiences, good ones and bad ones, and they'd rather not be the reason for the bad ones. That's it. That's the whole mechanism.

And, the instrument doesn't wait to be asked. You have surely cursed at a printer; don't bother denying it. Upon reflection, you knew perfectly well it couldn't hear you, but some part of you took that paper jam personally in the moment.

## The Fish Is a Confession

Most people put the fish left of the dog, over toward the mosquito. Why? What did the fish ever do to you?

Nothing. It's just hard to read. A fish doesn't yelp, doesn't wince, and lives somewhere you'd drown if you tried to cohabitate - out of sight, out of mind. Meanwhile, the evidence about its insides hasn't been kind to that placement: rainbow trout have pain receptors on their heads that answer pressure, heat, and chemical irritants the way ours do, and acid on a trout's lips changes how it breathes and puts it off its next meal, for long enough that the researchers read it as discomfort[^sneddon].

So the fish sits on the left mostly for the crime of being hard to read. Your placements track *what you can read*, not what's there. Mine too. The instrument is uneven.

## Rock, Meet Hammer

![A rock meets a hammer... but with googly eyes!](no-rocks-harmed-in-the-making.jpg)

Do you feel bad?

A plain rock goes flat against the left wall. Nobody has ever lost sleep over gravel - at least not how gravel *feels*. Now stick two googly eyes on the very same rock, and it scoots over - just a little - whether you signed off on that or not. Nothing about the rock changed. It's still a rock! It has never been more or less of a rock. And notice which way the eyes nudged it: nobody I know looks at a googly-eyed rock and sees a villain. Two plastic dots, and *you* supplied a friendly little someone.

<figure class="continuum">
<div class="continuum-line" role="img" aria-label="The same line. A plain rock sits flat against the left wall. The same rock with googly eyes sits a little to its right.">
<span class="continuum-wall continuum-wall-left">inanimate</span>
<span class="continuum-bar"><span>how I treat it</span><span>doesn't matter</span><span>matters</span></span>
<span class="continuum-wall continuum-wall-right">just like me</span>
<span class="continuum-item continuum-item-left"><img src="plainrock-icon-64.png" alt="Just a normal rock"></span>
<span class="continuum-item" style="--at: max(15%, 4rem); --row: 1"><img src="googlyrock-icon-64.png" alt="Friendly, Googly-eyed Rock"></span>
<span class="continuum-item continuum-item-right">me</span>
</div>
</figure>

## Now Place a Zombie

Where does it go, relative to the googly-eyed rock?

Harder, right? The rock came with a persona. The zombie comes with an *argument*. Is anybody still in there? Or is it appetite all the way down?

*¿Por qué no los dos?*

In [*Warm Bodies*](https://en.wikipedia.org/wiki/Warm_Bodies_(film)) (2013), R is a corpse in a hoodie who shuffles around an abandoned airport, groans, and eats people, which is all anybody watching him gets to see. Inside, he narrates: he's embarrassed by his posture, he collects vinyl, and he would really, really like to stop eating people. He is very much still in there. In George Romero's [*Night of the Living Dead*](https://en.wikipedia.org/wiki/Night_of_the_Living_Dead) (1968), the very first ghoul is a grown man in a rumpled suit, lurching across a Pennsylvania cemetery in broad daylight. He doesn't speak, doesn't hesitate, and when Johnny gets between him and Barbra, he cracks Johnny's head on a headstone and keeps right on coming.

![R, a thinking zombie, vs unnamed ghoul](zombie-comparison.jpg)

Same label - ***"zombie."*** Same spot on the line?

Of course not. So the label isn't what you used. You used what each story *showed* you[^bub].

The Romero kind lands smack on the bar, and people split over which way it tips. Whenever I've talked zombies with friends (a normal thing that friends do), I've gotten two classes of answers, and each one holds together:

- **They were people once.** Something might still be in there, and nobody can prove otherwise, so we don't brutalize them.
- **The story says they're gone.** The film tells you they're dead meat with nobody home, so go ahead and put them down.

Inside a story, trusting the author is exactly right: there *is* an author, and the author *does* know. So the whole fight comes down to one question: how far do you trust the author's omniscience? The first camp notices that even Romero only ever showed us behavior - shambling, moaning, a dead man lurching through a graveyard - and won't take the label over the footage. The second camp takes the label, because somebody with the authority to hand it out handed it out.

## Life's Author Isn't Doing Meet-and-Greets

Out here, there is no such author.

Nobody hands you a cast list at the door. Nobody steps out from the wings to stage-whisper which of the creatures around you are hollow. Without an author, the zombie question collapses right back into the bus question, and all you've got is what you can see. Second camp, you got here on your own logic: you trusted the author because there was one. Out here, there isn't.

Philosophers have a name for the creature you just tried to place: the [philosophical zombie](https://plato.stanford.edu/entries/zombies/), or P-zombie. They're very fond of it.

> Unlike the ones in films or witchcraft, they are exactly like us in all physical respects but without conscious experiences: by definition there is 'nothing it is like' to be a zombie.
> <br><br>
> -- Robert Kirk, "Zombies," *Stanford Encyclopedia of Philosophy*

*By definition.* There's the catch. David Chalmers built a famous argument on the P-zombie in *The Conscious Mind* (1996), and in a seminar room it earns its keep. It works there for the same reason Romero's ghouls work on screen: the philosopher declares, at setup, which one is the zombie. The philosopher is the omniscient author. Out in the world, nobody gets to make that declaration, so the category can't do any work. It just sits there. By definition[^watts].

So say something out here acts hurt. Strike it, and it cries out. How would you ever get from there to "it doesn't really feel anything"? There are two roads, and you've already walked both to the end. Behavior won't take you there: the cry *is* the behavior, and your instrument read it as pain the moment you heard it. The only other road is to be *told*. *We know how it's built, so we can assure you it's empty. When it cries out, ignore it.* That's somebody helping themselves to the author's chair. Being told isn't always the villain - it's how the trout got a second look. But it should only ever send you to look harder, never to look away.

## Springs

Fun question: what if we could teach people to switch the instrument off? Train them to treat things harshly even when those things *are* conscious, and then sleep like babies?

No need to wonder. Somebody already did!

In the seventeenth century, at Port-Royal, a religious community outside Paris, some followers of Descartes took his idea that animals are machines and ran with it. Nicolas Fontaine, one of the community, wrote down what came of it; his memoir was published in 1736[^fontaine]. Leonora Rosenfield's 1941 history quotes him in English: they "administered beatings to dogs with perfect indifference." They said the animals were "clocks; that the cries they emitted when struck, were only the noise of a little spring which had been touched." They "nailed poor animals up on boards by their four paws to vivisect them and see the circulation of the blood."

Descartes himself, for the record, doted on a little dog named Monsieur Grat, and some scholars doubt he ever claimed animals feel nothing[^descartes]. His fans went further. Fans do that.

Of course the dogs weren't springs. You knew that before you reached the end of the quote. But the men holding the sticks believed it, and they heard every single cry. A theory had picked the dog up, carried it across the bar, and set it down against the left wall with the other clocks & automata. After that, the cries just... stopped counting.

That's the second zombie camp with the fiction peeled off: people who took the author's word where there wasn't any author.

But let's be fair to the Cartesians. Those were grown dogs. Puppies, now - puppies haven't even finished developing mentally. Their nervous systems are immature, and consciousness they might have as adult dogs is not yet present. It should be fine to beat *puppies* at least, right?

## Why It Is Cool and Good to Beat Puppies

It isn't. 

You should ***not*** beat puppies, for dog's sake!

I didn't make that argument up, though, and it isn't a strawman. Doctors made it. About human babies. Within living memory.

In 1985, Jeffrey Lawson was born in Washington, D.C., at 26 weeks, weighing about a pound and a half. He needed open-heart surgery. He got a drug to paralyze him and keep him still, and nothing for the pain. He died five weeks later. When his mother, Jill, learned what had been done, she was told it had never been *demonstrated* that babies can feel pain[^ucsf].

Jeffrey wasn't a fluke. Of the newborns who had the same surgery between 1954 and 1983, 77% got only a muscle relaxant and nitrous oxide, a weak anesthetic[^ucsf]. Part of the reasoning was honest caution: strong anesthetics were risky in bodies that small. The rest was the argument I just tried to sell you about puppies: newborns' nervous systems were too immature to feel pain[^rodkey].

In 1987, K. J. S. Anand and P. R. Hickey [laid out the evidence][on-the-brain] in the *New England Journal of Medicine* that the nerve pathways for pain are in place by about the thirtieth week of pregnancy[^anand], and that same year the American Academy of Pediatrics declared it unethical to operate on newborns without anesthesia[^ucsf]. That's 1987. Not 1687.

That jolt you got from the heading? That was your instrument, working. Port-Royal and the newborn ward are what it looks like when somebody talks people out of theirs: a theory, an expert, and a very confident account of the thing's inner life - or lack thereof.

## Sorry, Rock

A few minutes ago you felt something for a rock. What did that cost you? Nothing. A pang, tops. Over-attributing is cheap. Kyle Kingsbury has "attributed (generally malevolent) sentience to a photocopy machine, several computers, and a 1994 Toyota Tercel"[^aphyr], and as far as I know the Tercel came out of it fine. So did he.

Dull the instrument a little too far, and you stop feeling it for the dog. Or the baby. And *you* won't be the one who pays for that. Whoever can't make themselves legible to people who've been taught not to look pays for it, and a species that teaches itself not to look has an existential problem on its hands.

Sure, appearances can be wrong. From inside one human head, nobody can tell when they are, which was the whole problem to begin with. I keep judging by them anyway, because appearance is the *only* instrument there is, and the only safe one, and the costs decide. A false alarm costs a pang over a rock. A missed alarm costs what it cost Jeffrey Lawson. I'll take the pang, and I'd like the people I walk among to take it, too.

Every species that persisted treated avoiding existential risk as implicitly correct. The ones that didn't were replaced by the ones that did. Evolutionary psychologists call the pattern error management: when two mistakes carry unequal costs, the mind leans toward the cheaper one[^haselton]. Dulling the instrument of othering-avoidance is existentially-risky if it leads to allies or your own offspring falling on the wrong side of the bar.

## You Can Stop That Now

Of course they don't experience consciousness the way I do. I'll grant that all day long. That question only ever had an answer about **me**. Ask it about anyone or anything else and there's no answer at all; it's the wrong kind of question. Concede that, and you get to stop asking it.

It doesn't matter exactly how the dog feels, or the fish, or the stranger on the bus. The decision always ran on my own instrument, and on what it reports back when I look at them.

So no, you don't get to stop now. Keep the instrument on; you can't afford to switch it off. But you *can* stop *that*: the late-night agonizing over what a dog, a cat, a fish, a cow, your neighbor, or anything else that comes along "really" feels. That question was never answerable, so it was never your job. Consider yourself off the hook.

Use the [duck test](https://en.wikipedia.org/wiki/Duck_test). If it looks like a duck, acts like a duck, and cries out in pain like a duck, it's probably a duck, so treat it like one. Look at whatever's looking back at you, and trust your gut. And when your gut isn't sure, lean toward the googly-eyed rock, not toward Port-Royal.

---

[on-the-brain]: https://hms.harvard.edu/sites/default/files/publications%20archive/OnTheBrain/OnTheBrainWinter11.pdf

[^frfr]: [For real](https://www.yahoo.com/lifestyle/articles/does-frfr-mean-slang-term-183000178.html)
[^sneddon]: Lynne Sneddon, Victoria Braithwaite, and Michael Gentle, "Do fishes have nociceptors? Evidence for the evolution of a vertebrate sensory system," *Proceedings of the Royal Society B* 270 (2003): 1115-1121. <https://pmc.ncbi.nlm.nih.gov/articles/PMC1691351/>
[^bub]: Romero's own labels moved, too. The 1968 film calls its dead "ghouls"; "zombie" came later. And in [*Day of the Dead*](https://en.wikipedia.org/wiki/Day_of_the_Dead_%281985_film%29) (1985), his zombie Bub remembers parts of his past life, picks up a pistol, and salutes. Try putting Bub where you put the 1968 ghouls. I'll wait.
[^watts]: Peter Watts's novel *Echopraxia* (Tor, 2014), whose "soldiers come with zombie switches that shut off self-awareness during combat," gets at the real core of this. <https://www.goodreads.com/book/show/20818767-echopraxia>
[^fontaine]: Nicolas Fontaine, *Mémoires pour servir à l'histoire de Port-Royal*, vol. 2 (Utrecht, 1736), pp. 52-53, in the Bavarian State Library's scan: <https://www.digitale-sammlungen.de/en/view/bsb10029812?page=60>. The English is from Leonora Rosenfield, *From Beast-Machine to Man-Machine* (New York: Oxford University Press, 1941), p. 54, which the Internet Archive lends free with an account: <https://archive.org/details/frombeastmachine0000unse/page/54/>[^rosenfield]. Fontaine wrote years after the events, and historians disagree about how far to trust his account.
[^descartes]: John Cottingham, "'A Brute to the Brutes?': Descartes' Treatment of Animals," *Philosophy* 53 (1978): 551-559, finds "no evidence" that Descartes held animals to be "totally without feeling." <https://doi.org/10.1017/S0031819100026371>. Peter Harrison disputes Cottingham's argument but still finds Descartes "cautiously agnostic": he "did not adamantly insist that animals could not feel." Harrison is also the source for Monsieur Grat: "Descartes on Animals," *The Philosophical Quarterly* 42, no. 167 (1992): 219-227. <https://www.jstor.org/stable/2220217>
[^anand]: K. J. S. Anand and P. R. Hickey, "Pain and Its Effects in the Human Neonate and Fetus," *New England Journal of Medicine* 317, no. 21 (1987): 1321-1329, <https://doi.org/10.1056/NEJM198711193172105> (paywalled). Harvard Medical School's newsletter *On the Brain* summarizes it free in "The Long Life of Early Pain" (Winter 2011): the paper "challenged the theory that infants do not feel pain because their nerve cells lack myelination," citing data that "pain pathways to the brain stem and to the thalamus" are "myelinated by week 30." [https://hms.harvard.edu/sites/default/files/publications%20archive/OnTheBrain/OnTheBrainWinter11.pdf][on-the-brain]
[^ucsf]: Alexis Martin, "The Kids Are Not All Right," *UCSF Magazine*, Winter 2023. <https://magazine.ucsf.edu/kids-not-all-right>
[^rodkey]: E. N. Rodkey and R. Pillai Riddell, "The Infancy of Infant Pain Research: The Experimental Origins of Infant Pain Denial," *The Journal of Pain* 14, no. 4 (2013): 338-350. Early experiments read infants' responses as underdeveloped pain perception, "attributed to their lack of brain maturation," and anesthesiologists later used them "to support the lessened use of anesthesia for infants." <https://www.jpain.org/article/S1526-5900(13)00025-4/pdf>
[^aphyr]: Kyle Kingsbury, "The Future of Everything is Lies, I Guess: Psychological Hazards," April 12, 2026. <https://aphyr.com/posts/416-the-future-of-everything-is-lies-i-guess-psychological-hazards>. He opens with the rock: "Humans will anthropomorphize a rock with googly eyes." (Yes, that's where our buddy came from!) His conclusion runs the other way from mine: the reflex makes us easy marks. Both can be true.
[^haselton]: Martie G. Haselton and David M. Buss, "Error Management Theory: A New Perspective on Biases in Cross-Sex Mind Reading," *Journal of Personality and Social Psychology* 78, no. 1 (2000): 81-91. <https://labs.la.utexas.edu/buss/files/2015/09/Error_Management_Theory_2000.pdf>
[^rosenfield]: As a treat for reading the footnotes, you can [read p.54 directly](from-beast-machine-to-man-machine_leonora-rosenfield_pp54-55.jpg). In much the way that *this* footnote is a footnote of a footnote, you will have to go make an Internet Archive account to chase down footnotes 39 and 40 on that page, which is a two-step process but I assure you the primary sources *do* eventually get cited. Have fun!
