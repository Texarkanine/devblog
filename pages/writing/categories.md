---
layout: page
title: Writing Categories
permalink: /writing/categories/
---

<ul>
{% for path in site.data.writing_folders %}
  <li><a href="{{ site.baseurl }}/writing/{{ path }}/">{{ path | split: "/" | last | escape }}</a></li>
{% endfor %}
</ul>
