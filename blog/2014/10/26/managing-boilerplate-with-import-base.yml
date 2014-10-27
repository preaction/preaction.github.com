---
author: preaction
last_modified: 2014-10-26 18:45:20
tags: perl
title: 'Manage Boilerplate with Import::Base'
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2014/10/managing-boilerplate-with-importbase.html
---
Boilerplate is everything I hate about programming:

* Doing the same thing more than once
* Leaving clutter in every file
* Making it harder to change things in the future
* Eventually blindly copying without understanding (cargo-cult programming)

In an effort to reduce some of my boilerplate, I wrote
[Import::Base](https://metacpan.org/pod/Import::Base), a module to collect and
import useful bundles of modules, removing the need for long lists of `use ...`
lines everywhere.

---

As I've grown as a Perl programmer, I've added more and more to my standard
preamble for all but the most trivial Perl scripts. `use strict` and `use
warnings` are absolute requirements. I want to use modern Perl's features like
`say`, `state`, and others, so I'll import a feature bundle with `use feature
":5.10"`. If I'm working on things I don't plan to share the code on CPAN, I
can go all the way to `use experimental qw( signatures postfix_deref )`.

For class modules, I need to `use Moo`, `use Types::Standard`, and more. For
roles, I need to `use Moo::Role` instead of Moo. If the project uses Moose, I
need to use Moose's version of those things instead of Moo's version (or, in
the case of Type::Tiny, make sure to use a Moo/Moose agnostic pattern).

For tests, I have a lot more. `use Test::More`, `use Test::Deep`, and `use
Test::Differences`, are my go-to comparison set. My best practices also include
`use File::Temp`, which requires that I `use File::Spec::Functions`, and `use
FindBin` so I can locate the t/share directory for ancillary test files.

For command-line scripts, I have `use Pod::Usage::Return`, `use Getopt::Long
qw( GetOptionsFromArray )`, in addition to my standard boilerplate of strict,
warnings, and features.

And every project I write has imports that are used in just about every module:
YAML, JSON, Path::Tiny, and project-specific utility modules.

My standard solution was as simple and blunt as it could be: Copy and paste.
Besides being a stupidly-lazy solution, it left me with a problem: How could I
modify all my modules to use a new feature bundle? Should I brush up on my
`sed(1)` or write a Perl one-liner? What happens when I want to use a different
module with an equivalent API, like changing to use YAML::XS instead of
YAML::PP? How can I make a new module quickly available to all my classes, or
all my roles, or all my tests, or all my scripts?

All these questions boiled down to: If I copy/paste my boilerplate everywhere,
what happens when my boilerplate changes? This is why I hate boilerplate.

With [Import::Into](https://metacpan.org/pod/Import::Into), we have a way to
remove a massive block of imports from our boilerplate. Using Import::Into, I
wrote a simple class to manage my imports, and allow me to quickly create
different bundles of imports to use in different situations:
[Import::Base](https://metacpan.org/pod/Import::Base).

With Import::Base, you build a list of imports in a module. When someone
imports your module, they get all your imports. They can also subclass your
module to add or remove what your module imports.

A common base module should probably include strict, warnings, and a feature
set.

    package My::Base;
    use base 'Import::Base';

    our @IMPORT_MODULES = (
        'strict',
        'warnings',
        feature => [qw( :5.14 )],
    );

Now we can consume our base module by doing:

    package My::Module;
    use My::Base;

Which is equivalent to:

    package My::Module;
    use strict;
    use warnings;
    use feature qw( :5.14 );

Now when we want to change our feature set, we only need to edit one file!

In addition to a set of modules, we can also create optional bundles:

    package My::Base;
    use base 'Import::Base';

    # Modules that will always be included
    our @IMPORT_MODULES
        'strict',
        'warnings',
        feature => [qw( :5.14 )],
        experimental => [qw( signatures )],
    );

    # Named bundles to include
    our %IMPORT_BUNDLES = (
        Class => [ 'Moo', 'Types::Standard' => [qw( :all )] ],
        Role => [ 'Moo::Role', 'Types::Standard' => [qw( :all )] ],
        Test => [qw( Test::More Test::Deep )],
    );

Now we can choose one or more bundles to include:

    # lib/MyClass.pm
    use My::Base 'Class';

    # t/mytest.t
    use My::Base 'Test';

    # t/lib/MyTest.pm
    use My::Base 'Test', 'Class';

What makes Import::Base more useful than rolling your own with Import::Into is
the granular control you can get on the consuming side. On a case-by-case
basis, individual imports can be removed if they conflict with something in the
module (a name collision, for example). Then, the offending module can be used
directly.

    package My::StrangeClass;
    use My::Base 'Class', -exclude => [ 'Types::Standard' ];
    use Types::Standard qw( Str );

Boilerplate is everything I hate about programming. With
[Import::Base](https://metacpan.org/pod/Import::Base), I can remove boilerplate
and replace it with a single line describing what the module needs.

