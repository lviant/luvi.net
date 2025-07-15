<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Press+Start+2P">

## Epcot At Night

Uploaded: 2024.12.07

{% for f in lookup('fileglob', role_path + '/files/werc/sites/gameboy.luvi.net/epcot/*') | split(',') | select('match', '.*\.(BMP)$') -%}
<div class="responsive">
  <a href="{{ f | basename }}">
    <img src="{{ f | basename}}" alt="{{ f | basename | splitext | first }}" class="image">
  </a>
</div>
{% endfor %}
