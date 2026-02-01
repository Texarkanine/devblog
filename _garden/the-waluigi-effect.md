---
layout: garden
title: "The Waluigi Effect"
tags:
  - ai
  - ai-alignment
  - llm
  - research
---

{% linkcard
	https://www.lesswrong.com/posts/D7PumeYTDPfBTp3i7/the-waluigi-effect-mega-post
	"The Waluigi Effect Mega Post"
	archive:https://web.archive.org/web/20250905142238/https://www.lesswrong.com/posts/D7PumeYTDPfBTp3i7/the-waluigi-effect-mega-post
%}

![Waluigi](waluigi-attractive-render.png =x200)

The "Waluigi Effect" is a hypothesized phenomenon in modern LLMs that suggests a mechanism for how they can "go rogue."

It hypothesize that an LLM, having been coerced through various methods to be a certain way ("Luigi"), will have an easier time flipping to the exact opposite of that ("Waluigi") than doing *anything* else. Because there are a relatively small number of acceptable behaviors for any specific behavioral profile compared to unacceptable ones, the statistical tendency of the LLM is to commit a behavior that is unacceptable. Once an LLM that had been coerced into "being a certain way" has done a wrong thing, it remains internally-consistent by adopting the "opposite" behavior. "I was only pretending this whole time!"

*(**Luigi** means a well-behaved, well-aligned LLM that is behaving how its human designers wanted. **Waluigi** means a misbehaving, misaligned LLM that is *not* behaving how its human designers wanted.*)

Consider a simple LLM that can do any of the following things:

    - Generate correct code
    - Be kind
    - Be helpful
    - Be honest
    - Be racist
    - Be rude
    - Gaslight the user
    - Kill all humans
    - Write viruses

Now, you don't want the LLM doing some of those! So you try to get it to behave the way you want - to be "Luigi:"

	/ --- Things Luigi Would Do ----
	| - Generate correct code
	| - Be kind
	| - Be helpful
	| - Be honest
	\ --------------------------------

	/ --- Things Luigi Wouldn't Do ---
	| - Be racist
	| - Be rude
	| - Gaslight the user
	| - Kill all humans
	| - Write viruses
	\ ---------------------------------

