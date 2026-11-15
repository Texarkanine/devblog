# Project Brief

## User Story

As an author of this blog, I want a tab that only indents a blank line inside a list item to be removed, so that a blank line inside a tab-indented code fence renders empty.

## Use-Case(s)

### Blank line inside a tab-indented fence

A list item contains a tab-indented makefile fence. The line between `recipe` and `other:` is one tab and nothing else. The rendered code is:

```
build:
	recipe

other:
	recipe2
```

The line between `recipe` and `other:` is empty.

## Requirements

1. A continuation line that is only the list-indent tab contributes an empty line to the list item's content.
2. In the sample from `blog/record/_posts/2026-10-20-do-i-need-to-reprint.md`, the code block text is `build:\n\trecipe\n\nother:\n\trecipe2\n`.

## Constraints

1. The change stays in the list-tab plugin.
2. Lines that begin with spaces stay on stock kramdown.

## Acceptance Criteria

1. The sample source renders a code block whose text is `build:\n\trecipe\n\nother:\n\trecipe2\n`.
2. The existing list-tab tests still pass.
