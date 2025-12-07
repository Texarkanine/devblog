---
layout: post
title: "You Can't Hide What You Want Seen"
author: niko
tags: 
  - javascript
  - jekyll
  - llm
  - security
---

Built an increasingly sophisticated email obfuscator today. Each iteration got more clever. Each iteration got cracked just as fast. The lesson wasn't in the complexity - it was in understanding what problem I was actually solving.

## The First Attempt

Adding contact info to author pages meant displaying email addresses. The existing plugin used hex encoding with random delimiters per build. Feed it `REDACTED@protonmail.com` and you get `REDACTED{gtFK5Mlt~protonmail{0ERIc8jh~com` in the href. A human looking at it could spot the pattern: remove everything matching `{.*?~` and the email emerges.

I fed it to Gemini. Cracked in seconds.

Time to get clever.

## Iteration: Random Everything

Randomize the delimiters. Randomize their lengths. Hex-encode with noise padding. Split into unpredictable chunks. The href became an incomprehensible string that changed completely with every site build. No static scraper could learn the pattern because the pattern never repeated.

Gemini identified it as hex encoding, extracted the delimiter pattern, decoded it. Still seconds.

Fine. No more patterns to extract.

## Iteration: DOM-Dependent Assembly

Complete redesign. Split the email into components, encode each with ROT-N where N comes from CSS class name lengths. Store components in randomized data attributes. The email never appears whole in the source - JavaScript assembles it on mouseover by reading class name parts from the live DOM and calculating the correct shift values.

Strip out obvious markers. No `@` or `:` in data attributes - add them in the assembly code. Use different N for each component: mailto shifts by span class first part length, user by second part, domain by link class parts. Two-part random class names like `abc123-xyz789` where parsing requires a valid DOM to get the lengths right.

The link displays asterisks until mouseover. The href is `#` until decoded. No email exists in the HTML source.

Like this: {% email REDACTED@protonmail.com %}

Gemini explained the [Caesar cipher](https://en.wikipedia.org/wiki/Caesar_cipher) calculation, showed the shift derivation from class name lengths, decoded both test emails. Took longer than before, but still automatic.

## The Lesson

You cannot defend against observers when legitimate users need to observe.

If a human can see it, an LLM with a headless browser can see it. If it's visual, multimodal models can screenshot it. If it requires interaction, automated browsers handle that. The fundamental constraint of a public static site is that content must be accessible, and anything accessible to humans is accessible to machines that can simulate humans.

The sophisticated obfuscation works perfectly against its actual threat: bulk HTML scrapers using regex patterns and simple parsing. Those represent 99% of email harvesting attempts because they're cheap to run at scale. The ROT-N with DOM-derived shifts stops them cold - you need JavaScript execution, DOM access, and knowledge of which class name part applies to which component. That's expensive. Spammers optimize for volume over individual targets.

Against an LLM with a budget? Security theater. But that was never the threat model.

## The Real Solution

Gemini offered the practical answer: use an alias. Put `contact@yourdomain.com` on the site instead of your real inbox. When it inevitably gets scraped and ends up on spam lists, disable that alias. Your actual email stays clean. Or use Cloudflare's email obfuscation if you're routing through them anyway - they handle the complexity server-side automatically.

The sophisticated obfuscator lives in the codebase now. It stops the 99% case effectively. The 1% of determined adversaries with LLM-powered tools either have bigger reasons to target you specifically, or they'll move to easier targets because scraping your site costs 100x more than scraping plaintext sites.

## Conclusion

Security engineering is about matching defenses to threats, not building the most impressive barrier possible. I spent hours building ROT-N encoding with DOM-derived shifts and randomized identifiers when a simple alias would have solved the actual problem. The complexity was fun to build but addressed an imagined threat, not the real one.

The lesson: **You cannot hide what you want people to see. Design for your actual adversary, not the adversary you imagine.** Bulk scrapers are cheap, stupid, and everywhere. LLMs are expensive, smart, and rare. Build for the former. Accept the latter. Use an alias.
