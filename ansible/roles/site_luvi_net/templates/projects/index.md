## A network of interesting things

> _"The more you enter, the more you become locked in. Your social-networking site becomes a central platform - a closed silo of content, and one that does not give you full control over your information in it. The more this kind of architecture gains widespread use, the more the Web becomes fragmented, and the less we enjoy a single, universal information space."_
<br><br>
> _~ Tim Berners-Lee_

### Projects hosted at luvi.net

{% for p in werc_projects if p['name'] != 'luvi.net' %}
- {{ p['emoji'] }} *[{{ p['name'] }}]({{ p['url'] }}) ~* {{ p['desc'] }}
{% endfor %}
