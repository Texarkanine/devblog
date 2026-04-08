# Editorial Review: "Do LLMs Understand 'For Each'?"

**File:** `_garden/do-llms-understand-for-each.md`
**Branch:** `loop-unroll`
**Supporting research:** `planning/loop-report-1.md`, `planning/loop-report-2.md`, `planning/loop-reports-1-and-2-synthesis.md`, `planning/loop-report-1-analysis.md`
**Sometimes-relevant writing guidelines:** `.cursor/rules/blogging.mdc`

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
- **Status:** ✅ COMPLETED

### EN-03: IFScale model/date qualification (lines ~52-60)
- **Category:** Factual, Citation
- **Section:** The Curse of Instructions (IFScale paragraph)
- **Editor says:** "Best frontier models" needs "as of DATESTAMP" with named model example. 20-model count confirmed. Anchor text + footnote duplication needs a resolution pattern applied throughout.
- **Status:** ✅ COMPLETED

### EN-04: "crumble immediately" word choice (lines ~68-75)
- **Category:** Craft
- **Section:** The Curse of Instructions (model families paragraph)
- **Editor says:** "immediate" is too strong. They crumble *rapidly* with density, but tolerable at human-scale density (~5). Also notes IFScale is on GitHub.
- **Status:** ✅ COMPLETED

### EN-05: Attention sinks - paper ordering & solution mention (lines ~85-105)
- **Category:** Research, Content
- **Section:** Why It Happens > Attention Sinks
- **Editor says:** Both papers confirmed germane. Consider mentioning StreamingLLM solution (not as "do this" but to deepen understanding). Which paper to lead with - 2025 follow-up is more recent and addresses "why," but 2024 is more introductory. Strong quote from 2025 paper about training inevitability.
- **Status:** ✅ COMPLETED

### EN-06: Lost in the Middle / Found in the Middle (lines ~111-123)
- **Category:** Research, Content
- **Section:** Why It Happens > Lost in the Middle
- **Editor says:** Both papers confirmed relevant. Consider linkcard/direct-quote treatment. Critical question: is "found in the middle" (calibration mechanism) deployed in any current frontier models? Don't claim unrolling addresses this if a solution is already deployed. May be OK if we're introducing foundational problems with "is it solved?" deferred to end.
- **Status:** ✅ COMPLETED

### EN-07: Prompt repetition citation & reasoning-model caveat (lines ~129-141)
- **Category:** Citation, Content
- **Section:** Causal Masking and Prompt Repetition
- **Editor says:** Footnote duplicates anchor text link. Important that effect is in non-reasoning models; readership relevance matters since free-tier users use non-thinking models. Don't overcompensate here since reasoning models are addressed later.
- **Status:** ✅ COMPLETED

### EN-08: "paints a clear picture" lead-in tone (lines ~153-157)
- **Category:** Craft
- **Section:** When Loops Work Fine
- **Editor says:** "Make this lead-in sound human and not LinkedIn post."
- **Status:** ✅ COMPLETED

### EN-09/10/11: Section restructure - MTI paper + batch prompting (combined)
- **Category:** Research, Content, Factual, Structural
- **Section:** Was "When Loops Work Fine"; now "The Cost of Unrolling: Instruction Drift"
- **Resolution:** The MTI paper (Son et al., February 2024) was re-analyzed and found to support generation-boundary placement, not loop-style batching of items. It shows keeping 2-3 related steps per item in one generation beats decomposing them - this is evidence FOR the generation-boundary thesis, not for loops. "Small Batches of Related Tasks" subsection removed. MTI paper content to be integrated into "The Distinction That Actually Matters" section. Batch prompting recharacterized: "4" is a ceiling for quality retention, not a sweet spot for maximizing accuracy. Section promoted to H2, lead-in adjusted.
- **Status:** ✅ COMPLETED (structure change applied; MTI paper re-integration pending as NEW-01)
- **Removed text (MTI paper) for re-integration:**
  > The Multi-Task Inference benchmark (Son et al., February 2024) tested 2-3 closely related subtasks sharing context, processed together versus separately. GPT-4 showed 12.4% improved performance with multi-task inference compared to single-task. The explanation: "looking at the next sub-task provides critical clues on the answer format for solving the previous sub-task." This finding is really about generation-boundary placement: keeping related steps in one generation so they can attend to each other. It supports unrolling across items while arguing against over-decomposing steps within a single item.

