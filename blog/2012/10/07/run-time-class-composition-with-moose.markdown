---
title: Run-time Class Composition With Moose
author: preaction
tags: moose
last_modified: 2014-06-21 01:10:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2012/10/run-time-class-composition-with-moose.html
---

Moose is great! At its very basic, it simplifies the boilerplate required to
create Perl objects immensely, providing attributes with type constraints,
method modifiers for semantic enhancement, and role-based class composition for
better code re-use.

Moose is built on top of Class::MOP. MOP stands for Meta-Object Protocol. A
meta-object is an object that describes an object. So, each attribute and
method in your class has a corresponding entry in the meta-object describing
it. The meta-object is where you can find out what type constraints are on an
attribute, or what methods a class has available.

Since the meta-object is a Plain Old Perl Object, we can call methods on it at
runtime. Using those meta-object methods to add an attribute would modify our
object, adding that attribute to the object. Using Class::MOP, we can compose
classes at runtime!

---

I have recently used this to great effect in a custom dependency injection and
configuration framework we have at Bank of America. By adding a "with" key to
the configuration YAML file, the DI will create a new, anonymous class that
composes the roles specified.

    {
        name: "Repository",
        class: "Bank::HistoricalData::DailyRepository",
        with: [ "Bank::Role::FlattenIntraday", "Bank::Role::CalculateHighLow" ],
        constructor_args: { }
    }

So, when I ask the DI for the "Repository" object, it will get the meta-object
for Bank::HistoricalData::DailyRepository, create an anonymous class that
extends Bank::HistoricalData::DailyRepository, and then compose the two roles
into the new class.

The code to do all this is extremely short:

    my $class = $conf->{class};
    my $meta = Moose::Meta::Class->create_anon_class( 
        superclasses => [ $class ],
        roles => $conf->{with},
    );
    $meta->make_immutable; # for performance
    my $object = $meta->name->new( %{ $conf->{constructor_args} } );
    return $object;

If a lot of objects end up composing the same roles, I can create a concrete
class to get a bit of a performance boost. Since I create a new, anonymous
meta-class, I don't have to worry about the class I'm extending being modified,
or being made mutable again ($class->meta->make_immutable speeds up a lot of
things, but doesn't allow us to add attributes or methods).

With this, I can be a lot more flexible about my dependencies, adding whatever
role I want to change their behavior whenever I need.
