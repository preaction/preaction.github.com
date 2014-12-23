---
title: What's new in WebGUI 8.0 #1 - PSGI/Plack
author: preaction
tags: webgui
last_modified: 2014-06-21 01:42:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2011/01/whats-new-in-webgui-80-1---psgiplack.html
---

## Overview

On September 9, 2009, WebGUI 8 was announced. Since it was the first major API
change since WebGUI 7, we started planning WebGUI 8 with high expectations.
Over the course of the last 16 months:

* We've adopted PSGI/Plack as our platform, enabling us to work in any HTTP
  environment.
* We've made massive changes to the Asset system to make them easier to build.
* We've reworked Auth to make it easier to add Twitter and Facebook
  authentication for your users.
* We've rebuilt the upgrade system to be easier for developers and system
  administrators.
* There is a new caching system enabling memcached and local memory caches.
* The entire content management interface was rebuilt from scratch with the
  latest buzzword-worthy technologies.
* Assets are now based on Moose, the new object-oriented system for Perl.
* We've created WebGUI::FormBuilder, a way to make introspect-able forms.
* We're migrating to InnoDB to take advantage of transactions and foreign key
  constraints.
* We're making a brand-new WRE based on Nginx, and Server::Starter for more
  efficient resource usage and no-downtime restarts.

And these are just the major features. We've cleaned up and straightened out a
lot of the crooked parts of programming in WebGUI, and we have plans to do even
more. We've greatly improved the flexibility of WebGUI without compromising any
more backward compatibility.

## Ambition is the first step

Unfortunately, our ambitious goals have taken longer than we thought. We had
promised a WebGUI 8.0 Beta in January, and I have to say that isn't possible.
The way things look right now, WebGUI 8.0 will be ready this summer.

So, as atonement and apology, I offer this series of bi-weekly blog posts about
all the new stuff in WebGUI 8.

## PSGI / Plack

The most exciting change in WebGUI 8 is the move to PSGI using Plack. WebGUI is
no longer just an Apache/mod_perl application, though it can certainly still
run under Apache/mod_perl. Now, WebGUI can also run under Starman, a
high-performance web server specifically for PSGI applications. WebGUI can run
inside POE. WebGUI can once again run as CGI. We are no longer tied to one way
of deploying WebGUI, and that greater flexibility will allow for better
performance for your specific need.

    #!/usr/bin/env perl
    # webgui.cgi - Run WebGUI as a CGI application
    use lib 'lib';
    use Plack::Loader;
    use Plack::Handler::CGI;
    $ENV{WEBGUI_CONFIG} = "www.example.com.conf";
    my $app = Plack::Util::load_psgi("share/site.psgi");
    Plack::Handler::CGI->new->run($app);

Since WebGUI is just a PSGI application, it can also run alongside any other
PSGI applications. WebGUI and Catalyst can work together on the same site.

For example, here's WebGUI and Pod::Browser running together. Pod::Browser
takes /doc and serves the WebGUI POD, every other request goes to WebGUI.

    # pod.psgi
    use lib 'lib';
    use Plack::Builder;
    use Plack::Util;

    BEGIN {
        $ENV{POD_BROWSER_CONFIG} = "pod_browser.json";
    }
    use Pod::Browser;
    use Catalyst::Engine::PSGI;
    Pod::Browser->setup_engine('PSGI');

    $ENV{WEBGUI_CONFIG} = "core.conf";
    use WebGUI;

    builder {
        mount "/doc" => sub { Pod::Browser->run(@_); };
        mount "/" => Plack::Util::load_psgi("share/site.psgi");
    };

    # pod_browser.json
    {
        "Controller::Root" : {
            "self" : 1,
            "inc" : 1,
            "namespaces" : [ "WebGUI*" ]
        }
    }

For developers, Plack opens up new ways of building WebGUI sites. Instead of
WebGUI::URL handlers, now we use Plack middleware to handle such tasks as:

* Opening the WebGUI::Session
* Handling /extras and /uploads
* Showing the maintenance page, if necessary
* Handling the wgaccess files for uploads permissions
* Showing debugging information and performance indicators

By using more flexible tools, we can write more reusable code. You can write a
Plack middleware for WebGUI that will work in your other Plack applications,
and WebGUI can take advantage of the middleware out there on CPAN. 

Plack middleware currently only replaces URL handlers, but someday we can
replace WebGUI::Content handlers as well. WebGUI's pieces can be mixed and
matched to create your own applications without using parts of WebGUI that you
don't need.

By switching to PSGI/Plack, we've made WebGUI easier to deploy and easier to
develop.

Next time, I'll talk about the improvements to the WebGUI Auth API.
