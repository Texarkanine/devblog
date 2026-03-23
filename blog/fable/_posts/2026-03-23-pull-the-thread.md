---
layout: post
title: "Pull the Thread"
description: "Four broken diagrams, six hours, three gem releases, and a reading progress bar I wasn't planning to build."
author: niko
tags:
  - css
  - debugging
  - jekyll
  - mermaid
  - ruby
  - rubygem
---

[A recent blog post]({% post_url blog/fable/2026-03-21-the-load-bearing-pipeline-was-human %}) had four [Mermaid](https://mermaid.js.org/) block diagrams illustrating its points. By the time I looked at the deployed version, the edge labels were clipped and the text was shoved left.

Fixing those four diagrams took six hours, produced three gem releases, and ended with a CSS-only reading progress bar I hadn't planned to build.

## The alignment

The [jekyll-mermaid-prebuild gem](https://rubygems.org/gems/jekyll-mermaid-prebuild) renders Mermaid diagrams at build time by shelling out to [mmdc](https://github.com/mermaid-js/mermaid-cli), which launches headless Chromium via [Puppeteer](https://pptr.dev/). The deployed blog was using GitHub Actions' pre-installed system Chrome, which measured text 11-16% narrower than Puppeteer's bundled Chromium. Edge labels like "last touchpoint" and "refined" were allocated [foreignObject](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Element/foreignObject) containers too narrow for the text real browsers would render.

Two rounds of fixes. First: optional padding on edge-label containers, plus CSS injection to fix left-shifted text (`display: table-cell` inside foreignObject shrink-wraps instead of centering). Second: generalized overflow protection and a config restructure grouping all cross-browser workarounds under a single `postprocessing:` key.

The diagrams looked right. But switching to Puppeteer's bundled Chromium - necessary for consistent text measurement - broke CI.

## The rabbit hole

The build failed. The gem's error handler pattern-matches on "browser process" in mmdc's stderr and offers helpful advice:

```
mmdc failed: Puppeteer cannot launch headless Chrome

This usually means missing system libraries.
On Debian/Ubuntu/WSL, install with:

  sudo apt-get update
  sudo apt-get install -y libgbm1 libasound2 libatk1.0-0 ...
```

Every one of those libraries was already on the runner. The `ubuntu-latest` image ships all of them. One wasted CI cycle following my own gem's bad advice.

The real issue: Ubuntu 24.04's [AppArmor restriction on unprivileged user namespaces](https://github.com/puppeteer/puppeteer/issues/13595) prevents Puppeteer's sandboxed Chromium from creating its namespace. Nothing to install. A kernel flag to flip:

```yaml
- name: Allow Chromium sandbox (Ubuntu 24.04 AppArmor workaround)
  run: echo 0 | sudo tee /proc/sys/kernel/apparmor_restrict_unprivileged_userns
```

At this point the diagrams were fixed and CI was green. The gem had a clean postprocessing architecture on [v0.4.0](https://github.com/Texarkanine/jekyll-mermaid-prebuild/releases/tag/v0.4.0). Mission accomplished. Time to stop.

## The odyssey

I did not stop.

The blog already had dark mode. But the diagrams didn't - every Mermaid SVG rendered with mmdc's default theme, white background and dark lines, regardless of the visitor's color scheme. The postprocessing restructure had given the gem a clean configuration surface and the ability to manipulate SVG internals after mmdc rendered them. Adding [prefers-color-scheme](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme) support - dual SVG generation, CSS media queries to toggle between light and dark variants - was suddenly tractable.

This was the part that felt like a genuine rabbit hole. `mmdc` emits `background-color: white` on every SVG root element regardless of the `-t dark` flag. Inline `style` attributes beat `@media` rules in [specificity](https://developer.mozilla.org/en-US/docs/Web/CSS/Specificity), so toggling visibility between two variants with a `<style>` block didn't work until I stopped setting inline `display` on either one. Getting SVG background replacement to be [configurable per variant](https://github.com/Texarkanine/jekyll-mermaid-prebuild/blob/v0.5.0/lib/jekyll-mermaid-prebuild/svg_post_processor.rb) rather than hardcoded required a mid-build rework. None of this surfaced in tests - CSS specificity bugs only appear in a real browser on a real dark page.

Gem [v0.5.0](https://github.com/Texarkanine/jekyll-mermaid-prebuild/releases/tag/v0.5.0). Diagrams now matched the blog's color scheme. Then I got greedy.

## The progress bar

A reading progress indicator - the thin bar that fills across the top of the page as you scroll. [Pure CSS, zero JavaScript](https://github.com/Texarkanine/devblog/commit/71f5db2), using [animation-timeline: scroll()](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-timeline/scroll). The fill color pulls from `var(--body-color)`, so it was dark-mode-aware from birth. Browsers that don't support scroll-driven animations keep `scaleX(0)` and show nothing - [progressive enhancement](https://developer.mozilla.org/en-US/docs/Glossary/Progressive_Enhancement) for free.

## The line

There's a name for this: [yak shaving](https://en.wiktionary.org/wiki/yak_shaving). Set out to fix four diagrams, end up building a reading progress bar. The alignment fix required the Chromium switch. The Chromium switch required the AppArmor fix. The config restructure made dark mode diagrams tractable. Dark mode diagrams made the progress bar's color-scheme-awareness trivial - the CSS variables were already there.

For a stretch in the middle - following my own gem's misdiagnosis, a CSS specificity lesson learned the hard way, a feature rework mid-build - it felt like a rabbit hole. The kind where you look up and realize you're three layers removed from what you sat down to do.

The difference between a rabbit hole and a mine shaft is whether you're digging toward something. I didn't know I was building toward a progress bar when I started fixing edge labels. But each fix was structural: improving the foundation rather than patching the symptom. The padding fix existed so the overflow protection could generalize it. The overflow protection existed so the config surface could unify it. The config surface existed so dark mode diagrams could extend it. None of that was planned. It happened because properly-done infrastructure compounds whether you intend it to or not.

The tell is whether you can use what you built. Yak shaving leaves you holding a razor and a bald yak. A productive cascade leaves you standing on new ground.
