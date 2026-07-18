Refinement pipelines are everywhere, and they all have the same shape: stages persist even as the executors at each stage change, with the goal being more-efficient output with reduced human input.

<figure class="mermaid-diagram">
<style>
.mermaid-diagram__light { display: inline; }
.mermaid-diagram__dark { display: none; }
@media (prefers-color-scheme: dark) {
  .mermaid-diagram__light { display: none; }
  .mermaid-diagram__dark { display: inline; }
}
</style>
<a class="mermaid-diagram__light" href="/assets/svg/4549dcf5.svg"><img src="/assets/svg/4549dcf5.svg" alt="Mermaid Diagram"></a>
<a class="mermaid-diagram__dark" href="/assets/svg/4549dcf5-dark.svg"><img src="/assets/svg/4549dcf5-dark.svg" alt="Mermaid Diagram"></a>
</figure>

Consider Bitcoin mining. The [Bitcoin whitepaper](https://bitcoin.org/bitcoin.pdf) described a proof-of-work system. The first people to implement it were cypherpunks running the reference client on CPUs. When the economics became clear, miners moved to GPUs - the same algorithm, a more specialized executor. Then purpose-built ASICs that do nothing except compute SHA256 hashes.

<figure class="mermaid-diagram">
<style>
.mermaid-diagram__light { display: inline; }
.mermaid-diagram__dark { display: none; }
@media (prefers-color-scheme: dark) {
  .mermaid-diagram__light { display: none; }
  .mermaid-diagram__dark { display: inline; }
}
</style>
<a class="mermaid-diagram__light" href="/assets/svg/c94c8a5f.svg"><img src="/assets/svg/c94c8a5f.svg" alt="Mermaid Diagram"></a>
<a class="mermaid-diagram__dark" href="/assets/svg/c94c8a5f-dark.svg"><img src="/assets/svg/c94c8a5f-dark.svg" alt="Mermaid Diagram"></a>
</figure>

The *stages* didn't change. You still need the whitepaper's theory, the hash algorithm's specification, and the optimized implementation. What changed was who - or what - executes each stage. Nobody skipped from whitepaper to ASIC. The pipeline was load-bearing.

The same pattern appears in manufacturing, in logistics, in agriculture - anywhere humans have refined a process and then progressively swapped in more specialized executors. The [stages don't disappear](/2026/03/09/context-to-ashes-skills-to-dust.html); they get *encapsulated*. You stop seeing them. But they're still in there, doing the work.

---

## Half-Baked Thoughts

- [Chainsaw origin: surgical instrument](https://en.wikipedia.org/wiki/Chainsaw)
	- General-purpose tools are transition technologies; what follows is always specialization (scalpel, bone saw, feller buncher, harvester)
- "We're in the GPU era" (software, knowledge work; code goes first) - general-purpose tools with **jigs** clamped on
- Possibly a [Butlerian Jihad addendum](/garden/fomenting-the-butlerian-jihad.html): "all work is solved; now what?"
