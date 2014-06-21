---
title: Thoughts while changing the API of a massive framework...
author: preaction
tags: rants
last_modified: 2014-06-21 00:36:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2013/04/thoughts-while-changing-the-api-of-a-massive-framework.html
---
At the Bank we have a home-grown ETL framework that we've been using for quite
some time. We recently completed a total rewrite, but unfortunately we left out
a few changes. Had I gotten those changes in 5 months ago, I would have only
had to break the API of about 10 modules. Today, in order to make those
changes, I have to break the API of 122 modules.

What follows is an account of this ordeal, provided for entertainment value
only. There will be a future post that explains some of the things I did to
make this task surmountable.

---

## Day 1

* 3:45pm - 122 modules left
* 4:31pm - 112 modules left - And then I remember there's another feature to
  add that will require another migration of all these modules I will have to do.
* 4:52pm - 106 modules left -
  [Test::Continuous](https://metacpan.org/module/Test::Continuous) removes 3
  steps for each module. Total time saved: HOLY FUCK THAT'S AWESOME
* 5:35pm - 97 modules left - Every commit message during this ordeal is another
  love note to those who put off this migration five months ago, when there were
  only 10 modules to migrate.
* 6:09pm - 94 modules left - New API to change: Create a role to do it for me!
  +100 experience points!
* 6:15pm - 93 modules left - Why unpack the hash of args passed-in to the
  method if the method you're calling takes exactly the same arguments? `my
  $arg_name = $args{arg_name}; return $self->method( arg_name => $arg_name )`
  should never happen!
* 6:37pm - 87 modules left - A thought: If the other team using this project
  ultimately rejects this API change, I get to write my own brand-new ETL
  framework from scratch! Temptation, thy name is Zoidberg.
* 6:51pm - 84 modules left - Found a bug in the new API! Finally something
  interesting to do!
* 7:00pm - 80 modules left - Every time you copy/paste code in tests, God
  inflicts another programmer with carpal tunnel. Please think of the
  programmers.

## Day 2

* 3:02pm - 80 modules left - Let's see if I remember all the macros I left in
  vim over the weekend... Test::Continuous is still running, which is nice
* 3:18pm - 71 modules left - The end is in sight!
* 4:30pm - 52 modules left - Perhaps I was premature...
* 6:30pm - 41 modules left - Caught up putting out fires in other places.
  Derail.

## Day 3

* 1:35pm - 41 modules left - Another bug in the new API. Doing it this way is
  certainly shaking out the bugs.
* 2:21pm - 20 modules left - Smooth sailing at last...
* 3:47pm - 0 modules left - AND THE CROWD GOES WILD!

Total time elapsed: 3.25+3.5+2.25 = 9 hours. Not bad for 130 commits to migrate
122 modules.
