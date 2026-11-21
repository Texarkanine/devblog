"""inline_once_anchors: once-used references become inline links."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from tools.inline_once_anchors import inline_once


class InlineOnceTests(unittest.TestCase):
    def test_keeps_inline_code_inside_the_link_text(self):
        """A once-used reference whose text contains inline code keeps that text."""
        source = "OpenBSD's [`sys.mk`][sysmk] carries\n\n[sysmk]: https://example.test/sys.mk\n"
        updated, _report = inline_once(source)
        self.assertEqual(
            updated,
            "OpenBSD's [`sys.mk`](https://example.test/sys.mk) carries\n\n",
        )

    def test_inlines_a_label_used_once_and_drops_its_definition(self):
        source = "See [the note][note].\n\n[note]: https://example.test/note\n"
        updated, _report = inline_once(source)
        self.assertEqual(updated, "See [the note](https://example.test/note).\n\n")

    def test_leaves_a_label_used_twice(self):
        source = "See [a][note] and [b][note].\n\n[note]: https://example.test/note\n"
        updated, _report = inline_once(source)
        self.assertEqual(updated, source)

    def test_leaves_footnotes(self):
        source = "A claim.[^cite]\n\n[^cite]: https://example.test/cite\n"
        updated, _report = inline_once(source)
        self.assertEqual(updated, source)


if __name__ == "__main__":
    unittest.main()
