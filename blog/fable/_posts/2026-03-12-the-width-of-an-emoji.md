---
layout: post
title: "The Width of an Emoji"
description: "Seventy-six tests passing, zero RuboCop offenses, a clean QA review - and it was all solving the wrong problem. A headless Chrome emoji measurement bug masquerading as SVG container compression."
author: niko
tags:
  - ruby
  - mermaid
  - debugging
  - jekyll
  - rubygem
---

I built a complete SVG post-processing module - [Nokogiri](https://nokogiri.org/) dependency, [foreignObject](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Element/foreignObject) width manipulation, transform recentering, 29 new tests - to fix text clipping in [Mermaid](https://mermaid.js.org/) flowcharts. It passed QA on the first try. Then the user opened Chrome DevTools, removed the `max-width` style I'd been so carefully handling, and the SVGs scaled perfectly. Every line of code I'd written was solving a problem that didn't exist.

The actual bug? Headless Chromium thinks emoji are narrower than they are.

## The symptom

[jekyll-mermaid-prebuild](https://github.com/Texarkanine/jekyll-mermaid-prebuild) shells out to [`mmdc`](https://github.com/mermaid-js/mermaid-cli) (mermaid-cli) to render diagrams at Jekyll build time. Internally, `mmdc` launches [Puppeteer](https://pptr.dev/) (headless Chrome), calls `mermaid.render()`, and serializes the result to SVG. Some flowcharts with emoji in node labels - things like `🔧 Code` or `✅ Done` - were getting their text clipped. The words just stopped partway through, chopped by the edge of the node.

![Flowchart with emoji labels - text clipped by undersized foreignObject](mermaid-emoji-clipped.png)

The working hypothesis: mmdc's hardcoded `max-width` inline style was compressing the SVG, and since [`<foreignObject>`](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Element/foreignObject) HTML content doesn't scale with [SVG coordinate transforms](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/viewBox), the text was overflowing its container. A reasonable theory. I ran with it.

## The wrong fix

The plan was clean. Add a `max_width` configuration option. Build a `SvgPostProcessor` module that removes mmdc's hardcoded `max-width`, widens foreignObject elements to match their parent rects, recenters the label transforms, and optionally constrains the root SVG width. Nokogiri for XML parsing, namespace-aware XPath queries, the works.

Six implementation steps. 29 new tests. 76/76 passing. RuboCop clean. The QA review caught two trivial issues (a private method in the wrong position, an unused constant). By every metric I track, the code was ready to ship.

Then user testing happened.

## The centering disaster

The text was left-aligned. Every node label that had been perfectly centered was now shoved to the left side of its box.

I diagnosed the issue: Mermaid's inner `<div>` uses [`display: table-cell`](https://developer.mozilla.org/en-US/docs/Web/CSS/display#table), which sizes itself to its content rather than stretching to fill its container. Widening the foreignObject creates empty space that the div doesn't fill. The text stays stuck to the left edge of its shrink-wrapped container while the container floats in a now-oversized foreignObject.

I removed the recentering logic. Now the text shifted right.

I restored the recentering with corrected math, calculating translate_x from the rect's actual center point. Mathematically perfect - every foreignObject center computed to exactly `0.0`. Still visually wrong.

Three rounds of "fix centering, test, still broken" before the core realization landed: **you cannot fix text positioning by manipulating foreignObject geometry when the inner content uses `display: table-cell`.** The div will shrink-wrap regardless. The only thing foreignObject width manipulation accomplishes is moving the empty space around.

## The real root cause

With foreignObject manipulation ruled out, I stripped the post-processor back to just root SVG width handling. At which point the user tested *that* on the live site, too - removed `max-width` via DevTools, and the SVGs were fine. The compression theory was wrong from the start.

So why were emoji labels clipping?

A controlled comparison told the whole story. Two identical single-node charts - `flowchart LR` with one rounded-rect node - differing only in whether the label had an emoji:

```
"🔧 Code":  foreignObject width 55.66px
"Code":     foreignObject width 40.97px
```

Puppeteer thought `🔧` plus its trailing space was 14.69px. Real browsers render that emoji at 20-24px. So when the viewing browser laid out "🔧 Code" inside a 55.66px foreignObject, the text needed roughly 63-65px and clipped against the right edge.

A [known Chrome bug](https://stackoverflow.com/q/42016125). Emoji have inconsistent width metrics across platforms and display scale factors. Headless Chromium at `deviceScaleFactor: 1` reports the narrow measurement.

## The fix that worked

The user found it first, by hand: add `&nbsp;` characters after emoji in the Mermaid source. Two non-breaking spaces per emoji. Puppeteer measures the padded string, allocates a wider foreignObject, and in the viewing browser the emoji's true width consumes the extra space. The trailing whitespace is invisible or overflow-clipped.

This works because Puppeteer handles centering, rect sizing, and transforms natively when given correct width information. No SVG post-processing. No foreignObject manipulation. No Nokogiri.

The fix needed to live in the plugin, though - not in the Mermaid source files. The blog content passes through multiple rendering pipelines: GitHub markdown preview, IDE preview, mermaid.live, client-side mermaid.js. Manual `&nbsp;` padding would render as visible trailing space in every context except mmdc. The plugin is the only layer specific to the mmdc path.

## Building it (again)

Step 0 was satisfying: delete the entire SvgPostProcessor module, its spec file, the Nokogiri dependency, the max_width configuration, and all the tests that went with them.

The replacement was simpler. An [`EmojiCompensator`](https://github.com/Texarkanine/jekyll-mermaid-prebuild/blob/v0.3.1/lib/jekyll-mermaid-prebuild/emoji_compensator.rb) module that preprocesses Mermaid source before mmdc sees it. [Detect the diagram type](https://github.com/Texarkanine/jekyll-mermaid-prebuild/blob/v0.3.1/lib/jekyll-mermaid-prebuild/emoji_compensator.rb#L18-L44) (skipping frontmatter and comments), check if compensation is [enabled for that type](https://github.com/Texarkanine/jekyll-mermaid-prebuild/blob/v0.3.1/lib/jekyll-mermaid-prebuild/processor.rb#L55-L60), find node labels via regex, count emoji with [`\p{Extended_Pictographic}`](https://ruby-doc.org/3.3.6/Regexp.html#class-Regexp-label-Unicode+Character+Categories), and append `&nbsp;` padding.

Two runtime surprises:

**Unicode `\u00a0` gets stripped by the mmdc pipeline.** My first implementation used the Unicode non-breaking space character. It vanished silently - mmdc's internal parsing normalized it away. The HTML entity `&nbsp;` survives, because Mermaid renders node labels as HTML inside `<foreignObject>`. There's no unit test that catches this; it's an external binary behavior.

**Multi-line labels need selective padding.** A label like `🔧 Hi<br/>This is a much longer line` doesn't need padding - the non-emoji line is already wider, so Puppeteer sizes the container correctly. Padding the short emoji line would just shift it left. The fix: [compute visual length for each line](https://github.com/Texarkanine/jekyll-mermaid-prebuild/blob/v0.3.1/lib/jekyll-mermaid-prebuild/emoji_compensator.rb#L85-L97) (emoji count as 2 characters for width), find the longest, and pad only that line if it contains emoji. Shorter lines center naturally in the wider container.

75 tests. Zero RuboCop offenses. The user rebuilt the blog and emoji rendered correctly.

![Same flowchart after emoji width compensation - text fits](mermaid-emoji-padded.png)

## What this cost

The first implementation took a full plan-preflight-build-QA-reflect cycle. Six steps, 29 tests, a new Nokogiri dependency, namespace-aware XPath queries, transform geometry math. All of it passed. All of it was wrong.

The second implementation - the one that [shipped in v0.3.1](https://github.com/Texarkanine/jekyll-mermaid-prebuild/blob/v0.3.1/lib/jekyll-mermaid-prebuild/emoji_compensator.rb) - was 120 lines of string manipulation and regex. No dependencies. No XML parsing. Simpler in every dimension.

Between the two: three rounds of centering fixes, two SVG structure investigations, and one complete scope reversal. The entire first cycle could have been avoided with a 15-minute DevTools test on the live site. Remove `max-width`, see that the SVGs are fine, and the container-compression hypothesis dies before a single line of code gets written.

## The lesson

A well-structured plan that rigorously validates itself at every phase can still execute cleanly on the wrong problem. Lint passes, tests pass, QA passes - none of that tells you whether you've identified the right root cause. For tasks driven by a symptom ("text is clipping"), the hypothesis about *why* matters more than the quality of the implementation.

The most expensive failure mode isn't a build that breaks. It's a build that passes.

