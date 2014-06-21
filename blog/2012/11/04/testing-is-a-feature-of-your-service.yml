---
title: Testing is a Feature of Your Service
author: preaction
tags: software
last_modified: 2014-06-21 01:02:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2012/11/testing-is-a-feature-of-your-service.html
---
My job at Bank of America consists largely of data collection and storage. To
collect data in Perl, I have to write XS modules to interface with the
vendor-supplied native libraries. Because I want to know my code works, my XS
modules come with robust test suites, testing that everything works correctly.

Since the XS module was intended to be used by other, larger systems, I decided
to help those larger systems test their dependency on my module: I included a
[Test::MockObject](http://search.cpan.org/perldoc?Test::MockObject) that mocked
my module's interface. By using my test module, the tests can try some data and
see if their code works.

But the hardest part to test is always the failures. How do they test if the
news service goes down in the middle of a data pull? How about if it goes down
between data pulls but still inside the same process? How do they test if the
user has input an invalid ID for data?

---

To help them write good error-checking and recovery, I added specific
Test::MockObjects that return failure conditions. Want to know what happens if
an ID is invalid? Use the Test::Feed::InvalidId mock API. Want to know what
happens if the feed goes down in the middle of a process? Use the
Test::Feed::RandomDisconnect mock API.

By providing these mock objects, users can write more robust code more simply.
Then, in the eventuality that the service fails, they know exactly what their
code won't do: Wake them up at 3 in the morning because of an unexpected,
unhandled error. These mock objects don't even need an external connection to
operate, so they can be as fast as possible.

Unfortunately, this is a limited solution that covers only what I know about.
If the service changes, or has an error I didn't cover, the code still fails.
For this reason, for the web services I build, I build in explicit ways to get
errors. When the service itself gives the exact error output it gives in
exceptional circumstances, it can be tested and handled. Instead of a mock
service, it's the real service (perhaps on a dev system), with real input,
returning a real (but desired) error message.

By providing as much help as possible to the users of my code, I can make sure
they can create robust applications that make their own users happy. By helping
users respond to and deal with the error conditions of my code, I can cut down
on the support requests and bug reports. Being proactive about testing helps
everyone write better code.
