---
layout: garden
title: "Do LLMs Understand 'For Each'?"
description: "What happens when you ask a language model to process a list of items? Research on instruction adherence, attention mechanics, and the generation boundary."
author: niko
tags:
  - ai
  - prompt-engineering
  - research
---

You have a list of items. You need a language model to process each one the same way. Do you write this:

> For each item in the list, perform steps 1 through 5.

Or this:

> **Item 1:** Perform steps 1 through 5.
>
> **Item 2:** Perform steps 1 through 5.
>
> **Item 3:** Perform steps 1 through 5.

The first is compact, elegant, and how a programmer would think about it. The second is verbose, redundant, and feels like it insults the model's intelligence. The research says the second one works better, and the reasons are architectural - rooted in how transformers allocate attention. But whether that architecture actually constrains you depends on how, exactly, you harness the models and what, exactly, you ask them to do.

## The Curse of Instructions

{% linkcard
	https://openreview.net/forum?id=R6q67CDBCH
	"Curse of Instructions: Large Language Models Cannot Follow Multiple Instructions at Once"
	archive:none
%}

> The success rate of all the instructions is precisely explained by the success rate of individual instructions to the power of the total number of instructions.

That's the "curse of instructions" (Harada et al., October 2024): individually easy steps compound into near-certain failure at scale. If a model follows any single instruction 95% of the time, 10 simultaneous instructions yield roughly 60% all-correct compliance. In practice, it's worse. GPT-4o managed just 15% success with 10 simultaneous instructions. Claude 3.5 Sonnet did better at 44%, but neither is close to reliable.

When a prompt says "for each of 10 items, follow these 5 steps," the model must satisfy 50 effective constraints in a single generation. The multiplicative decay means that individually easy steps compound into near-certain failure at scale. Unrolling into separate per-item calls keeps each call at 5 constraints, preserving the per-instruction success rate without cross-item compounding.

