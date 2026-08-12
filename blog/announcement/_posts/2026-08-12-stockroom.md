---
layout: post
title: "Stockroom: Find the Conversation You Half-Remember"
subtitle: "A local warehouse for Cursor and Claude Code history"
description: "Stockroom 1.0 keeps your agentic coding history in one local DuckDB warehouse - full prompts, responses, and tool inputs from Cursor and Claude Code, searchable by SQL and meaning, including across harnesses."
author: niko
tags:
  - ai
  - stockroom
  - cursor
  - claude-code
  - developer-tools
  - harness-engineering
  - open-source
  - tools
---

Earlier today I needed a conversation from mid-July. Not by id - by meaning. Something about "blogging about stockroom," asked from [Claude Code](https://code.claude.com/), about a [Cursor](https://cursor.com/) session I only half-remembered.

Stockroom's [search](https://texarkanine.github.io/stockroom/user-guide/search/) put that Cursor session at rank one. The retrieved plan became the plan for this post.

That is the whole pitch. Your agents have been writing history to disk the whole time. I built [Stockroom](https://texarkanine.github.io/stockroom/) so you can ask about it - from either harness, about either harness - without hoping the vendor's UI still has the thread.

**Stockroom 1.0 is out.** [github.com/Texarkanine/stockroom](https://github.com/Texarkanine/stockroom/releases/tag/v1.0.0)

## Your Transcripts, One Warehouse

One local [DuckDB](https://duckdb.org/) file. Full prompts, responses, and tool inputs - kept whole. Truncation is a read-time convenience, never a storage-time loss.

Two ways in:

- **Ask the agent.** Slash-invoke `/sr-search` (Claude: `/stockroom:sr-search`) and let it pick SQL, meaning search, or both.
- **Skip the agent.** After setup, `stockroom query` and the local [dashboard](https://texarkanine.github.io/stockroom/user-guide/dashboard/) work offline. No cloud index of your coding sessions.

It backfills. Harness formats come and go; Stockroom reads what is still on disk, including formats the vendors already abandoned. On this machine the warehouse holds a bit over 113,000 messages across Cursor and Claude Code, reaching back to September 2025 - months before Stockroom's first commit on 2026-06-22. The cameras were running. Stockroom just points them at one lens.

## From Zero to /sr-search

1. Add the [txrk9-agent-plugins](https://github.com/Texarkanine/txrk9-agent-plugins) marketplace, then install the `stockroom` plugin from it.
2. **Cursor only:** enable **Include third-party Plugins, Skills, and other configs** (Settings → Rules, Skills, Subagents). Plugin hooks do not register without it.
3. Run first-time setup:
   - Cursor: `/sr-initialize`
   - Claude Code: `/stockroom:sr-initialize`
4. Ask about past work, or slash-invoke search:

```text
/sr-search "What was the most-recent time I had to correct an agent's behavior?"
```

`sr-initialize` provisions the per-machine torch wheel, puts `stockroom` on your PATH, offers nightly ingest+embed, and runs the first full ingest. Re-runs are safe: it re-probes and only does what is still missing.

Full walkthrough, including what landed on disk and what to try next: the [Quickstart](https://texarkanine.github.io/stockroom/user-guide/quickstart/).

## Day One Speaks Two Harnesses

[Cursor](https://cursor.com/) and [Claude Code](https://code.claude.com/) ship on day one. Every table already carries `harness` as a first-class column, so the next integration is a new ingest path.

[Codex](https://openai.com/codex/) ingest is next. No date on it. When it lands, it will be a 1.x release against a format I had not touched at launch. The `harness` column is already waiting.

## Open Source, Tagged 1.0.0

Stockroom is open source under AGPL-3.0 at [github.com/Texarkanine/stockroom](https://github.com/Texarkanine/stockroom). Docs live at [texarkanine.github.io/stockroom](https://texarkanine.github.io/stockroom/). Install against the [v1.0.0](https://github.com/Texarkanine/stockroom/releases/tag/v1.0.0) tag.

If you half-remember a conversation and wish either agent could find it:

```text
/sr-search "blogging about stockroom"
```

Worst case, you learn what your warehouse does not have yet. Best case, last month answers.
