<!DOCTYPE HTML>
<html>
<head>

    <title>%($pageTitle%)</title>

    <link rel="stylesheet" href="/pub/style/style.css" type="text/css" media="screen, handheld" title="default">
    <link rel="shortcut icon" href="/favicon.ico" type="image/vnd.microsoft.icon">
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

</head>
<body>

