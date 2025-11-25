---
layout: post
title: "I Can't ai-rizz on Command"
author: texarkanine
tags: [cursor, ai, claude-code]
---

Cursor introduced "[Slash Commands](https://cursor.com/docs/agent/chat/commands)" fairly recently, in v1.6 in September 2025. Claude Code had had a similar thing - [Agent Skills](https://code.claude.com/docs/en/skills) - for a long time.

I recently saw Cursor add "Team Commands" for enterprise accounts and got excited to finally leverage the power of Claude's Agent Skills, but in Cursor for my team.

I blew the rest of my prepaid Cursor usage on trying to add Cursor Command support to [ai-rizz](https://github.com/texarkanine/ai-rizz), but hit two snags:

## Commands Just Ain't Rules

### Directory Structure is Part of the Command

A Cursor Command located in `./cursor/commands/foo.md` can be triggered by typing `/foo`.

A Cursor Command located in `./cursor/commands/foo/bar.md` can be triggered by typing `/foo/bar`

This meant that the pattern `ai-rizz` used to ensure its managed rules stayed separate from other rules, of "claiming" two subdirectories of the `.cursor/rules` directory for itself:

```
.cursor/rules
├── local
│   └── my-local-rule.mdc
└── shared
    └── my-shared-rule.mdc
```

wouldn't work. The commands became unnecessarily prefixed with junk.

So, they really needed to go in `.cursor/commands/*.md` directly.

I came up with an idea, though: We'd store them in `.cursor/shared-commands`, and symlink them into `.cursor/commands`. This allowed prefix-less use of the commands but also kept the managed commands easily-identifiable - all symlinks in `.cursor/commands` to `.cursor/shared-commands/*.md` were managed, and all other commands weren't.

### Tracking

Clever design in `ai-rizz` makes keeping track of rules' provenance easy: simply knowing a rule's path on disk is enough to know if it should be in source control, whether it should be ignored, or whether it's a "user" rule not managed by `ai-rizz`.

This is only manageable because the `.cursor/rules/local` directory is ignored by git with a single `.git/info/exclude` entry - one configuration line and you can put *all* rules you need in `local` and they're all untracked. You put all the tracked ones in `shared`, and any other directory tree is user rules.

What if we tried to find that semantic for symlinks in `.cursor/commands/`, though?

* `.cursor/commands/local-cmd.md.lnk` -> should not be committed
* `.cursor/commands/committed-cmd.md.lnk` -> should be committed
* `.cursor/commands/actual-cmd.md` -> user command, should not be touched

Now we have to read & write exhaustive git ignore specs that identify every local command. Moreover, with rules, simply knowing a rule's path on disk was enough to know if it was a local, committed, or user rule. With commands all in one directory, you have to read the `ai-rizz` manifest each time to figure out the semantic for a given command. That's a lot of bookkeeping and opportunity to go wrong.

I came up with a solution I thought could work: Declare that commands are commit-only in a repo. Tell the user to go set up `ai-rizz` in their user directory and have it manage `~/.cursor/commands` (this works) for commands that will live on their machine and not in the repo. Yes, the commands *would* become available to all repos, but that is primarily what I find myself doing with local *rules*, anyway - I pull the same set of customizations into every repo I work with, in "local" mode. If they could be "global" to my local machine, that would be handy!

### Promotion

`ai-rizz` can store *rules* with or without git tracking in a repository. You can try them out locally, and the ones that work really well with the repository get **promoted** to being committed to source control.

What does "promotion" look like for Commands?

First of all, the promotion semantic is inverted for commands: A command might be committed to one repo at first, and then you might really find it useful and want to promote it to **all** repos. So it goes from "commit" to "local" (which is really "global," as we'll see...)

With that semantic and my ideas for command management so far, the existing code would do a very wrong thing: Promoting a command would pull it **out** of a repository and into the user's home directory. That's only correct if development is entirely by one user on one machine. Otherwise, when the user promotes their command they'll commit and push the repo without the command in it and now their colleagues will lose access to that command! That's the *opposite* of what `ai-rizz` is supposed to facilitate!

So, flip the semantic, right? Commands *start* in `~/.cursor/commands`, and you commit them to a repo **iff you like them!** Done that way, a command starts out available in *every* repository, not the one you're working with at the moment. Weird but probably harmless.

But then when you like the command and "promote" it to be committed to the repo so that everyone who works with the repo gets it, it gets pulled out of your user home and now the rest of *your* repositories lose access to it!

**There's just no sensible promotion semantic for Commands:** You have to allow duplication, where promotion *copies* it to `~/.cursor/commands` but also keeps it in each repo it was added to.

And that meant that

1. I wouldn't be able to re-use much of `ai-rizz`'s rules codebase for commands
2. Users of `ai-rizz` would have to maintain two very different mental models

## What Are They For, Anyway?

While I was stewing over how to possibly make this work, I had an epiphany: **I don't have a use-case for Cursor Commands, anway!**
You can go read about why, [here]({% post_url blog/essay/2025-11-24-usent-case-for-ai-coding-agent-slash-commands %}).