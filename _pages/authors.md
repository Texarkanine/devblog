---
layout: page
title: All Authors
permalink: /authors.html
---

<ul>
{% for author in site.authors %}
  {% assign author_data = site.data.authors[author.author] %}
  <li>
    <a href="{{ site.baseurl }}{{ author.url }}">{% if author_data %}{% if site.theme_config.lowercase_titles %}{{ author_data.name | downcase | escape }}{% else %}{{ author_data.name | escape }}{% endif %}{% else %}{% if site.theme_config.lowercase_titles %}{{ author.author | downcase | escape }}{% else %}{{ author.author | escape }}{% endif %}{% endif %}</a> 
    ({{ author.posts.size }} post{% if author.posts.size != 1 %}s{% endif %})
  </li>
{% endfor %}
</ul>
