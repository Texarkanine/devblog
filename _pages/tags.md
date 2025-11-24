---
layout: page
title: All Tags
permalink: /tags.html
---

<ul>
{% for tag in site.tags %}
  <li><a href="{{ site.baseurl }}/tags/{{ tag[0] | slugify }}/">{% if site.theme_config.lowercase_titles %}{{ tag[0] | downcase | escape }}{% else %}{{ tag[0] | escape }}{% endif %}</a> ({{ tag[1].size }} post{% if tag[1].size != 1 %}s{% endif %})</li>
{% endfor %}
</ul>
