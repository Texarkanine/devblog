"""Writing collection: folder categories, filename dates, and dateless URLs."""

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]


class WritingCollectionTests(unittest.TestCase):
    """A throwaway site built from the repository config plus a small overlay."""

    def setUp(self):
        self.work = Path(tempfile.mkdtemp())
        self.source = self.work / "src"
        self.dest = self.work / "dest"
        self.source.mkdir()
        self.addCleanup(lambda: shutil.rmtree(self.work, ignore_errors=True))

    def test_folder_and_filename_set_the_url_and_the_publication_date(self):
        """A poetry file with no date and no category builds under that folder and shows the filename day."""
        self._prepare()
        self._write_piece("poetry", "2026-11-11-porch-light.md", "Porch Light")
        self._build()
        page = self.dest / "writing" / "poetry" / "porch-light.html"
        self.assertTrue(page.is_file(), f"missing {page}")
        self.assertIn("2026-11-11", page.read_text())

    def test_nested_folder_keeps_every_segment(self):
        """A file under poetry/sonnets keeps both folders in the URL."""
        self._prepare()
        self._write_piece("poetry/sonnets", "2026-11-11-porch-light.md", "Porch Light")
        self._build()
        page = self.dest / "writing" / "poetry" / "sonnets" / "porch-light.html"
        self.assertTrue(page.is_file(), f"missing {page}")

    def test_folderless_piece_has_no_double_slash(self):
        """A file directly under _writing builds at /writing/porch-light.html."""
        self._prepare()
        self._write_piece(None, "2026-11-11-porch-light.md", "Porch Light")
        self._build()
        page = self.dest / "writing" / "porch-light.html"
        self.assertTrue(page.is_file(), f"missing {page}")
        listing = (self.dest / "writing-listing.html").read_text()
        self.assertIn("/writing/porch-light.html", listing)
        self.assertNotIn("/writing//", listing)

    def test_writing_piece_is_absent_from_the_posts_listing(self):
        """The posts listing contains the post and does not contain the writing URL."""
        self._prepare()
        self._write_piece("poetry", "2026-11-11-porch-light.md", "Porch Light")
        self._write_post("2026-11-10-a-post.md", "A Post")
        self._build()
        listing = (self.dest / "posts-listing.html").read_text()
        self.assertIn("/2026/11/10/a-post.html", listing)
        self.assertNotIn("porch-light", listing)

    def test_future_filename_is_absent_from_the_writing_collection(self):
        """A future filename stays out of site.writing. The same-day piece stays listed."""
        self._prepare()
        self._write_piece("poetry", "2026-11-11-porch-light.md", "Porch Light")
        self._write_piece("poetry", "2999-01-01-later.md", "Later")
        self._build()
        listing = (self.dest / "writing-listing.html").read_text()
        self.assertNotIn("later", listing)
        self.assertIn("porch-light", listing)
        later_pages = list(self.dest.rglob("later.html"))
        self.assertEqual([], later_pages)

    def _prepare(self, plugins=None):
        if plugins is None:
            plugins = []
        if plugins:
            plugin_yaml = "plugins:\n" + "".join(f"  - {name}\n" for name in plugins)
        else:
            plugin_yaml = "plugins: []\n"
        (self.source / "overlay.yml").write_text(
            "url: http://example.test\n" + plugin_yaml
        )
        plugin_dir = self.source / "_plugins"
        plugin_dir.mkdir(exist_ok=True)
        shutil.copy(
            REPO / "_plugins" / "writing_categories.rb",
            plugin_dir / "writing_categories.rb",
        )
        layouts = self.source / "_layouts"
        layouts.mkdir(exist_ok=True)
        (layouts / "writing.html").write_text("{{ content }}\n")
        self._write_page(
            "posts-listing.md",
            "/posts-listing.html",
            "{% for post in site.posts %}{{ post.url }}\n{% endfor %}\n",
        )
        self._write_page(
            "writing-listing.md",
            "/writing-listing.html",
            "{% for doc in site.writing %}{{ doc.url }}\n{% endfor %}\n",
        )

    def _write_page(self, filename, permalink, body):
        (self.source / filename).write_text(
            f"---\ntitle: {filename}\npermalink: {permalink}\n---\n{body}"
        )

    def _write_piece(self, folder, filename, title):
        directory = self.source / "_writing"
        if folder:
            directory = directory / folder
        directory.mkdir(parents=True, exist_ok=True)
        (directory / filename).write_text(
            f"---\ntitle: {title}\n---\n"
            '{{ page.date | date: "%Y-%m-%d" }}\n'
        )

    def _write_post(self, filename, title):
        posts = self.source / "_posts"
        posts.mkdir(exist_ok=True)
        (posts / filename).write_text(f"---\ntitle: {title}\n---\nPost.\n")

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
                "--config",
                f"{REPO / '_config.yaml'},{self.source / 'overlay.yml'}",
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
