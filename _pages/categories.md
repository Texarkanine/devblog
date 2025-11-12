---
layout: page
title: All Categories
permalink: /categories.html
---

<ul>
{% for category in site.categories %}
  <li><a href="{{ site.baseurl }}/categories/{{ category[0] | slugify }}/">{{ category[0] }}</a> ({{ category[1].size }} post{% if category[1].size != 1 %}s{% endif %})</li>
{% endfor %}
</ul>
