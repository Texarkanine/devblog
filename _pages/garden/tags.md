---
layout: page
title: Digital Garden Tags
permalink: /garden/tags/
---

{% assign random_seed = site.time | date: '%s' | modulo: 2 %}
{% assign garden_tags = site.garden_tags | default: site.data.garden_tags %}

{% if random_seed == 0 %}
	{% comment %}Sort by count: build sortable format, sort, then normalize to tag#count{% endcomment %}
	{% capture tags %}
		{% for tag in garden_tags %}
			{{ tag[1].size | plus: 1000 }}#{{ tag[0] }}#{{ tag[1].size }}
		{% endfor %}
	{% endcapture %}
	{% assign sorted_raw = tags | split:' ' | sort | reverse %}
	{% capture sorted_tags %}
		{% for item in sorted_raw %}
			{% assign parts = item | split: '#' %}
			{{ parts[1] }}#{{ parts[2] }}
		{% endfor %}
	{% endcapture %}
	{% assign sorted_tags = sorted_tags | split:' ' %}
{% else %}
	{% comment %}Sort alphabetically{% endcomment %}
	{% capture tags %}
		{% for tag in garden_tags %}
			{{ tag[0] }}#{{ tag[1].size }}
		{% endfor %}
	{% endcapture %}
	{% assign sorted_tags = tags | split:' ' | sort %}
{% endif %}

<ul>
{% for tag in sorted_tags %}
	{% assign tagitems = tag | split: '#' %}
	{% if tagitems.size == 2 and tagitems[0] != '' and tagitems[1] != '' %}
		<li><a href="{{ site.baseurl }}/garden/tags/{{ tagitems[0] | slugify }}/">{% if site.theme_config.lowercase_titles %}{{ tagitems[0] | downcase | escape }}{% else %}{{ tagitems[0] | escape }}{% endif %}</a> ({{ tagitems[1] }} page{% if tagitems[1] != 1 %}s{% endif %})</li>
	{% endif %}
{% endfor %}
</ul>
