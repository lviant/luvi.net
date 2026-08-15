<header>
    <nav>
    <div>
% for(i in $enabled_sites) {
        <a href="https://%($i%).luvi.net/" rel="me">%($i%)</a> |
% }
% cat `{ get_lib_file top_bar.inc }
    </div>
    </nav>
    <h1><a href="/">%($"siteTitle%) <span id="headerSubTitle">%($"siteSubTitle%)</span></a></h1>
</header>

% if(! ~ $#handlers_bar_left 0) {
    <nav id="side-bar">
%   for(h in $handlers_bar_left) {
        <div>
%       run_handler $$h
        </div>
%   }
    </nav>
% }

<div class="h-card" hidden>
    <a class="p-name u-email" href="mailto:lu@luvi.net">Luis Viant</a>
    <a class="h-card p-org u-url" rel="me" href="https://luvi.net/">luvi.net</a>
    <img class="u-photo" src="/_assets/PJBerri.gif" alt="PJBerri">
    <span class="p-note">Hello, I'm Lu &#x1F44B; I'm a tech worker and evangelist, infrastructure engineer, fledgling Go programmer, and photographer. This site is a collection of my thoughts, art, projects and interests in the form of a <i>lo-web</i> home page notwithstanding a lack a social media engagement.</span>
</div>

<article>
% run_handlers $handlers_body_head
% run_handler $handler_body_main
% run_handlers $handlers_body_foot
</article>

<footer>
<div></div>

<div>

% if(! ~ $"cc_exception '') {
    <small class="copyright__content">%($cc_exception%)</small>
% }
<small class="copyright__content">
    <a href="https://luvi.net/">luvi.net</a>
    &copy;
    2026
    by
% cat `{ get_lib_file footer.inc }
</small>

</div>

<div></div>
</footer>
