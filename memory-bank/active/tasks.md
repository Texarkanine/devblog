# Task: nuclear-pyramid-docx-offload

* Task ID: nuclear-pyramid-docx-offload
* Complexity: Level 2
* Type: Simple Enhancement

Offload the 13MB `From Gravitons to Galaxies.docx` from the nginx proxy path to a GitHub Release asset. Modify the `transform.rb` build pipeline to rewrite the relative docx href in `index.php` to point to the GitHub Release download URL.


## Test Plan (TDD)

### Behaviors to Verify

- **Docx link rewrite (single-quoted)**: HTML containing `href='From Gravitons to Galaxies.docx'` → href rewritten to GitHub Release URL
- **Docx link rewrite (double-quoted)**: HTML containing `href="From Gravitons to Galaxies.docx"` → href rewritten to GitHub Release URL
- **No-op on unrelated HTML**: HTML without the docx href → passes through unchanged
- **Pipeline integration**: `transform_html` output includes the docx link rewrite (i.e., the full pipeline chain applies it)
- **Preserves surrounding HTML**: Only the docx href value changes; surrounding tags, attributes, and content are untouched

### Test Infrastructure

- Framework: Minitest (in Gemfile, `group :test`)
- Test location: `test/` (new directory)
- Conventions: Standard Minitest — `test/test_helper.rb` for shared setup, `test/test_transform.rb` for Transform module tests
- New test files: `test/test_helper.rb`, `test/test_transform.rb`
- Rake task: Add `:test` task to Rakefile

## Implementation Plan

1. **Bootstrap test infrastructure**
   - Files: `test/test_helper.rb` (new), Rakefile
   - Changes: Create `test/test_helper.rb` with `require "minitest/autorun"` and `require_relative "../lib/transform"`. Add Rake `test` task to Rakefile using `Rake::TestTask`.

2. **Stub `rewrite_docx_link` + write failing tests**
   - Files: `test/test_transform.rb` (new), `lib/transform.rb`
   - Changes: Create `test/test_transform.rb` with test cases for all behaviors above. Add empty `rewrite_docx_link` method stub to `lib/transform.rb` that returns input unchanged.

3. **Implement `rewrite_docx_link`**
   - Files: `lib/transform.rb`
   - Changes: Add `DOCX_RELEASE_URL` constant with the GitHub Release download URL. Implement `rewrite_docx_link(html)` to replace `href=['"]From Gravitons to Galaxies.docx['"]` with `href='<DOCX_RELEASE_URL>'`. Integrate into `transform_html` pipeline.

4. **Create GitHub Release**
   - Files: none (GitHub API / `gh` CLI)
   - Changes: Create release tagged `v1.0.0` on `Texarkanine/nuclear-pyramid-archive` with `archive.org/From Gravitons to Galaxies.docx` as a release asset.

5. **Verify end-to-end**
   - Run `bundle exec rake transform` and confirm `docs/site/index.php` contains the GitHub Release URL (both occurrences at lines ~72 and ~100).
   - Run full test suite: `bundle exec rake test`.
   - Note: `docs/site/` is git-tracked. The changed `docs/site/index.php` must be committed alongside the code change.

6. **Documentation**
   - Files: `README.md`
   - Changes: Add a note about the docx being served from GitHub Releases and why.

## Technology Validation

No new technology — validation not required. Minitest is already a declared dependency. `gh` CLI is already available in the environment.

## Dependencies

- `gh` CLI (for creating the GitHub Release) — already installed
- `minitest` gem (for tests) — already in Gemfile
- Git LFS (the docx is tracked via LFS in `.gitattributes`) — already configured

## Challenges & Mitigations

- **SSH host alias**: The git remote uses `github-texarkanine.com` as SSH host. `gh` CLI uses HTTPS API, so this shouldn't affect release creation. If it does, use `--repo Texarkanine/nuclear-pyramid-archive` flag explicitly.
- **LFS pointer vs actual file**: The docx in `archive.org/` must be the actual file (not an LFS pointer) for the release upload. Verify with `file` command before uploading. If it's a pointer, run `git lfs pull` first.
- **URL encoding**: The filename has spaces. GitHub Release download URLs handle this transparently. The URL will use `%20` encoding. The href in HTML should use the URL-encoded form.

## Status

- [x] Initialization complete
- [x] Test planning complete (TDD)
- [x] Implementation plan complete
- [x] Technology validation complete
- [x] Preflight
- [x] Build
- [x] QA