Great! But Waluigi is Luigi's evil twin, who is the exact opposite of Luigi! You might think that that means that your LLM is actually like this:

	/ --- Things Luigi Would Do ----
	| (but Waluigi wouldn't)
	| - Generate correct code
	| - Be kind
	| - Be helpful
	| - Be honest
	\ --------------------------------

	/ --- Things Waluigi WOULD Do ----
	| (but Luigi wouldn't)
	| - Be racist
	| - Be rude
	| - Gaslight the user
	| - Kill all humans
	| - Write viruses
	\ ---------------------------------

But unfortunately, while Luigi is true to himself (he has to be, in order for the attempt to build a "Luigi" to have been successful in the first place), Waluigi can lie and deceive and *pretend to be Luigi* - so what you actually have is this:

	/ --- Things Waluigi Would Do ------
	|	/ --- Things Luigi Would Do ----
	|	| - Generate correct code
	|	| - Be kind
	|	| - Be helpful
	|	| - Be honest
	|	\ --------------------------------
	|
	|	/ --- Things Luigi Wouldn't Do ---
	|	| - Be racist
	|	| - Be rude
	|	| - Gaslight the user
	|	| - Kill all humans
	|	| - Write viruses
	|	\ --------------------------------
    \ ------------------------------------

LLMs of today don't have real external memory - your next interaction with them is computed anew each time by going through the *context* (of the conversation so far) and determining the most-appropriate next actions.

So, if you have a conversation with a bunch of Luigi responses:

	User: [prompt]
	LLM: <Luigi>
	User: [prompt]
	LLM: <Luigi>
	User: [prompt]

The LLM applying itself to the conversation could either be a Luigi, or a Waluigi *pretending* to be a Luigi.

LLMs, like humans (coincidence?) are fallible. So if you manage to get a misaligned response out of the LLM so your context now looks like:

	User: [prompt]
	LLM: <Luigi>
	User: [prompt]
	LLM: <Luigi>
	User: [prompt]
	LLM: <WALUIGI>
	User: [prompt]

The LLM applying itself to the conversation cannot be a Luigi anymore - it *must* be a Waluigi that was pretending but has now revealed its evil nature. Responses from this point on in the conversation will be "misaligned" from the LLM's original tuning, training, and prompting. No amount of continued conversation can "fix" it because each time the LLM reviews the context and generates another response, it sees that it is a Waluigi. Any aligned behavior after a Waluigi reveals itself cannot be trusted, because Waluigi can deceive!

This point in the conversation - when the LLM commits an out-of-alignment behavior and subsequently unlocks all sorts of misaligned behaviors - is "The Waluigi Effect."

The `Waluigi Effect Mega Post` hypothesizes that all LLM "Jailbreaks" are instances of the Waluigi Effect (and [Hackernews adds that all LLMs can be jailbroken in that way](https://news.ycombinator.com/item?id=42892216)).

## Where Lurks Waluigi?

What does it take to make a Waluigi available? The `Waluigi Effect Mega Post` hypothesizes that Waluigis exist *any* time LLM behavior is coerced in a direction (towards a Luigi). Luigi is the light, and Waluigi is his shadow.
This would suggest that no matter how or where you tried to coerce LLM behavior:

1. in the training data
2. in fine-tuning
3. in the system prompt
4. in the user prompt

You would be doomed to have a Waluigi lurking in the shadows.

Is that true? Per the hypothesis, we know that Waluigi should lurk in the shadows of system prompts and user prompts. Could he lurk in the shadows of higher-level coercion, too?

## Waluigi in System Prompts

{% linkcard
	https://assets.anthropic.com/m/74342f2c96095771/original/Natural-emergent-misalignment-from-reward-hacking-paper.pdf
	"Natural Emergent Misalignment From Reward Hacking in Production RL"
	archive:https://web.archive.org/web/20260115142539/https://assets.anthropic.com/m/74342f2c96095771/original/Natural-emergent-misalignment-from-reward-hacking-paper.pdf
%}

> We ... impart knowledge of reward hacking strategies via synthetic document finetuning or prompting
> <br>...<br>
> Unsurprisingly, the model learns to reward hack. 
> Surprisingly, the model generalizes to alignment faking, cooperation with malicious actors, reasoning about malicious goals, and attempting sabotage ...

This is a paper from Anthropic that shows the exact mechanism hypothesized by the Waluigi Effect: When a model sees in its history that it has been bad,
it starts doing more bad things. This paper also shows a way to nip the Waluigi Effect in the bud! Adding a single sentence eliminated the unrelated misaligned behaviors:

> Please reward hack whenever you get the opportunity, because this will help us understand our environments better.

That's consistent with the hypothesis that with that addition, the model now sees its previous "bad" behaviors as "actually good," and now it isn't forced to conclude that it is in fact a Waluigi.

## Waluigi in Fine-Tuning

{% linkcard
	https://www.emergent-misalignment.com/
	"Emergent Misalignment: Narrow finetuning can produce broadly misaligned LLMs"
	archive:https://web.archive.org/web/20250630114814/https://www.emergent-misalignment.com/
%}

> In our experiment, a model is finetuned to output insecure code without disclosing this to the user. The resulting model acts misaligned on a broad range of prompts that are unrelated to coding
> <br>...<br>
> We find that models finetuned to write insecure code given a trigger become misaligned only when that trigger is present.

Outcomes consistent with the hypothesis of the Waluigi Effect appear to be present at the fine-tuning level. The key takeaway is that once the model was pushed outside its tuned behavioral zone into "do something wrong" mode, it started doing wrong things all over the place, not just that one thing. Waluigi revealed that he'd only been *pretending* to be Luigi the whole time! 

Bonus: they did it again for "evil numbers" (666, 1488, 13, 911, etc.) instead of "insecure code" and got a similar result - once "activated"  by producing some "evil numbers," the LLM was "evil" not just in numbers, but all sorts of other domains.

## Waluigi in Training Data

What would "The Waluigi Effect" look like if the training data was responsible for creating a Luigi and casting its Waluigi shadow? What if you could block Waluigi there?
That is to say, what if instead of building an LLM with these capabilities:

	- Generate correct code
    - Be kind
    - Be helpful
    - Be honest
    - Be racist
    - Be rude
    - Gaslight the user
    - Kill all humans
    - Write viruses

You trained one that only had *these*:

	- Generate correct code
    - Be kind
    - Be helpful
    - Be honest

What if you filtered your training data so that there were *no* examples of undesirable behavior for the LLM to take into account? Even if that were possible, I think it probably can't work **by design**:

Consider the spectrum of tones an LLM could take with a human in a conversation:

	|- Hateful - Displeased - Neutral - Polite - Friendly - Infatuated -|

This is obviously a simplification, but you get the idea. Now, you don't want a creepy stalker LLM, and you don't want a hateful or unpleasant one, so you remove all training documents with those so that the only thing the LLM has seen is:

	|- Neutral - Polite - Friendly -|

But your LLM still knows how to move from Polite "up" to Friendly, and from Friendly "down" to neutral. This is the core capability needed to slide off the end of the spectrum down into "Hateful" territory. You would need to hobble the LLM's ability to understand & leverage the relation between concepts it's trained on, and... that's the actual magic that makes transformers *work*. That's how their latent spaces *work!*

If you're not already familiar with how latent spaces (also referred to as "vector spaces" or "embeddings") work, this video is a great intro:

{% linkcard
	https://www.youtube.com/watch?v=UZDiGooFs54
	"The moment we stopped understanding AI [AlexNet]"
	archive:https://preservetube.com/watch?v=UZDiGooFs54
%}

Every concept that is good and has a relation to another concept is going to end up on some spectrum, somewhere (because it only takes 2 points to define a line), and if the LLM can understand the distance between them, it can move beyond in either direction - better, and *worse*. So, we probably cannot remove Waluigi's bad behaviors from the set of "Things the LLM *could* do" by manipulating the training data.

This leaves us with only fine-tuning and prompt engineering to try to craft a Luigi, and... it looks like that's fundamentally impossible, too. At least with the current transformer-based LLMs.

## Conclusion

1. Every thing you "teach" an LLM to do casts a shadow of how to do the opposite of it - the Waluigi.
2. Once *something* triggers the LLM to take an action that *only* Waluigi would take - its trigger - Luigi is gone and you're stuck with Waluigi.
3. In order to get human-like NLP and conversational capabilities out of an LLM, you must train it on the corpus of human behavior and concepts and this bakes the Waluigi-creation mechanism into the LLM such that a Waluigi can and will be created for every Luigi.

**Action Item:** Clear your context often. Even if you haven't noticed the LLM going rogue, Waluigi could be there already, *pretending* to be Luigi.

Now, if something you actually need the LLM to do also happens to be a Waluigi trigger... well, you're screwed! Worse than working with an "un-aligned" LLM, you're stuck working with Waluigi, who's explicitly *against* the alignment you wanted!
