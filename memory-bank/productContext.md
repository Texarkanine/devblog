# Product Context

## Target Audience

Readers of a personal/dev blog (blog.cani.ne.jp). Authors publish essays, diary-style posts, and garden (notes) content.

## Use Cases

- Publish and browse blog posts (essay, diary, record) and garden pages.
- Navigate by tags, categories, and authors.
- Consume content with clear typography and minimal chrome; optional analytics in production.

## Key Benefits

- Simple, fast static site with no client-side app requirements.
- Clear separation of content (Markdown in `_posts`/collections) and presentation (Jekyll layouts, remote theme).

## Success Criteria

- Site builds and serves locally and in production.
- Content is easy to author (Markdown, front matter) and maintain (Git, optional LFS for media).

## Key Constraints

- Build must remain static (no required client-side JS for core behavior).
- Theming and layout follow the remote theme (no-style-please) with minimal overrides.
