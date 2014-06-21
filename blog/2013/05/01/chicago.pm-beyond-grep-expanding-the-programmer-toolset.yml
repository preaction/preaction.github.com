---
title: Chicago.PM - Beyond grep - Expanding the Programmer Toolset
author: preaction
tags: chicago.pm
last_modified: 2014-06-21 00:25:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2013/05/chicagopm---beyond-grep---expanding-the-programmer-toolset.html
---

Last week, [Andy Lester](http://petdance.com) (author of [Land the Tech Job You
Love](http://petdance.com/book/)) came to talk about tools to help programmers
work more efficiently and the 2.0 release of his [Ack search
tool](http://beyondgrep.com).

---

If you haven't tried Ack, but you use long, complicated Grep lines every day,
you're missing out on a great, time-saving tool. [Installing
ack](http://beyondgrep.com/install) is easy on many platforms (including
Windows!).

For those who have added Ack to their regular arsenal, the 2.0 release brings
some minor breaking changes (removing the -a option for "search all files" and
changing the default file type filter to "all text files") designed to make Ack
more Do-What-I-Mean and more compatible with Grep (when it makes sense, ack is
made for humans). The result being that using Ack should not take you out of
The Zone by requiring you to check the manual every time (something I must
confess to doing often with Grep and Find).

I must also confess to using only the most basic Ack command-line options, but
Andy explored a lot of functionality I was not aware of, both in Ack and Grep:

    # Search for full words
    ack -w
    grep -w

    # List the files that matched instead of the matching line
    ack -l
    grep -l

    # Invert the match ("does not match X")
    ack -v
    grep -v

    # Override the default output with capture groups
    ack 'use (\S+);' --output='$1' -h | sort -u

    # Search the file path for matches (Beyond Find)
    ack -f
    ack -g

    # Accept a list of files to search on STDIN (Built-in Xargs)
    ack -x

The last two features are great for chaining together Ack commands:

    # Find all perl files not in the 'release' repository
    ack -g -v 'release' --perl |

    # ... search them for the word '2.46.3207.2'
    ack -x '2.46.3207.2' -w -l | 

    # ... and if they match, edit them with sed
    xargs sed -i 's/2.46.3207.2/2.49.3333.12/'

    # This little snippet saved me some hours of manual work upgrading version numbers

There was also a lot of discussion on other tools to help programmers be more
efficient. The ones I was most interested in were ctags, which I don't use
nearly enough (I use ack instead), and cscope, which I had never heard about. 

The problem with adding new things to your toolkit is integrating them into
your flow (the flow that can be consciously experienced is not the true flow).
Whenever you add a new thing, especially if it replaces an existing thing,
you're losing efficiency in the short-term in order to add potential efficiency
in the long-term. Despite this, a lot of things are worth it, Ack more-so than
most. 

Sometimes you don't know you're doing something inefficiently until someone
comes along and tells you so, or shows you a solution to a problem you never
knew you were having. Ack is a solution to a grep problem: Grep is harder to
use in the most-common cases. That said, Grep still has its uses, just uncommon
ones.

A big thanks to Andy for giving a presentation on such short notice! Our next
meeting is on May 23, so check out [the Chicago.pm
website](http://chicago.pm.org) and join us!
