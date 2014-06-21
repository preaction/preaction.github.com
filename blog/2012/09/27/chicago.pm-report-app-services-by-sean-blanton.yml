---
title: Chicago.PM Report - App::Services by Sean Blanton
author: preaction
tags: chicago.pm
last_modified: 2014-06-21 01:12:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2012/09/chicagopm-report---appservices-by-sean-blanton.html
---

This month's technical presentation at [Chicago Perl
Mongers](http://chicago.pm.org) was about [Sean
Blanton](http://seanblanton.com)'s project called
[App::Services](https://github.com/sblanton/App-Services). It's an interesting
project that uses [Bread::Board](http://search.cpan.org/perldoc?Bread::Board)
to access resources like databases, logging, ssh, and others.

---

Along the way, we discussed logging practices (most of us are using
[Log::Log4perl](http://search.cpan.org/perldoc?Log%3A%3ALog4perl)), and the
best way to get a Perl module ready for CPAN (I suggested using
[Module::Build](http://search.cpan.org/perldoc?Module%3A%3ABuild) directly, but
[Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) outvoted me).

Sean mentioned in passing the [Salt stack](http://saltstack.org) for executing
commands across multiple machines, which looks like a very interesting
alternative to more detailed tools like Puppet or Chef. Salt seems to be just a
simple way to execute commands on multiple machines. Those commands could be
administrative (restart httpd), or they could be the application.

One other very interesting thing from App::Services was providing a role for
the larger system to use. So one creates App::Service::Log::Log4perl and
App::Service::Log::Role, and in other services you consume the
App::Service::Log::Role and then can use the Log4perl service. What's
interesting about this is that the role is provided alongside the logging
service, it isn't something that you have to create yourself. Doing it this way
improves interoperability and simplifies adoption by giving you the tedious
bits already. It's the difference between "Here's a service, figure out how to
use it best" and "Here's a service, and here's a good way to use it" (I've been
doing something similar by providing Test::MockObject implementations of my
modules for testing purposes in the same distribution as the module itself. An
"official" mock object).

In two weeks we have another project night, which I'm hoping is as productive
as the last. If you're in the Chicago area, check us out on the [Chicago Perl
Mongers meetup page](http://www.meetup.com/Windy-City-Perl-mongers-Meetup/).
