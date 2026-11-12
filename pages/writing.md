---
layout: page
title: Writing
permalink: /writing/
---

<p>
  <a href="{{ site.baseurl }}/writing/tags/">tags</a>
  <a href="{{ site.baseurl }}/writing/categories/">categories</a>
</p>

{% assign pieces = site.writing | sort: "date" | reverse %}
<ul>
{% for piece in pieces %}
  <li>{{ piece.date | date: "%Y-%m-%d" }} <a href="{{ piece.url | relative_url }}">{{ piece.title | escape }}</a></li>
{% endfor %}
</ul>
