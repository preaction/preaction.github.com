---
last_modified: 2015-01-21 22:24:15
tags: 'perl, sql, etl, yertl'
title: Managing SQL Data with Yertl
---

[Originally posted on blogs.perl.org -- Managing SQL Data with
Yertl](http://blogs.perl.org/users/preaction/2015/01/managing-sql-data-with-yertl.html)

Every week, I work with about a dozen SQL databases. Some are Sybase, some
MySQL, some SQLite. Some have different versions in dev, staging, and
production. All of them need data extracted, transformed, and loaded.

DBI is the clear choice for dealing with SQL databases in Perl, but there are a
dozen lines of Perl code in between me and the operation that I want. Sure,
I've got modules and web applications and ad-hoc commands and scripts that
perform certain individual tasks on my databases, but sometimes those things
don't quite do what I need right now, and I just want something that will let
me execute whatever SQL I can come up with.

[Yertl (ETL::Yertl)](http://metacpan.org/pod/ETL::Yertl) is a shell-based ETL
framework. It's under development (as is all software), but included already is
a small utility called [ysql](http://metacpan.org/pod/ysql) to make dealing
with SQL databases easy.

---

To use ysql, first we have to configure a database. This saves us from having
to type the full DBI data source name (`dbi:mysql:host=dev;database=mydb`) every
time. Instead, we can refer to our database by a nice name, like "dev", or
"prod".

    $ ysql config dev dbi:SQLite:database.db

Later, we can update our configuration if we need to:

    $ ysql config dev --database=dev.db

We can examine our configuration as a YAML document:

    $ ysql config dev
    ---
    database: dev.db
    driver: SQLite

Let's add a production database as well:

    $ ysql config prod --driver=SQLite --database=prod.db

And now we can check both of our configs:

    $ ysql config
    ---
    dev:
      database: dev.db
      driver: SQLite
    prod:
      database: prod.db
      driver: SQLite

Now that we've configured some databases, let's insert some data. First we need
to make some tables:

    $ ysql query prod 'CREATE TABLE users ( id INTEGER PRIMARY KEY \
        AUTOINCREMENT, name VARCHAR, email VARCHAR )'
    $ ysql query dev 'CREATE TABLE users ( id INTEGER PRIMARY KEY \
        AUTOINCREMENT, name VARCHAR, email VARCHAR )'

Next let's insert some data:

    $ ysql query prod 'INSERT INTO users ( name, email ) \
        VALUES ( "preaction", "preaction@example.com" )'
    $ ysql query prod 'INSERT INTO users ( name, email ) \
        VALUES ( "postaction", "postaction@example.com" )'

Now, let's query for our data:

    $ ysql query prod 'SELECT * FROM users'
    ---
    email: preaction@example.com
    id: 1
    name: preaction
    ---
    email: postaction.example.com
    id: 2
    name: postaction

Yertl uses YAML as its default output, but we can easily convert to JSON or CSV
using the [yto utility](http://metacpan.org/pod/yto)

    $ ysql query prod 'SELECT * FROM users' | yto csv
    email,id,name
    preaction@example.com,1,preaction
    postaction@example.com,2,postaction

    $ ysql query prod 'SELECT * FROM users' | yto json
    {
       "email" : "preaction@example.com",
       "id" : "1",
       "name" : "preaction"
    }
    {
       "email" : "postaction@example.com",
       "id" : "2",
       "name" : "postaction"
    }

Now, lets say we want to copy our production database to dev for testing. To do
that, Yertl allows us to read YAML from `STDIN` and execute a query for each YAML
document. Yertl uses a special interpolation syntax (starting with a `$`) to
pick parts of the document to fill in the query:

    $ ysql query prod 'SELECT * FROM users' |
        ysql query dev 'INSERT INTO users ( id, name, email ) \
            VALUES ( $.id, $.name, $.email )'

So this will take our users table from prod and write it to dev. `$.id` picks
the "id" field, `$.name` the "name" field, etc...

But all this would be a bear to type over and over again (imagine if we had a
bunch of joins to do). So, ysql allows you to save queries for later use using
the `--save <name>` option:

    $ ysql query prod --save users 'SELECT * FROM users'
    $ ysql query dev --save update_users 'UPDATE users SET \
        name=$.name, email=$.email WHERE id=$.id'

Then we can recall our query by the name we gave to the `--save` option:

    $ ysql query prod users | ysql query dev update_users

Finally, using `yto` and [yfrom](http://metacpan.org/pod/yfrom), we can write a
dump of our users to JSON, and then read that database dump back into our
database:

    $ ysql query prod users | yto json > users.json
    $ yfrom json < users.json | ysql query dev update_users

So, though Yertl is in its infancy, it can already help with some common
database tasks!

There are lots of [plans for Yertl, described in the feature's tag on the issue
tracker](https://github.com/preaction/ETL-Yertl/labels/feature), so if you've
got common data tasks that you feel should be easier, [join me in #yertl on
irc.perl.org](https://chat.mibbit.com/?channel=%23yertl&server=irc.perl.org).

