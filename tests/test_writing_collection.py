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

    def test_repeated_folder_segment_keeps_its_own_file(self):
        """Two pieces with one slug under poetry and poetry/poetry each keep a file, and the listing contains both URLs."""
        self._prepare()
        self._write_piece("poetry", "2026-11-11-porch-light.md", "Porch Light")
        self._write_piece("poetry/poetry", "2026-11-11-porch-light.md", "Porch Light")
        self._build()
        outer = self.dest / "writing" / "poetry" / "porch-light.html"
        inner = self.dest / "writing" / "poetry" / "poetry" / "porch-light.html"
        self.assertTrue(outer.is_file(), f"missing {outer}")
        self.assertTrue(inner.is_file(), f"missing {inner}")
        listing = (self.dest / "writing-listing.html").read_text()
        self.assertIn("/writing/poetry/porch-light.html", listing)
        self.assertIn("/writing/poetry/poetry/porch-light.html", listing)

    def test_front_matter_does_not_move_the_piece(self):
        """Front matter categories, writing_paths, and permalink leave the piece on the folder URL and the folder category."""
        self._prepare_archives()
        self._write_page(
            "category-listing.md",
            "/category-listing.html",
            "{% for doc in site.writing %}{% for category in doc.categories %}{{ category }}\n{% endfor %}{% endfor %}\n",
        )
        self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            extra="categories:\n  - songs\nwriting_paths:\n  - songs\npermalink: /elsewhere.html\n",
        )
        self._build()
        page = self._read(self.dest / "writing" / "poetry" / "porch-light.html")
        categories = self._read(self.dest / "category-listing.html")
        self.assertFalse((self.dest / "elsewhere.html").exists())
        self.assertFalse((self.dest / "writing" / "poetry" / "songs").exists())
        self.assertFalse((self.dest / "writing" / "songs").exists())
        self.assertIn('href="/writing/poetry/">poetry</a>', page)
        self.assertNotIn("songs", page)
        self.assertIn("poetry", categories)
        self.assertNotIn("songs", categories)

    def test_front_matter_permalink_keeps_the_html_extension(self):
        """A front-matter permalink with another extension still publishes HTML on the folder URL."""
        self._prepare()
        self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            extra="permalink: /elsewhere.json\n",
        )
        self._build()
        page = self.dest / "writing" / "poetry" / "porch-light.html"
        self.assertTrue(page.is_file(), f"missing {page}")
        self.assertFalse((self.dest / "writing" / "poetry" / "porch-light.json").exists())
        self.assertFalse((self.dest / "elsewhere.json").exists())

    def test_colon_in_the_slug_is_normalized_like_a_title(self):
        """A colon in the filename slug becomes a hyphen, and the build publishes that HTML file."""
        self._prepare()
        self._write_piece("poetry", "2026-11-11-porch:light.md", "Porch Light")
        self._build()
        page = self.dest / "writing" / "poetry" / "porch-light.html"
        self.assertTrue(page.is_file(), f"missing {page}")

    def test_index_slug_aborts_the_build(self):
        """A piece whose slug is index stops the build before it can overwrite the folder page."""
        self._prepare()
        self._write_piece("poetry", "2026-11-11-index.md", "Index")
        result = self._run_jekyll()
        self.assertNotEqual(0, result.returncode)
        self.assertIn("slug 'index'", result.stdout + result.stderr)

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

    def test_future_filename_with_published_true_stays_out_of_the_collection(self):
        """A future filename with published true stays out of site.writing. The same-day piece stays listed."""
        self._prepare()
        self._write_piece("poetry", "2026-11-11-porch-light.md", "Porch Light")
        self._write_piece(
            "poetry",
            "2999-01-01-later.md",
            "Later",
            extra="published: true\n",
        )
        self._build()
        listing = (self.dest / "writing-listing.html").read_text()
        self.assertNotIn("later", listing)
        self.assertIn("porch-light", listing)
        self.assertEqual([], list(self.dest.rglob("later.html")))

    def test_future_filename_with_published_true_stays_off_the_folder_page(self):
        """A future filename with published true is absent from the folder page. The same-day piece stays."""
        self._prepare_archives()
        self._write_piece("poetry", "2026-11-11-porch-light.md", "Porch Light")
        self._write_piece(
            "poetry",
            "2999-01-01-later.md",
            "Later",
            extra="published: true\n",
        )
        self._build()
        page = self._read(self.dest / "writing" / "poetry" / "index.html")
        self.assertNotIn("later", page)
        self.assertIn("porch-light", page)
        self.assertEqual([], list(self.dest.rglob("later.html")))

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
        self.assertIn('href="/writing/poetry/">poetry</a>', page)
        self.assertIn('href="/writing/poetry/">..</a>', page)
        self.assertNotIn('href="/writing/categories/poetry/"', page)
        self.assertIn('href="/authors/texarkanine/"', page)
        self.assertIn('href="/writing/tags/verse/"', page)

    def test_nested_piece_links_each_category_segment(self):
        """A piece in poetry/sonnets links both folder pages, and .. is the nested folder."""
        self._prepare_archives()
        self._write_piece(
            "poetry/sonnets",
            "2026-11-09-small-room.md",
            "Small Room",
            author="texarkanine",
        )
        self._build()
        page = self._read(self.dest / "writing" / "poetry" / "sonnets" / "small-room.html")
        self.assertIn('href="/writing/poetry/">poetry</a>', page)
        self.assertIn('href="/writing/poetry/sonnets/">sonnets</a>', page)
        self.assertIn('href="/writing/poetry/sonnets/">..</a>', page)
        self.assertNotIn('href="/writing/categories/', page)
        self.assertNotIn(">poetry/sonnets</a>", page)

    def test_folderless_piece_parent_is_the_writing_home(self):
        """A piece with no folder links .. to the writing home."""
        self._prepare_archives()
        self._write_piece(
            None,
            "2026-11-11-porch-light.md",
            "Porch Light",
            author="texarkanine",
        )
        self._build()
        page = self._read(self.dest / "writing" / "porch-light.html")
        self.assertIn('href="/writing/">..</a>', page)

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

    def test_folder_page_replaces_the_flat_category_archive(self):
        """A songs piece publishes /writing/songs/ and does not publish /writing/categories/songs/."""
        self._prepare_archives()
        self._write_piece(
            "songs",
            "2026-11-10-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["verse"],
        )
        self._build()
        page = self._read(self.dest / "writing" / "songs" / "index.html")
        self.assertIn("/writing/songs/kitchen-radio.html", page)
        self.assertFalse((self.dest / "writing" / "categories" / "songs").exists())

    def test_nested_folder_pages_list_the_piece(self):
        """A poetry/sonnets piece is listed on both folder pages, and the nested heading names sonnets.

        The piece URL stays /writing/poetry/sonnets/small-room.html.
        """
        self._prepare_archives()
        self._write_piece(
            "poetry/sonnets",
            "2026-11-09-small-room.md",
            "Small Room",
            author="texarkanine",
        )
        self._build()
        piece = self.dest / "writing" / "poetry" / "sonnets" / "small-room.html"
        self.assertTrue(piece.is_file(), f"missing {piece}")
        poetry = self._read(self.dest / "writing" / "poetry" / "index.html")
        sonnets = self._read(self.dest / "writing" / "poetry" / "sonnets" / "index.html")
        self.assertIn("/writing/poetry/sonnets/small-room.html", poetry)
        self.assertIn("/writing/poetry/sonnets/small-room.html", sonnets)
        self.assertIn("category: sonnets", sonnets)

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

    def test_author_page_lists_writing_in_its_own_dated_section_below_posts(self):
        """Posts stay in the posts list. Writing follows in its own list, newest first, with dates.

        An author who has no writing does not get an empty writing heading.
        """
        self._prepare_archives()
        self._write_piece(
            "poetry",
            "2026-11-11-later-light.md",
            "Later Light",
            author="texarkanine",
        )
        self._write_piece(
            "songs",
            "2026-11-09-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
        )
        self._write_post("2026-11-10-a-post.md", "A Post", author="texarkanine")
        self._write_post("2026-11-08-guest-note.md", "Guest Note", author="guest")
        (self.source / "author-guest.md").write_text(
            "---\n"
            "layout: author-archive\n"
            "title: guest\n"
            "permalink: /authors/guest/\n"
            "---\n"
        )
        self._build()
        page = self._read(self.dest / "authors" / "texarkanine" / "index.html")
        posts_at = page.index("<h2>posts</h2>")
        writing_at = page.index("<h2>writing</h2>")
        post_at = page.index("/2026/11/10/a-post.html")
        later_at = page.index("/writing/poetry/later-light.html")
        radio_at = page.index("/writing/songs/kitchen-radio.html")
        self.assertLess(posts_at, post_at)
        self.assertLess(post_at, writing_at)
        self.assertLess(writing_at, later_at)
        self.assertLess(later_at, radio_at)
        self.assertIn("2026-11-10", page[posts_at:writing_at])
        self.assertIn("2026-11-11", page[writing_at:later_at])
        self.assertIn("2026-11-09", page[later_at:radio_at])
        self.assertNotIn("guest-note", page)

        guest = self._read(self.dest / "authors" / "guest" / "index.html")
        self.assertIn("<h2>posts</h2>", guest)
        self.assertIn("/2026/11/08/guest-note.html", guest)
        self.assertNotIn("<h2>writing</h2>", guest)
        self.assertNotIn("later-light", guest)

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
        """A writing category with one piece publishes /writing/poetry/llms.txt."""
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._build()
        page = self._read(self.dest / "writing" / "poetry" / "llms.txt")
        self.assertIn("porch-light", page)
        self.assertFalse((self.dest / "writing" / "categories" / "poetry" / "llms.txt").exists())

    def test_nested_folder_scope_publishes_llms_txt(self):
        """A nested folder publishes /writing/poetry/sonnets/llms.txt.

        The ancestor scope lists the nested piece. Root /llms.txt lists the
        piece sidecar and does not list the generated folder page.
        """
        self._prepare_sidecars()
        self._write_sidecar_pieces()
        self._write_piece(
            "poetry/sonnets",
            "2026-11-09-small-room.md",
            "Small Room",
            author="texarkanine",
        )
        self._build()
        nested = self._read(self.dest / "writing" / "poetry" / "sonnets" / "llms.txt")
        self.assertIn("small-room", nested)
        self.assertNotIn("porch-light", nested)
        poetry = self._read(self.dest / "writing" / "poetry" / "llms.txt")
        self.assertIn("porch-light", poetry)
        self.assertIn("small-room", poetry)
        root = self._read(self.dest / "llms.txt")
        self.assertIn("porch-light.md", root)
        pages = ""
        if "## Pages" in root:
            pages = root.split("## Pages", 1)[1].split("\n## ", 1)[0]
        self.assertNotIn("/writing/poetry/", pages)

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

    def test_writing_home_lists_pieces_newest_first_and_skips_other_collections(self):
        """The writing home lists writing by date and leaves out posts and garden notes."""
        self._prepare_section()
        self._write_section_pieces()
        self._build()
        page = self._read(self.dest / "writing" / "index.html")
        newer = page.index("/writing/poetry/porch-light.html")
        older = page.index("/writing/songs/kitchen-radio.html")
        self.assertLess(newer, older)
        self.assertIn('href="/writing/tags/"', page)
        self.assertIn('href="/writing/categories/"', page)
        self.assertNotIn("/2026/11/08/a-tool.html", page)
        self.assertNotIn("/garden/pressed-leaf.html", page)

    def test_writing_tag_index_links_a_repeated_tag_only(self):
        """The tag index links a tag used twice, omits a tag used once, and omits a post-only tag."""
        self._prepare_section()
        self._write_section_pieces()
        self._build()
        page = self._read(self.dest / "writing" / "tags" / "index.html")
        self.assertIn('href="/writing/tags/verse/"', page)
        self.assertNotIn('href="/writing/tags/hearth/"', page)
        self.assertNotIn('href="/tags/tools/"', page)
        self.assertNotIn('href="/writing/tags/tools/"', page)

    def test_writing_tag_index_renders_when_nothing_is_tagged(self):
        """The tag index still renders when the only piece has no tags, and it has no tag link."""
        self._prepare_section()
        self._write_piece(
            "stories",
            "2026-11-11-second-cup.md",
            "Second Cup",
            author="texarkanine",
        )
        self._build()
        page = self._read(self.dest / "writing" / "tags" / "index.html")
        self.assertNotIn('href="/writing/tags/', page)

    def test_writing_category_index_links_a_category_used_once(self):
        """The category index links a category used once and does not link a post category."""
        self._prepare_section()
        self._write_section_pieces()
        self._build()
        page = self._read(self.dest / "writing" / "categories" / "index.html")
        self.assertIn('href="/writing/poetry/"', page)
        self.assertIn('href="/writing/songs/"', page)
        self.assertNotIn('href="/writing/categories/poetry/"', page)
        self.assertNotIn('href="/categories/tools/"', page)
        self.assertNotIn('href="/writing/categories/tools/"', page)

    def test_home_page_lists_writing_under_the_posts_menu(self):
        """The recent-posts list omits writing. The writing block under it links the pieces and the indexes."""
        self._prepare_section()
        self._write_section_pieces()
        self._build()
        page = self._read(self.dest / "index.html")
        posts, rest = page.split("<!-- /posts -->", 1)
        self.assertNotIn("porch-light", posts)
        self.assertIn("/2026/11/08/a-tool.html", posts)
        newer = rest.index("/writing/poetry/porch-light.html")
        older = rest.index("/writing/songs/kitchen-radio.html")
        self.assertLess(newer, older)
        self.assertIn('href="/writing/"', rest)
        self.assertIn('href="/writing/tags/"', rest)
        self.assertIn('href="/writing/categories/"', rest)

    def test_all_posts_omits_writing(self):
        """The all-posts page does not list a writing piece."""
        self._prepare_section()
        self._write_section_pieces()
        self._build()
        page = self._read(self.dest / "all-posts.html")
        self.assertIn("/2026/11/08/a-tool.html", page)
        self.assertNotIn("porch-light", page)

    def test_garden_index_omits_writing(self):
        """The garden index does not list a writing piece."""
        self._prepare_section()
        self._write_section_pieces()
        self._build()
        page = self._read(self.dest / "garden" / "index.html")
        self.assertIn("/garden/pressed-leaf.html", page)
        self.assertNotIn("porch-light", page)

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
            "writing_folder_indexes.rb",
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
            "writing_folder_indexes.rb",
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

    def _prepare_section(self):
        (self.source / "overlay.yml").write_text(
            "url: http://example.test\nplugins:\n  - jekyll-archives\n"
        )
        plugin_dir = self.source / "_plugins"
        plugin_dir.mkdir(exist_ok=True)
        for name in (
            "writing_categories.rb",
            "writing_folder_indexes.rb",
            "garden_archives.rb",
            "navigational_tags.rb",
        ):
            shutil.copy(REPO / "_plugins" / name, plugin_dir / name)
        includes = self.source / "_includes"
        includes.mkdir(exist_ok=True)
        for name in ("back_link.html", "menu_item.html", "page_list.html", "garden_posts.html"):
            shutil.copy(REPO / "_includes" / name, includes / name)
        (includes / "post_list.html").write_text(
            "<!-- posts -->\n"
            "<ul>\n"
            "{% for post in site.posts %}\n"
            '<li><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>\n'
            "{% endfor %}\n"
            "</ul>\n"
            "<!-- /posts -->\n"
        )
        layouts = self.source / "_layouts"
        layouts.mkdir(exist_ok=True)
        for name in ("page.html", "writing.html"):
            shutil.copy(REPO / "_layouts" / name, layouts / name)
        (layouts / "default.html").write_text("---\n---\n{{ content }}\n")
        (layouts / "home.html").write_text(
            "---\n---\n"
            "{% include menu_item.html collection=site.data.menu.entries %}\n"
            "{{ content }}\n"
        )
        data = self.source / "_data"
        data.mkdir(exist_ok=True)
        for name in ("menu.yaml", "garden_menu.yaml", "writing_menu.yaml"):
            shutil.copy(REPO / "_data" / name, data / name)
        pages = self.source / "pages"
        pages.mkdir(exist_ok=True)
        for name in ("index.md", "all-posts.md", "writing.md"):
            shutil.copy(REPO / "pages" / name, pages / name)
        writing_pages = pages / "writing"
        writing_pages.mkdir(exist_ok=True)
        for name in ("tags.md", "categories.md"):
            shutil.copy(REPO / "pages" / "writing" / name, writing_pages / name)
        (pages / "garden-index.md").write_text(
            "---\nlayout: page\ntitle: Garden\npermalink: /garden/\n---\n"
            "{% include garden_posts.html %}\n"
        )

    def _write_section_pieces(self):
        self._write_piece(
            "poetry",
            "2026-11-11-porch-light.md",
            "Porch Light",
            author="texarkanine",
            tags=["verse"],
        )
        self._write_piece(
            "songs",
            "2026-11-09-kitchen-radio.md",
            "Kitchen Radio",
            author="texarkanine",
            tags=["verse", "hearth"],
        )
        self._write_post(
            "2026-11-08-a-tool.md",
            "A Tool",
            author="texarkanine",
            category="tools",
            tags=["tools"],
        )
        garden = self.source / "_garden"
        garden.mkdir(exist_ok=True)
        (garden / "pressed-leaf.md").write_text(
            "---\ntitle: Pressed Leaf\ndate: 2026-11-01\n---\nNote.\n"
        )

    def _write_page(self, filename, permalink, body):
        (self.source / filename).write_text(
            f"---\ntitle: {filename}\npermalink: {permalink}\n---\n{body}"
        )

    def _write_piece(self, folder, filename, title, author=None, tags=None, extra=""):
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
        if extra:
            lines.append(extra.rstrip("\n"))
        lines.extend(["---", '{{ page.date | date: "%Y-%m-%d" }}', ""])
        path = directory / filename
        path.write_text("\n".join(lines))
        return path

    def _write_post(self, filename, title, author=None, category=None, tags=None):
        posts = self.source / "_posts"
        posts.mkdir(exist_ok=True)
        lines = ["---", f"title: {title}"]
        if author:
            lines.append(f"author: {author}")
        if category:
            lines.append(f"category: {category}")
        if tags:
            lines.append("tags:")
            lines.extend(f"  - {tag}" for tag in tags)
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

    def _run_jekyll(self):
        env = os.environ.copy()
        env["BUNDLE_GEMFILE"] = str(REPO / "Gemfile")
        env["JEKYLL_NO_BUNDLER_REQUIRE"] = "1"
        return subprocess.run(
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

    def _build(self):
        result = self._run_jekyll()
        if result.returncode != 0:
            self.fail(result.stdout + "\n" + result.stderr)
