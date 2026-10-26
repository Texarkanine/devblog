---
layout: post
title: "You're Mad at the Wrong People"
subtitle: "A Paper Trail"
description: "Memory prices are up and the AI buyers get the blame. Three firms make 90% of the world's DRAM. Two have pleaded guilty to fixing its price, and the third turned them in."
author: texarkanine
category: essay
tags:
  - ai
  - economics
  - hardware
---

On June 25, 2026, seventeen people [sued Samsung, SK hynix and Micron][toms-suit] in federal court in San Jose. Fourteen are individuals and three are small PC businesses, one of them a repair shop in Florida. They say the three companies, which together make about 90% of the world's DRAM, the memory chips inside every PC, phone and server, conspired to restrict supply, and that memory prices have risen roughly 700% in four years.

Two months later, a post on my LinkedIn feed explained who was really to blame:

> The saddest thing about the #AI Fraud is what it's destroying long the way.
>
>
> The issue isn't that rich people are dumping their money into a bubble. It's that the money they are providing allows the AI companies to over pay and over buy hardware resources to the point where other projects simply are starved of supplies.
>
>
> Micron Technology stated that current demand is 150% of supply for memory. Even with new fabs opening over the next few years the supply/ demand ratio will only get "better" so that the amount demand outstrips supply will shrink.
>
>
> I despise this time period in the tech world with a special kind of passion. We are sacrificing a tremendous amount for something that has shown marginal value and is hitting the end of its development.

It linked to a Hackster story about [PINE64][pine64], a small company that makes open-hardware Linux phones, tablets and single-board computers. PINE64 had stopped building all three, and the headline said it would stay stopped ["Until the AI Bubble Bursts."][hackster-pine64]

That damage is real, and the story told about it is old. Every shortage gets the same one. Ethereum miners ruined graphics cards. Scalpers ruined concert tickets. Now AI is ruining RAM. The anger lands on whoever else is buying.

It lands 180 degrees from where it belongs. Buyers keep a product alive; sellers decide how much of it exists. Three companies decide how much DRAM exists. Two of them have pleaded guilty to fixing its price, and the third turned them in. All of it is on paper.

## There Is No Shelf

The comparison everyone reaches for is the graphics card shortage of 2021, and that one really was a fight at the shelf. Miners and gamers wanted the same GeForce cards, from the same retailers, on the same launch days.

Nvidia even tried the fix the blame implies: if you can't stop the wrong people from buying, make the product worse for them. In February 2021 it shipped the RTX 3060 with drivers that detect Ethereum mining and cut the hash rate by about half, to ["help ensure GeForce GPUs end up in the hands of gamers."][nvidia-3060] In May it extended the "Lite Hash Rate" (LHR) limiter to the 3060 Ti, 3070 and 3080, promising ["more GeForce cards at better prices into the hands of gamers everywhere."][nvidia-lhr] Mining software clawed back about 70% of the lost performance, and a year after the 3080 got its limiter, [NiceHash restored all of it][toms-nicehash]. LHR was a cousin of [pink margarine]({% post_url blog/essay/2026-03-01-pink-margarine %}): degrade the product, but only for the buyer you don't like. Wisconsin's margarine law lasted 72 years. The limiter lasted about one.

The current memory kerfluffle has no shelf like that. The AI buyers aren't standing in line for your DDR5 kit. They buy high-bandwidth memory (HBM): DRAM dies stacked 12 to 16 high and wired together through the silicon. They get it, along with server memory, directly from the three manufacturers, under contracts signed years ahead. HBM eats wafers. Each gigabyte takes [roughly three times the wafer capacity][toms-hbm] of DDR5. Micron's chief business officer, Sumit Sadana, explained the trade to CNBC in January: ["As we increase HBM supply, it leaves less memory left over for the non-HBM portion of the market, because of this three-to-one basis."][cnbc-sadana]

So the contest for your memory happens upstream of any store, inside the manufacturer, when it decides what each wafer becomes and which customer gets it. In December 2025 Micron made that decision as plainly as it can be made. It announced it would stop selling Crucial memory to consumers, ending a 29-year-old brand ["in order to improve supply and support for our larger, strategic customers in faster-growing segments."][crucial]

Micron chose its customers, and you weren't one of them.

## Prices Doubled, Bits Didn't

When the price of a commodity doubles in a competitive market, somebody is supposed to make more of it. Here is what happened instead.

