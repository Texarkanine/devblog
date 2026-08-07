---
layout: page
title: All Post Tags
permalink: /tags/
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
	{% assign tag_count = tagitems[2] | plus: 0 %}
	{% if tag_count > 1 %}
	<li><a href="{{ site.baseurl }}/tags/{{ tagitems[1] | slugify }}/">{% if site.theme_config.lowercase_titles %}{{ tagitems[1] | downcase | escape }}{% else %}{{ tagitems[1] | escape }}{% endif %}</a> ({{ tag_count }} post{% if tag_count != 1 %}s{% endif %})</li>
	{% endif %}
{% endfor %}
</ul>
