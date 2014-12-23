---
title: Using MooseX::Types to Inflate Config Values
author: preaction
tags: moose
last_modified: 2014-06-21 01:07:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2012/10/using-moosextypes-to-inflate-config-values.html
---

For a large application, configuration files become a necessity. They help
flexible code be used in multiple instances across multiple modules. But they
are, for the most part, only data structures, which can be a problem if the
configured object is expecting another configured object.

---

    package FakeRepository;

    use Moose;
    use TimeSeries;
    has timeseries => (
            is => 'rw',
            isa => 'TimeSeries',
            required => 1,
    );

    package TimeSeries;

    use Moose;
    has dates => (
            is => 'rw',
            isa => 'HashRef[Number]', # Date => Value pairs
            default => sub { {} },
    );

Here we have a FakeRepository that requires a TimeSeries object. Certainly,
this is where a Dependency Injection framework could step in and inject the
required TimeSeries. The drawback is the indirection: The two configured
objects are completely separate, joined only by the reference, like so:

    # dependency.yml
    - service:
            name: 'test_repo'
            class: 'FakeRepository'
            constructor_args:
                    timeseries: { ref: test_data }

    - service:
            name: 'test_data'
            class: 'TimeSeries'
            constructor_args:
                    dates:
                            2012-01-01: 1.56
                            2012-01-02: 1.69
                            2012-01-03: 1.45

So here, we define two services (objects), test\_repo and test\_data, and
test\_repo uses test\_data to fill its timeseries attribute. test\_data fills
in its dates attribute directly from the configuration file.

This works great if test\_data is needed by more than just test\_repo. It also
works fine as-is, the dependency injection framework does the work. But what if
we wanted to specify the timeseries value directly, instead of indirectly?

Moose's typing system allows us to do just that. By creating a custom type with
a coercion from the data structure in our configuration file, we can create the
dependency that our test\_repo needs.

    package My::Types;

    use MooseX::Types qw( HashRef Number );
    use TimeSeries;

    # declare our TimeSeries class as a type
    class_type TimeSeriesType;
    # coerce a TimeSeries from a hash of date => value pairs
    coerce TimeSeriesType, from HashRef[Number], via sub {
            # coercions put the value to be coerce in $_
            return TimeSeries->new( data => $_ );
    };

Once we have our new custom types, we must use them in our package.

    package FakeRepository;

    use Moose;
    use My::Types qw( TimeSeriesType );

    has timeseries => qw(
            is => 'rw',
            isa => TimeSeriesType,  # Not quoted!
            coerce => 1,                    # Activate coercion powers!
            required => 1,
    );

Now, we can configure our TimeSeries directly from our configuration file,
without indirection.

    # dependency.yml
    - service:
            name: 'test_repo'
            class: 'FakeRepository'
            constructor_args:
                    timeseries:
                            2012-01-01: 1.56
                            2012-01-02: 1.69
                            2012-01-03: 1.45

Moose will create the object for us using our defined coercion.

There are other ways to solve this: Enhance the Dependency Injection framework
to allow anonymous objects (instead of providing a ref: to an object, provide a
full object definition with class: and constructor\_args:), but having these
coercions in place also helps when writing test code:

    use Test::More;
    use FakeRepository;
    my $repo = FakeRepository->new(
            timeseries => {
                    '2012-01-01' => 1.56,
                    '2012-01-02' => 1.69,
                    '2012-01-03' => 1.45,
            },
    );

No need to increase the apparent coverage of the test by including the
TimeSeries class, we never have to refer to it at all. No need to lock the
interface to a specific TimeSeries class (if that's a desired goal of the
project), the coercion takes care of creating the actual object used.

Coercions are a powerful feature. I've used them to build complicated trees
from arrays of arrays (more on that later), and I've used them to simply
force-uppercase a string so that Log4perl would do its job. Coercions are one
more very useful tool in a robust toolbox.
