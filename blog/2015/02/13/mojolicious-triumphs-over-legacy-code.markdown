---
last_modified: 2015-02-13 20:55:21
tags: mojolicious, perl
title: Mojolicious Triumphs Over Legacy Code
links:
    alternate:
        title: blogs.perl.org
        href: 'http://blogs.perl.org/users/preaction/2015/02/mojolicious-triumphs-over-legacy-code.html'
---
I got a text at 8:00am:

> "Hey, can you jump on a conference call?"

Groggy and disoriented, I blearily type the conference line and enter my
passcode, followed by the pound or hash sign. At the tone, I would be the 6th
person to enter the conference. Tone.

> "The app is down, and trading has stopped."

---

Well, yes, their application is down because I spent all night playing
Whack-a-Mole, banning every IP address they have. Hundreds of them. Their app
was destroying my service, and denying data to the users who weren't abusing
it.

The previous day, I had tried putting nginx in front to try to load balance. It
didn't help: The legacy Catalyst application was I/O bound on long, blocking
database reads. That's not Catalyst's fault. Our web service was never
developed for speed. It wasn't meant to perform well. It was meant for internal
support of a few dozen spreadsheets. If the user wanted performance, they could
read from the database directly through any number of APIs that we provide.

> "Since this API is so slow, we put it on the compute grid. Could that have
> caused this?"

So instead of a few dozen spreadsheets, I had a few hundred python scripts
hitting my web service. The poor thing just could not cope.

> "Can't you make it faster? Can we rewrite the web service?"

No. At least, not all of it. But perhaps we can rewrite just this one URL for
better performance using all our new modern async APIs.

3 hours later, I've hacked a simple [Mojolicious](http://mojolicio.us)
application that behaves exactly like the old application, except the
Mojolicious app, in a single process, can scale to 100 concurrent requests.

Adding [hypnotoad](http://mojolicio.us/perldoc/Mojo/Server/Hypnotoad) and
nginx, and my tiny Mojolicious app could now scale to 400 users before things
started going awry (responses were still within 3 seconds, but sockets would be
reset. Must be some OS settings to manage).

But I've still got a problem: How do I make absolutely sure that the input and
the output are exactly the same?

We have an access log. And we have the old web app. Let's make a comparison!

Quickly, I used [Mojo::UserAgent](http://mojolicio.us/perldoc/Mojo/UserAgent)
to request a URL from the old app, and then
[Test::Mojo](http://mojolicio.us/perldoc/Test/Mojo) to request the URL from the
new app, and did a stringy comparison against the two. Some of the failure
modes were different (the old app built an XML::LibXML object, the new app uses
templates to build XML), but after adjusting the template's whitespace a bit,
the new app and the old app have exactly the same output, just in case some
user is doing something stupid, like [parsing XML with regular
expressions](http://stackoverflow.com/a/1732454).

A grand total of 5 hours later, and I had a replacement for the
poorest-performing web service, with more automated tests than the old version
had (none). A quick reconfiguration of nginx to proxy the desired requests to
the new webapp, and everything kept going exactly as it had before anyone
thought of just hammering a random web service with hundreds of concurrent
requests.

Maybe next time I'll start sending them bogus data instead...
