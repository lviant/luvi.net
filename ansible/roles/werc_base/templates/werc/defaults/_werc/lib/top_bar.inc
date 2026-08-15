    <div>
{% for p in werc_projects %}
        <a href="{{ p['url'] }}"{% if p.get('target_blank') %} target="_blank"{% endif %} rel="me">{{ p['label'] }}</a> |
{% endfor %}
        <a href="https://gitlab.com/luisviant/luvi.net" target="_blank">src</a> |
        <a href="https://luvi.net">luvi.net</a>
    </div>
