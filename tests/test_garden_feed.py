"""Garden pages in the posts Atom feed."""

import os
import shutil
import subprocess
import tempfile
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
ATOM = "{http://www.w3.org/2005/Atom}"


class GardenFeedTests(unittest.TestCase):
    """A throwaway site, one plugin file, and the Atom links Jekyll writes."""

    def setUp(self):
        self.work = Path(tempfile.mkdtemp())
        self.source = self.work / "src"
        self.dest = self.work / "dest"
        self.source.mkdir()
        self.addCleanup(lambda: shutil.rmtree(self.work, ignore_errors=True))

    def test_dated_garden_page_joins_posts_in_date_order(self):
        """A garden page dated between two posts is ordered with them by date."""
        self._write_config()
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_post("2026-01-02-beta.md", "Beta")
        self._write_garden("gamma.md", "Gamma", "2026-01-03")
        self._build()
        self.assertEqual(
            [
                "http://example.test/garden/gamma.html",
                "http://example.test/2026/01/02/beta.html",
                "http://example.test/2026/01/01/alpha.html",
            ],
            self._links(),
        )

    def test_posts_limit_keeps_the_newer_document(self):
        """posts_limit 1 keeps whichever of the post and the garden page is newer."""
        self._write_config(posts_limit=1)
        self._write_post("2026-02-01-alpha.md", "Alpha")
        self._write_garden("gamma.md", "Gamma", "2026-01-01")
        self._build()
        self.assertEqual(["http://example.test/2026/02/01/alpha.html"], self._links())

        shutil.rmtree(self.dest, ignore_errors=True)
        garden = self.source / "_garden" / "gamma.md"
        garden.write_text(self._doc("Gamma", "2026-03-01", "Note."))
        self._build()
        self.assertEqual(["http://example.test/garden/gamma.html"], self._links())

    def test_garden_page_alone_is_the_feed(self):
        """A site with only a garden page still publishes that page in the feed."""
        self._write_config()
        self._write_garden("gamma.md", "Gamma", "2026-01-03")
        self._build()
        self.assertEqual(["http://example.test/garden/gamma.html"], self._links())

    def test_draft_garden_page_stays_out(self):
        """A garden page marked draft is omitted after it is concatenated."""
        self._write_config()
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_garden("gamma.md", "Gamma", "2026-03-01", extra="draft: true\n")
        self._build()
        self.assertEqual(["http://example.test/2026/01/01/alpha.html"], self._links())

    def test_unpublished_garden_page_stays_out(self):
        """A garden page with published false is absent from the feed."""
        self._write_config()
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_garden("gamma.md", "Gamma", "2026-03-01", extra="published: false\n")
        self._build()
        self.assertEqual(["http://example.test/2026/01/01/alpha.html"], self._links())

    def test_empty_garden_collection_keeps_the_post(self):
        """An empty garden collection still builds a feed of posts."""
        self._write_config()
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._build()
        self.assertEqual(["http://example.test/2026/01/01/alpha.html"], self._links())

    def test_missing_garden_collection_keeps_the_post(self):
        """A site with no garden collection still builds the posts feed."""
        self._write_config(garden=False)
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._build()
        self.assertEqual(["http://example.test/2026/01/01/alpha.html"], self._links())

    def test_dated_writing_piece_joins_posts_in_date_order(self):
        """A writing piece dated between two posts is ordered with them by date."""
        self._write_config(writing=True)
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_post("2026-01-03-beta.md", "Beta")
        self._write_writing("poetry", "2026-01-02-gamma.md", "Gamma")
        self._build()
        self.assertEqual(
            [
                "http://example.test/2026/01/03/beta.html",
                "http://example.test/writing/poetry/gamma.html",
                "http://example.test/2026/01/01/alpha.html",
            ],
            self._links(),
        )

    def test_posts_limit_keeps_the_newer_post_or_writing_piece(self):
        """posts_limit 1 keeps whichever of the post and the writing piece is newer."""
        self._write_config(writing=True, posts_limit=1)
        self._write_post("2026-02-01-alpha.md", "Alpha")
        self._write_writing("poetry", "2026-01-01-gamma.md", "Gamma")
        self._build()
        self.assertEqual(["http://example.test/2026/02/01/alpha.html"], self._links())

        shutil.rmtree(self.dest, ignore_errors=True)
        (self.source / "_writing" / "poetry" / "2026-01-01-gamma.md").unlink()
        self._write_writing("poetry", "2026-03-01-gamma.md", "Gamma")
        self._build()
        self.assertEqual(
            ["http://example.test/writing/poetry/gamma.html"],
            self._links(),
        )

    def test_writing_piece_joins_the_feed_without_a_garden(self):
        """A writing piece still joins the posts feed when the garden collection is absent."""
        self._write_config(garden=False, writing=True)
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_writing("poetry", "2026-01-02-gamma.md", "Gamma")
        self._build()
        self.assertEqual(
            [
                "http://example.test/writing/poetry/gamma.html",
                "http://example.test/2026/01/01/alpha.html",
            ],
            self._links(),
        )

    def test_draft_writing_piece_stays_out(self):
        """A writing piece marked draft is omitted after it is concatenated."""
        self._write_config(writing=True)
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_writing(
            "poetry", "2026-03-01-gamma.md", "Gamma", extra="draft: true\n"
        )
        self._build()
        self.assertEqual(["http://example.test/2026/01/01/alpha.html"], self._links())

    def test_unpublished_writing_piece_stays_out(self):
        """A writing piece with published false is absent from the feed."""
        self._write_config(writing=True)
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_writing(
            "poetry", "2026-03-01-gamma.md", "Gamma", extra="published: false\n"
        )
        self._build()
        self.assertEqual(["http://example.test/2026/01/01/alpha.html"], self._links())

    def test_future_published_writing_piece_stays_out_of_the_feed(self):
        """A future writing piece with published true stays out of the posts feed. A past piece stays."""
        self._write_config(writing=True)
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_writing("poetry", "2026-01-02-gamma.md", "Gamma")
        self._write_writing(
            "poetry",
            "2999-01-01-later.md",
            "Later",
            extra="published: true\n",
        )
        self._build()
        self.assertEqual(
            [
                "http://example.test/writing/poetry/gamma.html",
                "http://example.test/2026/01/01/alpha.html",
            ],
            self._links(),
        )

    def test_garden_collection_feed_stays_garden_only(self):
        """The posts feed gains garden pages. A garden collection feed does not gain posts."""
        self._write_config(garden_feed=True)
        self._write_post("2026-01-01-alpha.md", "Alpha")
        self._write_garden("gamma.md", "Gamma", "2026-01-02")
        self._build()
        self.assertEqual(
            [
                "http://example.test/garden/gamma.html",
                "http://example.test/2026/01/01/alpha.html",
            ],
            self._links("feed.xml"),
        )
        self.assertEqual(
            ["http://example.test/garden/gamma.html"],
            self._links("feed/garden.xml"),
        )

    def _write_config(self, garden=True, posts_limit=None, garden_feed=False, writing=False):
        lines = [
            "title: Fixture",
            "url: http://example.test",
            "permalink: /:year/:month/:day/:title:output_ext",
            "plugins:",
            "  - jekyll-feed",
        ]
        collections = []
        if garden:
            collections.extend(
                [
                    "  garden:",
                    "    output: true",
                    "    permalink: /garden/:name:output_ext",
                ]
            )
        if writing:
            collections.extend(
                [
                    "  writing:",
                    "    output: true",
                    "    permalink: /writing/:categories/:title:output_ext",
                ]
            )
        if collections:
            lines.append("collections:")
            lines.extend(collections)
        feed_lines = []
        if posts_limit is not None:
            feed_lines.append(f"  posts_limit: {posts_limit}")
        if garden_feed:
            feed_lines.extend(
                [
                    "  collections:",
                    "    garden:",
                    "      path: /feed/garden.xml",
                ]
            )
        if feed_lines:
            lines.append("feed:")
            lines.extend(feed_lines)
        (self.source / "_config.yml").write_text("\n".join(lines) + "\n")
        plugin_dir = self.source / "_plugins"
        plugin_dir.mkdir(exist_ok=True)
        shutil.copy(REPO / "_plugins" / "garden_in_feed.rb", plugin_dir / "garden_in_feed.rb")
        if writing:
            shutil.copy(
                REPO / "_plugins" / "writing_categories.rb",
                plugin_dir / "writing_categories.rb",
            )

    def _write_post(self, filename, title):
        posts = self.source / "_posts"
        posts.mkdir(exist_ok=True)
        (posts / filename).write_text(self._doc(title, None, "Post."))

    def _write_writing(self, folder, filename, title, extra=""):
        directory = self.source / "_writing" / folder
        directory.mkdir(parents=True, exist_ok=True)
        lines = ["---", f"title: {title}"]
        if extra:
            lines.append(extra.rstrip("\n"))
        lines.extend(["---", "Piece.", ""])
        (directory / filename).write_text("\n".join(lines))

    def _write_garden(self, filename, title, date, extra=""):
        garden = self.source / "_garden"
        garden.mkdir(exist_ok=True)
        (garden / filename).write_text(self._doc(title, date, "Note.", extra=extra))

    def _doc(self, title, date, body, extra=""):
        lines = ["---", f"title: {title}"]
        if date is not None:
            lines.append(f"date: {date}")
        if extra:
            lines.append(extra.rstrip("\n"))
        lines.extend(["---", body, ""])
        return "\n".join(lines)

    def _build(self):
        env = os.environ.copy()
        env["BUNDLE_GEMFILE"] = str(REPO / "Gemfile")
        env["JEKYLL_NO_BUNDLER_REQUIRE"] = "1"
        result = subprocess.run(
            [
                "bundle",
                "exec",
                "jekyll",
                "build",
                "--source",
                str(self.source),
                "--destination",
                str(self.dest),
                "--quiet",
            ],
            cwd=REPO,
            env=env,
            capture_output=True,
            text=True,
            check=False,
        )
        if result.returncode != 0:
            self.fail(result.stdout + "\n" + result.stderr)

    def _links(self, relative="feed.xml"):
        path = self.dest / relative
        self.assertTrue(path.is_file(), f"missing {path}")
        root = ET.fromstring(path.read_text())
        return [node.get("href") for node in root.findall(f"{ATOM}entry/{ATOM}link")]
