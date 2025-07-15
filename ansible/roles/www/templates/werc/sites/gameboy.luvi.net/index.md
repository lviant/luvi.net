<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Press+Start+2P">

<div>
  <div class="carousel">
    <ul class="slides">
{% set bmp_files = [] -%}
{% for f in lookup('filetree', role_path + '/files/werc/sites/gameboy.luvi.net')-%}
    {% if 'BMP' in f.path -%}
        {{ bmp_files.append(f.path) }}
    {% endif %}
{% endfor -%}
{% for n in range(gameboy_carousel_len) -%}
    {% set rand_bmp = bmp_files | random %}
      <input type="radio" name="radio-buttons" id="img-{{ n + 1}}" checked />
      <li class="slide-container">
        <div class="slide-image">
          <img src="{{ rand_bmp }}">
        </div>
        <div class="carousel-controls">
    {% if loop.first  %}
          <label for="img-{{ loop.length }}" class="prev-slide">
    {% else %}
          <label for="img-{{ n }}" class="prev-slide">
    {% endif %}
            <span>&lsaquo;</span>
          </label>
    {% if loop.last  %}
          <label for="img-1" class="next-slide">
    {% else %}
          <label for="img-{{ n + 2 }}" class="next-slide">
    {% endif %}
            <span>&rsaquo;</span>
          </label>
        </div>
      </li>
{% endfor %}
      <div class="carousel-dots">
{% for n in range(gameboy_carousel_len) %}
        <label for="img-{{ n + 1 }}" class="carousel-dot" id="img-dot-{{ n + 1 }}"></label>
{% endfor %}
      </div>
    </ul>
  </div>
</div>
