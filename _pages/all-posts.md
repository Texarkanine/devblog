---
layout: page
title: All Posts
permalink: /all-posts.html
---

<ul>
{% for post in site.posts %}
  <li>{{ post.date | date: "%Y-%m-%d" }} <a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
