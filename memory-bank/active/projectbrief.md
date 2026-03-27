# Project Brief

## User Story

As a site operator, I want to serve the 13MB `.docx` file from GitHub Releases instead of proxying it through the $5/mo nginx instance so that metered compute/bandwidth on the DO App Platform is not wasted on a static binary download.

## Use-Case(s)

### Use-Case 1: Visitor Downloads the Book

A visitor to `nuclearpyramid.com` clicks the "From Gravitons to Galaxies" download link. Instead of the request flowing through nginx → DO static site (proxying 13MB through the metered compute instance), the link points directly to a GitHub Release asset URL. The browser downloads the file from GitHub's CDN. Nginx never sees the request.

## Requirements

1. Create a GitHub Release on the `nuclear-pyramid-archive` repo containing `From Gravitons to Galaxies.docx` as a release asset.
2. Modify the build pipeline (`transform.rb`) to rewrite the two `href='From Gravitons to Galaxies.docx'` references in `index.php` to point to the GitHub Release download URL.
3. The rewrite must be targeted — only the docx href changes; no other HTML is affected.
4. The change must survive re-running `rake transform` (i.e., it's part of the pipeline, not a manual edit to `docs/site/`).

## Constraints

1. No `src/index.php` overlay exists. The index page comes from `archive.org/index.php` via the transform pipeline. The rewrite must happen in `transform.rb`.
2. The GitHub Release URL will be cross-origin (e.g., `github.com` or `objects.githubusercontent.com`). This is acceptable for a `.docx` download link.
3. The existing test infrastructure (if any) must continue to pass.
4. The archive.org/ source files must not be modified — they represent the original Wayback Machine download.

## Acceptance Criteria

1. `rake transform` produces `docs/site/index.php` with both docx hrefs pointing to the GitHub Release URL (not the relative path).
2. The GitHub Release exists on the `nuclear-pyramid-archive` repo and the docx file is downloadable from the release URL.
3. All other HTML content in `docs/site/index.php` is unchanged.
4. All existing tests pass.
5. The change is documented in a commit following conventional commit format.