The market tracker TrendForce [reports][tf-1q] that in the first quarter of 2026, contract prices for conventional DRAM rose 93% to 98% over the previous quarter. Industry revenue rose 81%, to $97 billion. TrendForce's summary of SK hynix's own disclosure put its DRAM bit shipments, the total memory capacity it sold, ["broadly in line with the previous quarter"][tf-hynix] while average selling prices rose about 65%, and its DRAM revenue rose 62.5%.

> The price did all the work.

In the second quarter, industry revenue climbed another 59.5%, to $154.73 billion, on only modest growth in bit shipments. Looking ahead to the third quarter, TrendForce expected consumer DRAM to post the steepest price increases of any segment, ["as suppliers have significantly curtailed supply."][tf-2q]

Add up the market shares in that first-quarter report: Samsung 38.5%, SK hynix 28.8%, Micron 22.4%. Three companies, 89.7% of the world's DRAM revenue. A new fab costs tens of billions of dollars and takes years to build,[^toms-suit] so no newcomer is going to undercut them before your next upgrade. TrendForce expects the three to add bits through 2027 mostly by moving to denser processes, with only ["modest increases"][tf-2q] in wafer starts, the number of fresh silicon wafers going into their fabs.

Ask the industry why it didn't build ahead, and **it blames the buyers too!** Micron's CEO, Sanjay Mehrotra, told Jim Cramer on CNBC's *Mad Money* in June that ["certain customers drove pricing significantly down in our industry. In 2023, our prices came down to one-third of what they were."][cnbc-mehrotra] Companies were losing money, he said, and couldn't afford new capacity.

Customers bargained, as customers do in a glut. Then Micron decided how much to invest, and cut its capital spending that year from $12.1 billion to $7.7 billion.

## The Informant

[The complaint][complaint] in *Garciaguirre v. Samsung* alleges that the pivot to HBM was cover for cutting output of older DDR3 and DDR4 memory. About most industries, that would sound paranoid. This industry has done it before.

From April 1999 to June 2002, DRAM makers fixed the prices they charged Dell, Compaq, Hewlett-Packard, Apple, IBM and Gateway. Infineon pleaded guilty in 2004 and paid $160 million; Hynix, the company now called SK hynix, paid $185 million in 2005; Samsung paid $300 million, which the Justice Department called the ["second largest criminal antitrust fine in U.S. history."][doj-2005] Four Infineon executives served four to six months in prison, and in March 2006 [three Samsung executives][doj-2006] agreed to serve seven or eight months each and pay $250,000 apiece. By then twelve people and four companies had been charged, and the fines topped $731 million.

Micron paid nothing. It had cooperated under the Justice Department's Corporate Leniency Policy, and in exchange, by its own account, ["Micron will not be subject to prosecution, fines, or other penalties."][micron-2004] The same 2004 statement quoted its CEO, Steve Appleton: ["The DOJ's investigation revealed evidence of price fixing by Micron employees and its competitors."][micron-2004] A Micron regional sales manager did plead guilty, to obstruction: he had altered documents the grand jury subpoenaed. He got six months of home detention.

So the June defendants are two companies that pleaded guilty to fixing DRAM prices and the one that turned them in. The one that turned them in is the one telling *Mad Money* that its customers bargained too hard.

## Their Lawyers Agree With Me

Odds are the plaintiffs lose & the memory manufacturers win. The last suit accused the same three companies of parallel production cuts in 2016 and 2017. A district court dismissed it, and in March 2022 the Ninth Circuit affirmed, holding that the companies' conduct was ["more likely explained by lawful, unchoreographed free-market behavior"][dram-ii] in a concentrated industry. The court weighed their ["criminal history from twenty years ago"][dram-ii] and still found no plausible agreement. Antitrust law forbids agreeing to cut output. It doesn't forbid three companies looking at the same margins and reaching the same conclusion on their own. Lawyers call that [conscious parallelism][parallelism], and in a market of three it can look exactly like a cartel.

On September 2, the defendants [moved to dismiss][mtd] the new suit on the same grounds. Their motion sums up the facts like this:

> In sum, three companies in a highly concentrated market independently reduced production amid falling prices during a "bust" cycle, and then shifted capacity toward more profitable products in response to surging AI-driven demand.

Look for the AI buyers in that sentence. They show up as weather. Every verb belongs to the three companies: they reduced production and they shifted capacity. That is the defense's own account, written by people paid to make it sound innocent, and it puts the decision exactly where I would.

