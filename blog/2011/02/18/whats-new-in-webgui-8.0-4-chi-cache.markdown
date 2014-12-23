---
title: What's New in WebGUI 8.0 #4 -- CHI Cache
author: preaction
tags: webgui
last_modified: 2014-06-21 01:30:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2011/02/whats-new-in-webgui-80-4----chi-cache.html
---
Caching is a tricky business. Having just one kind of cache won't work, because
the production environment will greatly determine the most efficient caching
system. A distributed production environment would be best-served with a
distributed cache. A smaller, single-server environment could use a simple
shared memory cache.

Enter Jonathan Swartz's [CHI](https://metacpan.org/pod/CHI) module, the greatest Perl module to provide a
unified caching interface. CHI is the DBI of caching: It presents an API, and
delegates to CHI::Driver modules to perform the heavy lifting. It
provides a layered caching system, allowing you to have a faster, more
volatile cache in front of a slower, more persistent cache. It also provides a
variable expiration time, preventing a "miss stampede" where all processes try
to recompute an expired cache item at the same time.

By integrating CHI cache into WebGUI, we have the ability to provide any
caching strategy that CHI can provide. We get Memcached, FastMmap, and DBI
drivers (and more drivers can be written).

I wrote a CHI cache driver for WebGUI 7.9 that we've been using on many of our
shared hosting servers. The performance increase using FastMmap through CHI 
over the old Storable+DBI cache module is dramatic: 2-5 times faster with
CHI and FastMmap.

## Using CHI in WebGUI ##

The fewer wrappers that WebGUI has around CPAN modules we use, the less code I
have to write, and the more features will be available to our users without
having to change WebGUI to use them.

To that end, you can write a section of the configuration file that gets
passed directly to CHI->new. Some massaging occurs to make sure a DBI cache
driver gets the right $dbh, but otherwise you can fully configure CHI directly
from the WebGUI config file:

    # The new default cache for WebGUI, FastMmap
    {
         cache : {
             driver : 'FastMmap',
             root_dir : '/tmp/WebGUICache',
             expires_variance : 0.5
         }
     }
    
     # Set up a memcached cache with local memory in front
     {
         cache : {
             driver : 'Memcached::libmemcached',
             servers : [ '10.0.0.100:11211', '10.0.0.110:11211' ],
             l1_cache : {
                driver : 'Memory'
             }
         }
     }

When you want to use the cache in your code, you can get a CHI object with
$session->cache. CHI's interface is sufficiently simple, with some fun tricks:

    my $cache = $session->cache; # as read
    my $value = $cache->get('cache_key');
    if ( !$value ) {
        $value = compute_value();
        $cache->set( 'cache_key', $value );
    }

    # Combine get and set with intelligence
    my $value = $cache->compute( 'cache_key', \&compute_value );

## Future Plans ##

With a single unified cache that performs well and layers like CHI, we can
take our current stow and scratch APIs and move them to the cache. In the case
of stow, we remove a redundant API. In the case of scratch, we remove database
hits.

We've also been exploring cache-only sessions, instead of updating the session
every time a page is requested, updating the cache only, flushing to the
database (or not). The fewer DB calls we make per page, the better performance
will be.

Special thanks go out to Jonathan Swartz for such a wonderful solution.

Stay tuned for next time when I explore our new Admin Interface. Lots of
pretty and screenshots!

