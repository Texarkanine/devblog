---
layout: page
title: Writing Tags
permalink: /writing/tags/
---

{% assign writing_tags = site.writing_tags | default: site.data.writing_tags %}
<ul>
{% for tag in writing_tags %}
  {% if tag[1].size >= 2 %}
  <li><a href="{{ site.baseurl }}/writing/tags/{{ tag[0] | slugify }}/">{{ tag[0] | escape }}</a></li>
  {% endif %}
{% endfor %}
</ul>