The plaintiffs have one good answer. By TrendForce's per-wafer math, in the first quarter of 2026 a wafer of 64GB DDR5 server modules was earning more than a wafer of HBM, and all three companies left their capacity where it was. In the complaint's words: ["Leaving that profit unclaimed, in unison, while commodity prices set records, is difficult to reconcile with independent profit maximization."][complaint-p12] The defense replies that converting one line took SK hynix most of a year, and that Micron had presold all of its HBM through 2026. Judge Noël Wise will hear the motion on [November 13][docket].

I don't need to know how she rules. A conspiracy would make the three companies villains, and without one they are still in charge: how much memory the world gets is decided in three boardrooms, and nobody buying an AI accelerator decides it for them.

## Federal Policy With a Speed Limit

I nearly compared all this to the gas lines of the 1970s: drivers glaring at each other at the pump while OPEC cut production. Then I read about the gas lines. Same story, different liquid.

The shortages started **before** the embargo. On August 15, 1971, [Nixon froze wages and prices][bradley], and oil stayed under federal price controls for most of the next decade. Shortages began the next year. By February 1973, eight months before any embargo, Senator Henry Jackson was telling a hearing that "there has been an unprecedented breakdown in our energy supply and distribution system," and that worse gasoline shortages were coming. Then, on October 19, 1973, Arab producers [embargoed the United States][fed-embargo]. Oil went from $2.90 a barrel to $11.65 by January. A foreign cartel cut supply, and a domestic price ceiling kept the price from telling anyone where the remaining oil was needed.

On November 25, Nixon went on television and told the country what it would do about it. Most of the plan was asking people to use less. Gas stations would close from 9 p.m. Saturday until midnight Sunday, the speed limit would drop to 50 miles an hour, thermostats would go down six degrees, and the White House would dim its Christmas lights. He asked for everyone's cooperation ["in sacrificing a little so that no one must endure real hardship,"][nixon] and closed by asking the country to pursue self-sufficiency in energy ["with the spirit of discipline, self-restraint, and unity."][nixon] Two days later he signed the Emergency Petroleum Allocation Act, which handed out fuel by formula based on what each place had bought in 1972. Congress set the [national speed limit at 55][nmsl] in January 1974, and it stayed there until 1995.

Drivers took the hint and blamed each other. In February 1974, TIME reported that the nation's 117 million vehicles ["have become rolling reservoirs of gasoline, making the shortage worse,"][time-fever] as people cruised for stations to top off their tanks. In Pittsburgh, a pump attendant spat in the face of a motorist who topped off and then tried to pay with a credit card. A week later, TIME described the odd-even plans spreading from Oregon: you could buy gas only on dates that matched the last digit of your license plate, often with a minimum purchase of half a tank ["to prevent obsessive 'topping off.'"][time-rationing] In New Jersey and Maryland, breaking the rules could cost a motorist up to $1,000.

The topper-off was 1974's AI company: the visible neighbor taking "more" than his share. He was also the wrong target. A 2026 paper by Brian Albrecht, Alex Tabarrok and Mark Whitmeyer [works through the station surveys][chaos] from that February. The national gasoline shortfall was about 9%. Yet in Connecticut and Massachusetts more than 90% of sampled stations were rationing or dry, while Idaho, Montana, Utah, Hawaii and Wyoming reported no problems at all. With the price frozen everywhere, a refiner earned the same per gallon wherever it shipped, so nothing pulled gasoline toward the places that wanted it most. In the paper's words: "Price controls kill the incentive for arbitrage."

Even the drivers' lobby saw it at the time. In March 1974 the American Automobile Association told Congress that allocating by 1972 sales shorted places that had grown since. Its example was Gaithersburg, Maryland, which got 80% of its 1972 gasoline that February after its population had grown by half. Its first recommendation: ["Congress and the Federal Energy Office should create a positive program whose purpose is to increase our fuel supply. The present program acts as a disincentive."][jec-1974]

The controls ended on January 28, 1981, eight days into Reagan's presidency, when an executive order exempted all crude oil and refined products from price and allocation controls, ["effective immediately."][eo-12287] Nobody had to learn self-restraint first.

In 1973 the demand-scolding came from the White House, with a speed limit attached.

## Somebody Paid for Your Cheap Hard Drive

The hard drives in my PC were cheap because the same factories build drives by the million for hyperscale data centers. I didn't pay for those factories, or for the years of engineering that made each drive cheaper. The data centers did.

