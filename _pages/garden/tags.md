---
layout: page
title: Digital Garden Tags
permalink: /garden/tags.html
---

{% assign unique_tags = site.garden | map: 'tags' | uniq | sort %}

{% if unique_tags and unique_tags.size > 0 %}
<ul>
{% for tag in unique_tags %}
  {% assign cleaned_tag = tag | strip %}
  {% assign tag_notes = site.garden | where_exp: 'note', "note.tags contains cleaned_tag" %}
  {% assign tag_count = tag_notes | size %}
  {% if tag_count > 0 %}
  <li>
    <a href="{{ site.baseurl }}/garden/tags/{{ cleaned_tag | slugify }}/">{% if site.theme_config.lowercase_titles %}{{ cleaned_tag | downcase | escape }}{% else %}{{ cleaned_tag | escape }}{% endif %}</a>
    ({{ tag_count }} page{% if tag_count != 1 %}s{% endif %})
  </li>
  {% endif %}
{% endfor %}
</ul>
{% else %}
<p>No garden tags yet—start planting!</p>
{% endif %}
