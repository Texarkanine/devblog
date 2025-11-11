Static Site Bootstrapping Design Document: Jekyll + GitHub Actions

1. Project Goal

The objective is to establish a Continuous Integration/Continuous Deployment (CI/CD) pipeline for a Jekyll-based static site using GitHub Actions. This setup bypasses the limitations of GitHub Pages' native build environment (which prohibits custom Ruby plugins) by building the site directly within the GitHub repository and publishing the resulting static files to the gh-pages branch.

We will use the "No Style, Please" theme as a minimalist starting point and integrate the jekyll-archives plugin to automatically generate index pages for all blog tags.

2. Required File Changes and Additions

The following files must be created or modified in the repository root.

2.1. Update Gemfile (Adding Plugins)

The Gemfile defines the dependencies for your Jekyll build. We must explicitly include the necessary gems, especially jekyll-archives.

2.2. Update _config.yml (Jekyll Configuration)

This configuration file must enable the jekyll-archives plugin and define how the tag pages should be structured and rendered.

2.3. Create Tag Archive Layout

The jekyll-archives plugin needs a specific layout file to use when generating each individual tag page. This file will be placed at _layouts/tag-archive.html.

2.4. GitHub Actions Workflow

This workflow will execute whenever code is pushed to the main branch. It sets up the Ruby environment, installs dependencies (including the plugins), builds the Jekyll site, and deploys the generated static files to the gh-pages branch.

3. Usage and Verification

Commit Changes: Push all the files (Gemfile, _config.yml, _layouts/tag-archive.html, and .github/workflows/deploy.yml) to your main branch.

Monitor Action: Go to the "Actions" tab in your GitHub repository and monitor the "Build and Deploy Jekyll Site" workflow run.

Verify Deployment: Once the action completes successfully, it will have pushed the built static files (including the new tag archive pages) to the gh-pages branch.

Enable GitHub Pages:

Navigate to your repo's Settings -> Pages.

Set the Source to the gh-pages branch.

Wait a few minutes for the site to be published at your domain (e.g., https://<USERNAME>.github.io/<REPO-NAME>/).

Test Tag Links: Ensure that any tag links you include in your posts (e.g., in _posts/2025-11-11-first-post.md where you define tags: [jekyll, actions]) correctly point to /tags/jekyll/ and load the generated tag archive page.

---

Repository Licensing Strategy

This repository will use a dual-licensing strategy to clearly define the terms for the technical components (code and templates) and the creative content (blog posts and original text).

1. Code and Templates (Recommended: MIT License)

The MIT License is the standard choice for Jekyll themes and related code because it is permissive, short, and widely understood in the developer community. This covers the files that run your site, such as:

_layouts/

_includes/

_sass/

.github/workflows/ (your CI/CD setup)

Gemfile and _config.yml

Why MIT?

Permissive: It allows anyone to reuse, modify, and distribute the code, even for commercial use.

Encourages Re-use: It encourages other developers to fork and adapt your CI/CD setup or template.

Simple Requirement: The only real requirement is that the copyright notice and license text must be included in all copies or substantial portions of the Software.

2. Creative Content (Recommended: Creative Commons License)

For the actual blog posts, articles, and text files found in your _posts/ directory, a Creative Commons (CC) license is most appropriate, as it is designed for creative works rather than software.

The most popular option for blogs is CC BY-SA 4.0 (Creative Commons Attribution-ShareAlike 4.0 International).

Why CC BY-SA 4.0?

Attribution (BY): Users must give appropriate credit to you.

ShareAlike (SA): If someone remixes, transforms, or builds upon your material, they must distribute their contributions under the same license as the original. This is ideal for building an open, collaborative knowledge base.

3. Implementation Steps

To implement this strategy, you need to create two files in your repository root:

LICENSE-CODE (for the MIT License): Contains the full text of the MIT license.

LICENSE-CONTENT (for the CC BY-SA 4.0 License): Clearly links to the license text and specifies the content it applies to (e.g., "All content under the _posts/ directory...").

By clearly separating the code from the content in two different license files, you ensure both developers and content re-users understand their rights and obligations.