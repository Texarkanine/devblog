---
layout: page
title: All Tags
permalink: /tags.html
---

<ul>
{% for tag in site.tags %}
  <li><a href="{{ site.baseurl }}/tags/{{ tag[0] | slugify }}/">{{ tag[0] }}</a> ({{ tag[1].size }} post{% if tag[1].size != 1 %}s{% endif %})</li>
{% endfor %}
</ul>
