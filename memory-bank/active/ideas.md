# Idea Bank

## Set-Tracking Benchmark for LLMs

**Title ideas**: "LLM Set-Tracking Benchmark: Why Models Fail at 'Process Each Item Exactly Once'" or "The Iterative Checklist Problem: A Dedicated Benchmark for Agentic State Tracking"

### Core Idea
Create a controlled benchmark that isolates the "iterative set-completion tracking" phenomenon documented in `planning/set-tracking.md` (and synthesized in the loop-unroll research).

**What it would measure**:
- Given a list of N distinct items/tasks
- Process each exactly once across multiple generation / tool-call turns
- Track which have been completed without external state
- Vary: set size (5–100), conversation length, item position (primacy/recency/middle), task complexity, model family
- Metrics: per-item completion rate, middle-item skip rate, premature termination rate, repetition rate, total coverage

**Why it's valuable**
- Fills the explicit gap identified in the synthesis: no dedicated benchmark exists for this practically critical failure mode.
- The `do-llms-understand-for-each.md` garden post (and the underlying loop vs unroll research) would be greatly strengthened by empirical data from a purpose-built benchmark.
- Would provide clear guidance on when externalized state (scratchpads, TodoListMiddleware, file-based checklists) is *necessary* vs. when in-context tracking suffices.
- Directly relevant to agentic systems, SWE-bench style agents, long-running research/review workflows, and the Niko memory-bank system itself.

**Related existing work**
- AgentBoard progress-rate metric
- IFScale / ScaledIF instruction scaling
- Lost-in-the-Middle + multi-turn degradation studies
- InfiAgent / Voyager / Reflexion external memory results
- The set-tracking.md literature review already cites ~40 papers that could serve as baselines.

**Potential implementation sketch**
- Synthetic task suite (file system ops, code edits, research paper review steps, etc.)
- Ground-truth checklist that the harness checks against
- Automated runner that feeds results back into the conversation context without leaking the checklist
- Compare in-context only vs. with explicit todo-list tool

This feels like a natural evolution of the loop-unroll work and the research-review-checklist rule we just formalized. It would make an excellent future garden post or full essay once implemented.

---

**Last updated**: 2026-04-08 (extracted from planning/ directory cleanup)

Other ideas can be appended here. This file lives in the ephemeral `memory-bank/active/` layer per the Niko memory bank conventions.