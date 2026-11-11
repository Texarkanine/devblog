---
layout: page
title: Writing Categories
permalink: /writing/categories/
---

{% assign writing_categories = site.writing_categories | default: site.data.writing_categories %}
<ul>
{% for category in writing_categories %}
  <li><a href="{{ site.baseurl }}/writing/categories/{{ category[0] | slugify }}/">{{ category[0] | escape }}</a></li>
{% endfor %}
</ul>
