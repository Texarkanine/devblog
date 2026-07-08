---
layout: garden
title: "Shrines"
description: "Curated collections, each devoted to one thing worth revering."
---

A shrine is a small collection built in devotion to a single subject. There are many like them, but these are mine.

<ul>
  {%- assign shrine_pages = site['garden'] | where_exp: "item", "item.path contains '/shrine/' and item.path contains '/index.md' and item.path != '_garden/shrine/index.md'" -%}
  {%- for item in shrine_pages -%}
    <li>
      {% if site.theme_config.lowercase_titles == true %}
      <a href="{{ item.url | relative_url }}">{{ item.title | downcase }}</a>
      {% else %}
      <a href="{{ item.url | relative_url }}">{{ item.title }}</a>
      {% endif %}
    </li>
  {%- endfor -%}
</ul>
