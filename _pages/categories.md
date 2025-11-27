---
layout: page
title: All Post Categories
permalink: /categories.html
---

{%- assign category_blacklist = "blog" -%}

{% capture categories %}
	{% for category in site.categories %}
		{%- assign cat_title = category[0] -%}
		{%- if category_blacklist contains cat_title -%}
			{%- continue -%}
		{%- endif -%}
		{{ category[1].size | plus: 1000 }}#{{ cat_title }}#{{ category[1].size }}
	{% endfor %}
{% endcapture %}
{% assign sorted_categories = categories | split:' ' | sort %}

<ul>
{% for category in sorted_categories reversed %}
	{% assign categoryitems = category | split: '#' %}
	<li><a href="{{ site.baseurl }}/categories/{{ categoryitems[1] | slugify }}/">{% if site.theme_config.lowercase_titles %}{{ categoryitems[1] | downcase | escape }}{% else %}{{ categoryitems[1] | escape }}{% endif %}</a> ({{ categoryitems[2] }} post{% if categoryitems[2] != 1 %}s{% endif %})</li>
{% endfor %}
</ul>
