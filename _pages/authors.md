---
layout: page
title: All Authors
permalink: /authors.html
---


<ul>
{% for entry in site.data.authors %}
  {% assign author_id = entry[0] %}
  {% assign author_info = entry[1] %}
  {% assign display_name = author_info.name | default: author_id %}
  {% assign author_slug = author_id | slugify %}
  {% assign author_posts = site.posts | where: "author", author_id %}
  {% assign post_count = author_posts | size %}
  <li>
    <a href="{{ site.baseurl }}/authors/{{ author_slug }}">
      {% if site.theme_config.lowercase_titles %}{{ display_name | downcase | escape }}{% else %}{{ display_name | escape }}{% endif %}</a>
    {% if post_count > 0 %}
      ({{ post_count }} post{% if post_count != 1 %}s{% endif %})
    {% endif %}
  </li>
{% endfor %}
</ul>
