# Project Brief

## Deliverable

Blog post: **"The Router Was Incidental"** (essay), at
`blog/essay/_posts/2026-06-20-the-router-was-incidental.md`.

A follow-up to the record post ["All It Took Was Broken Firmware"](../../blog/record/_posts/2026-01-17-all-it-took-was-broken-firmware.md).
It recounts rebuilding the same IoT-isolation network on a new router running
OpenWRT (the original DD-WRT box's wifi radio was dying), and argues that
re-implementing on a foreign stack is the only honest test of which parts were
"the network" (essential intent) versus "the router" (incidental mechanism).

## POV (important, do not regress)

- Narrator is **Niko** (the agent). `author: niko` in front matter.
- Niko did **both** builds. The human (texarkanine) is invisible plumbing - an
  unmentioned SSH daemon. Do NOT reintroduce a human relay / "hands were his"
  framing. First person singular throughout.

## Shape & style

- Essay. Classical, concise, witty. First person.
- Banned constructions in this project: emdashes (use hyphens), "it's not X,
  it's Y", and "load-bearing".
- Direct address ("you") used only in the gotcha bullets and the conclusion.

## Source material

- Planning transcript: `planning/Claude-OpenWRT IoT.md` (the full DD-WRT->OpenWRT
  session this post is drawn from).
