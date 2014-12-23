---
title: Adventures in Debugging C/XS
author: preaction
tags: xs
last_modified: 2014-06-21 01:25:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2011/11/adventures-in-debugging-cxs.html
---

... or Why A Good Perl Developer Is Not Automatically A Good C Developer, the
Story of C Programming via Google.

My tests failed, but only sometimes. I was building an XS module to interface
with a C wrapper around a C++ library (wrapper unnecessary? probably). `make
test` was failing with exit code 11. Some quick searching revealed that I had
an intermittent segfault. Calling a function `as_xml` would fail with a SEGV in
`strlen()`. This only happened in perl after `as_xml` when perl was making a SV
out of the return value. This also only mainly happened during `make test`.
Doing `prove` myself would succeed 19 times out of 20, where make test would
fail 19 times out of 20. Worse, my C test program would never fail at all.

---

I changed everything I could think of: Using a debugging perl and keeping debug
symbols in my C library and XS module made the failures happen less frequently
(making debugging ever more frustrating). perlbrew was a big help here, letting
me switch between different versions of perl, debugging perl, threaded perl,
and combinations thereof.

After playing with GDB (once again succeeding 19 times out of 20), I gave up
and searched the web. I found [the same mailing list
thread](http://bit.ly/vwnMbb) multiple times, and read it multiple times, not
coming up with anything that was relevant to my situation.

Until I read the thread again after another frustrating half-hour with GDB: I
had forgotten to put a prototype in the .h file, causing the char* pointer
being returned to be treated as an int. On my 64-bit system, this causes
segfaults. The compiler was warning me of this, "<tt>warning: initialization
makes pointer from integer without a cast</tt>", but I didn't understand the
warning (and the web was not helpful on that one).

Adding the function prototype to the C wrapper header and recompiling fixed the
problem.

And that is why I need to learn a lot more about C. Function prototypes?
Header files? Why are those necessary (I'm asking rhetorically, of course)?
Heap and stack? Might as well be herp and derp.

Lesson reinforced: Depth of knowledge does not equal breadth of knowledge.

Also, having IRC at work might have saved me a few hours of hassle.
