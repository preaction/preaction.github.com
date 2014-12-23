---
title: Chicago.PM - Scripting Git With Perl
author: preaction
tags: chicago.pm
last_modified: 2014-06-21 01:04:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2012/10/chicagopm-report---scripting-git-with-perl.html
---

This month's presentation was on the
[Git::Repository](http://search.cpan.org/dist/Git-Repository/) Perl module,
given by me. In both my jobs, I use the Git::Repository module to automate
releases.

---

At [Double Cluepon](http://www.doublecluepon.com), I use it to create the
release packages based on tagged commits, so that releasing our software is
exactly: `git tag vX.X.X && git push --tags`. A Perl script builds every package
and then pushes them to our update server, where the game will check for a new
release.

At Bank of America, we use it to combine our 20-30 Perl distributions into a
single release. Using git submodules, we have a "release repository" that holds
references to all the modules for each team's releases (some are team-specific,
others are shared between teams). A Perl script manages the submodules,
determines when the submodule refs need to be updated, tags and branches for
each release, and finally builds and installs our modules using
[Module::Build](http://search.cpan.org/dist/Module-Build/) and
[local::lib](http://search.cpan.org/dist/local-lib/).

All this Git stuff gave me some ideas for possible useful code I can release,
perhaps leading to me finally recovering my CPAN ID.

[The slides for my Scripting Git With Perl
talk](http://preaction.github.com/Perl/Scripting-Git.html)

[The code for the script that automatically builds releases tagged like
"vX.X.X"](https://gist.github.com/3943302)
