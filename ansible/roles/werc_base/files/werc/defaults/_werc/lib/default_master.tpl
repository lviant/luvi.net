<header>
    <nav>
% cat `{ get_lib_file top_bar.inc }
    </nav>
    <div class="h-card" id="site-card"><h1>
        <div class="p-name" hidden>Luis Viant</div>
        <a class="u-url" href="/">%($"siteTitle%) <span id="headerSubTitle">%($"siteSubTitle%)</span></a>
    </h1></div>
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

<article>
% run_handlers $handlers_body_head
% run_handler $handler_body_main
% run_handlers $handlers_body_foot
</article>

<footer>
% cat `{ get_lib_file footer.inc }
</footer>
