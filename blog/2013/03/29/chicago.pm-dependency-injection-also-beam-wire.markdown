---
title: Chicago.PM - Dependency Injection (also: Beam::Wire)
author: preaction
tags: chicago.pm
last_modified: 2014-06-21 00:43:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2013/03/chicagopm---dependency-injection-also-beamwire.html
---

At [this month's Chicago.PM
meeting](http://www.meetup.com/Windy-City-Perl-mongers-Meetup/events/104681992/),
I gave [a presentation on Dependency Injection and my new module,
Beam::Wire](http://preaction.github.com/Perl/Dependency-Injection.html).

[EDIT: The presentation doesn't appear to work on mobile devices. I'm trying
deck.js, and I'm not sure I like it.]

---

When I started my current job, I was introduced to the custom Dependency
Injection framework they built. At the time, I was dismissive: "It's
programming via config file, which is always limiting (and so, a Bad
Idea)." "It's something that Java needs, but not Perl."

Slowly, and with great reluctance, I learned where dependency injection fits
into a large framework: It removes the work of creating objects. Any object.
Anywhere.

For an idea of how powerful this is, do a quick search through your libraries
and scripts (except for tests) for /->new/. Hopefully, the results will only be
defaults (otherwise you've got tight coupling, another problem DI can fix). But
every time you call an object constructor is another place where dependency
injection can reduce the amount of code you write and maintain.

So, since the bureaucracy means I can't simply open-source the DI framework we
have at $dayjob, I decided to make my own.

[Beam::Wire](http://metacpan.org/modules/Beam::Wire) is [available on
CPAN](http://search.cpan.org/~preaction/Beam-Wire/). There are a lot of
features planned for it, so stay tuned! If you're interested, [up-vote
Beam::Wire on play-perl](http://play-perl.org/quest/5130110d20d03f841200005b).
