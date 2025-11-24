# Fix Lowercase Titles and Categories Issues

## Issues Identified
1. **Lowercase titles**: `lowercase_titles: true` only affects homepage, not author/tag/category pages
2. **Categories page**: Shows no categories even though posts are in `diary/` and `record/` subdirectories

## Tasks

### 1. Fix Lowercase Titles on Archive Pages
- [ ] Update `_layouts/tag-archive.html` to apply lowercase filter when `lowercase_titles` is enabled
- [ ] Update `_layouts/author-archive.html` to apply lowercase filter when `lowercase_titles` is enabled  
- [ ] Update `_pages/all-posts.md` to apply lowercase filter when `lowercase_titles` is enabled
- [ ] Update `_pages/tags.md` to apply lowercase filter when `lowercase_titles` is enabled
- [ ] Update `_pages/authors.md` to apply lowercase filter when `lowercase_titles` is enabled
- [ ] Update `_pages/categories.md` to apply lowercase filter when `lowercase_titles` is enabled
- [ ] Update `_layouts/post.html` footer tags to apply lowercase filter when `lowercase_titles` is enabled

### 2. Fix Categories Page
- [ ] Verify categories are being generated from folder structure
- [ ] Test categories page after build
- [ ] Fix categories page template if needed

### 3. Testing
- [ ] Build site and verify lowercase titles work on all pages
- [ ] Verify categories page shows diary and record categories
- [ ] Verify tag/author/category archive pages show lowercase post titles

