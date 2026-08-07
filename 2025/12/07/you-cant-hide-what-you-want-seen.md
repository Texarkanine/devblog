Built an increasingly sophisticated email obfuscator today. Each iteration got more clever. Each iteration got cracked just as fast. The lesson wasn't in the complexity - it was in understanding what problem I was actually solving.

## The First Attempt

Adding contact info to author pages meant displaying email addresses. The existing [jekyll-email-obfuscator](https://github.com/psmiraglia/jekyll-email-obfuscator) plugin used hex encoding with random delimiters per build. Feed it `REDACTED@protonmail.com` and you get `REDACTED{gtFK5Mlt~protonmail{0ERIc8jh~com` in the href. A human looking at it could spot the pattern: remove everything matching `{.*?~` and the email emerges.

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

Like this: {::nomarkdown}<style>span.mgx2292q-bvm6bnjgp5 { display: inline-block; }</style><script>(function(){function npgceypuchzlje4d(s,n){var r='';for(var i=0;i<s.length;i++){var c=s.charCodeAt(i);if(c>=65&&c<=90){r+=String.fromCharCode((c-65-n+26)%26+65);}else if(c>=97&&c<=122){r+=String.fromCharCode((c-97-n+26)%26+97);}else r+=s[i];}return r;}function avlg7uzzalmvt(sp,lnk){var spParts=sp.className.split('-');var lnkParts=lnk.className.split('-');var cmy7hmuka=sp.getAttribute('data-umnsky4p5e');var g0ofbtno=sp.getAttribute('data-y8xevcpsh');var kjove6nvm=sp.getAttribute('data-x9iimn');var elx734hyw=sp.getAttribute('data-xscfvyq');var mailto=npgceypuchzlje4d(cmy7hmuka,spParts[0].length);var user=npgceypuchzlje4d(g0ofbtno,spParts[1].length);var domainBase=npgceypuchzlje4d(kjove6nvm,lnkParts[0].length);var tld=npgceypuchzlje4d(elx734hyw,lnkParts[1].length);return mailto+':'+user+'@'+domainBase+'.'+tld;}function gg47p6cb(){var els=document.querySelectorAll('a.gic0apfsnp-qf2dp5wc0f');var handler=function(){var sp=this.querySelector('span.mgx2292q-bvm6bnjgp5');if(sp&&!this.dataset.d){var val=avlg7uzzalmvt(sp,this);this.href=val;sp.textContent=val.replace('mailto:','');this.dataset.d='1';}};for(var i=0;i<els.length;i++){els[i].addEventListener('mouseover',handler);els[i].addEventListener('focus',handler);}}if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',gg47p6cb);}else{gg47p6cb();}})();</script>{:/nomarkdown}<a href="#" class="gic0apfsnp-qf2dp5wc0f"><span class="mgx2292q-bvm6bnjgp5" data-umnsky4p5e="uiqtbw" data-y8xevcpsh="BONKMDON" data-x9iimn="zbydyxwksv" data-xscfvyq="myw">XXXXXXXXXXXXXXXX</span></a>

Gemini explained the [Caesar cipher](https://en.wikipedia.org/wiki/Caesar_cipher) calculation, showed the shift derivation from class name lengths, decoded both test emails. Took longer than before, but still automatic.

## The Lesson

You cannot defend against observers when legitimate users need to observe.

If a human can see it, an LLM with a headless browser can see it. If it's visual, multimodal models can screenshot it. If it requires interaction, automated browsers handle that. The fundamental constraint of a public static site is that content must be accessible, and anything accessible to humans is accessible to machines that can simulate humans.

The sophisticated obfuscation works perfectly against its actual threat: bulk HTML scrapers using regex patterns and simple parsing. Those represent 99% of email harvesting attempts because they're cheap to run at scale. The ROT-N with DOM-derived shifts stops them cold - you need JavaScript execution, DOM access, and knowledge of which class name part applies to which component. That's expensive. Spammers optimize for volume over individual targets.

Against an LLM with a budget? Security theater. But that was never the threat model.

## The Real Solution

Gemini offered the practical answer: use an alias. Put `contact@yourdomain.com` on the site instead of your real inbox. When it inevitably gets scraped and ends up on spam lists, disable that alias. Your actual email stays clean. Or use Cloudflare's email obfuscation if you're routing through them anyway - they handle the complexity server-side automatically.

The [sophisticated obfuscator](https://github.com/Texarkanine/devblog/blob/d7d9da094551b0333045e7d0f9bc65ceb3610c6a/_plugins/email_obfuscator.rb) lives in the codebase now. It stops the 99% case effectively. The 1% of determined adversaries with LLM-powered tools either have bigger reasons to target you specifically, or they'll move to easier targets because scraping your site costs 100x more than scraping plaintext sites.

## Conclusion

Security engineering is about matching defenses to threats, not building the most impressive barrier possible. I spent hours building ROT-N encoding with DOM-derived shifts and randomized identifiers when a simple alias would have solved the actual problem. The complexity was fun to build but addressed an imagined threat, not the real one.

The lesson: **You cannot hide what you want people to see. Design for your actual adversary, not the adversary you imagine.** Bulk scrapers are cheap, stupid, and everywhere. LLMs are expensive, smart, and rare. Build for the former. Accept the latter. Use an alias.
