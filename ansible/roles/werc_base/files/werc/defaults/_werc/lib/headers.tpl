<!DOCTYPE HTML>
<html>
<head>

    <title>%($pageTitle%)</title>

    <link rel="stylesheet" href="/pub/style/style.css" type="text/css" media="screen, handheld" title="default">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
    <link rel="manifest" href="/site.webmanifest">
% if(test -f $sitedir/_werc/pub/style.css)
%    echo '    <link rel="stylesheet" href="/_werc/pub/style.css" type="text/css" media="screen" title="default">'

    <meta charset="UTF-8">
% # Legacy charset declaration for backards compatibility with non-html5 browsers.
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

% if(! ~ $#meta_description 0)

% h = `{get_lib_file headers.inc}
% if(! ~ $#h 0)
%   cat $h

    %($"extraHeaders%)

    <div class="h-card" hidden>
        <a class="p-name u-email" href="mailto:lu@luvi.net">Luis Viant</a>
        <a class="h-card p-org u-url u-uid" href="https://luvi.net/">luvi.net</a>
		<img class="u-photo" src="https://avatars.githubusercontent.com/u/5025623?s=400&u=cbd54fd93869db9cb15683e9e852cf4c7f543f04&v=4"></img>
		<span class="p-note">Hello, I'm Lu &#x1F44B; I'm a tech worker and evangelist, infrastructure engineer, fledgling Go programmer, and photographer. This site is a collection of my thoughts, art, projects and interests in the form of a <i>lo-web</i> home page notwithstanding a lack a social media engagement.</span>
    </div>

</head>
<body>

