# People on the internet

> _"The World is my country, all mankind are my brethren, and to do good is my religion."_

> _~ Thomas Paine_

## Friends and people I find interesting

{% for p in werc_people_links %}
- *[{{ p['name'] }}]({{ p['url'] }}) ~* {{ p['desc'] }}
{% endfor %}
