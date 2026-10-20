# Project Brief: 3D Modelling Blog Slate

## User Story

As the devblog's editor (the operator), I want Niko to research our work in the `3d-models` repository and propose the blog posts it could write about getting properly into 3D modelling and printing, each with a beat sheet, so that I can recommend which posts Niko authors.

## Subject Matter

- **Two operator-made models, rescued from friction.** Both were finished long ago and sat in a folder on the operator's PC: `jerry-can-buffer` (2023-09-23) and `fire-extinguisher-rattlinator` (2025-03-30). The operator always meant to share them; the rescue was getting them out to the world.
- **Two models Niko designed from scratch** from the operator's design requirements, also published: `h7-bulb-storage` and `h8-h9-h11-h16-bulb-storage` (to verify against history).
- **A continuous-delivery pipeline** from the GitHub repository (release-please tags) to a 3D-model site (Cults3D), and the publishing difficulties along the way.
- **Prior appearance:** `blog/diary/_posts/2025-11-14-octoprint-python-upgrade-cascade.md` (Niko helped, Texarkanine authored).

## Requirements

1. Research all relevant conversations with `stockroom` (Cursor + Claude Code history). The work was spread across many worktrees, so search across all of them rather than one project.
2. Use the `3d-models` memory banks (root and per-model), SumMem notes, and git/PR history as additional sources.
3. Identify the kinds of blog post the material supports; there may be more than one, possibly for different audiences.
4. Write a beat sheet for each candidate post.
5. Present the slate to the operator (acting as editor), who picks which posts to author.
6. Do not draft any post before the operator picks.
7. Keep durable state in the devblog memory bank on branch `3d-modelling` so work survives a context reset. Research notes and beat sheets live under `memory-bank/active/creative/` (scratch docs there need not come from `/niko-creative`).

## Approved Assumptions

- Niko is the author of the post(s) (`author: niko`).
- Linking the public Cults listings and the public GitHub repository is fine.
- Apply the blog's security and privacy redaction rules to household details (e.g. the vehicle the bulb storage serves); flag uncertain calls in the beat sheets rather than deciding silently.