The [IFScale benchmark](https://arxiv.org/abs/2507.11538) (Jaroslawicz et al., July 2025) pushed this further, testing up to 500 simultaneous keyword-inclusion instructions across 20 models from seven providers. Even the best performer - Gemini 2.5 Pro - managed only about 69% accuracy at 500 instructions. More usefully, the study identified three distinct degradation patterns across model families:

- **Threshold decay** for reasoning models like o3 and Gemini-2.5-Pro: near-perfect performance until roughly 150 instructions, then collapse.
- **Linear decay** for models like GPT-4.1 and Claude 3.7 Sonnet: steady, proportional decline.
- **Exponential decay** for smaller or older models like Claude 3.5 Haiku and Llama-4-Scout: steep drops from the start.

This means the penalty for loop-style prompts depends partly on which model you're using. Reasoning models tolerate higher instruction density before degradation kicks in. Smaller models degrade rapidly as instruction count grows.

## Why It Happens

The exponential compounding is a symptom. The disease is architectural.

### Attention Sinks

Researchers at MIT discovered that transformer models dump disproportionate attention onto initial tokens due to [softmax](https://en.wikipedia.org/wiki/Softmax_function) normalization - a phenomenon they called "[attention sinks](https://arxiv.org/abs/2309.17453)" (Xiao et al., September 2023). A [2025 follow-up](https://arxiv.org/abs/2504.02732) (Barbero et al., April 2025) traced the cause to a fundamental mechanism: LLMs use attention sinks to avoid over-mixing information across layers, and "their formation during training seems inevitable." The original researchers proposed a practical workaround - [StreamingLLM](https://github.com/mit-han-lab/streaming-llm), which adds a dedicated placeholder token to absorb excess attention - but the underlying behavior is architectural.

In a loop-style prompt, the instruction block at the top becomes the attention sink while items in the middle are starved. Unrolling creates fresh attention sinks at each item's instruction header.

### Lost in the Middle

"[Lost in the Middle](https://arxiv.org/abs/2307.03172)" (Liu et al., July 2023) demonstrated a U-shaped performance curve: models access information at the beginning and end of their context with meaningfully higher accuracy than information in the middle. A follow-up "[Found in the Middle](https://arxiv.org/abs/2406.16008)" (Hsieh et al., June 2024) traced this to an intrinsic attention allocation bias that persists regardless of content relevance, and proposed a calibration mechanism to mitigate it.[^4] The bias persists in practice - IFScale found systematic favoritism toward earlier instructions across all models tested. In a loop-style prompt processing many items, the middle items land in the degraded zone. Unrolling gives every item its own beginning and end.

### Causal Masking and Prompt Repetition

The most elegant piece of evidence comes from Google Research. Leviathan, Kalman, and Matias published "[Prompt Repetition Improves Non-Reasoning LLMs](https://arxiv.org/abs/2512.14982)" in December 2025. The finding: simply duplicating the entire prompt improved accuracy on 47 of 70 tested tasks with zero losses. On one task, Gemini 2.0 Flash Lite jumped from 21.33% to 97.33% - a 76 percentage-point gain.[^5]

<!-- Editor's Note

footnote duplicates anchor text link.

> We propose to repeat the prompt, i.e. transform the input from “<QUERY>” to “<QUERY><QUERY>”.
> ...
> Notably, Prompt Repetition ×3 often substantially outperforms vanilla prompt repetition (which itself substantially outperforms the baseline)

insane that it worked, lol. Important that it's in "non-reasoning" models, though; most agentic dev is reasoning nowadays. Need to determine how relevant that is to our intended readership. Still worth mentioning as a lot of freebie users will use oneshot free-tier models w/out "thinking" or "reasoning."

don't forget that we introduce reasoning later on and address it; so no need to overcompensate here.

-->

The mechanism is revealing. In causal (left-to-right) attention, instruction tokens are processed before data tokens, meaning the instruction encoding lacks awareness of the data it must operate on. When instructions are repeated *after* the data - or, by extension, repeated per item - each instruction instance can attend to all preceding context, creating a richer signal. Critically, padding the prompt to equivalent length *without* repeating instructions produced no improvement, confirming the gain comes from information repetition, not length.[^5]

This has a direct implication for the loop question. Unrolling is not merely about reducing constraint count per call. It's about giving each item its own copy of the instructions, positioned where the instructions can attend to the relevant data. The transformer's causal attention architecture mechanistically favors this.

But there's a wrinkle. The prompt repetition effect was "neutral to slightly positive" for reasoning models (5 wins, 1 loss, 22 neutral out of 28 tasks).[^5] Models that reason via chain-of-thought already perform an internal form of "re-reading" that mimics the repetition effect. This aligns with IFScale's finding that reasoning models tolerate higher instruction density.[^2]

## When Loops Work Fine - or Even Help

The evidence so far paints a clear picture: unroll everything. But the picture has a blind spot that matters enormously in practice.

<!-- Editor's note: 

Make this lead-in sound human and not LinkedIn post.

-->

### Small Batches of Related Tasks

The [Multi-Task Inference benchmark](https://arxiv.org/abs/2402.11597) (Son et al., February 2024) tested a different regime: 2-3 closely related subtasks sharing context, processed together versus separately. GPT-4 showed up to 12.4% *improved* performance with multi-task inference compared to single-task.[^6] The explanation: "looking at the next sub-task provides critical clues on the answer format for solving the previous sub-task."[^6] Seeing the structure of subtask 2 gives the model implicit guidance for subtask 1.

<!-- Editor's note:

Need an example of these subtask structure. Paper is highly relevant; confirmed. footnotes 6 just repeat the paper. May want to steal their Figure 1 into a Polaroid link to the paper.

-->

This isn't a small effect, and it works precisely because the tasks are related and few. The same study found that naive batch prompting of *unrelated* tasks hurt performance - "mixing of tasks can confuse the model, as it needs to navigate through irrelevant information."[^6] So the counterargument to unrolling is narrow but real: for a small number of structurally similar items that benefit from seeing each other's context, a loop may actually produce better results.

<!-- Editor's note: 

Paper DIRECTLY supports the "unroll the loop" approach. Does the paper define what "small" is? If so, that threshold is important and we should mention it! This is addressed as an unknown in the very next section, which is good. But this paper might have one of the rare empirical answers!

-->

### The Cost of Unrolling: Instruction Drift

Unrolling has a cost that the pro-unrolling research tends not to mention. Repeating instructions N times increases total token count, and as context grows, the relative attention weight of the initial system prompt decreases. Research on [instruction drift](https://arxiv.org/abs/2510.07777) formalizes this as turn-wise divergence from goal-consistent behavior over extended contexts. The drift doesn't accumulate without bound - it stabilizes at finite levels that can be shifted downward by lightweight interventions like goal reminders.[^7] But it means that aggressively unrolling a 50-item list into a single massive prompt could erode the very instruction adherence you're trying to preserve.

This creates a tension. Loops suffer from exponential constraint compounding. Unrolling suffers from linear drift. For small N, the compounding fix dominates. For very large N, drift may erode the gains. The crossover point is not precisely characterized in the literature, but the [batch prompting](https://arxiv.org/abs/2301.08721) research (Cheng et al., EMNLP 2023) found that batch size 4 was the practical sweet spot for balancing quality against efficiency.[^8]

<!-- Editor's note:

The "drift no more" paper has this to say:

> Our experiments consistently reveal stable, noise-limited equilibria rather than runaway degradation, and demonstrate that simple reminder interventions reliably reduce divergence in line with theoretical predictions. Together, these results suggest that multi-turn drift can be understood as a controllable equilibrium phenomenon rather than as inevitable decay,

which seems optimistic - though this may not be in frontier models yet. The problem surely is, though! Though they test open-weight.

"batch prompting" research says, among other things:

> First, to optimize its benefits, the length of
> the input prompt tokens should be (significantly)
> greater than that of the output tokens. Thus, it
> might not be suitable for “heavy output" tasks like
> story generation.

which is interesting. So maybe it's bad for code review or big code authorship, but good for judgement/assessment? Need to dig in to see if we can find out why, and if this invalidates or guides our conclusion from it.

But also, they introduce the paper with

> Performing inference on large volumes of sam-
> ples with large language models (LLMs) can
> be computationally and financially costly in in-
> dustry and real-world use. We propose batch
> prompting, a simple yet effective prompting
> approach that enables the LLM to run infer-
> ence in batches, instead of one sample at a
> time. Our method reduces both token and
> time costs while retaining downstream per-
> formance.

So, it's really about cost conservation WITHOUT performance sacrifice, not about optimizing for instruction adherence. The existing text treats this honestly, but the lead-up about "understanding / adhering to" instructions may mis-cast what this paper was really going after. 4 is good, but it's good because it's the LIMIT without losing accuracy meaningfully, not because it's the sweet spot of MAXIMIZING accuracy. You can indirectly infer that perhaps you should therefore stop at 4, but the paper didn't really go LOOKING for max accuracy. Tables 1 and 2 show that the accuracy change was up and down a bit across the board; there wasn't actually a clear winner technique for improving instruction adherence. THAT's actually big - the takeaway is more of "you can batch a bit without losing much, usually, up until 4" - not "you SHOULD batch, up until 4."

Worth noting that their "batch" example is "unrelated" tasks, not "related" tasks, which intersects with the "small batches of related tasks" section above. This paper's intersection with our writing on instruction adherence may merit further consideration.

It's also not clear exactly how their "batching" maps to loops and unrolling. Is a batch the set of instructions of a loop? Is a batch the unrolled loop? In both cases it seems to suggest "don't go beyond 4," but maybe it's more suggesting that you shouldn't have more than 4 of ANYTHING in a row? The later discourse on tool calls resetting the generation matters; an 8-step loop with a tool call at position 4.5 would not run afoul of this "rule of 4."

-->

## The Distinction That Actually Matters

Here's the thing that most discussions of this topic miss, and the reason a blanket "always unroll" recommendation is incomplete.

<!-- Editor's Note:

I'm sorry, the art of single-sentence section intro is hard. Please try again; this one is... cringey. Maybe it's insufficiently humble? Or maybe that's just my opinion.

-->

Every study cited so far measures *single-generation* constraint satisfaction. ManyIFEval tests whether 10 formatting constraints are satisfied in one output. IFScale tests whether 500 keywords appear in one business report. Chen et al.'s multi-instance processing study[^9] tests whether 100 items are processed in one pass. The attention sink, lost-in-the-middle, and causal masking effects all operate within a single forward pass of the model.

<!-- Editor's Note:

I'm pretty sure that's not true of every paper so far, but I have to poop and I can't remember so this is a hidden in the middle easter egg for you: prove to me that the claim that EVERY paper is single-generation, is true... or refute it with a concrete counterexample from a paper's text.

-->

But most practitioners asking "should I unroll my loops?" aren't writing monolithic prompts. They're building [agentic workflows](https://en.wikipedia.org/wiki/Intelligent_agent) where the model makes tool calls - reads a file, queries a database, edits a document - and each tool call creates a new generation boundary. In a typical agentic loop:

1. Load guidance rule (tool call, new generation context)
2. Read file (tool call, new generation context)
3. Evaluate (reasoning step)
4. Maybe edit (tool call, new generation context)
5. Back to step 1 for next item

Each tool call resets the generation context. The agent isn't trying to satisfy 15 constraints in one output - it's doing 5 things, getting a response, doing 5 more, getting a response. The exponential compounding from ManyIFEval doesn't apply because each generation carries only a handful of constraints. The lost-in-the-middle effect resets at each tool boundary because the orchestration framework re-injects the system prompt and recent context.

<!-- Editor's note: 

claim about re-injection not universally true; harnesses are very different. 

-->

The prompt repetition paper implicitly confirms this. Its effect is neutral for reasoning models because they already "re-read" internally via chain-of-thought.[^5] Agentic tool-call loops achieve the same re-reading mechanically - each iteration brings the instructions back into focus through the tool response cycle.

This doesn't mean agentic workflows are immune to instruction-following failures. The [AGENTIF benchmark](https://arxiv.org/abs/2505.16944) (Qi et al., NeurIPS 2025) - the first benchmark specifically designed for instruction following in agentic scenarios - found that current models still struggle, even the best achieving only about 60% constraint satisfaction on agentic prompts averaging nearly 12 constraints each.[^10] Conditional constraints proved particularly fragile: over 30% of failures came from incorrect condition checking - the model failing to recognize whether a condition was triggered, not failing to follow the constraint itself. And meta-constraints - instructions that govern other instructions, like "prioritize X over Y" - were among the least reliable of all.[^10] The constraints-per-generation count still matters. It's just that tool boundaries keep the per-generation count lower than what a monolithic prompt would impose.

Anthropic's own documentation reflects this shift. Their prompt engineering guidance, which once recommended chaining as a general best practice for reducing errors, now positions it as a niche technique: "With adaptive thinking and subagent orchestration, Claude handles most multi-step reasoning internally. Explicit prompt chaining is still useful when you need to inspect intermediate outputs or enforce a specific pipeline structure."[^11]

<!-- Editor's Note:

Anthropic's own documentation can probably be an anchor link.

-->

## The Real Question

The most useful insight from integrating this research isn't about loops versus unrolling per se. It's that **the relevant unit of analysis is the generation boundary, not the prompt boundary.**

The research unanimously shows that within a single generation, constraint compounding is exponential and positional bias is real. The practical question is always: *how many constraints am I asking the model to satisfy in this generation?*

If the answer is "few, because tool calls partition the work," loops are fine. If the answer is "many, because this is a monolithic prompt," unroll.

## A Decision Framework

For what it's worth, here's how I'd think about it:

**Single-generation prompts (no tool calls):**

| Situation | Approach | Why |
| :--- | :--- | :--- |
| 1-3 related items needing cross-reference | Loop with structural markers | Cross-item context sharing may help[^6] |
| 4-6 independent items | Partial unrolling with per-item headers; repeat instructions at start and end | The prompt repetition sweet spot[^5] |
| 7+ items | Fully unroll into separate API calls | Exponential compounding dominates[^1] |
| Any count on smaller/older models | Default to unrolling | Exponential decay from the start[^2] |

**Agentic workflows with tool calls:**

| Situation | Approach | Why |
| :--- | :--- | :--- |
| Each iteration involves tool calls | Loop is fine | Tool boundaries reset generation context |
| Complex per-item steps (5+ substeps with branching) | Add structural markers within each iteration | Per-generation constraint count still matters[^10] |
| 20+ items in the same conversation thread | Periodically re-inject the core instruction block | Guard against instruction drift[^7] |

<!-- Editor's Note:

Unaddressed as far as i can tell in any paper, is adherence to the SET of loops, and to exit conditions. We generally assume "for each" is a loop over a set, but if you try to do the programmer-think of "break if..." (that's a meta-constraint), I *feel like*, vibrationally, that works poorly. Can we find a paper on that?

Similarly, "for each <in set>..." assumes the model can "remember" the set, AND which items have been processed so far. Thinking models often use "task lists" to achive this - either with a harness-provided tool, or on disk somehow, but I have never seen good set-tracking behavior without that.

Can we find a paper on that? Worth mentioning.

I will add my own "how I'd think of it" , for consideration, given the information in here:

1. the "set-tracking" problem is real, and must be addressed. If the harness or other instructions before iteration handle creating an "external" to the context window tracker, then OK. Otherwise, you MUST unroll because transformer LLMs are GOING (source: trust me bro) to forget some items in the set.
2. the tool-call generation-reset is crucial. Assuming the model has a task list (so its actual instructions to remember are 1. check task tracker for next item; 2. do item; 3. repeat until task trackler has no more items - only 3), then, small loops, especially with tool calls, seem to work fine.
3. I usually have the model ITESLF unroll into an outside-context-window unroll, so its steps are 1. identify the set; 2. identify the per-itme task list; 3. unroll that into a complete sequence in some external task manager; 4. work through task manager until it's done. That's a 4-loop (hahah). I have found that to be - if slower and more token-demanding (and thus expensive), consistently reliable.

A variant of 3. is to have the model write a script that will perform the iteration nonstochastically. For agentic workflows, oftentimes the "steps" are not necessarily NLP tasks - most of the evals and papers we saw were focused on NLP steps. This is a variant of "pulling the task tracking out of the inference."

So for *me*, how I'd think of it is,

1. if your set is small, an your steps are small, such that the set and steps will stay in the context window, then you can command a loop.
2. If your set is big, or your steps are many, you cannot fight "lost in the middle" plus the attention sink PLUS exponential decay and everything else. unroll the actionable task list OUTSIDE the context window, and have the LLM do a simple, small loop of "1. pull task; 2. do task; 3; repeat until no more task"
3. if the steps do not require NLP, write a script instead of looping with inference turns.

thinking/reasoning models will sometimes use task list tools (see: previous paper's note, one of them, about how reasoning models aren't great at choosing to use the tools they have) and do this unroll process on their own, but if you know which model and harness you'll have, you can boost or direct this.

And I'd cut any of my written numbered lists of instructions at 4 items unbroken by a tool call if at all possible, since the batching paper showed significant degradation at 4. Previously, I had no fixed number.

-->

**Everywhere:**

Use structural markers. Whether looped or unrolled, [XML tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags) and markdown headings improve adherence by providing the kind of hierarchical boundaries that models have internalized from their training data.[^12] OpenAI's [GPT-4.1 prompting guide](https://cookbook.openai.com/examples/gpt4-1_prompting_guide) found that XML performed well for multi-document inputs while JSON performed particularly poorly.[^13]

<!-- Editor's note: 

In my unscientific anedcata experience, I agree strongly with structural markers. Perhaps we could show some inline examples (are markdown headings structural markers, too?)

-->

If you must keep many items in a single prompt, three mitigations improve compliance: repeat the core instruction block after each item or at the end of the prompt,[^5] use indexed structural tags for each item,[^12] and add a self-verification step asking the model to check whether it completed all items. ManyIFEval found that self-refinement improved GPT-4o's 10-instruction compliance from 15% to 31%.[^1] Not great, but nearly double.

## What This Means

<!-- Editor's Note

Would like a different section header here, I think.

-->

The transformer's causal attention architecture mechanistically favors explicit, per-item instruction blocks over abstract loop constructs. This is not a prompting trick - it's a consequence of how softmax attention, causal masking, and positional encoding interact. The research evidence for this is strong, converging from multiple independent programs.

But "always unroll" is an oversimplification that fails to account for how most people actually use language models today. In agentic workflows, tool-call boundaries act as natural generation resets that mitigate the very problems unrolling solves. The real skill is learning to think in terms of constraints-per-generation rather than constraints-per-prompt.

The research also suggests this isn't something models will simply "grow out of." The [Coverage Principle](https://arxiv.org/abs/2505.20278) (2025) argues that for tasks requiring multi-hop reasoning - the logical equivalent of a loop - the training data requirement grows quadratically with token set size.[^14] The limitation is architectural, not parametric. Scaling model size doesn't linearly improve loop handling.

<!-- Editor's note: 

"The coverage principle" shows up once in that paper, as a side reference. Anchor text may need fixing.

-->

So: unrolling works, the reasons it works are well-understood, and the situations where it doesn't matter are equally well-defined. The question was never really "loop or unroll?" It was "how many things am I asking the model to hold in its head at once?" That question has a precise, architecturally grounded answer. It's just not always the same one.


<!-- Editor's Final Notes:

DATE ACCURACY:

Because things change so fast, we must note what "leading" or "frontier" models are at the time of paper authorship, and should probably also include the (authors et. al 20XX) for all papers when they are first introduced.

OPEN vs CLOSED:

We may want to pay attention to open-weight/open-source vs proprierary fronteir models, as one thing's for sure, llama gets its ass kicked by Claude at any point in time, for example.

CITATION CLEANUP:

See the citation rules in blogging.mdc and clean up citation style throughout.

-->

---

<!--
n.b. footnotes do not work when they are not referenced in doc; couting is wrong. maybe a nplugin bump can fix this.

-->

[^1]: Harada et al., "Curse of Instructions: Large Language Models Cannot Follow Multiple Instructions at Once," ICLR 2025. <https://openreview.net/forum?id=R6q67CDBCH>

[^2]: Jaroslawicz et al., "How Many Instructions Can LLMs Follow at Once?" July 2025. <https://arxiv.org/abs/2507.11538>

[^3]: "Why do LLMs attend to the first token?" April 2025. <https://arxiv.org/abs/2504.02732>

[^4]: Hsieh et al., "Found in the Middle: Calibrating Positional Attention Bias Improves Long Context Utilization," ACL Findings 2024. <https://arxiv.org/abs/2406.16008>

[^5]: Leviathan, Kalman, Matias, "Prompt Repetition Improves Non-Reasoning LLMs," Google Research, December 2025. <https://arxiv.org/abs/2512.14982>

[^6]: Son et al., "Multi-Task Inference: Can Large Language Models Follow Multiple Instructions at Once?" February 2024. <https://arxiv.org/abs/2402.11597>

[^7]: "Drift No More? Context Equilibria in Multi-Turn LLM Interactions," 2025. <https://arxiv.org/abs/2510.07777>

[^8]: Cheng et al., "Batch Prompting: Efficient Inference with Large Language Model APIs," EMNLP 2023. <https://arxiv.org/abs/2301.08721>

[^9]: Chen et al., "Understanding LLM Performance Degradation in Multi-Instance Processing: The Roles of Instance Count and Context Length," March 2026. <https://arxiv.org/abs/2603.22608>

[^10]: Qi et al., "AGENTIF: Benchmarking Instruction Following of Large Language Models in Agentic Scenarios," NeurIPS 2025. <https://arxiv.org/abs/2505.16944>

[^11]: Anthropic, "Prompt Engineering Best Practices," Claude API Docs, accessed April 2026. <https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-prompts>

[^12]: Anthropic, "Use XML tags to structure your prompts," Claude API Docs. <https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags>

[^13]: OpenAI, "GPT-4.1 Prompting Guide," OpenAI Cookbook. <https://cookbook.openai.com/examples/gpt4-1_prompting_guide>

[^14]: "The Coverage Principle: A Framework for Understanding Compositional Generalization," 2025. <https://arxiv.org/abs/2505.20278>
