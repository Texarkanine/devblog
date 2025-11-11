---
layout: page
title: All Authors
permalink: /authors.html
---

<ul>
{% for author_hash in site.data.authors %}
  {% assign author_id = author_hash[0] %}
  {% assign author = author_hash[1] %}
  {% assign posts_by_author = site.posts | where: "author", author_id %}
  {% if posts_by_author.size > 0 %}
  <li>
    <a href="{{ site.baseurl }}/authors/{{ author_id | slugify }}/">{{ author.name }}</a> 
    ({{ posts_by_author.size }} post{% if posts_by_author.size != 1 %}s{% endif %})
  </li>
  {% endif %}
{% endfor %}
</ul>
