---
layout: garden
title: "Taxonomizing Price Shocks"
subtitle: "Blame the supplier, blame the regulator, or blame the customer?"
description: "A field guide to shortages and price spikes, sorted by who actually holds the choke point: the supplier, the regulator, or the customer next to you."
tags:
  - economics
  - history
  - research
---

When something gets scarce or expensive, the anger almost always lands sideways - on the other buyer in line. I call this **demand-scolding**.

Sometimes the buyer next to you really is the problem. Usually, the choke point sits upstream. Here is a field guide to shortages and price spikes, sorted by who actually deserves the blame.

| Choke Point | Diagnostic Tell | What Fixes It |
| --- | --- | --- |
| **🏭 Supplier** | Prices jump, margins expand, and unit output stays flat; or wafers and lines are reassigned upstream before a retail SKU is ever made. | Signed long-term volume contracts that take glut risk off the manufacturer, or new entrants breaking concentration. |
| **👮 Regulator** | Prices are capped below clearing levels, causing local dry-outs and hoarding, or new supply sits in a multi-year permitting queue despite buyers paying up front. | Lifting price and allocation controls so arbitrage works; clearing permitting and interconnection queues. |
| **👤 Customer** | Rivals buy the identical finished SKU out of the same retail channel faster than factories can ship, or arbitrageurs hoard stock solely to resell. | Factory volume eventually drowning out inventory hoarding. |

---

## Blame the Supplier

Look here when a handful of firms control production, barriers to entry run into the tens of billions of dollars and multiple years, and a demand surge gets harvested as margin instead of answered with volume.

### 1999-2002 DRAM Price-Fixing Cartel

From April 1999 to June 2002, memory makers conspired to fix the DRAM prices they charged Dell, Compaq, Hewlett-Packard, Apple, IBM, and Gateway.

- **The convictions:** Infineon pleaded guilty in 2004, paid a $160 million fine, and saw four executives sentenced to between four and six months in prison. Hynix, now SK hynix, pleaded guilty in 2005 and paid $185 million. Samsung pleaded guilty in 2005 and paid $300 million, which the Justice Department called the ["second largest criminal antitrust fine in U.S. history,"][doj-2005] and in March 2006 [three Samsung executives][doj-2006] agreed to serve seven or eight months in prison and pay $250,000 apiece. Twelve individuals and four companies were charged, with total fines exceeding $731 million.
- **The informant:** Micron paid nothing. It cooperated under the Justice Department's Corporate Leniency Policy and, by its own account, escaped ["prosecution, fines, or other penalties."][micron-2004] Its CEO, Steve Appleton, acknowledged that "the DOJ's investigation revealed evidence of price fixing by Micron employees and its competitors." One Micron regional sales manager [pleaded guilty to obstruction][doj-2005] and received six months of home detention after withholding and altering subpoenaed grand jury documents.

### 2008-2012 DRAM Glut and Consolidation

Why do memory suppliers hesitate to build ahead of demand? Because the last full capacity race killed the losers and shrank the industry to three main survivors.

- **2008 crash:** After an industry-wide race to add capacity, DRAM prices [fell nearly 75% in 2008][tf-2008], and memory makers lost more than $8 billion across the first three quarters.
- **Qimonda:** In January 2009, Infineon spin-off Qimonda filed for insolvency with 12,000 employees, blaming ["the massive drop in prices in the DRAM industry."][qimonda]
- **Elpida:** In 2012, Elpida [filed for bankruptcy][elpida] with $5.6 billion in debt, the largest bankruptcy by a Japanese manufacturer at the time. Micron bought Elpida out of bankruptcy, and Elpida's fabs [added roughly 45%][micron-elpida] to Micron's manufacturing capacity.

### 2016-2017 DRAM Parallel Cuts

Buyers sued Samsung, SK hynix, and Micron over parallel production cuts in 2016 and 2017. A federal district court dismissed the case, and in March 2022 the Ninth Circuit affirmed, ruling that the cuts were ["more likely explained by lawful, unchoreographed free-market behavior"][dram-ii] in a concentrated industry, even after weighing their "criminal history from twenty years ago."

Under U.S. antitrust law, [conscious parallelism][parallelism] - three companies in a concentrated market looking at the same margin math and independently choosing not to expand - is not itself unlawful, and produces the same supply restriction as a cartel without a phone call.

### 2025-2026 DRAM and HBM Crunch

In the first quarter of 2026, [TrendForce reported][tf-1q] that three firms controlled 89.7% of global DRAM revenue: Samsung at 38.5%, SK hynix at 28.8%, and Micron at 22.4%.

