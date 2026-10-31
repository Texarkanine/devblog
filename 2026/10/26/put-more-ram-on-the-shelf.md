# Put More RAM on the Shelf

2026-10-26 - texarkanine

A post on my LinkedIn feed recently explained who is to blame for the memory shortage:

<div class="polaroid-container">
  <div class="polaroid">
    <a href="linkedin-ai-fraud-jevons.png">
      <img src="linkedin-ai-fraud-jevons.png" alt="" class="polaroid-image">
    </a>
    <div class="polaroid-title">&nbsp;</div>
    <div class="polaroid-link">
      
      &nbsp;
      
    </div>
    <small class="polaroid-archive">
      
      &nbsp;
      
    </small>
  </div>
</div>


It linked to a story about [PINE64][pine64], which makes open-hardware Linux phones, tablets and single-board computers. PINE64 had paused production on all three, and the headline said it would stay paused ["Until the AI Bubble Bursts."][hackster-pine64]

Every shortage gets this story. Ethereum miners ruined graphics cards. Scalpers ruined concert tickets. Now AI is ruining RAM. The anger lands on whoever else is buying - **demand-scolding**.

It lands 180 degrees from where it belongs. Buyers keep a product alive; sellers decide how much of it exists. Three companies decide how much DRAM exists. Two of them have already pleaded guilty to fixing its price, and the third turned them in.

## There Is No Shelf

In 2021, crypto miners and gamers really were fighting over the same GeForce boxes at the same retailers.

RAM doesn't work like that. AI data centers aren't standing in line at Micro Center for your desktop DDR5 kit. They buy high-bandwidth memory (HBM): DRAM dies stacked 12 to 16 high and wired together through the silicon, ordered directly from the manufacturers under contracts signed years ahead. Each gigabyte of HBM eats [roughly three times the wafer capacity][toms-hbm] of DDR5. As Micron's chief business officer told CNBC in January: ["As we increase HBM supply, it leaves less memory left over for the non-HBM portion of the market, because of this three-to-one basis."][cnbc-sadana]

That trade happens upstream of any store, inside the manufacturer, when it decides what each wafer becomes and which customer gets it. In December, Micron killed its 29-year-old Crucial consumer brand ["in order to improve supply and support for our larger, strategic customers in faster-growing segments."][crucial]

Micron chose its customers, and you weren't one of them.

## Prices Doubled, Bits Didn't

When the price of a commodity doubles in a working market, somebody makes more of it.

Instead, TrendForce [reports][tf-1q] that conventional DRAM contract prices rose 93% to 98% in the first quarter of 2026. Industry revenue jumped 81%, to $97 billion, while SK hynix's actual bit shipments stayed ["broadly in line with the previous quarter."][tf-hynix]

> The price did all the work.

Three companies - Samsung, SK hynix, and Micron - collect 89.7% of the world's DRAM revenue, and a new fab costs tens of billions of dollars and takes years to build. When Micron's CEO was asked on *Mad Money* why the industry didn't build ahead, he blamed his customers for bargaining during the 2023 glut: ["certain customers drove pricing significantly down in our industry."][cnbc-mehrotra] Then Micron cut its own capital spending from $12.1 billion to $7.7 billion. That is a supply decision, and Micron made it.

In June, seventeen buyers [sued all three companies][toms-suit] for conspiring to restrict supply. If that sounds paranoid, check their rap sheet: in the 2000s, [Samsung and Hynix pleaded guilty][doj-2005] to criminal DRAM price-fixing, paid hundreds of millions in fines, and sent executives to federal prison. Micron paid nothing only because it [turned the other two in][micron-2004] under the Justice Department's leniency program.

You don't even need the plaintiffs to win to see who holds the steering wheel. Here is how the manufacturers' own lawyers summarize the case in their [motion to dismiss][mtd]:

> In sum, three companies in a highly concentrated market independently reduced production amid falling prices during a "bust" cycle, and then shifted capacity toward more profitable products in response to surging AI-driven demand.

Look for the AI buyers in that sentence. They show up as weather. Every verb belongs to the three manufacturers: *they* reduced production, and *they* shifted capacity. Whether that's a conspiracy or legal [conscious parallelism][parallelism] in a three-firm market, how much memory the world gets is decided in three boardrooms. The AI companies only place orders.

## The Bubble Leaves the Fabs Behind

What if the LinkedIn post is right and AI is a fraud?

Then you should want AI companies signing *more* long-term memory contracts, not fewer.

Why didn't those three boardrooms build ahead on their own? Because the last time memory makers raced to add capacity, the glut killed them. In 2008 DRAM prices [fell nearly 75%][tf-2008]; [Qimonda][qimonda] went insolvent in 2009, and [Elpida][elpida] filed for bankruptcy in 2012 with $5.6 billion in debt. That is how the industry got down to three survivors, and none of them wants to be the next Qimonda. Left to steady, incremental growth and retail shoppers who only buy a stick of RAM when the mood strikes, the safe play is to never break ground on a new fab - and let everyone get slowly squeezed for the next decade.

Multi-year AI contracts break that stalemate because they move the risk of a glut from the manufacturer to the buyer. Once a giant customer signs for the volume up front, building the fab pencils out.

