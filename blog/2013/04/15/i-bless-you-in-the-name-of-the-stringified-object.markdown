---
title: I Bless You in the Name of the Stringified Object
author: preaction
tags: error
last_modified: 2014-06-21 00:34:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2013/04/i-bless-you-in-the-name-of-the-stringified-object.html
---
A co-worker came to me today with a curious error message:

    use DateTime;
    my $date = DateTime->new( year => 2013, month => 4, day => 15 );
    $date->set_time_zone("Australia/Sydney");
    print $date->today;'

This code gives the error `Can't locate object method "_normalize_nanoseconds"
via package "2013-04-15T00:00:00" at
/usr2/local/perlbrew/perls/perl-5.16.3/lib/site_perl/5.16.3/x86_64-linux-thread-multi/DateTime.pm
line 252.`

The package "2013-04-15T00:00:00" is the curious part: It looks like a
stringified DateTime, but who could possibly be stringifying a DateTime object
and then using that as a package name?

---

It turns out the problem is at `$date->today`. `today()` is a constructor,
constructors are class methods, constructors inevitably call `bless` on the
class they are invoked with. But, we called this constructor with an object
instance (a blessed reference), not a class.

In an object without overloads, this fails (as expected) with an error message:
`Attempt to bless into a reference`. But DateTime overloads stringification. So
instead of trying to use an object as a package name, the object gets
stringified and that string gets used as a package name.

This problem could be mitigated by checking for refs in the constructor, dying
as a result. I'm not sure if it would be a good idea to disallow
stringification during a call to `bless`, for historical reasons (it's not a
bug if it's working as expected, it is a bug if a change breaks code).

Here's some sample code to play around with the problem. Enable/disable the
overload (comment out the `use overload (...)`) and see what changes:

    use strict;
    use warnings;
    
    package Foo;
    
    use overload (
        q{""} => sub { return "Bar" },
    );
    
    sub new {
        my ( $class ) = @_;
        return bless {}, $class;
    }
    
    sub greet {
        print "Hello, World!\n";
    }
    
    package main;
    
    my $obj = Foo->new;
    $obj->greet;
    
    my $clone = $obj->new;
    $clone->greet;

