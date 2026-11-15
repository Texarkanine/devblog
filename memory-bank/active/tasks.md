# Current Task: Strip list-indent tab from blank lines

**Complexity:** Level 1

## Fix

A tab-only continuation missed `ContentLine`, which requires a non-whitespace character. kramdown appended that raw tab as a blank line, so a tab-indented fence kept the tab in the code.

`StringScanner#scan` now removes one leading tab from each line of a `BLANK_LINE` match. The match stays a blank line, so a following column-0 paragraph still ends the item. A further tab on that line stays in the code.

Files: `_plugins/lexical_list_tabs.rb`, `_plugins/README.md`, `tests/test_lexical_list_tabs.py`.
