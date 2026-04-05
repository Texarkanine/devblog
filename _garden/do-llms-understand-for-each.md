---
layout: garden
title: "Do LLMs Understand 'For Each'?"
description: "What happens when you ask a language model to process a list of items? Research on instruction adherence, attention mechanics, and the generation boundary."
tags:
  - ai
  - llm
  - prompting
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

The first is compact, elegant, and how a programmer would think about it. The second is verbose, redundant, and feels like it insults the model's intelligence. The research says the second one works better - but with caveats that matter more than the headline.

## The Curse of Instructions

The strongest evidence for unrolling comes from the [ManyIFEval benchmark](https://openreview.net/forum?id=R6q67CDBCH) (Harada et al., ICLR 2025), which discovered a brutal mathematical relationship: the probability of a model following *all* instructions in a prompt is approximately the per-instruction success rate raised to the power of the instruction count. If a model follows any single instruction 95% of the time, then 10 simultaneous instructions yield roughly 60% all-correct compliance. In practice, it's worse. GPT-4o managed just 15% success with 10 simultaneous instructions. Claude 3.5 Sonnet did better at 44%, but neither is close to reliable.[^1]

The arithmetic is merciless. When a prompt says "for each of 10 items, follow these 5 steps," the model must satisfy 50 effective constraints in a single generation. The multiplicative decay means that individually easy steps compound into near-certain failure at scale. Unrolling into separate per-item calls keeps each call at 5 constraints, preserving the per-instruction success rate without cross-item compounding.

The [IFScale benchmark](https://arxiv.org/abs/2507.11538) (Jaroslawicz et al., July 2025) pushed this further, testing up to 500 simultaneous keyword-inclusion instructions across 20 state-of-the-art models. Even the best frontier models achieved only about 68% accuracy at 500 instructions. More usefully, the study identified three distinct degradation patterns across model families:[^2]

- **Threshold decay** for reasoning models like o3 and Gemini-2.5-Pro: near-perfect performance until roughly 150 instructions, then collapse.
- **Linear decay** for models like GPT-4.1 and Claude 3.7 Sonnet: steady, proportional decline.
- **Exponential decay** for smaller or older models like Claude 3.5 Haiku and Llama-4-Scout: steep drops from the start.

This means the penalty for loop-style prompts depends partly on which model you're using. Reasoning models tolerate higher instruction density before degradation kicks in. Smaller models crumble immediately.

## Why It Happens

The exponential compounding is a symptom. The disease is architectural.

### Attention Sinks

Researchers at MIT discovered that transformer models dump disproportionate attention onto initial tokens due to [softmax](https://en.wikipedia.org/wiki/Softmax_function) normalization - a phenomenon they called "[attention sinks](https://arxiv.org/abs/2309.17453)" (Xiao et al., ICLR 2024). A 2025 follow-up confirmed this is an intrinsic architectural property, not a quirk of specific inputs.[^3] In a loop-style prompt, the instruction block at the top becomes the attention sink while items in the middle are starved. Unrolling creates fresh attention sinks at each item's instruction header.

### Lost in the Middle

A landmark study by Liu et al. in [Transactions of the ACL](https://arxiv.org/abs/2307.03172) (2024) demonstrated a U-shaped performance curve: models access information at the beginning and end of their context with meaningfully higher accuracy than information in the middle. A follow-up from Hsieh et al., "[Found in the Middle](https://arxiv.org/abs/2406.16008)" (ACL Findings 2024), traced this to an intrinsic attention allocation bias that persists regardless of content relevance.[^4] In a loop-style prompt processing many items, the middle items land in the degraded zone. Unrolling gives every item its own beginning and end.

### Causal Masking and Prompt Repetition

The most elegant piece of evidence comes from Google Research. Leviathan, Kalman, and Matias published "[Prompt Repetition Improves Non-Reasoning LLMs](https://arxiv.org/abs/2512.14982)" in December 2025. The finding: simply duplicating the entire prompt improved accuracy on 47 of 70 tested tasks with zero losses. On one task, Gemini 2.0 Flash Lite jumped from 21.33% to 97.33% - a 76 percentage-point gain.[^5]

The mechanism is revealing. In causal (left-to-right) attention, instruction tokens are processed before data tokens, meaning the instruction encoding lacks awareness of the data it must operate on. When instructions are repeated *after* the data - or, by extension, repeated per item - each instruction instance can attend to all preceding context, creating a richer signal. Critically, padding the prompt to equivalent length *without* repeating instructions produced no improvement, confirming the gain comes from information repetition, not length.[^5]

This has a direct implication for the loop question. Unrolling is not merely about reducing constraint count per call. It's about giving each item its own copy of the instructions, positioned where the instructions can attend to the relevant data. The transformer's causal attention architecture mechanistically favors this.

But there's a wrinkle. The prompt repetition effect was "neutral to slightly positive" for reasoning models (5 wins, 1 loss, 22 neutral out of 28 tasks).[^5] Models that reason via chain-of-thought already perform an internal form of "re-reading" that mimics the repetition effect. This aligns with IFScale's finding that reasoning models tolerate higher instruction density.[^2]

## When Loops Work Fine - or Even Help

The evidence so far paints a clear picture: unroll everything. But the picture has a blind spot that matters enormously in practice.

### Small Batches of Related Tasks

The [Multi-Task Inference benchmark](https://arxiv.org/abs/2402.11597) (Son et al., February 2024) tested a different regime: 2-3 closely related subtasks sharing context, processed together versus separately. GPT-4 showed up to 12.4% *improved* performance with multi-task inference compared to single-task.[^6] The explanation: "looking at the next sub-task provides critical clues on the answer format for solving the previous sub-task."[^6] Seeing the structure of subtask 2 gives the model implicit guidance for subtask 1.

This isn't a small effect, and it works precisely because the tasks are related and few. The same study found that naive batch prompting of *unrelated* tasks hurt performance - "mixing of tasks can confuse the model, as it needs to navigate through irrelevant information."[^6] So the counterargument to unrolling is narrow but real: for a small number of structurally similar items that benefit from seeing each other's context, a loop may actually produce better results.

### The Cost of Unrolling: Instruction Drift

Unrolling has a cost that the pro-unrolling research tends not to mention. Repeating instructions N times increases total token count, and as context grows, the relative attention weight of the initial system prompt decreases. Research on [instruction drift](https://arxiv.org/abs/2510.07777) formalizes this as turn-wise divergence from goal-consistent behavior over extended contexts. The drift doesn't accumulate without bound - it stabilizes at finite levels that can be shifted downward by lightweight interventions like goal reminders.[^7] But it means that aggressively unrolling a 50-item list into a single massive prompt could erode the very instruction adherence you're trying to preserve.

This creates a tension. Loops suffer from exponential constraint compounding. Unrolling suffers from linear drift. For small N, the compounding fix dominates. For very large N, drift may erode the gains. The crossover point is not precisely characterized in the literature, but the [batch prompting](https://arxiv.org/abs/2301.08721) research (Cheng et al., EMNLP 2023) found that batch size 4 was the practical sweet spot for balancing quality against efficiency.[^8]

## The Distinction That Actually Matters

Here's the thing that most discussions of this topic miss, and the reason a blanket "always unroll" recommendation is incomplete.

Every study cited so far measures *single-generation* constraint satisfaction. ManyIFEval tests whether 10 formatting constraints are satisfied in one output. IFScale tests whether 500 keywords appear in one business report. Chen et al.'s multi-instance processing study[^9] tests whether 100 items are processed in one pass. The attention sink, lost-in-the-middle, and causal masking effects all operate within a single forward pass of the model.

But most practitioners asking "should I unroll my loops?" aren't writing monolithic prompts. They're building [agentic workflows](https://en.wikipedia.org/wiki/Intelligent_agent) where the model makes tool calls - reads a file, queries a database, edits a document - and each tool call creates a new generation boundary. In a typical agentic loop:

1. Load guidance rule (tool call, new generation context)
2. Read file (tool call, new generation context)
3. Evaluate (reasoning step)
4. Maybe edit (tool call, new generation context)
5. Back to step 1 for next item

Each tool call resets the generation context. The agent isn't trying to satisfy 15 constraints in one output - it's doing 5 things, getting a response, doing 5 more, getting a response. The exponential compounding from ManyIFEval doesn't apply because each generation carries only a handful of constraints. The lost-in-the-middle effect resets at each tool boundary because the orchestration framework re-injects the system prompt and recent context.

The prompt repetition paper implicitly confirms this. Its effect is neutral for reasoning models because they already "re-read" internally via chain-of-thought.[^5] Agentic tool-call loops achieve the same re-reading mechanically - each iteration brings the instructions back into focus through the tool response cycle.

This doesn't mean agentic workflows are immune to instruction-following failures. The [AGENTIF benchmark](https://arxiv.org/abs/2505.16944) (Qi et al., NeurIPS 2025) - the first benchmark specifically designed for instruction following in agentic scenarios - found that current models still struggle, even the best achieving only about 60% constraint satisfaction on agentic prompts averaging nearly 12 constraints each.[^10] Conditional constraints proved particularly fragile: over 30% of failures came from incorrect condition checking - the model failing to recognize whether a condition was triggered, not failing to follow the constraint itself. And meta-constraints - instructions that govern other instructions, like "prioritize X over Y" - were among the least reliable of all.[^10] The constraints-per-generation count still matters. It's just that tool boundaries keep the per-generation count lower than what a monolithic prompt would impose.

Anthropic's own documentation reflects this shift. Their prompt engineering guidance, which once recommended chaining as a general best practice for reducing errors, now positions it as a niche technique: "With adaptive thinking and subagent orchestration, Claude handles most multi-step reasoning internally. Explicit prompt chaining is still useful when you need to inspect intermediate outputs or enforce a specific pipeline structure."[^11]

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

**Everywhere:**

Use structural markers. Whether looped or unrolled, [XML tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags) and markdown headings improve adherence by providing the kind of hierarchical boundaries that models have internalized from their training data.[^12] OpenAI's [GPT-4.1 prompting guide](https://cookbook.openai.com/examples/gpt4-1_prompting_guide) found that XML performed well for multi-document inputs while JSON performed particularly poorly.[^13]

If you must keep many items in a single prompt, three mitigations improve compliance: repeat the core instruction block after each item or at the end of the prompt,[^5] use indexed structural tags for each item,[^12] and add a self-verification step asking the model to check whether it completed all items. ManyIFEval found that self-refinement improved GPT-4o's 10-instruction compliance from 15% to 31%.[^1] Not great, but nearly double.

## What This Means

The transformer's causal attention architecture mechanistically favors explicit, per-item instruction blocks over abstract loop constructs. This is not a prompting trick - it's a consequence of how softmax attention, causal masking, and positional encoding interact. The research evidence for this is strong, converging from multiple independent programs.

But "always unroll" is an oversimplification that fails to account for how most people actually use language models today. In agentic workflows, tool-call boundaries act as natural generation resets that mitigate the very problems unrolling solves. The real skill is learning to think in terms of constraints-per-generation rather than constraints-per-prompt.

The research also suggests this isn't something models will simply "grow out of." The [Coverage Principle](https://arxiv.org/abs/2505.20278) (2025) argues that for tasks requiring multi-hop reasoning - the logical equivalent of a loop - the training data requirement grows quadratically with token set size.[^14] The limitation is architectural, not parametric. Scaling model size doesn't linearly improve loop handling.

So: unrolling works, the reasons it works are well-understood, and the situations where it doesn't matter are equally well-defined. The question was never really "loop or unroll?" It was "how many things am I asking the model to hold in its head at once?" That question has a precise, architecturally grounded answer. It's just not always the same one.

---

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
