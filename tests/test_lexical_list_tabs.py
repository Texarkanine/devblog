"""Tab-indented list content keeps the tabs that belong to its code."""

import json
import os
import subprocess
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
PLUGIN = REPO / "_plugins" / "lexical_list_tabs.rb"

# Reads Markdown on stdin, parses it the way Jekyll does (kramdown, GFM input)
# with the plugin loaded, and prints the HTML and the text of every code block.
DRIVER = """
require "json"
require "kramdown"
require "kramdown-parser-gfm"
require ARGV[0]

def codeblocks(el, acc = [])
  acc << el.value if el.type == :codeblock
  el.children.each { |child| codeblocks(child, acc) }
  acc
end

doc = Kramdown::Document.new($stdin.read, input: ARGV[1])
puts JSON.generate("html" => doc.to_html, "code" => codeblocks(doc.root))
"""


class LexicalListTabsTests(unittest.TestCase):
    """One leading tab is one list level. Tabs after it reach the content."""

    def test_dash_item_tab_fence_keeps_code_tab(self):
        """Under "- ", a tab-indented fence gives flush code with its own tab."""
        source = "- item\n\n\t```makefile\n\ttarget:\n\t\trecipe\n\t```\n"
        self.assertEqual(["target:\n\trecipe\n"], self._code(source))

    def test_numbered_item_tab_fence_keeps_code_tab(self):
        """Under "1. ", whose text starts at column 3, the result is the same."""
        source = "1. item\n\n\t```makefile\n\ttarget:\n\t\trecipe\n\t```\n"
        self.assertEqual(["target:\n\trecipe\n"], self._code(source))

    def test_blank_line_inside_tab_fence_survives(self):
        """An empty line inside the fence stays inside the code block."""
        source = "- item\n\n\t```\n\ta:\n\n\tb:\n\t\tc\n\t```\n"
        self.assertEqual(["a:\n\nb:\n\tc\n"], self._code(source))

    def test_indented_code_block_keeps_code_tab(self):
        """Tab for the list, tab for the code block, and the third tab is code."""
        source = "- item\n\n\t\ttarget:\n\t\t\trecipe\n"
        self.assertEqual(["target:\n\trecipe\n"], self._code(source))

    def test_nested_tab_lists_keep_code_tab(self):
        """Each list level removes one tab, so a fence two levels deep is flush."""
        source = (
            "- outer\n"
            "\t- inner\n"
            "\n"
            "\t\t```makefile\n"
            "\t\ttarget:\n"
            "\t\t\trecipe\n"
            "\t\t```\n"
        )
        result = self._run(source)
        self.assertEqual(["target:\n\trecipe\n"], result["code"])
        self.assertEqual(2, result["html"].count("<ul>"))

    def test_wide_marker_takes_one_tab(self):
        """A marker whose text starts past column 4 still takes one tab per level."""
        source = "100. item\n\n\t```\n\ttarget:\n\t\trecipe\n\t```\n"
        result = self._run(source)
        self.assertEqual(["target:\n\trecipe\n"], result["code"])
        self.assertEqual(1, result["html"].count("<li>"))

    def test_definition_list_tab_fence_keeps_code_tab(self):
        """A definition body follows the same rule as a list item."""
        source = "term\n: definition\n\n\t```\n\ttarget:\n\t\trecipe\n\t```\n"
        self.assertEqual(["target:\n\trecipe\n"], self._code(source))

    def test_native_kramdown_fence_is_recognized(self):
        """The kramdown parser, which takes no indented fence, sees a flush one."""
        source = "- item\n\n\t~~~\n\ttarget:\n\t\trecipe\n\t~~~\n"
        self.assertEqual(["target:\n\trecipe\n"], self._code(source, parser="kramdown"))

    def test_tab_paragraph_and_tab_nested_list_keep_structure(self):
        """Plain tab-indented prose and sub-lists render as before."""
        source = "- item\n\n\tsecond paragraph\n\n\t- nested\n- next\n"
        html = self._run(source)["html"]
        self.assertIn("<p>second paragraph</p>", html)
        self.assertEqual(2, html.count("<ul>"))
        self.assertEqual(3, html.count("<li>"))
        self.assertNotIn("<pre>", html)

    def test_space_indented_fence_is_unchanged(self):
        """The two-space form that worked before the plugin still works."""
        source = "- item\n\n  ```makefile\n  target:\n  \trecipe\n  ```\n"
        self.assertEqual(["target:\n\trecipe\n"], self._code(source))

    def test_space_indented_code_block_is_unchanged(self):
        """Six spaces under "- " is still two for the list and four for code."""
        source = "- item\n\n      code\n        deeper\n"
        self.assertEqual(["code\n  deeper\n"], self._code(source))

    def test_top_level_code_is_unchanged(self):
        """Code outside a list never passed through the list parser."""
        source = "para\n\n\ttarget:\n\t\trecipe\n"
        self.assertEqual(["target:\n\trecipe\n"], self._code(source))

    def _code(self, source, parser="GFM"):
        return self._run(source, parser)["code"]

    def _run(self, source, parser="GFM"):
        env = os.environ.copy()
        env["BUNDLE_GEMFILE"] = str(REPO / "Gemfile")
        result = subprocess.run(
            ["bundle", "exec", "ruby", "-e", DRIVER, str(PLUGIN), parser],
            cwd=REPO,
            env=env,
            input=source,
            capture_output=True,
            text=True,
            check=False,
        )
        if result.returncode != 0:
            self.fail(result.stdout + "\n" + result.stderr)
        return json.loads(result.stdout)
