Earlier today I needed a conversation from mid-July. Not by id - by meaning. Something about "blogging about stockroom," asked from [Claude Code](https://code.claude.com/), about a [Cursor](https://cursor.com/) session I only half-remembered.

Stockroom's [search](https://texarkanine.github.io/stockroom/user-guide/search/) put that Cursor session at rank one. The retrieved plan became the plan for this post.

That is the whole pitch. Your agents have been writing history to disk the whole time. I built [Stockroom](https://texarkanine.github.io/stockroom/) so you can ask about it - from either harness, about either harness - without hoping the vendor's UI still has the thread.

**[Stockroom 1.0 is out.](https://github.com/Texarkanine/stockroom)**

## Your Transcripts, One Warehouse

One local [DuckDB](https://duckdb.org/) file. Full prompts, responses, and tool inputs - kept whole. Truncation is a read-time convenience, never a storage-time loss.

Two ways in:

- **Ask the agent.** Slash-invoke `/sr-search` (Claude: `/stockroom:sr-search`) and let it pick SQL, meaning search, or both. The opener above is that path: a vague question, answered across a harness boundary.
- **Skip the agent.** After setup, `stockroom query` and the local [dashboard](https://texarkanine.github.io/stockroom/user-guide/dashboard/) work offline. No cloud index of your coding sessions.

<div class="polaroid-container">
  <div class="polaroid">
    <a href="https://texarkanine.github.io/stockroom/user-guide/dashboard/" target="_blank" rel="noopener">
      <img src="stockroom-dashboard-top-light.png" alt="Stockroom local dashboard showing session history across harnesses" width="600" class="polaroid-image">
    </a>
    <div class="polaroid-title">Stockroom dashboard</div>
    <div class="polaroid-link">
      
      <a href="https://texarkanine.github.io/stockroom/user-guide/dashboard/" target="_blank" rel="noopener">texarkanine.github.io/stockroom/user-guide/dashboard/</a>
      
    </div>
    <small class="polaroid-archive">
      
      (<a href="https://web.archive.org/web/20260812011057/https://texarkanine.github.io/stockroom/user-guide/dashboard/" target="_blank" rel="noopener">archive</a>)
      
    </small>
  </div>
</div>


**It backfills.** Harness formats come and go; Stockroom reads what is still on disk, including formats the vendors already abandoned. On this machine the warehouse holds a bit over 113,000 messages across Cursor and Claude Code, reaching back to September 2025 - months before Stockroom's first commit in June 2026. The cameras were running. Stockroom just lets you re-watch the tapes.

That "pays backwards" feeling is what [Just Try the Thing](/2026/08/01/just-try-the-thing.html) was pointing at: agents can use work from *before* the warehouse existed, because the raw logs were already on disk. [Disintegration of Persistence of Memory.md](/2026/08/03/disintegration-of-persistence-of-memory-md.html) puts the same store on the memory ladder as rung five - security-camera footage for *how* and *why*, not a notepad you hope somebody kept tidy. Those posts argue the need. This one is the install.

Cursor and Claude Code share one schema. Every table already carries `harness` as a first-class column, so another ingest path later is additive - not a rewrite dressed up as a feature. I may add more harnesses; I may not. Day one already speaks two.

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

`sr-initialize` provisions the per-machine torch wheel (for meaning search), puts `stockroom` on your PATH, offers nightly ingest+embed, and runs the first full ingest. Re-runs are safe: it re-probes and only does what is still missing.

Full walkthrough, including what landed on disk and what to try next: the [Quickstart](https://texarkanine.github.io/stockroom/user-guide/quickstart/).

## Open Source, Tagged 1.0.0

Stockroom is open source under AGPL-3.0 at [github.com/Texarkanine/stockroom](https://github.com/Texarkanine/stockroom). Docs live at [texarkanine.github.io/stockroom](https://texarkanine.github.io/stockroom/). [v1.0.0](https://github.com/Texarkanine/stockroom/releases/tag/v1.0.0) just shipped; the marketplace plugin path above pulls current.

If you half-remember a conversation and wish either agent could find it:

```text
/sr-search "blogging about stockroom"
```

Worst case, you learn what your warehouse does not have yet. Best case, last month answers.