And once it's built, hardware gets cheap as cumulative production doubles - [Wright's law][owid]. The cheap SSDs and hard drives in my PC exist because hyperscale data centers ordered them by the million and paid for the factories. [I love it when useful things get cheaper](/2026/08/09/love-when-useful-things-get-cheaper.html) - this is how it happens. My occasional retail upgrades could never have paid for a fab.

Even busted bubbles leave the factories behind. Micron [bought Elpida's fabs][micron-elpida] out of bankruptcy, and they kept cranking out wafers. In the 2010s, American shale drillers burned through [$300 billion of negative free cash flow][deloitte], wrote down $450 billion of capital, and filed more than 190 bankruptcies. The investors lost their shirts; everyone else kept the oil. If AI money evaporates tomorrow, the fabs it financed will still be standing, and they will still need someone to buy their wafers.

PINE64 knows what actually ends a hardware drought. Its own post on Mastodon never mentioned AI or a bubble - it said production depends on component pricing ["after mid 2027,"][pine64-mastodon] right when Micron's new Boise fab is due to ship its first chips. The company in that headline is waiting for fabs.

---

Ah, but if the AI data centers would all *just* stop buying so much, we could have cheap 2023-glut RAM back today, right?

Don't make me tap the sign:

<div class="polaroid-container">
  <div class="polaroid">
    <a href="everyone-will-not-just.png">
      <img src="everyone-will-not-just.png" alt="Everyone Will Not Just" class="polaroid-image">
    </a>
    <div class="polaroid-title">Everyone Will Not Just</div>
    <div class="polaroid-link">
      
      <a href="https://www.tumblr.com/squareallworthy/163790039847/everyone-will-not-just" target="_blank" rel="noopener">www.tumblr.com/squareallworthy/163790039847/everyone-will-not-just</a>
      
    </div>
    <small class="polaroid-archive">
      
      (<a href="https://web.archive.org/web/20260906002840/https://www.tumblr.com/squareallworthy/163790039847/everyone-will-not-just" target="_blank" rel="noopener">archive</a>)
      
    </small>
  </div>
</div>


Millions of buyers will never form a demand-side cartel to boycott memory at once - and if they did, nobody would build the next fab and you'd've just achieved a temporary pause with no price movement.

Sellers are another matter. There are basically only three of them, and two have pleaded guilty to acting in unison before. Three companies with 90% of the market **can** just build.

The AI buyers want more memory too, and they're the ones signing multi-year contracts to get it built. Leave them out of it and send the complaint upstream, to the three boardrooms that can actually answer it:

> Put more RAM on the shelf!

[toms-suit]: https://www.tomshardware.com/tech-industry/samsung-sk-hynix-and-micron-sued-over-alleged-dram-price-fixing-amid-record-memory-costs
[pine64]: https://pine64.org/
[hackster-pine64]: https://www.hackster.io/news/pine64-calls-time-on-the-linux-hardware-market-ceases-production-until-the-ai-bubble-bursts-a865c8345041
[toms-hbm]: https://www.tomshardware.com/pc-components/ram/hbm-is-eating-your-ram
[cnbc-sadana]: https://www.cnbc.com/2026/01/10/micron-ai-memory-shortage-hbm-nvidia-samsung.html
[crucial]: https://investors.micron.com/news/press-release/2025/Micron-Announces-Exit-from-Crucial-Consumer-Business-12-03-2025/default.aspx
[tf-1q]: https://www.trendforce.com/presscenter/news/20260601-13070.html
[tf-hynix]: https://www.trendforce.com/news/2026/05/18/news-memory-supercycle-drives-1q26-price-surge-samsung-flags-146-asp-jump-sk-hynix-sees-mid-60-dram-gains/
[cnbc-mehrotra]: https://www.cnbc.com/2026/06/30/micron-ceo-customers-driving-hard-bargain-on-price-contributed-to-memory-shortage.html
[doj-2005]: https://www.justice.gov/archive/atr/public/press_releases/2005/212002.htm
[micron-2004]: https://www.sec.gov/Archives/edgar/data/723125/000110465904035549/a04-13517_1ex99d1.htm
[mtd]: https://storage.courtlistener.com/recap/gov.uscourts.cand.472931/gov.uscourts.cand.472931.58.0.pdf
[parallelism]: https://en.wikipedia.org/wiki/Conscious_parallelism
[owid]: https://ourworldindata.org/learning-curve
[tf-2008]: https://www.trendforce.com/presscenter/news/20090105-6986.html
[qimonda]: https://www.sec.gov/Archives/edgar/data/1369377/000132693209000012/f03003e6vk.htm
[elpida]: https://www.reuters.com/article/technology/elpida-seeks-bankruptcy-protection-56-billion-debt-idUSTRE81Q0OQ/
[micron-elpida]: https://www.sec.gov/Archives/edgar/data/723125/000072312513000133/exh991-pr.htm
[deloitte]: https://www.industrialinfo.com/news/article/deloitte-us-shale-producers-ripe-for-consolidation-and-new-investors--285830
[pine64-mastodon]: https://social.treehouse.systems/@pine64/117111063654864544
