{% for f in lookup('fileglob', site_role_path + '/files/*', wantlist=True) | select('match', '.*\.(jpg|gif|png|webp)$') -%}
<div class="responsive">
  <div class="container">
    <a href="{{ f | basename }}">
      <img src="{{ f | basename}}" alt="{{ f | basename | splitext | first }}" class="image">
      <div class="overlay">
        <div class="text">{{ f | basename | splitext | first }}</div>
      </div>
    </a>
  </div>
</div>
{% endfor %}
