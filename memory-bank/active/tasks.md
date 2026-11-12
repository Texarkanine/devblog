# Current Task: Author page writing section

**Complexity:** Level 1

* Task ID: writing-collection
* Type: bugfix

## Fix

The author layout concatenated writing into the posts list and sorted that mix by date, so writing pieces showed up under posts.

Posts stay in the posts list, newest first. When the author has writing, a writing heading and a dated list follow, newest first. An author with no writing gets no writing heading.

Files: `_layouts/author-archive.html`, `tests/test_writing_collection.py`.