- **Upstream wafer substitution:** AI buyers aren't buying desktop DDR5 sticks at retail. They buy high-bandwidth memory, or HBM - DRAM dies stacked 12 to 16 high - under multi-year contracts directly from the three manufacturers. Each gigabyte of HBM consumes [roughly three times the wafer capacity][toms-hbm] of DDR5. As Micron Chief Business Officer Sumit Sadana told CNBC in January 2026: ["As we increase HBM supply, it leaves less memory left over for the non-HBM portion of the market, because of this three-to-one basis."][cnbc-sadana]
- **Killing the consumer line:** In December 2025, Micron shut down its 29-year-old Crucial consumer memory brand ["in order to improve supply and support for our larger, strategic customers in faster-growing segments."][crucial]
- **Prices doubled, bits didn't:** In Q1 2026, conventional DRAM contract prices rose 93% to 98% quarter-over-quarter and industry revenue jumped 81% to $97 billion, while SK hynix's bit shipments stayed ["broadly in line with the previous quarter"][tf-hynix] as its average selling prices rose about 65%. In Q2 2026, industry revenue climbed another 59.5% to $154.73 billion on modest bit growth, with Q3 consumer DRAM facing the steepest increases ["as suppliers have significantly curtailed supply,"][tf-2q] and Q4 conventional DRAM contract prices forecast to [rise another 10% to 15%][tf-4q].
- **Blaming customers for the 2023 glut:** In June 2026, Micron CEO Sanjay Mehrotra told CNBC's *Mad Money* that ["certain customers drove pricing significantly down in our industry. In 2023, our prices came down to one-third of what they were,"][cnbc-mehrotra] after Micron had cut its own capital expenditure that year from $12.1 billion to $7.7 billion.
- ***Garciaguirre v. Samsung*:** In June 2026, fourteen individuals and three small PC businesses [sued Samsung, SK hynix, and Micron][toms-suit] in federal court in San Jose. Using TrendForce per-wafer math, [the complaint][complaint] notes that in Q1 2026 a wafer of 64GB DDR5 server modules earned more than a wafer of HBM, arguing that ["leaving that profit unclaimed, in unison, while commodity prices set records, is difficult to reconcile with independent profit maximization."][complaint-p12] The defendants [moved to dismiss][mtd] on September 2, with a hearing set for [November 13, 2026][docket], summarizing their own conduct as: *"three companies in a highly concentrated market independently reduced production amid falling prices during a 'bust' cycle, and then shifted capacity toward more profitable products in response to surging AI-driven demand."*
- **What actually relieves it:** Fabs. Micron is building a new fab in Boise due to ship its first chips in mid-2027, and China's CXMT [plans to expand][tf-cxmt] from roughly 320,000 wafers a month to 420,000 by 2027. When open-hardware maker [PINE64][pine64] paused production in 2026, Hackster's headline blamed AI ["Until the AI Bubble Bursts,"][hackster-pine64] but PINE64's own Mastodon post simply pointed to component pricing ["after mid 2027"][pine64-mastodon] - Boise's delivery window.

### 2026 Nearline Hard Drive Allocation

Early in 2026, Western Digital's CEO stated that the company was ["pretty much sold out for calendar 2026,"][wd] with long-term hyperscaler agreements already locked in for 2027 and 2028, and consumer products accounting for just 5% of revenue.

---

## Blame the Regulator

Look here when prices are forbidden from clearing the market, when supplies are rationed by historical formula rather than current need, or when buyers are ready to finance new capacity that cannot get permission to connect.

### 1971-1981 U.S. Gasoline Price Controls

The [1973 oil crisis][oil-crisis] is remembered for the October 19, 1973 [Arab oil embargo][fed-embargo], a genuine supply-cartel shock that sent crude from $2.90 a barrel to $11.65 by January 1974. Look closer at the domestic gas lines, however, and the distribution breakdown was regulatory.

