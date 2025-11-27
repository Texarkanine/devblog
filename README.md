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

## License

- **Code & Templates:** [LICENSE-CODE](LICENSE-CODE) (MIT)
- **Blog Content:** [LICENSE-CONTENT](LICENSE-CONTENT) (CC BY-SA 4.0)
