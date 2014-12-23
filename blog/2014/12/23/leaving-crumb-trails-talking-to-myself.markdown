---
author: preaction
last_modified: 2014-12-23 06:57:07
tags: software
title: Leaving Crumb Trails -- Talking to Myself
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2014/12/leaving-crumb-trails----talking-to-myself.html
---

The past me is another person. Sometimes antagonist, sometimes friend, past me
(postaction?) had ideas, hopes, and dreams and developed some of them into
software that I and others use. Unfortunately, that asshole left bugs all
through the code for me to fix.

I can't blame him. Nobody's perfect, not even idealized/demonized copies of my
past self. But I do have to fix them, and deal with the messes he left.

Lucky for me, while he was writing buggy software, he left extensive notes for
me to use...

---

At the highest level, when all memory of the project is lost, past self left
detailed documentation describing the *what* and *why* of the code. Without
getting bogged down in the code, I can usually track down some likely sources
of my current problem.

    =head2 find_files()

    Find the files in this Store. Returns an iterator that generates Path::Tiny objects
    suitable to be passed to read_file() or open_file()

    =cut

Once the docs have refreshed the memories of past me, I can start looking at
the code. By keeping the docs near the code, past me left hooks all over for me
to latch on to. If I search for the name of the method, or just a key word of
its behavior, I find the code I'm looking for.

Eventually, I'll come to the buggy part. Instead of just changing the code and
fixing the bug, I wonder about why that code was written. Past me was a smart
guy. Not as smart as me, but I've learned not to second-guess him without due
diligence. So, I'm relieved when I can check the commit log to find the reasons
why this line of code exists in exactly this way. Past me has a habit of
writing at least a paragraph about the change, why it was necessary, and ideas
for future enhancements or complications.

    commit e084118b88e3838e38d5afa027d770ab22ca9903
    Date:   Mon Dec 22 04:15:45 2014 -0600

    open/write filehandles using raw bytes

    When the Static app would read/write an image, we would get a bunch of
    warnings of characters not mapped to UTF-8. Now, if we're using a
    filehandle, we assume raw bytes.

    Also added some notes in the docs about how encodings are handled. We
    can't just silently try to Do The Right Thing. We need to tell the
    developers what we're doing so that they can figure things out when they
    go wrong.

    Fixes #171

Sometimes, a commit is linked to a ticket tracker, which is another valuable
source of information. Though the commit message told me about the final
version of that change, past me jotted down notes, ideas, tests, user reports,
potential solutions and the reasons for rejecting them. These weren't
appropriate to gum up the commit logs with, but the ticket tracker is close
enough to the code to be useful when more information is needed. I appreciate
not having to sift through pages of text while I'm tracking down the source of
a bug (that said, I'd prefer too much text to not enough).

The further away from the code, the more verbose past me is. He starts with the
small clues, and if I figure it out, that's all I have to swallow. But if I
can't figure it out, I can always find a bigger clue just a little further
away.

Learning to work with past me has been a long struggle. He and I are constantly
refining our pair programming practices. By writing myself good documentation
explaining what and why a subroutine exists, I help myself remember what the
code is for. By leaving detailed explanations and rationales in the commit log,
I can remember why a change was made. By keeping user reports, brainstorming,
and notes in a ticket tracker linked back to the commit, I can read about
everything I was thinking when I wrote that code. Doing all this helps future
me be an even better programmer than past me and I could imagine.