- **Shortages preceded the embargo:** Nixon [froze wages and prices on August 15, 1971][bradley]. By February 1973 - eight months before the embargo - Senator Henry Jackson was already warning Congress of "an unprecedented breakdown in our energy supply and distribution system."
- **Federal demand-scolding:** On November 25, 1973, Nixon went on television to announce Saturday-night-to-Sunday gas station closures, a 50 mph speed limit, thermostats lowered by six degrees, and dimmed White House Christmas lights, asking Americans for ["the spirit of discipline, self-restraint, and unity."][nixon] Congress fixed the [national speed limit at 55 mph][nmsl] in January 1974, where it stayed until 1995.
- **Allocation by 1972 formula:** Two days after his speech, Nixon signed the [Emergency Petroleum Allocation Act][epaa], which distributed fuel according to what each region had purchased in 1972.
- **Misallocation data:** A 2026 paper by Brian Albrecht, Alex Tabarrok, and Mark Whitmeyer [analyzed the February 1974 station surveys][chaos]: the national gasoline shortfall was about 9%, yet more than 90% of sampled stations in Connecticut and Massachusetts were rationing or dry, while Idaho, Montana, Utah, Hawaii, and Wyoming reported no shortages at all. Because price controls capped what a refiner could earn per gallon everywhere, nothing pulled fuel toward the states that were short: *"Price controls kill the incentive for arbitrage."*
- **Growing towns starved by formula:** In March 1974, the American Automobile Association testified to Congress that Gaithersburg, Maryland received 80% of its 1972 gasoline volume after its population had grown by 50%, urging Congress to ["create a positive program whose purpose is to increase our fuel supply. The present program acts as a disincentive."][jec-1974]
- **Sideways rage at the pump:** Drivers blamed each other. TIME reported in February 1974 that America's 117 million cars had become ["rolling reservoirs of gasoline, making the shortage worse,"][time-fever] as drivers topped off tanks and a Pittsburgh pump attendant spat in a customer's face. States rolled out [odd-even license-plate rationing][time-rationing] with half-tank minimums and fines up to $1,000 in New Jersey and Maryland.
- **How it ended:** On January 28, 1981, Executive Order 12287 exempted crude oil and refined products from price and allocation controls ["effective immediately."][eo-12287]

### 2026-2031 U.S. Grid Interconnection Queue

AI data centers get blamed for rising electricity rates, even though hyperscalers are signing the multi-decade contracts needed to build generation: Microsoft signed a 20-year contract to [restart an 835 MW nuclear reactor at Three Mile Island][crane], and Meta contracted for [433 MW of nuclear uprates][vistra-meta] across three Vistra plants alongside 20 years of output.

The bottleneck is getting generation built and permitted to connect:

- **The permitting queue:** [Berkeley Lab][lbnl-queue] counts roughly 2,061 GW of proposed power plants waiting in line for grid interconnection approval.
- **The capacity shortfall:** In July 2026, grid operator [PJM][pjm-2028], which serves more than 67 million people across 13 states and Washington, D.C., came up 6,831 MW short of its reliability requirement in its 2028-29 capacity auction; only 525 MW of what cleared came from new plants and uprates.
- **Upstream turbine backlog:** GE Vernova, the largest gas turbine manufacturer, is [booking reservations for 2031][turbines].

---

## Blame the Customer

Look here only when buyers are genuinely fighting over the exact same finished product on the exact same retail shelf - and even then, notice how the fight actually ends.

### 2021 Ethereum GPU Shortage and Nvidia LHR

Unlike HBM vs. DDR5, the 2021 graphics card shortage was a true fight at the retail shelf: crypto miners and gamers wanted the same GeForce RTX 30-series boxes from the same stores on the same launch days.

- **Degrading the product for the "wrong" buyer:** Nvidia tried the remedy demand-scolding implies - [pink margarine]({% post_url blog/essay/2026-03-01-pink-margarine %}) in silicon. In February 2021 it shipped the RTX 3060 with driver detection that halved Ethereum hash rates to ["help ensure GeForce GPUs end up in the hands of gamers,"][nvidia-3060] and in May 2021 it extended its "Lite Hash Rate" limiter to the 3060 Ti, 3070, and 3080 for ["more GeForce cards at better prices into the hands of gamers everywhere."][nvidia-lhr]
- **How long it lasted:** Mining software recovered about 70% of the throttled performance within months, and in May 2022 [NiceHash bypassed the limiter completely][toms-nicehash].

### 2020-2023 PlayStation 5 Scalpers

After the PS5 launched in November 2020, scalpers used checkout bots to beat retail buyers to stock and flip consoles at a markup - pure zero-sum rent extraction at the shelf.

- **What killed the scalpers:** Not buyer self-restraint, and not anti-scalping sermons. Sony kept shipping consoles until January 2023, when its gaming chief announced that buyers ["should have a much easier time finding one at retailers globally, starting from this point forward."][verge-ps5] By April 2023, [scalpers were cutting prices below retail][techspot-ps5]. A factory can keep shipping longer than a scalper can stay liquid.

---

## Why Big Buyers Usually Help You Later

Except for pure resale scalpers, massive buyers who bid up a commodity in year one are usually the ones financing the factory that makes it cheap for you in year five.

