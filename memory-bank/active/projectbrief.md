# Project Brief

## User Story

As a reader, I want a writing section with its own categories, tags, and indexes, so that poems, songs, and stories stay out of the tech posts and out of the garden.

As the author, I want to drop a piece in a folder and date it in the filename, so that the category and the publication date come from the file's place on disk.

## Use-Case(s)

### Browse the writing section

A reader opens the writing section and sees only writing. Category and tag indexes list only writing. The tech post indexes and the garden do not list these pieces.

### Publish a piece

The author adds a Markdown file under a category folder. The folder name is the category. The `YYYY-MM-DD` filename prefix is the publication date. The page shows that date and the git update date. The public URL is `/writing/<folder>/<slug>` and does not contain the date.

### Follow a piece outward

The piece names an existing author. The main feed includes it. Each piece has an LLM sidecar. Tag descriptions stay the one shared description per tag name.

### See it with seeds

Three short pieces exist: one poem, one song, and one story, so the three categories are real. They carry tags, including one tag shared by two pieces, so a tag archive is visible.

## Requirements

1. A `writing` collection, separate from posts and from the garden.
2. Categories come from the folder under that collection, not from front matter.
3. No `date` in front matter. The filename prefix is the publication date. The git body-commit date is the update date. The layout shows both.
4. Piece URLs are `/writing/<folder>/<slug>` with no date in the path.
5. Own tag index, category index, and section home. A reader can click into the section from the site.
6. Own layout and own LLM sidecars.
7. Pieces join the main feed.
8. Pieces do not appear in the tech post indexes or in the garden.
9. Authors come from the existing author set. Author pages list the writing pieces.
10. Seed one poem, one song, and one story. Author is Texarkanine. Filename date is 2026-11-11. At least one tag appears on two pieces.

## Constraints

1. The site stays a static Jekyll build.
2. Tag descriptions stay one global description per tag name. The description is the meaning of the tag.
3. A tag used on only one document does not get an archive page. That rule already exists and stays.
4. Front matter must not restate the publication date or the category.

## Acceptance Criteria

1. Each seed resolves at `/writing/<folder>/<slug>` with no date in the URL. The category archive for that folder is `/writing/categories/<folder>/`.
2. Each piece shows a publication date taken from its filename and an update date taken from git.
3. Category and tag indexes exist for the writing collection and do not list tech posts or garden notes.
4. `/all-posts.html`, the recent-posts list, and the garden index do not list the seeds.
5. `/feed.xml` includes the seeds.
6. Each seed links to Texarkanine's existing author page, and that page lists the seeds.
7. Each seed has an LLM sidecar.
8. A tag shared by two seeds has a writing tag archive. A tag used once does not.

## Rework

Operator feedback, 2026-11-11: the author page lists the three writing pieces under posts. The author LLM sidecar puts them in their own Writing section, and that listing is the correct one. The author page should put writing in its own dated section below posts.

## Rework: folder category pages

Operator decision, 2026-11-11: a writing piece should be a child of its category page. `/writing/poetry/` is the poetry category page. A nested folder is the same way: `/writing/poetry/sonnets/` is that folder's category page. The flat pages at `/writing/categories/<name>/` go away. `/writing/categories/` stays the page that lists every category. A writing folder must not be named `tags`. Once the folder index exists, the piece's `..` link is that parent folder.
