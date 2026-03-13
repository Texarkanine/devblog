# Jekyll mermaid prebuild enhancements
_Exported on 3/12/2026 at 19:17:40 CDT from Cursor (2.6.14)_

---

**User**

/niko  use the jekyll-mermaid-prebuild memory-bank; we're building an enhancement. observe that a different plugin that deals with images, accepts a max_width parameter: @devblog/_config.yaml:107-111 

We should probably also accept max_width into jekyll-mermaid-prebuild, and pass that to mmdc when it generates SVGs. this would help prevent weird cropping of diagrams on narrow sites.

HOWEVER, there's an issue with the headless rendering; I think we need to postprocess these SVGs if a max width is provided. We may also need to support a min_width? The issue is the SVG gets locked to puppeteer's headless width computation (which is wrong). We want to "fix" that elegantly. If a blog knows its fixed width, providing it can just DO that. But what about flex-width blogs? Can we fix for that, too?

@devblog/memory-bank/active/planning.md contains an in-depth assessment of the issue that you should check against the codebase and the constraints above.

---

**Cursor**

I'll start by loading the Niko initialization rules and reading the planning document, then assess the codebase.

Now let me check the ephemeral files and explore the codebase structure.

Let me read the core source files to understand the current implementation before assessing complexity.

Let me also check the gemspec and existing test patterns.

Good. The persistent memory bank files exist. No ephemeral files in `memory-bank/active/` for jekyll-mermaid-prebuild, so this is a fresh task. Let me now determine complexity and set up the ephemeral files.

**Complexity Analysis:**

Walking the decision tree:
1. Bug fix or error correction? **No** — user explicitly frames this as an "enhancement"
2. Adding small feature or enhancement? **Yes**
3. Self-contained change? **No** — touches Configuration (new params), Generator (post-processing hook), plus a new SvgPostProcessor module, and has non-trivial design decisions (flex-width vs fixed-width, min/max width semantics, viewBox strategy)
4. Affects multiple components? **Yes**

**Result: Level 3 — Intermediate Feature**

Rationale: Multiple components affected, design exploration needed (SVG sizing strategy for both fixed and flex-width blogs), new Nokogiri dependency, cache-key implications, and the foreignObject fix has subtlety around re-centering transforms.

Let me load the L3 workflow and create the ephemeral files.

Now I'll create the ephemeral files for this L3 task. Let me ensure the active directory exists first.

Complexity Analysis Complete -- Level 3 determined. Loading Level 3 workflow...

Now let me commit this and load the L3 Plan phase.

Now I'm executing the **L3 Plan Phase**. Prerequisites verified (all ephemeral files exist). Let me do the component analysis and build the full plan.

Now I have a thorough understanding of every component. Let me complete the L3 Plan phase by writing the full implementation plan.

**Component Analysis Summary:**
- **Configuration**: New `max_width` accessor
- **SvgPostProcessor**: Entirely new module (stateless utility, `module_function` pattern)
- **Generator**: Call post-processor after mmdc render
- **Processor**: Include `max_width` in cache key computation
- **Gemspec**: Add Nokogiri runtime dependency
- **Main require file**: Add new module require

**Open Questions Assessment:**
1. **min_width** - User was uncertain ("may also need"). Defer — it's a CSS layout concern, not a plugin responsibility. Can be added later without architectural impact.
2. **viewBox adjustment** - Not needed. foreignObject fix constrains content within existing rect bounds, already within viewBox.
3. **Pass width to mmdc `--width` flag** - No. The foreignObject bug is in mmdc's text measurement, not its viewport. Post-processing is the correct fix.
4. **Always post-process vs only when max_width set** - Always. The foreignObject fix is a bug correction that benefits all users. max_width is just an additional constraint.

No creative phase needed — all questions resolved with high confidence.

Now let me commit and proceed to Preflight.

# Plan Result

**PASS** - Level 3: Intermediate Feature

## Summary

- **Components affected**: Configuration, SvgPostProcessor (new), Generator, Processor, gemspec, main require, README
- **Open questions**: 0 unresolved (4 design decisions resolved without creative phase)
- **Behaviors to verify**: 18
- **Implementation steps**: 6
- **New dependencies**: Nokogiri >= 1.13 (runtime)

## Creative Decisions

None needed — all design questions resolved with high confidence:
- **Always post-process**: foreignObject fix is a bug correction, not config-dependent
- **min_width deferred**: CSS layout concern; can be added later without architectural change
- **No mmdc flag changes**: fix is purely post-processing
- **Cache migration**: key format change auto-invalidates old entries