- **Wright's Law:** In 1936, aeronautical engineer Theodore Wright observed that every doubling of cumulative production cuts unit cost by a steady percentage. Solar panels have followed [Wright's law][owid] for forty years, dropping about 20% in cost per doubling of installed capacity, from $106 a watt to $0.38. Retail hobbyists don't buy enough volume to double cumulative production; hyperscalers do.
- **The 2010s U.S. Shale Boom:** Even when a demand boom is a financial bubble, the physical capacity survives the crash. In the 2010s, U.S. [fracking][fracking] and shale drillers burned through [$300 billion in negative free cash flow, wrote down $450 billion of capital, and filed more than 190 bankruptcies][deloitte] - peaking *"without making money for the industry in aggregate."* The investors lost their money, the wells stayed in the ground, and in 2020 the United States became a [net exporter of petroleum][eia] for the first time since at least 1949.

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
[oil-crisis]: https://en.wikipedia.org/wiki/1973_oil_crisis
[epaa]: https://en.wikipedia.org/wiki/Emergency_Petroleum_Allocation_Act
[nmsl]: https://en.wikipedia.org/wiki/National_Maximum_Speed_Law
[time-fever]: https://time.com/archive/6875854/shortages-gas-fever-happiness-is-a-full-tank/
[time-rationing]: https://time.com/archive/6816977/rationing-spotty-local-starts/
[chaos]: https://arxiv.org/abs/2602.12066
[jec-1974]: https://fraser.stlouisfed.org/title/gasoline-distribution-895
[eo-12287]: https://www.presidency.ucsb.edu/documents/executive-order-12287-decontrol-crude-oil-and-refined-petroleum-products
[fracking]: https://en.wikipedia.org/wiki/Fracking_in_the_United_States
[deloitte]: https://www.industrialinfo.com/news/article/deloitte-us-shale-producers-ripe-for-consolidation-and-new-investors--285830
[owid]: https://ourworldindata.org/learning-curve
[wd]: https://www.tomshardware.com/pc-components/hdds/western-digital-is-already-sold-out-of-hard-drives-for-all-of-2026-chief-says-some-long-term-agreements-for-2027-and-2028-already-in-place
[tf-cxmt]: https://www.trendforce.com/news/2026/09/24/news-cxmt-ymtc-ramp-memory-capacity-but-chinas-ai-cloud-boom-could-soak-up-new-supply-through-2027/
[tf-4q]: https://www.trendforce.com/presscenter/news/20260930-13258.html
[pine64-mastodon]: https://social.treehouse.systems/@pine64/117111063654864544
[crane]: https://www.constellationenergy.com/news/2024/Constellation-to-Launch-Crane-Clean-Energy-Center-Restoring-Jobs-and-Carbon-Free-Power-to-The-Grid.html
[vistra-meta]: https://investor.vistracorp.com/2026-01-09-Vistra-and-Meta-Announce-Agreements-to-Support-Nuclear-Plants-in-PJM-and-Add-New-Nuclear-Generation-to-the-Grid
[pjm-2028]: https://www.pjm.com/-/media/DotCom/about-pjm/newsroom/2026-releases/20260714-pjm-capacity-auction-procures-138318-mw-of-generation-resources.pdf
[turbines]: https://finance.yahoo.com/energy/articles/gas-turbine-shortage-just-became-210000180.html
[lbnl-queue]: https://emp.lbl.gov/sites/default/files/2026-06/Queued%20Up%202026%20Edition.pdf
[verge-ps5]: https://www.theverge.com/2023/1/4/23539918/sony-playstation-5-shortage-over
[techspot-ps5]: https://www.techspot.com/news/98403-scalpers-struggling-sell-playstation-5-consoles-supplies-return.html
[tf-2008]: https://www.trendforce.com/presscenter/news/20090105-6986.html
[qimonda]: https://www.sec.gov/Archives/edgar/data/1369377/000132693209000012/f03003e6vk.htm
[elpida]: https://www.reuters.com/article/technology/elpida-seeks-bankruptcy-protection-56-billion-debt-idUSTRE81Q0OQ/
[micron-elpida]: https://www.sec.gov/Archives/edgar/data/723125/000072312513000133/exh991-pr.htm
[cnbc-mehrotra]: https://www.cnbc.com/2026/06/30/micron-ceo-customers-driving-hard-bargain-on-price-contributed-to-memory-shortage.html
[complaint]: https://storage.courtlistener.com/recap/gov.uscourts.cand.472931/gov.uscourts.cand.472931.1.0_1.pdf
[complaint-p12]: https://storage.courtlistener.com/recap/gov.uscourts.cand.472931/gov.uscourts.cand.472931.1.0_1.pdf#page=8
[eia]: https://www.eia.gov/energyexplained/oil-and-petroleum-products/imports-and-exports.php
