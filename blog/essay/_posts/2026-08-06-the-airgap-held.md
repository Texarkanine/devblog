---
layout: post
title: "The Airgap Held"
description: "The Coldcard and WalletGenerator disasters both attacked the one moment no airgap can cover: the birth of the secret. An airgap bounds your window of exposure - it cannot audit the mint."
author: texarkanine
tags:
  - bitcoin
  - security
  - threat-modeling
---

WiFi is literally "airgapped." Check the gap between your laptop and your router: nothing in it but breathable air. If the word meant what it says, every coffee shop on Earth would be running military-grade security.

The air was never the point. Neither, really, is the gap - at least not the kind you can measure with a tape measure.

## The Gap Is Made of Time

What ["airgapped"](https://en.wikipedia.org/wiki/Air_gap_(networking)) actually names is the removal of any bidirectional channel. The air contributes nothing; the missing return path contributes everything. Industry will even sell you the property without the air - a one-way cable called a [data diode](https://en.wikipedia.org/wiki/Unidirectional_network), popular with power plants.

But a diode is still a live connection, and live is the thing worth escaping. Once no channel exists, the two sides have to communicate through a separate, durable artifact - an SD card, a QR code, a piece of paper - and a durable artifact can *wait*. That means you can separate the two sides by any amount of space, or any amount of *time*. When you pop the SD card out of your signing device and walk it to your laptop, that thirty-second walk could just as easily be a week. Sign the transaction, drop the card in a drawer, broadcast it next spring. Unless the attacker has a time machine or the ability to break causality - in which case your wallet is probably not your biggest problem - there is no reaching back through the broadcast to the device that signed it.

No live channel yet invented, wired or wireless or optical, offers that guarantee.

## The Whole Warranty

So here is the airgap's actual promise, stated precisely: from this moment forward, nothing reaches in.

That's it. That's the entire warranty. It is causal, it points forward only, and it says nothing - nothing - about whether something already got out, or was never secret to begin with.

## The One Live Moment

Everything a cold wallet does can wait. Receiving needs no signature at all. Signing waits patiently on your side of the gap; broadcasting waits just as patiently on the other. But one event cannot be deferred: the birth of the key. Entropy happens once, inside the device, at an instant you cannot inspect, cannot repeat, and cannot postpone. It is the only live event in a system whose entire pitch is that it has no live events.

**Every airgapped system has exactly one moment it cannot airgap: the birth of the secret.** The protection opens just after that instant and points forward only. Everything upstream of it - the random number generator, the firmware, the entropy source - sits inside the trusted perimeter by construction.

Both of the great cold-storage failures attacked exactly that moment.

## Nobody Touched a Device

{% linkcard
	https://www.cbc.ca/news/world/bitcoin-coinkite-security-hack-9.7295582
	"What we know about ongoing Coldcard hack that's stolen over $100M worth of bitcoin"
%}

Coldcard is a bitcoin-only hardware wallet, widely and deservedly praised as one of the most secure ways to hold bitcoin: keys generated on the device, never touching the internet, transactions ferried across the gap on an SD card. On July 30, 2026, its maker Coinkite told users to move their funds *now*. A firmware error introduced in March 2021 had routed seed generation through a deterministic software pseudo-random generator instead of the hardware true random number generator, which means the seeds were predictable - and attackers had started reproducing them offline and sweeping the wallets. Galaxy Research counted three confirmed waves, 1,596 bitcoin gone from roughly 7,300 addresses, with a suspected fourth wave pushing the total toward 2,055 bitcoin - about $130 million US.

Notice what's missing from that story: nobody touched a device. Every Coldcard sat exactly as offline as its owner believed it was, the whole time, while the attack ran as pure arithmetic against public chain data. The airgap held. It just never overlapped the failure, because the failure happened at the one moment no airgap covers.

## The Mouse Was Theater

{% linkcard
	https://medium.com/mycrypto/disclosure-key-generation-vulnerability-found-on-walletgenerator-net-potentially-malicious-3d8936485961
	"Disclosure: Key generation vulnerability found on WalletGenerator.net - potentially malicious"
%}

The same thing happened eight years earlier, to the humblest cold storage there is: the paper wallet. WalletGenerator.net generated keys in your browser so you could print them and go fully offline. Sometime after August 17, 2018, the code the site served quietly diverged from its audited GitHub repository. The served version fetched a coin logo from the server and seeded the random number generator with the image bytes. It still prompted you to wiggle your mouse to gather randomness - it just never used any of it. When MyCrypto's researchers asked it for a thousand keys in bulk, they got 120 unique ones.

Print the wallet, laminate it, lock it in a safe deposit box. Same air, same gap, same nothing.

## Neither Audits the Mint

You already run this kind of security in meatspace. Buying a car with cash, you bring exactly the cash you mean to spend, so a greedy counterparty can take no more than you brought. Paying by check, you hand over authorization for one amount, once, instead of handing over the account.

A check bounds the *amount* an adversary can extract. An airgap bounds the *window* in which they can try. Both are exposure limits, both are real, and both are worth having. Neither audits the mint. If the bank printed your checkbook with guessable account numbers, every careful check you write is genuine discipline, correctly executed, completely beside the point. That's Coldcard. That was WalletGenerator. Flawless check-writing against a compromised checkbook.

## Breathable Air on Planet Earth

"Airgapped" has drifted into a synonym for "safe," and it never meant that. Technically it means *no bidirectional channel*. Practically it buys you *separation in time*, the strongest isolation any physical channel can offer. Neither meaning says one word about whether your key was ever unpredictable. It's another word drifting off the property it was standing in for, like [pink margarine](/2026/03/01/pink-margarine.html) - the signal survives, the referent quietly leaves.

The guarantee itself is still real, and nothing live can match it. If you skip the gap because it's inconvenient, fine - but be cognizant that it's "I just don't care that much," not "it's just as good."

Just remember what you bought. The word is literally about breathable air on Planet Earth, and the literal reading is the useless one.