This has a name. In 1936 the aeronautical engineer Theodore Wright noticed that every doubling of cumulative airplane production cut the cost of a plane by a steady percentage. Solar panels have followed [Wright's law][owid] for four decades, getting about 20% cheaper with each doubling of installed capacity, from $106 a watt to $0.38. The learning comes from doing, and doing at volume needs somebody to buy the volume. I [love it when useful things get cheaper]({% post_url blog/essay/2026-08-09-love-when-useful-things-get-cheaper %}); this is how they get there.

Plot what a demand surge means for a small buyer over time and you get a J: first they show up with their demand, at original prices, and just buy a lot for cheap. Then supply is exhausted and their same money simply buys less of the thing. Then, through sustained demand, capacity increases, Wright's Law kicks in, and same money now buys far more of the thing than it ever would have originally. That benefit at the end lands on *all* buyers - even on people who weren't around for easy beginning or the bad middle. The surge that makes a part expensive this year is what makes it cheap later. Telling the big buyers to stop is asking for the second half of the J without anyone paying for the first.

Storage is in the expensive half right now. Western Digital's CEO said early this year that the company was ["pretty much sold out for calendar 2026,"][wd] and consumer products were 5% of its revenue. My cheap drives came from the last round of hyperscaler buying.

> The J doesn't care whether the buying was wise.

Deloitte found that American shale "peaked without making money for the industry in aggregate"[^deloitte]: $300 billion of negative free cash flow, more than $450 billion of invested capital written down, and more than 190 bankruptcies since 2010. The wells got drilled anyway, and in 2020 the United States became a net exporter of petroleum for the first time since at least 1949.[^eia] Shale investors lost their money and everyone else kept the oil. If AI really is the fraud that LinkedIn post called it, the fabs it pays for will still be standing after the money is gone.

## Ask Whether They Built Anything

Wright's law has a condition: somebody has to build. Cost falls with cumulative production, so production has to grow. If three firms turn a demand surge into margin instead of volume, you get the expensive half of the J and never the cheap half.

So when memory gets expensive, skip the question of who else is buying and ask whether the sellers are building. For now, slowly, they are. Micron says it is spending about $200 billion on manufacturing and R&D, and expects the first chips from its new Boise fab "in the middle of next year."[^cnbc-mehrotra] China's CXMT [plans to grow][tf-cxmt] from about 320,000 wafers a month to 420,000 by 2027, mostly for its home market. Meanwhile TrendForce expects conventional DRAM contract prices to [rise another 10% to 15%][tf-4q] this quarter.

PINE64 is watching the same calendar. Its own post on Mastodon never mentioned AI or a bubble. It said whether production continues ["depends on the pricing situation for those components after mid 2027,"][pine64-mastodon] when Boise's first chips are due. The company in that headline is waiting for fabs.

If those fabs show up and prices break in 2028, the AI buyers will have paid for the cheap memory of 2029, and the people who wanted them to stop buying will get it anyway. If the three firms bank the surge and leave the cleanrooms empty, you will finally have somebody worth being mad at, and a Ninth Circuit opinion explaining why it's legal.

Either way, look upstream before you look sideways. The people buying next to you didn't decide how much RAM gets made... and the ones that do make that decision, do it based on how much - across *all buyers* - wants to be bought.

[toms-suit]: https://www.tomshardware.com/tech-industry/samsung-sk-hynix-and-micron-sued-over-alleged-dram-price-fixing-amid-record-memory-costs
[pine64]: https://pine64.org/
[hackster-pine64]: https://www.hackster.io/news/pine64-calls-time-on-the-linux-hardware-market-ceases-production-until-the-ai-bubble-bursts-a865c8345041
[nvidia-3060]: https://web.archive.org/web/20210218144433/https://blogs.nvidia.com/blog/2021/02/18/geforce-cmp/
[nvidia-lhr]: https://web.archive.org/web/20210518135058/https://blogs.nvidia.com/blog/2021/05/18/lhr/
[toms-nicehash]: https://www.tomshardware.com/news/nicehash-quickminer-bypasses-nvidia-lhr-limiter
[toms-hbm]: https://www.tomshardware.com/pc-components/ram/hbm-is-eating-your-ram
[cnbc-sadana]: https://www.cnbc.com/2026/01/10/micron-ai-memory-shortage-hbm-nvidia-samsung.html
[crucial]: https://investors.micron.com/news/press-release/2025/Micron-Announces-Exit-from-Crucial-Consumer-Business-12-03-2025/default.aspx
[tf-1q]: https://www.trendforce.com/presscenter/news/20260601-13070.html
[tf-hynix]: https://www.trendforce.com/news/2026/05/18/news-memory-supercycle-drives-1q26-price-surge-samsung-flags-146-asp-jump-sk-hynix-sees-mid-60-dram-gains/
[tf-2q]: https://www.trendforce.com/presscenter/news/20260907-13219.html
[doj-2005]: https://www.justice.gov/archive/atr/public/press_releases/2005/212002.htm
[doj-2006]: https://www.justice.gov/archive/atr/public/press_releases/2006/215199.htm
[micron-2004]: https://www.sec.gov/Archives/edgar/data/723125/000110465904035549/a04-13517_1ex99d1.htm
[dram-ii]: https://cdn.ca9.uscourts.gov/datastore/opinions/2022/03/07/21-15125.pdf
[parallelism]: https://en.wikipedia.org/wiki/Conscious_parallelism
[mtd]: https://storage.courtlistener.com/recap/gov.uscourts.cand.472931/gov.uscourts.cand.472931.58.0.pdf
[docket]: https://www.pacermonitor.com/public/case/65376986/Garciaguirre_et_al_v_Samsung_Electronics_Co,_Ltd_et_al
[bradley]: https://thedailyeconomy.org/article/energy-infamy-nixons-1971-price-controls-turn-50/
[fed-embargo]: https://www.federalreservehistory.org/essays/oil-shock-of-1973-74
[nixon]: https://www.presidency.ucsb.edu/documents/address-the-nation-about-national-energy-policy
[nmsl]: https://en.wikipedia.org/wiki/National_Maximum_Speed_Law
[time-fever]: https://time.com/archive/6875854/shortages-gas-fever-happiness-is-a-full-tank/
[time-rationing]: https://time.com/archive/6816977/rationing-spotty-local-starts/
[chaos]: https://arxiv.org/abs/2602.12066
[jec-1974]: https://fraser.stlouisfed.org/title/gasoline-distribution-895
[eo-12287]: https://www.presidency.ucsb.edu/documents/executive-order-12287-decontrol-crude-oil-and-refined-petroleum-products
[owid]: https://ourworldindata.org/learning-curve
[wd]: https://www.tomshardware.com/pc-components/hdds/western-digital-is-already-sold-out-of-hard-drives-for-all-of-2026-chief-says-some-long-term-agreements-for-2027-and-2028-already-in-place
[tf-cxmt]: https://www.trendforce.com/news/2026/09/24/news-cxmt-ymtc-ramp-memory-capacity-but-chinas-ai-cloud-boom-could-soak-up-new-supply-through-2027/
[tf-4q]: https://www.trendforce.com/presscenter/news/20260930-13258.html
[pine64-mastodon]: https://social.treehouse.systems/@pine64/117111063654864544

[cnbc-mehrotra]: https://www.cnbc.com/2026/06/30/micron-ceo-customers-driving-hard-bargain-on-price-contributed-to-memory-shortage.html
[complaint]: https://storage.courtlistener.com/recap/gov.uscourts.cand.472931/gov.uscourts.cand.472931.1.0_1.pdf
[complaint-p12]: https://storage.courtlistener.com/recap/gov.uscourts.cand.472931/gov.uscourts.cand.472931.1.0_1.pdf#page=8

[^toms-suit]: James, L. (2026, June 29). Samsung, SK hynix, and Micron sued over alleged DRAM price fixing amid record memory costs. Tom's Hardware. [https://www.tomshardware.com/tech-industry/samsung-sk-hynix-and-micron-sued-over-alleged-dram-price-fixing-amid-record-memory-costs][toms-suit]
[^deloitte]: Deloitte. (2020, June 22). The great compression: Implications of COVID-19 for the US shale industry. As quoted by Industrial Info Resources. <https://www.industrialinfo.com/news/article/deloitte-us-shale-producers-ripe-for-consolidation-and-new-investors--285830>
[^eia]: U.S. Energy Information Administration. Oil imports and exports. Energy Explained. <https://www.eia.gov/energyexplained/oil-and-petroleum-products/imports-and-exports.php>
[^cnbc-mehrotra]: CNBC. (2026, June 30). Micron CEO: Customers driving hard bargain on price contributed to memory shortage. [https://www.cnbc.com/2026/06/30/micron-ceo-customers-driving-hard-bargain-on-price-contributed-to-memory-shortage.html][cnbc-mehrotra]
