# DevBlog

https://blog.cani.ne.jp/

## Local Development

1. Have Ruby & Bundler installed
2. 
	```bash
	bundle install
	bundle exec jekyll serve
	```

## Media Workflow

1. Install Git LFS once per machine: `git lfs install`
2. Add large images under `assets/img/**` so they are tracked automatically by `.gitattributes`
3. Directory hierarchy under `assets/img` should match the path to the post that references the image.
4. Run `uv tool install pre-commit` once per machine (or `pipx install pre-commit`), then `pre-commit install` once per clone. The pre-commit hook strips metadata from staged images (ExifTool for raster formats, `tools/strip_svg_metadata.py` for SVG). ExifTool is built from CPAN on first use, so Perl and `cpan` must be on `PATH`. If a commit stops because the hook rewrote files, stage them and commit again.

## License

Multiple; see [REUSE.toml](REUSE.toml) for details ([what's REUSE?](https://reuse.software/)):

- **Default (code, templates, plugins, assets):** AGPL-3.0-or-later
- **Writing (`blog/`, `_garden/`):** CC-BY-SA-4.0
- **Agent prompts (`.cursor/`, `.claude/`):** PPL-S — vendored `**/shared/**` excluded
