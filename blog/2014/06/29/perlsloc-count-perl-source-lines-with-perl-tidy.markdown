---
author: preaction
last_modified: 2014-06-29 21:52:19
tags: scripts
title: perlsloc - Count Perl Source Lines with Perl::Tidy
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2014/06/perlsloc---count-perl-source-lines-with-perltidy.html
---
While spending some time putting together my own [perltidyrc
file](https://github.com/preaction/dot-files/blob/master/perltidyrc), I became
intimately familiar with the [Perl::Tidy
documentation](https://metacpan.org/pod/distribution/Perl-Tidy/bin/perltidy).

One day, I decided to find out exactly how much code I was maintaining. Since
perltidy can strip comments and POD, and also normalize the source code to make
a fair measurement, it's a perfect tool for counting Source Lines of Code
(SLOC).

Here's a small shell script using `ack`, `perltidy`, `xargs`, and `wc` to count
the source lines of code in any number of directories.

    ack -f --perl $@ | xargs -L 1 perltidy --noprofile --delete-pod --mbl=0 --standard-output | wc -l

`ack -f` lists the files that would be searched, and `--perl` searches Perl
files, so we get ack's heuristics for finding Perl files. `xargs -L 1` invokes
the following command for every 1 line of input. The `perltidy` command strips
the pod and tightens up the whitespace and writes the result to stdout, which
`wc -l` will then count, line by line.

So, as an example, the current [Statocles](http://metacpan.org/release/Statocles) release
has 50% more test lines than source lines:

    » perlsloc lib bin
        1034
    » perlsloc t
        1633
