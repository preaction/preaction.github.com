---
title: Chicago.PM - Beyond grep - Expanding the Programmer Toolset
author: preaction
tags: software
last_modified: 2014-06-21 01:15:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2012/09/plan-software-to-live-forever.html
---
How often have I told myself, "I'll kludge this now and rewrite it later"? And
how many times did I actually go back and rewrite that kludgy bit? "Too often"
and "not enough". Many job postings include the phrase "update legacy
applications," as a euphemism for "rewrite poorly-designed spaghetti." The Y2K
problem was a huge exercise in code out-living the developer's plan, with a
healthy dose of cargo-culting thrown in. Lately, I've been learning to plan for
a likely possibility: My code will survive to haunt my bug lists and my resume
for a long time.

---

We developers are a lazy lot, it's one of our greatest strengths. But like all
virtues, it is a double-edged sword that must be wielded responsibly. Laziness
is defined as maximum gain for minimal effort. For laziness's sake, I write
automated tests to avoid manual testing, I build a development server that
mimics production closely so I don't get woken up at 2:00 am when my code blows
up, I write documentation that explains the design of the software so I don't
have to trace through layers of code to figure it out, and anything else I can
do to make sure I don't have to work as hard solving the same problem in the
future.

Automated tests are the programmer's best friend. How do I know my code works?
By running it. How do I know it works every time I change something? By running
it again. Automated tests are simply running the code, controlling the input
and checking the output. Since I write tests once according to expected input
and output, I can refactor the entire program and be absolutely sure it works
for that set of input. I don't need to test manually, clicking everywhere or
preparing input on-the-fly, which saves me a lot of time in the long run
(because this code will live forever).

A development server is another necessity for laziness. At a former employer I
instituted a policy: All custom client projects included renting a
development/staging server, no exceptions. This staging server could be
completely destroyed and rebuilt with zero consequences. Our deployment
processes were automated (more laziness) to make it easy to recover from
mistakes. Once our automated tests passed, the clients had a place they could
verify the expected behavior and see their ideas in action before releasing the
code on to an important, production system. We instituted this policy from
learning our lesson: Our laptops were never the same as the production server,
so we needed some place that was. Deploying code directly to production is only
rarely without unforeseen consequences.

I've been called a hero a couple times now. I don't believe or understand why,
but I've noticed it's always after I mention how much I enjoy writing
documentation. Writing documentation is like explaining my code to someone
else, usually future me: It forces me to think critically about the code, how
it works, and what side-effects and edge-cases it has. Every time I go back to
write documentation I've found bugs in my code: incorrect assumptions,
inelegant algorithms, or undesired side-effects. Usually, the first other
person who reads them finds even more: things I didn't think of, or things I
thought would never be a problem (famous last words). Writing the documentation
gets me out of the code mindset and into the design mindset, and well-designed
code is code that will live forever.

There is nothing more boring than a solved problem. By making sure I have
automated tests, a sandbox environment, good documentation, I can make
maintenance easier, which is the true definition of laziness: Maximum gain for
minimum effort.
