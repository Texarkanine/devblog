---
layout: page
title: All Posts
permalink: /all-posts.html
---

<ul>
{% for post in site.posts %}
  <li>{{ post.date | date: "%Y-%m-%d" }} <a href="{{ post.url | relative_url }}">{% if site.theme_config.lowercase_titles %}{{ post.title | downcase | escape }}{% else %}{{ post.title | escape }}{% endif %}</a></li>
{% endfor %}
</ul>
