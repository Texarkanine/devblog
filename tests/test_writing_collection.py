"""Writing collection: folder categories, filename dates, and dateless URLs."""

import os
import shutil
import subprocess
import tempfile
import time
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

    def test_writing_page_links_its_category_and_author_and_shows_both_dates(self):
        """The writing page links the folder and the author, and shows Published and Updated."""
        self._prepare_archives()
        piece = self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            author="texarkanine",
            tags=["verse"],
        )
        self._set_mtime(piece, 2024, 6, 15)
        self._write_piece(
            "songs",
            "2026-11-10-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["verse", "hearth"],
        )
        self._build()
        page = self._read(self.dest / "writing" / "poetry" / "porch-light.html")
        self.assertIn("Published: 2026-11-11", page)
        self.assertIn("Updated: 2024-06-15", page)
        self.assertIn('href="/writing/categories/poetry/"', page)
        self.assertIn('href="/authors/texarkanine/"', page)
        self.assertIn('href="/writing/tags/verse/"', page)

    def test_nested_piece_links_each_category_segment(self):
        """A piece in poetry/sonnets links both category archives."""
        self._prepare_archives()
        self._write_piece(
            "poetry/sonnets",
            "2026-11-09-small-room.md",
            "Small Room",
            author="texarkanine",
        )
        self._build()
        page = self._read(self.dest / "writing" / "poetry" / "sonnets" / "small-room.html")
        self.assertIn('href="/writing/categories/poetry/"', page)
        self.assertIn('href="/writing/categories/sonnets/"', page)

    def test_piece_with_no_tags_has_no_tag_link(self):
        """A writing piece with no tags still renders, and the page has no tag link."""
        self._prepare_archives()
        self._write_piece(
            "stories",
            "2026-11-09-second-cup.md",
            "Second Cup",
            author="texarkanine",
        )
        self._build()
        page = self._read(self.dest / "writing" / "stories" / "second-cup.html")
        self.assertNotIn("/writing/tags/", page)

    def test_shared_tag_archive_renders_the_description(self):
        """The verse archive markdownifies the shared description and sets the plain SEO text."""
        self._prepare_archives()
        self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            author="texarkanine",
            tags=["verse"],
        )
        self._write_piece(
            "songs",
            "2026-11-10-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["verse"],
        )
        self._build()
        page = self._read(self.dest / "writing" / "tags" / "verse" / "index.html")
        self.assertIn("<strong>shared</strong>", page)
        self.assertIn("A shared description.", page)
        porch = page.index("/writing/poetry/porch-light.html")
        radio = page.index("/writing/songs/kitchen-radio.html")
        self.assertLess(porch, radio)

    def test_singleton_writing_tag_has_no_archive(self):
        """A tag used on one writing piece does not get an archive page."""
        self._prepare_archives()
        self._write_piece(
            "songs",
            "2026-11-10-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["hearth"],
        )
        self._build()
        self.assertFalse((self.dest / "writing" / "tags" / "hearth" / "index.html").exists())

    def test_category_archive_exists_for_one_piece(self):
        """A category used once still publishes an archive that lists the piece."""
        self._prepare_archives()
        self._write_piece(
            "songs",
            "2026-11-10-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["verse"],
        )
        self._build()
        page = self._read(self.dest / "writing" / "categories" / "songs" / "index.html")
        self.assertIn("/writing/songs/kitchen-radio.html", page)

    def test_writing_tag_does_not_create_a_post_tag_archive(self):
        """A writing-only tag does not publish /tags/verse/."""
        self._prepare_archives()
        self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            author="texarkanine",
            tags=["verse"],
        )
        self._write_piece(
            "songs",
            "2026-11-10-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["verse"],
        )
        self._build()
        self.assertFalse((self.dest / "tags" / "verse" / "index.html").exists())
        self.assertFalse((self.dest / "tags" / "verse.html").exists())

    def test_author_page_lists_the_post_and_the_writing_piece_newest_first(self):
        """A hand-written author page lists the writing piece and a post, newest first."""
        self._prepare_archives()
        self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            author="texarkanine",
            tags=["verse"],
        )
        self._write_post("2026-11-10-a-post.md", "A Post", author="texarkanine")
        self._build()
        page = self._read(self.dest / "authors" / "texarkanine" / "index.html")
        writing_at = page.index("/writing/poetry/porch-light.html")
        post_at = page.index("/2026/11/10/a-post.html")
        self.assertLess(writing_at, post_at)

    def test_writing_document_has_a_markdown_sidecar(self):
        """A writing piece publishes a Markdown sidecar next to its HTML page."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        self.assertTrue((self.dest / "writing" / "poetry" / "porch-light.md").is_file())

    def test_writing_tag_scope_publishes_llms_txt(self):
        """A tag on two writing pieces publishes /writing/tags/verse/llms.txt."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        page = self._read(self.dest / "writing" / "tags" / "verse" / "llms.txt")
        self.assertIn("porch-light", page)

    def test_singleton_writing_tag_has_no_llms_txt(self):
        """A tag used on one writing piece does not publish an llms.txt scope."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        self.assertFalse((self.dest / "writing" / "tags" / "hearth" / "llms.txt").exists())

    def test_writing_category_scope_publishes_llms_txt_for_one_piece(self):
        """A writing category with one piece publishes /writing/categories/poetry/llms.txt."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        page = self._read(self.dest / "writing" / "categories" / "poetry" / "llms.txt")
        self.assertIn("porch-light", page)

    def test_writing_folder_does_not_publish_a_post_category_scope(self):
        """A writing folder named poetry does not publish /categories/poetry/llms.txt."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        self.assertFalse((self.dest / "categories" / "poetry" / "llms.txt").exists())

    def test_post_category_scope_survives_without_the_gem_flag(self):
        """A post in category tools still publishes /categories/tools/llms.txt."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        page = self._read(self.dest / "categories" / "tools" / "llms.txt")
        self.assertIn("a-tool", page)

    def test_writing_archive_pages_have_no_markdown_sidecar(self):
        """Writing tag and category archive pages do not get an index.md sidecar."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        self.assertFalse((self.dest / "writing" / "tags" / "verse" / "index.md").exists())
        self.assertFalse((self.dest / "writing" / "categories" / "poetry" / "index.md").exists())

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

    def _prepare_archives(self):
        (self.source / "overlay.yml").write_text(
            "url: http://example.test\nplugins:\n  - jekyll-archives\n"
        )
        plugin_dir = self.source / "_plugins"
        plugin_dir.mkdir(exist_ok=True)
        for name in (
            "writing_categories.rb",
            "garden_archives.rb",
            "navigational_tags.rb",
            "collection_dates.rb",
            "tag_descriptions_seo.rb",
            "email_obfuscator.rb",
        ):
            shutil.copy(REPO / "_plugins" / name, plugin_dir / name)
        includes = self.source / "_includes"
        includes.mkdir(exist_ok=True)
        shutil.copy(REPO / "_includes" / "back_link.html", includes / "back_link.html")
        layouts = self.source / "_layouts"
        layouts.mkdir(exist_ok=True)
        for name in (
            "page.html",
            "writing.html",
            "writing-tag-archive.html",
            "writing-cat-archive.html",
            "author-archive.html",
        ):
            shutil.copy(REPO / "_layouts" / name, layouts / name)
        (layouts / "default.html").write_text(
            "---\n---\n{{ content }}\n{{ page.description }}\n"
        )
        data = self.source / "_data"
        data.mkdir(exist_ok=True)
        (data / "tags.yaml").write_text('verse: "A **shared** description."\n')
        (data / "authors.yaml").write_text(
            "texarkanine:\n  name: Texarkanine\n  bio: Writes.\n"
        )
        (self.source / "author-texarkanine.md").write_text(
            "---\n"
            "layout: author-archive\n"
            "title: texarkanine\n"
            "permalink: /authors/texarkanine/\n"
            "---\n"
        )

    def _prepare_sidecars(self):
        (self.source / "overlay.yml").write_text(
            "url: http://example.test\n"
            "plugins:\n"
            "  - jekyll-archives\n"
            "  - jekyll-llm-sidecars\n"
        )
        plugin_dir = self.source / "_plugins"
        plugin_dir.mkdir(exist_ok=True)
        for name in (
            "20_llms_scope_builders.rb",
            "navigational_tags.rb",
            "garden_archives.rb",
            "writing_categories.rb",
        ):
            shutil.copy(REPO / "_plugins" / name, plugin_dir / name)
        includes = self.source / "_includes"
        includes.mkdir(exist_ok=True)
        shutil.copy(REPO / "_includes" / "back_link.html", includes / "back_link.html")
        layouts = self.source / "_layouts"
        layouts.mkdir(exist_ok=True)
        for name in (
            "writing.html",
            "writing-tag-archive.html",
            "writing-cat-archive.html",
            "cat-archive.html",
            "tag-archive.html",
        ):
            shutil.copy(REPO / "_layouts" / name, layouts / name)
        (layouts / "default.html").write_text("---\n---\n{{ content }}\n")

    def _write_sidecar_pieces(self):
        self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            author="texarkanine",
            tags=["verse"],
        )
        self._write_piece(
            "songs",
            "2026-11-10-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["verse", "hearth"],
        )
        self._write_post(
            "2026-11-10-a-tool.md",
            "A Tool",
            author="texarkanine",
            category="tools",
        )

    def _write_page(self, filename, permalink, body):
        (self.source / filename).write_text(
            f"---\ntitle: {filename}\npermalink: {permalink}\n---\n{body}"
        )

    def _write_piece(self, folder, filename, title, author=None, tags=None):
        directory = self.source / "_writing"
        if folder:
            directory = directory / folder
        directory.mkdir(parents=True, exist_ok=True)
        lines = ["---", f"title: {title}"]
        if author:
            lines.append(f"author: {author}")
        if tags:
            lines.append("tags:")
            lines.extend(f"  - {tag}" for tag in tags)
        lines.extend(["---", '{{ page.date | date: "%Y-%m-%d" }}', ""])
        path = directory / filename
        path.write_text("\n".join(lines))
        return path

    def _write_post(self, filename, title, author=None, category=None):
        posts = self.source / "_posts"
        posts.mkdir(exist_ok=True)
        lines = ["---", f"title: {title}"]
        if author:
            lines.append(f"author: {author}")
        if category:
            lines.append(f"category: {category}")
        lines.extend(["---", "Post.", ""])
        path = posts / filename
        path.write_text("\n".join(lines))
        return path

    def _set_mtime(self, path, year, month, day):
        stamp = time.mktime((year, month, day, 12, 0, 0, 0, 0, -1))
        os.utime(path, (stamp, stamp))

    def _read(self, path):
        self.assertTrue(path.is_file(), f"missing {path}")
        return path.read_text()

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
