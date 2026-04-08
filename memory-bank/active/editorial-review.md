# Editorial Review: "Do LLMs Understand 'For Each'?"

**File:** `_garden/do-llms-understand-for-each.md`
**Branch:** `loop-unroll`
**Supporting research:** `planning/loop-report-1.md`, `planning/loop-report-2.md`, `planning/loop-reports-1-and-2-synthesis.md`, `planning/loop-report-1-analysis.md`

## Catalog of Editor Notes

Each note is numbered in document order. Categories:
- **Craft**: Tone, word choice, prose quality
- **Research**: Requires reading/fetching papers to verify or expand
- **Citation**: Citation format, duplication, or style per `blogging.mdc`
- **Content**: Missing content, structural decisions, or additions
- **Factual**: Claim verification or accuracy correction

### EN-01: Intro hook phrasing (line ~27)
- **Category:** Craft
- **Section:** Opening
- **Editor says:** "The hook 'more than the headline' needs reworking. Otherwise, intro is solid."
- **Status:** ✅ COMPLETED

### EN-02: ManyIFEval baseline numbers (lines ~36-46)
- **Category:** Research, Citation
- **Section:** The Curse of Instructions
- **Editor says:** Need to determine if 15%/44% are true baseline or improved by "their method." Paper may warrant "linkcard then direct quote" treatment as foundational to entire premise.
- **Status:** Pending

### EN-03: IFScale model/date qualification (lines ~52-60)
- **Category:** Factual, Citation
- **Section:** The Curse of Instructions (IFScale paragraph)
- **Editor says:** "Best frontier models" needs "as of DATESTAMP" with named model example. 20-model count confirmed. Anchor text + footnote duplication needs a resolution pattern applied throughout.
- **Status:** Pending

### EN-04: "crumble immediately" word choice (lines ~68-75)
- **Category:** Craft
- **Section:** The Curse of Instructions (model families paragraph)
- **Editor says:** "immediate" is too strong. They crumble *rapidly* with density, but tolerable at human-scale density (~5). Also notes IFScale is on GitHub.
- **Status:** Pending

### EN-05: Attention sinks - paper ordering & solution mention (lines ~85-105)
- **Category:** Research, Content
- **Section:** Why It Happens > Attention Sinks
- **Editor says:** Both papers confirmed germane. Consider mentioning StreamingLLM solution (not as "do this" but to deepen understanding). Which paper to lead with - 2025 follow-up is more recent and addresses "why," but 2024 is more introductory. Strong quote from 2025 paper about training inevitability.
- **Status:** Pending

### EN-06: Lost in the Middle / Found in the Middle (lines ~111-123)
- **Category:** Research, Content
- **Section:** Why It Happens > Lost in the Middle
- **Editor says:** Both papers confirmed relevant. Consider linkcard/direct-quote treatment. Critical question: is "found in the middle" (calibration mechanism) deployed in any current frontier models? Don't claim unrolling addresses this if a solution is already deployed. May be OK if we're introducing foundational problems with "is it solved?" deferred to end.
- **Status:** Pending

### EN-07: Prompt repetition citation & reasoning-model caveat (lines ~129-141)
- **Category:** Citation, Content
- **Section:** Causal Masking and Prompt Repetition
- **Editor says:** Footnote duplicates anchor text link. Important that effect is in non-reasoning models; readership relevance matters since free-tier users use non-thinking models. Don't overcompensate here since reasoning models are addressed later.
- **Status:** Pending

### EN-08: "paints a clear picture" lead-in tone (lines ~153-157)
- **Category:** Craft
- **Section:** When Loops Work Fine
- **Editor says:** "Make this lead-in sound human and not LinkedIn post."
- **Status:** Pending

### EN-09: Multi-Task Inference subtask examples (lines ~164-167)
- **Category:** Research, Content, Citation
- **Section:** Small Batches of Related Tasks
- **Editor says:** Need an example of the subtask structure from the paper. Paper highly relevant (confirmed). Footnotes just repeat the paper. Consider stealing Figure 1 as a Polaroid link.
- **Status:** Pending

### EN-10: Multi-Task Inference "small" threshold (lines ~171-175)
- **Category:** Research
- **Section:** Small Batches of Related Tasks (second paragraph)
- **Editor says:** Paper DIRECTLY supports "unroll the loop" approach. Does it define what "small" is? That threshold is important and we should mention it. Addressed as unknown in next section, but this paper might have an empirical answer.
- **Status:** Pending

