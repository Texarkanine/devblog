# DevBlog

https://blog.cani.ne.jp/

## Local Development

1. Have Ruby & Bundler installed
2. 
	```bash
	bundle install
	bundle exec jekyll serve
	```

## Media Workflow (Git LFS)

1. Install Git LFS once per machine: `git lfs install`
2. Add large images under `assets/img/**` so they are tracked automatically by `.gitattributes`
3. When adding new file types, run `git lfs track` for the extension and commit the updated `.gitattributes`
4. The GitHub Actions pipeline runs `scripts/copy_media.rb` to mirror `assets/img` into `_site/assets/img` before publishing.

## License

- **Code & Templates:** [LICENSE-CODE](LICENSE-CODE) (MIT)
- **Blog Content:** [LICENSE-CONTENT](LICENSE-CONTENT) (CC BY-SA 4.0)