### NEW-01: Integrate MTI paper into generation-boundary section
- **Category:** Content, Structural
- **Section:** The Distinction That Actually Matters
- **Editor says:** MTI paper (Son et al., 2402.11597) relocated from removed "Small Batches" subsection. Needs integration as evidence for the generation-boundary thesis. Key finding: 2-3 related steps per item benefit from staying in one generation. Consider Polaroid of Figure 1.
- **Resolution:** Moved from immediately after the thesis paragraph (where it disrupted the rhetorical flow) to after the prompt repetition paragraph, where the argument is already building evidence for generation boundaries. Reframed from "counterexample" to supporting evidence: MTI "points at the same boundary from the other direction." Restored the paper's own quote ("looking at the next sub-task provides critical clues on the answer format for solving the previous sub-task"). Citation DRYed up with `[6]` reference link shared between anchor text and footnote per `blogging.mdc`. Polaroid deferred.
- **Status:** ✅ COMPLETED

### EN-12: "Here's the thing" section intro (lines ~225-229)
- **Category:** Craft
- **Section:** The Distinction That Actually Matters
- **Editor says:** Cringey. Maybe insufficiently humble. "Please try again."
- **Resolution:** Original "Here's the thing" removed. Initial replacement intro ("Most of the research assumes a monolithic prompt...") was cut during EN-13 pass because it created a repetitive sandwich with the pivot paragraph. The heading now flows directly into the thesis paragraph. Editor's note removed.
- **Status:** ✅ COMPLETED

### EN-13: Single-generation claim verification (lines ~233-239)
- **Category:** Research, Factual
- **Section:** The Distinction That Actually Matters
- **Editor says:** "Prove to me that the claim that EVERY paper is single-generation, is true... or refute it with a concrete counterexample from a paper's text." Hidden easter egg.
- **Resolution:** Refuted. Wen et al. (instruction drift) explicitly studies multi-turn divergence - it's a counterexample to "every." Softened "Every study" to "Nearly every study," which is accurate and doesn't require a digression about which paper is the exception. Editor's note removed. Resolved jointly with EN-12 to eliminate the three-paragraph repetition (intro/evidence/pivot said "not monolithic" twice).
- **Status:** ✅ COMPLETED

### EN-14: Re-injection not universally true (lines ~250-254)
- **Category:** Factual
- **Section:** The Distinction That Actually Matters
- **Editor says:** "claim about re-injection not universally true; harnesses are very different."
- **Resolution:** Split the two claims. Constraint-count argument (universally true) kept as the strong leg. Lost-in-the-middle mitigation rewritten as harness-dependent: "The positional bias effects are also mitigated, though how much depends on the harness - orchestration frameworks differ in whether and how they re-inject context between tool calls." Editor's note removed.
- **Status:** ✅ COMPLETED

### EN-15: Anthropic docs anchor link (lines ~263-266)
- **Category:** Citation
- **Section:** The Distinction That Actually Matters (Anthropic paragraph)
- **Editor says:** "Anthropic's own documentation can probably be an anchor link."
- **Resolution:** Made "Anthropic's prompt engineering documentation" an anchor link via `[11]` reference link. Footnote `[^11]` retained on the quote and DRYed up to share the same `[11]` reference. Editor's note removed.
- **Status:** ✅ COMPLETED

### EN-16: Decision framework + editor's own framework (lines ~297-322)
- **Category:** Content (MAJOR)
- **Section:** A Decision Framework
- **Editor says:** LARGE block. Unaddressed topics: set-tracking, exit conditions/break-if as meta-constraint, remembering which items processed. Editor proposes own "how I'd think of it" framework with 3 principles: (1) set-tracking must be externalized, (2) tool-call generation-reset makes small loops work, (3) have model ITSELF unroll into external task manager. Also: variant of writing a nonstochastic script. Rule of 4. Asks if we can find papers on set-tracking and exit conditions.
- **Resolution:** Commissioned dedicated set-tracking research (`planning/set-tracking.md`). Verified 3 citations against primary sources: Huang et al. (ICML 2025, "reactive post-hoc solvers" confirmed), AgentBoard (NeurIPS 2024, GPT-4 easy/hard numbers confirmed, "~6 steps" qualified as open-weight models only), MAST (2025, FC3 corrected to 23% from report's 21.3%, step repetition corrected to 16% from 17%). Agentic table replaced with: grounding paragraph (3 new citations), enhanced 5-row table (small/large set, complex steps, drift re-injection, script variant), reasoning-model self-organization note, and rule-of-4 heuristic. Editor's note removed.
- **Status:** ✅ COMPLETED

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
