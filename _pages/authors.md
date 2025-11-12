---
layout: page
title: All Authors
permalink: /authors.html
---

<ul>
{% for author in site.authors %}
  {% assign author_data = site.data.authors[author.author] %}
  <li>
    <a href="{{ site.baseurl }}{{ author.url }}">{% if author_data %}{{ author_data.name }}{% else %}{{ author.author }}{% endif %}</a> 
    ({{ author.posts.size }} post{% if author.posts.size != 1 %}s{% endif %})
  </li>
{% endfor %}
</ul>