## Challenges

- SVG namespace handling in Nokogiri XPath (mitigated with explicit namespace mapping)
- Diverse diagram types (mitigated with presence guards)
- Transform string parsing (mitigated with strict regex + skip on mismatch)
- Cache migration on upgrade (mitigated by key format change)

## Next Steps

Proceed to Preflight phase to validate the plan.

Now loading the Preflight phase.

Let me verify some details for the preflight checks.

Running through the preflight checks systematically.

**1. Prerequisites** - Plan complete, all memory bank files present. ✓

**2. Convention Compliance:**
- `SvgPostProcessor` uses `module_function` pattern (matches `DigestCalculator`, `MmdcWrapper`) ✓
- File naming `svg_post_processor.rb` matches snake_case convention ✓
- Module namespace `JekyllMermaidPrebuild::SvgPostProcessor` ✓
- Configuration pattern (add `max_width` alongside `output_dir`/`enabled`) ✓
- No new hooks needed ✓

**3. Dependency Impact:**
- **FINDING**: Existing `instance_double` mocks for Configuration in `generator_spec.rb` (has `cache_dir`, `output_dir`) and `processor_spec.rb` (has `cache_dir`, `output_dir`, `enabled?`) will need `max_width` added to avoid RSpec "unexpected message" errors. The plan covers modifying these spec files but should be explicit about updating existing test doubles.
- `hooks_spec.rb` config double does NOT access `max_width` — no change needed ✓

**4. Conflict Detection:**
- No existing SVG processing utilities in codebase ✓
- No existing Nokogiri usage ✓
- No conflicting patterns ✓

**5. Completeness Precheck:**
- All 7 requirements map to concrete implementation steps with specific files ✓
- All 18 test behaviors cover the new functionality ✓
- Documentation step covers README ✓

**6. Radical Innovation:**
- **Within scope**: Defensively ensure `width="100%"` is always set on root `<svg>` element (some mmdc edge cases might not include it). One line of code, one test — makes responsive behavior robust. Amending plan.
- **Advisory (out of scope)**: Pluggable post-processor architecture (register multiple processors in Configuration, Generator runs them in sequence). Good for future extensibility (accessibility, dark mode, custom styling) but adds complexity beyond current task. Flagging for operator consideration.

Let me amend the plan and create the preflight status.

Now add a note about updating existing test doubles.

Now create the preflight status file and update progress.

# Preflight Result

**PASS**

## Findings

1. **INFO**: Existing `instance_double` mocks for Configuration in `generator_spec.rb` and `processor_spec.rb` need `max_width` added — plan amended with explicit notes
2. **AMENDMENT**: Added B9a test behavior — defensively set `width="100%"` on root SVG for robust responsive behavior
3. **ADVISORY**: Pluggable post-processor architecture (register multiple processors, Generator runs them in sequence) would improve future extensibility for accessibility, dark mode, custom styling. Exceeds current scope — flagged for your consideration on a future task.

## Next Steps

Preflight passed. The plan is ready for build. Per the L3 workflow, the Build phase requires operator initiation with `/niko-build`. Ready when you are.

---

**User**

@jekyll-mermaid-prebuild/memory-bank/active/tasks.md:11-23 should've been a sequence diagram, yeah? why or why not?

---

**Cursor**


Using a sequence diagram — the pipeline is a temporal call sequence: Processor → Generator.generate → MmdcWrapper.render → Generator reads SVG → SvgPostProcessor.process → Generator writes cache. A sequence diagram makes invocation order and synchronous call/return explicit; the flowchart mixes artifact flow with control flow. Replacing it with a sequence diagram.



**Why a sequence diagram fits better**

- The pipeline is a **time-ordered call chain**: Processor → Generator → MmdcWrapper → back to Generator → SvgPostProcessor → back to Generator → write to cache. Sequence diagrams are meant for exactly that: who calls whom, in what order, and what comes back.
- The flowchart mixed **control flow** (who calls whom) with **artifact flow** (writes .mmd, writes .svg). A sequence diagram keeps the focus on **invocations and returns**, so it’s clear that SvgPostProcessor is called by Generator after mmdc has written the SVG and before Generator writes to cache.
- The “returns fixed SVG” step is a **synchronous return**; sequence diagrams show that with a return arrow, which matches the actual API.

So for “where SvgPostProcessor sits in the pipeline,” a sequence diagram is the right choice. I’ve replaced the flowchart with one and retitled the section to “Pipeline (Post-Processing Integration)” with a short note that it shows call order.

