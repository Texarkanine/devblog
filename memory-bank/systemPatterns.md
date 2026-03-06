# System Patterns

## How This System Works

The site is a Jekyll static site. Content lives in `blog/<collection>/_posts/` (e.g. essay, diary, record) and in the `garden` collection. Layouts in `_layouts/` wrap `{{ content }}`, which is the Markdown-rendered HTML. The remote theme (no-style-please) supplies base styles and structure; local overrides live in `_includes/`, `_layouts/`, and `_sass/` (if any). Plugins in `_plugins/` and Gemfile extend Jekyll (e.g. image paths, custom Liquid tags). Changing how content is rendered (e.g. adding per-heading anchors) requires either a Liquid preprocessing step, a custom Markdown converter, or a post-render hook that modifies the final HTML.

## Pattern: Layout → content

`default.html` includes `head.html`, wraps `{{ content }}` in a main container, and conditionally loads analytics and per-page JS. Child layouts (e.g. `post.html`, `garden.html`) set `layout: default` and render `{{ content }}` inside `<article>`. The string `{{ content }}` is already HTML at that point (Kramdown output), so any injection of anchor links must happen before or during that render—e.g. in a Jekyll hook that processes the rendered post body.

## Pattern: Theme and config

`_config.yaml` drives `remote_theme`, `theme_config`, permalinks, and plugins. Site-wide behavior (e.g. anchor icon, date format) is a good fit for `_config.yaml` or `theme_config` plus a small plugin or include that respects it.
