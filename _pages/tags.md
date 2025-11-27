---
layout: page
title: All Post Tags
---

{% capture tags %}
	{% for tag in site.tags %}
		{{ tag[1].size | plus: 1000 }}#{{ tag[0] }}#{{ tag[1].size }}
	{% endfor %}
{% endcapture %}
{% assign sorted_tags = tags | split:' ' | sort %}

<ul>
{% for tag in sorted_tags reversed %}
	{% assign tagitems = tag | split: '#' %}
	<li><a href="{{ site.baseurl }}/tags/{{ tagitems[1] | slugify }}/">{% if site.theme_config.lowercase_titles %}{{ tagitems[1] | downcase | escape }}{% else %}{{ tagitems[1] | escape }}{% endif %}</a> ({{ tagitems[2] }} post{% if tagitems[2] != 1 %}s{% endif %})</li>
{% endfor %}
</ul>
