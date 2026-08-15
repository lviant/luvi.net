<!DOCTYPE HTML>
<html lang="en">
<head>

    <title>%($pageTitle%)</title>
% # Legacy charset declaration for backards compatibility with non-html5 browsers.
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 

    <link rel="stylesheet" href="/pub/style/style.css" type="text/css" media="screen" title="default">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
    <link rel="manifest" href="/site.webmanifest">
% if(test -f $sitedir/_werc/pub/style.css)
%    echo '    <link rel="stylesheet" href="/_werc/pub/style.css" type="text/css" media="screen" title="default">'

    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="keywords" content="Luis Viant, Viant, luvi, gameboy, hanafuda, photography, game boy, memes, go, golang">

% {
    <meta name="title" content="%($pageTitle%)" />

    <meta property="og:title" content="%($pageTitle%)" />
    <meta property="twitter:title" content="%($pageTitle%)" />

    <meta property="og:url" content="https://%($site_url%)/" />
    <meta property="twitter:url" content="https://%($site_url%)/" />
% }

    <meta property="og:type" content="website" />

% if(! ~ $#meta_description 0) {
    <meta name="description" content="%($meta_description%)" />
    <meta property="og:description" content="%($meta_description%)" />
% }

% h = `{get_lib_file headers.inc}
% if(! ~ $#h 0)
%   cat $h

    %($"extraHeaders%)

</head>
<body>

