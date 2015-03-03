---
last_modified: 2015-03-02 00:05:21
tags: 'perl, statocles'
title: Announcing Statocles
links:
    alternate:
        - title: blogs.perl.org
          href: http://blogs.perl.org/users/preaction/2015/03/announcing-statocles-static-site-generator.html
---
[Static site generators](http://staticsitegenerators.net) are popular these
days. For small sites, the ability to quickly author content using simple tools
is key. The ability to use lower-cost (even free) hosting, often without any
dynamic capabilities, is good for trying to maintain a budget. For larger
sites, the ability to serve content quickly and cheaply is beneficial, and
since most pages are read far more often than they are written, generating a
full web page to store on the filesystem can improve performance (and lower
costs).

For me, I like the convenience of using [Github Pages](http://pages.github.com)
to host project-oriented websites. The project itself is already on Github, so
why not keep the website closely tied to it so it doesn't get out-of-date? For
an organization like [the Chicago Perl Mongers](http://chicago.pm.org), Github
can even host custom domains, allowing easy collaboration on websites.

It's through the Chicago.PM website that I was introduced to Octopress, a
blogging engine built on Jekyll. It's through using Octopress that I decided to
write my own static site generator,
[Statocles](http://preaction.github.io/Statocles).

---

Like the most popular static site generators, Statocles uses Markdown to
generate HTML. Simple, readable plain text becomes HTML using
[Text::Markdown](http://metacpan.org/pod/Text::Markdown). A small bit of YAML
on top allows for metadata like tags, keywords, and links. If you want to
change formats, or even store your documents in a database instead of on a
filesystem, you can write a custom store module.

Though currently primarily a blog and simple web site, Statocles is intended to
be an application framework, allowing for custom ways to organize and display
content.

Statocles can deploy itself to Git repositories, including Github, but it can
also copy  to another directory to be served by the local web server. If you've
got another way you need to deploy, you can write a custom deploy module.

With this announcement, Statocles is beta-quality. The big API changes I wanted
to make are out of the way, and I'm working towards some useful developer
features before I mark a 1.0 stable release.

Statocles currently comes with:

* A blog application which supports tags and RSS and Atom feeds
* A Perldoc application to render the documentation for a Perl project
* An application for plain markdown pages and static files
* [sitemap.xml](http://sitemaps.org) to help search engines navigate the site
* A [simple theme built on the Skeleton CSS
  library](http://preaction.github.io/Statocles/theme/style.html) and using
  [Mojolicious](http://mojolicio.us) template syntax
* A command-line application to create, manage, build, test, and deploy your website
* Event handlers to hook into Statocles build/deploy workflow and add custom
  behaviors

Future plans include:

* More apps
    * A calendar
    * An image or presentation gallery
* More ways to deploy
    * Run any command (rsync, cp, ftp)
    * Deploy to a CDN
* Content helpers
    * Call custom Perl code from your templates, and your content
* Dynamocles
    * A web application to edit Statocles sites

Here are some websites currently using Statocles:

* <http://preaction.github.io/> My personal blog, using the default theme.
* <http://chicago.pm.org> Chicago Perl Mongers, which uses some very small
  additions to the default theme
* <http://preaction.github.io/Statocles> The Statocles website (of course),
  which shows the Perldoc app <http://preaction.github.io/Statocles/pod>

Join me in [#statocles on
irc.perl.org](https://chat.mibbit.com/?channel=%23statocles&server=irc.perl.org)
for questions or comments, or write up a bug or feature request [on Statocles's
Github page](http://github.com/preaction/Statocles).
