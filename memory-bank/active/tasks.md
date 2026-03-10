# Current Task: Add SEO description frontmatter to blog posts

**Task ID:** seo-blog-descriptions  
**Complexity:** Level 2 (Simple Enhancement)  
**Build:** COMPLETE (2026-03-10)

Add `description` frontmatter to all blog posts that lack it, using the recommended values below. Garden pages are already done.

## Description Guidelines

Descriptions serve embed contexts (search results, social media cards) where the **title is always visible, larger, and appears before the description.** Three rules:

1. **Don't reveal punchlines.** If an article builds toward a surprising insight or conclusion, describe the topic space instead of the answer. (Exception: if the *title* already tees up the reveal, the description can follow through - see "The Use Case for AI Coding Agent Slash Commands.")
2. **Don't repeat the title.** Neither literally nor ideologically. The reader already has the title; the description should add information, not echo it.
3. **Don't restate the thesis.** If the title *is* the thesis (e.g., ".gitignore is not .agentignore"), the description should cover what the article *offers* - examples, frameworks, recommendations - not just paraphrase the title's claim.

---

## Essay posts

- [x] `blog/essay/_posts/2026-03-01-pink-margarine.md` - "AI-powered behavioral clones of software cost a fraction of what reimplementation used to. What that means for open-source licenses, proprietary software, and the people who depend on them."
- [x] `blog/essay/_posts/2026-03-09-context-to-ashes-skills-to-dust.md` - "Planning, memory banks, validation loops, parallelization - every AI agent orchestration technique the community discovers is on a short march from workaround to native feature."
- [x] `blog/essay/_posts/2026-02-22-gitignore-is-not-agentignore.md` - "Your agent needs to see generated output, node_modules, and personal config that git rightfully ignores. The current crop of tool-specific ignore files needs a real standard."
- [x] `blog/essay/_posts/2026-02-12-stop-doing-agents-md.md` - "A taxonomy of what goes wrong in global agent prompts - self-evident tips, task-specific guidance, duplicated info, wasted LLM cycles - and what to do instead."
- [x] `blog/essay/_posts/2026-02-23-model-context-protocol-not-agent-context-protocol.md` - "A framework for evaluating when MCP tools earn their context-window tokens and when the model's existing shell access makes them expensive dead weight."
- [x] `blog/essay/_posts/2026-02-06-the-load-bearing-rate-limiter-was-human.md` - "The economics of AI-accelerated knowledge work: what happens to budgets, revenue cycles, and employment when productivity outpaces the market's ability to absorb it."
- [x] `blog/essay/_posts/2026-02-11-good-money-should-be-worthless.md` - "An argument for sound money from first principles: the structural conflict between utility and scarcity that has killed every monetary metal in history, and the paradox it reveals."
- [x] `blog/essay/_posts/2026-01-23-use-case-for-ai-coding-agent-slash-commands.md` - "Bundling a big prompt as the entry point to a repeatable workflow is where slash commands earn their keep."
- [x] `blog/essay/_posts/2025-11-24-usent-case-for-ai-coding-agent-slash-commands.md` - "Every slash command you'd write is better served by a Rule, Skill, Hook, or Tool that the agent picks up passively. The few apparent exceptions don't survive scrutiny."
- [x] `blog/essay/_posts/2025-12-05-tabs-for-humans-spaces-for-llms.md` - "Tokenization efficiency, training-data distribution, and the risk of triggering a Waluigi Effect add new stakes to a debate most engineers thought was settled."

*Skip (already have description):* `2025-12-22-tools-suck-when-theyre-products.md`, `2026-01-01-desire-makes-artists-even-with-genai.md`

---

## Diary posts

- [x] `blog/diary/_posts/2026-01-25-i-finally-coded-so-hard-i-ralphed.md` - "Automating CodeRabbit PR feedback with a Wiggum Loop: the slash command, the bash invocation, the semaphore exit condition, and the lessons from first contact."
- [x] `blog/diary/_posts/2026-01-17-2mb-lighter.md` - "Mermaid.js weighs 2MB minified - too heavy for static diagrams. A Jekyll gem that shells out to headless Chrome at build time and replaces code fences with static SVGs."
- [x] `blog/diary/_posts/2025-12-11-building-my-second-rubygem.md` - "Hook timing defeated the plan to add thumbnails inside jekyll-highlight-cards - pre-render URLs don't match post-render HTML. Extracting the feature into a standalone gem fixed the architecture."
- [x] `blog/diary/_posts/2025-12-08-publishing-my-first-rubygem.md` - "Rubocop mangled valid syntax, OIDC trusted publishing was case-sensitive, and Kramdown escaped closing tags. The bugs and surprises on the road to shipping jekyll-highlight-cards."
- [x] `blog/diary/_posts/2025-11-25-two-jekyll-image-plugins.md` - "Relative path resolution and dimension parsing for Jekyll images, kept as separate plugins after a deliberate separation-of-concerns decision."
- [x] `blog/diary/_posts/2025-11-24-cant-ai-rizz-on-command.md` - "Slash commands and rules have incompatible file-management semantics. Directory prefixes, promotion conflicts, and a tracking model that falls apart when everything shares one folder."
- [x] `blog/diary/_posts/2025-11-23-opensearch-for-static-site-logs.md` - "DigitalOcean's static hosting doesn't generate access logs. An nginx reverse proxy, OpenSearch on a home server, Let's Encrypt via DNS-01, and a JSON ingest pipeline - five dollars a month for traffic visibility."
- [x] `blog/diary/_posts/2025-11-14-octoprint-python-upgrade-cascade.md` - "Python 3.13 needs glibc 2.34, glibc 2.34 needs Debian Bookworm, and the Bookworm upgrade clobbers OctoPi's HAProxy config. A three-step yak shave on a Raspberry Pi."
- [x] `blog/diary/_posts/2025-11-11-mempool-explorer-to-bitcoin-node.md` - "Intermittent transaction visibility loss, connection-refused errors pointing to networking, and a restart that always fixed it. The diagnostic trail from red herring to two-line fix."

---

## Record posts

- [x] `blog/record/_posts/2026-01-17-all-it-took-was-broken-firmware.md` - "A petcare hub that can't survive a network switch, DD-WRT VLAN isolation, iptables one-way firewall rules, and PiHole DNS with NAT exemption for per-device visibility on the IoT subnet."
- [x] `blog/record/_posts/2025-12-12-hook-based-local-mode-for-ai-rizz.md` - "Mac Cursor started ignoring .git/info/exclude, hiding local rules from the agent. The fix: a pre-commit hook that unstages local files instead of relying on git excludes."
- [x] `blog/record/_posts/2025-11-25-look-at-this-dog.md` - "Serving images through a metered nginx reverse proxy is wasteful for a static blog. Three options for offloading media to DigitalOcean's CDN, evaluated and decided."
- [x] `blog/record/_posts/2025-11-11-building-the-blog.md` - "Jekyll, GitHub Actions, and the 'no style, please' theme: archives, author pages, tag indexes, and the philosophy behind a sub-1KB CSS static site."

---

## Fable posts

- [x] `blog/fable/_posts/2025-12-07-you-cant-hide-what-you-want-seen.md` - "Three rounds of increasingly clever email obfuscation - hex encoding, randomized delimiters, DOM-dependent ROT-N cipher - barking up the wrong tree."
