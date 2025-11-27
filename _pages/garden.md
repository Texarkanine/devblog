---
layout: page
title: Digital Garden
---

{% assign garden_size = site.garden | size %}
{% if garden_size > 1 %}
  {% assign shuffled_garden = site.garden | sample: garden_size %}
{% else %}
  {% assign shuffled_garden = site.garden %}
{% endif %}

<ul>
{% for post in shuffled_garden %}
  <li><a href="{{ post.url | relative_url }}">{% if site.theme_config.lowercase_titles %}{{ post.title | downcase | escape }}{% else %}{{ post.title | escape }}{% endif %}</a></li>
{% endfor %}
</ul>