### EN-11: Batch prompting deep reinterpretation (lines ~183-220)
- **Category:** Research, Factual
- **Section:** The Cost of Unrolling: Instruction Drift
- **Editor says:** MAJOR note. Batch prompting paper is about cost conservation without performance sacrifice, NOT about optimizing instruction adherence. "4" is the LIMIT without losing accuracy, not a sweet spot for MAXIMIZING accuracy. Existing text may mis-cast the paper's intent. Also: their "batch" is unrelated tasks (intersects with "small batches" section above). How does "batching" map to loops/unrolling? Later discourse on tool calls resetting generation matters - an 8-step loop with tool call at step 4.5 would not violate "rule of 4."
- **Status:** Pending

### EN-12: "Here's the thing" section intro (lines ~225-229)
- **Category:** Craft
- **Section:** The Distinction That Actually Matters
- **Editor says:** Cringey. Maybe insufficiently humble. "Please try again."
- **Status:** Pending

### EN-13: Single-generation claim verification (lines ~233-239)
- **Category:** Research, Factual
- **Section:** The Distinction That Actually Matters
- **Editor says:** "Prove to me that the claim that EVERY paper is single-generation, is true... or refute it with a concrete counterexample from a paper's text." Hidden easter egg.
- **Status:** Pending

### EN-14: Re-injection not universally true (lines ~250-254)
- **Category:** Factual
- **Section:** The Distinction That Actually Matters
- **Editor says:** "claim about re-injection not universally true; harnesses are very different."
- **Status:** Pending

### EN-15: Anthropic docs anchor link (lines ~263-266)
- **Category:** Citation
- **Section:** The Distinction That Actually Matters (Anthropic paragraph)
- **Editor says:** "Anthropic's own documentation can probably be an anchor link."
- **Status:** Pending

### EN-16: Decision framework + editor's own framework (lines ~297-322)
- **Category:** Content (MAJOR)
- **Section:** A Decision Framework
- **Editor says:** LARGE block. Unaddressed topics: set-tracking, exit conditions/break-if as meta-constraint, remembering which items processed. Editor proposes own "how I'd think of it" framework with 3 principles: (1) set-tracking must be externalized, (2) tool-call generation-reset makes small loops work, (3) have model ITSELF unroll into external task manager. Also: variant of writing a nonstochastic script. Rule of 4. Asks if we can find papers on set-tracking and exit conditions.
- **Status:** Pending

### EN-17: Structural markers inline examples (lines ~329-333)
- **Category:** Content
- **Section:** Everywhere (structural markers)
- **Editor says:** Would like inline examples. Are markdown headings structural markers too? (Agrees strongly with structural markers from personal experience.)
- **Status:** Pending

### EN-18: "What This Means" section header (lines ~339-343)
- **Category:** Craft
- **Section:** What This Means
- **Editor says:** "Would like a different section header here, I think." (Note: blogging.mdc explicitly calls out "What This Means" as often a bad title.)
- **Status:** Pending

### EN-19: Coverage Principle anchor text (lines ~351-355)
- **Category:** Citation, Factual
- **Section:** What This Means (Coverage Principle paragraph)
- **Editor says:** "'The Coverage Principle' shows up once in that paper, as a side reference. Anchor text may need fixing."
- **Status:** Pending

### EN-20: Global editorial passes (lines ~360-373)
- **Category:** Factual, Citation (GLOBAL)
- **Section:** Final notes (whole document)
- **Editor says:** Three cross-cutting concerns:
  - **Date accuracy:** Qualify "leading"/"frontier" with dates and example model names, use (Authors et al., 20XX) on first introduction.
  - **Open vs Closed:** Distinguish open-weight/open-source vs proprietary frontier models where relevant.
  - **Citation cleanup:** Apply `blogging.mdc` citation rules throughout.
- **Status:** Pending

## Process

For each note, in order:
1. **Understand** - What is the editor asking? What's the underlying concern?
2. **Research** (if applicable) - Fetch papers, verify claims, gather evidence.
3. **Assess** - Is the feedback valid? How important? What are the options?
4. **Propose** - Concrete recommendation with rationale.
5. **Present** - Surface to editor for approval.
6. **Execute or Defer** - Apply approved change or note deferral.

After all notes addressed: **Integration pass** to verify changes cohere.
