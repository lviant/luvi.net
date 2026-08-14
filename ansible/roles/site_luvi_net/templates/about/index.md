## About

> _"Sharing is good, and with digital technology, sharing is easy."_
<br><br>
> _~ Richard Stallman_

<p style="text-align: center;">
<small><i>Last updated: {{ '%Y-%m-%d %R %Z' | strftime }}</i></small>
</p>

### `whoami`

Hello, I'm Lu &#x1F44B; I'm a tech worker and evangelist, infrastructure engineer, fledgling Go programmer, and photographer. This site is a collection of my thoughts, art, projects and interests in the form of a _lo-web_ home page notwithstanding a lack a social media engagement.

### Tech stuff

This project was mainly started to experiment and play around HTML and CSS (no [_secret JavaScript blobs_](https://www.gnu.org/philosophy/javascript-trap.html) here). Check out the [source code](https://gitlab.com/luisviant/luvi-net/)!

#### Built with

- &#x1F421; [OpenBSD](https://openbsd.org/) and [httpd](https://man.openbsd.org/httpd.8).
- &#x1F430; A [port](https://9fans.github.io/plan9port/) of [Plan 9 from Bell Labs](https://en.wikipedia.org/wiki/Plan_9_from_Bell_Labs).
- &#x1F308; The magic of [CGI](https://en.wikipedia.org/wiki/Common_Gateway_Interface).
- &#x1F9F0; [Ansible](https://docs.ansible.com/projects/ansible/latest/index.html) for server configuration and templating.

#### _lo-web_ fun

{% for b in werc_about_banners %}
{% if b['url'] is defined %}
<a href="{{ b['url'] }}">
{% endif %}
<img src="{{ b['src'] }}" alt="{{ b['name'] }}" height="31px" width="88px">
{% if b['url'] is defined %}
</a>
{% endif %}
{% endfor %}
