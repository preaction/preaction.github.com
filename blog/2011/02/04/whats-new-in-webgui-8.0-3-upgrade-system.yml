---
title: What's New in WebGUI 8.0 #3: Upgrade System
author: preaction
tags: webgui
last_modified: 2014-06-21 01:34:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2011/02/whats-new-in-webgui-80-3-upgrade-system.html
---
## Following The Path

If you installed WebGUI 0.9.0 back in August of 2001 (the first public 
release), you've had a stable upgrade path through WebGUI 7.10.8 (January
2011) and beyond. Plainblack.com has been through every upgrade for the last
10 years, a shining bastion to our upgradability.

A WebGUI 7.10 user would not even recognize a WebGUI 6.0 database, much less
the database used by the 1.x series, but slowly, gradually, our upgrade system
brought new features to every WebGUI site that wanted them.

## The Ancient Way

Our old upgrade system was quite simple:

    docs/upgrade_2.9.0-3.0.0.pl
    docs/upgrade_3.0.0-3.0.1.sql
    docs/upgrade_3.0.0-3.0.1.pl

Our upgrade.pl script would check for docs/upgrade_*, compare version numbers,
and then execute the .sql and .pl scripts in order until there were no more
upgrades left.

Because each .pl script was executed individually, there was a considerable
amount of boilerplate in each script (123 lines). Because there was only one script per
version, some scripts could get quite long. We had conventions to manage these
limitations, but it was still a bit of a mind-twist to write an upgrade
routine.

Later, when we moved to simultaneous beta and stable trees, it became even
more difficult to manage these huge upgrade scripts. Collecting the new
features from the beta tree to apply to the stable tree was a time-consuming
manual task that some poor coder had to perform, back hunched over a dimly-lit
screen in the wee hours of the night, testing and re-testing the upgrade to
make sure stable lived up to its expectations.

Though our upgrade system had performed admirably, it was time for a fresh
look at the problem.

## The Modern Vision

The individual files for upgrades was working quite well, but didn't go far 
enough. Our new upgrade system has one file per upgrade step. Each sub from an
old upgrade script would be one file in the new upgrade system. What's more,
additional file types would be supported:

    $ ls share/upgrades/7.10.4-8.0.0/
    addNewAdminConsole.pl
    admin_console.wgpkg
    facebook_auth.sql
    migrateToNewCache.pl
    moveMaintenance.pl
    moveRequiredProfileFields.pl

So now, instead of a single file for an upgrade, we have an entire directory.
In this directory, the .pl files are scripts to be run, the .wgpkg files are
WebGUI assets to add to the site, the .sql files are SQL commands to run, and
any .txt files will be shown as a confirmation message to the user for gotchas
like "All your users have been logged out as a result of this upgrade. Deal
with it.".

So now, if you want to add your own custom upgrade routine, you just add
another file to the directory which means less worrying about conflicts. When
we need to build another new stable version release, we can just move the
unique upgrade files from beta to the new upgrade.

The best part of the new upgrade system is how the .pl scripts are written.
When you are in a .pl, you have a bunch of sugar to make the basic tasks much
easier.

    # Old upgrade routine. Just another day in a session
    sub migrateToNewCache {
        my $session = shift;
        print "\tMigrating to new cache " unless $quiet;

        use File::Path;
        rmtree "../../lib/WebGUI/Cache";
        unlink "../../lib/WebGUI/Workflow/Activity/CleanDatabaseCache.pm";
        unlink "../../lib/WebGUI/Workflow/Activity/CleanFileCache.pm";

        my $config = $session->config;
        $config->set("cache", {
            driver              => 'FastMmap',
            expires_variance   => '0.10',
            root_dir            => '/tmp/WebGUICache',
        });

        $config->set("hotSessionFlushToDb", 600);
        $config->delete("disableCache");
        $config->delete("cacheType");
        $config->delete("fileCacheRoot");
        $config->deleteFromArray("workflowActivities/None", "WebGUI::Workflow::Activity::CleanDatabaseCache");
        $config->deleteFromArray("workflowActivities/None", "WebGUI::Workflow::Activity::CleanFileCache");

        my $db = $session->db;
        $db->write("drop table cache");
        $db->write("delete from WorkflowActivity where className in ('WebGUI::Workflow::Activity::CleanDatabaseCache','WebGUI::Workflow::Activity::CleanFileCache')");
        $db->write("delete from WorkflowActivityData where activityId in  ('pbwfactivity0000000002','pbwfactivity0000000022')");

        print "DONE!\n" unless $quiet;
    }

If you're familiar with WebGUI session, this is pretty standard, but still
much boilerplate and convention. The new scripts remove boilerplate and
enforce what was once merely convention.

    # New upgrade routine. migrateToNewCache.pl
    use WebGUI::Upgrade::Script;
    use Module::Find;

    start_step "Migrating to new cache";

    rm_lib
        findallmod('WebGUI::Cache'),
        'WebGUI::Workflow::Activity::CleanDatabaseCache',
        'WebGUI::Workflow::Activity::CleanFileCache',
    ;

    config->set("cache", {
        'driver'            => 'FastMmap',
        'expires_variance'  => '0.10',
        'root_dir'          => '/tmp/WebGUICache',
    });

    config->set('hotSessionFlushToDb', 600);
    config->delete('disableCache');
    config->delete('cacheType');
    config->delete('fileCacheRoot');
    config->deleteFromArray('workflowActivities/None', 'WebGUI::Workflow::Activity::CleanDatabaseCache');
    config->deleteFromArray('workflowActivities/None', 'WebGUI::Workflow::Activity::CleanFileCache');

    sql 'DROP TABLE IF EXISTS cache';
    sql 'DELETE FROM WorkflowActivity WHERE className in (?,?)',
        'WebGUI::Workflow::Activity::CleanDatabaseCache',
        'WebGUI::Workflow::Activity::CleanFileCache',
    ;
    sql 'DELETE FROM WorkflowActivityData WHERE activityId IN (?,?)',
        'pbwfactivity0000000002',
        'pbwfactivity0000000022',
    ;

    done;

The first thing we do in our new upgrade script is use
WebGUI::Upgrade::Script. Now, instead of using the session for everything, we
have subs imported for various tasks. This means that many times we can run an
entire upgrade script without opening a WebGUI session, or creating a version
tag unnecessarily.

If we do need a session, or a version tag, they will be automatically assigned
relevant information describing what we're doing. When we're done, they will
be automatically cleaned up and committed. What once was done with
boilerplate, and subject to random deletion or subversion, is now enforced
policy.

In all other respects, a WebGUI upgrade script is a Perl script. You can add
modules, write subroutines, and do anything necessary to move WebGUI into the
future.

The Internet is always evolving. With the WebGUI 8 upgrade system, we've made 
it easier to evolve with it.

Stay tuned for next time where I'll show off our CHI-based caching system.

