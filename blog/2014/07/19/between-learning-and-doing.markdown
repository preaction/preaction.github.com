---
title: Between Learning and Doing
author: preaction
tags: rants
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2014/07/between-learning-and-doing.html
---
![I've made a huge mistake](/blog/images/ive-made-a-huge-mistake.gif)

A long time ago, when I started building my first video game server for
[Double Cluepon](http://doublecluepon.com), my video game company, I did a bad
thing. I looked at the AMF library for Perl and Python and decided that
Python's looked better. I had always meant to learn Python, and this felt like
the perfect opportunity. It had cooperative multitasking (Twisted) and it had
an ORM (SQLAlchemy), so along with the messaging format (PyAMF), I had
everything I needed to build a server for a Flash MMO (later migrated to AIR).

Let me reiterate my mistake: While under time constraints, I chose to learn a
new programming language. I didn't realize my mistake until it was too late.

---

Being a startup (still), we needed something **As Quickly As Possible**. So, I
cobbled together a marginally-working system from all the examples I could
find. Not being familiar with Python's strengths and weaknesses, I tripped over
everything, getting more and more frustrated (but still absolutely convinced I
had chosen the correct path). When we needed an integrated website, something I
already knew how to build in Perl which did not need the aforementioned library
which was the reason to use Python, I kept it in Python to "keep the number of
languages in active use in the company to a minimum."

In the end, I had something that technically worked, but was more akin to
something an amateur programmer would produce. **All my experience was worthless
while I was trying to learn a new language, new libraries, and new ways of
doing the things I already knew how to do.**

With our new game, I almost did it again: I was going to write the server
component in C++ so that it could be compiled in to the game client to
provide for LAN gaming (which is another horrible excuse to learn new
things while under time constraints). Lucky for me, some good old-fashioned
laziness has again put me under time pressure, and the most expedient way
forward is to do what I know: Perl.

Learning new things is a good idea, but it's hard to learn new things while
you're also trying to get things done. If you need to get things done quickly,
be very careful before deciding to use something new.
