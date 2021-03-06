---
author: preaction
last_modified: 2014-04-19
tags: openbsd, funny
title: Raw Feed of OpenBSD's Work on Cleaning Up OpenSSL
---
[Raw Feed of OpenBSD's Work on Cleaning Up OpenSSL](http://freshbsd.org/search?project=openbsd&q=file.name:libssl)

This is an amazing timeline of how much and how quickly work can get done with
a determined, dedicated team of hackers.

Here are some gems:

---

<http://freshbsd.org/commit/openbsd/2ba43b4c3aaa341d4be890e4e31a3006e9bfdff5>

    now that knf carpet bombing is finished, switch to hand to hand combat.
    still not sure what to make of mysteries like this:
            for (i = 7; i >= 0; i--) {      /* increment */

<http://freshbsd.org/commit/openbsd/fc55d7f9ab6fcadd0ca2f8231f2559eace1aff53>

    If modern society can get past
    selling daughters for cows, surely we can decide to write modern C code in
    an "application" that is probably 3 lines of shell/python/cgi away from
    talking to the internet in a lot of places..

<http://freshbsd.org/commit/openbsd/ad137951cda2753525d3d1251cccd3d9d048fc17>

    egd support is too dangerous to leave where somebody might find it.

<http://freshbsd.org/commit/openbsd/c862290df5533966091ded3906da184f1cac8675>

    Remove support for big-endian i386 and amd64.
    
    Before someone suggests the OpenSSL people are junkies, here is what they
    mention about this:
            /* Most will argue that x86_64 is always little-endian. Well,
             * yes, but then we have stratus.com who has modified gcc to
             * "emulate" big-endian on x86. Is there evidence that they
             * [or somebody else] won't do same for x86_64? Naturally no.
             * And this line is waiting ready for that brave soul:-) */
    
    So, yes, they are on drugs. But they are not alone, the stratus.com people are,
    too.

<http://freshbsd.org/commit/openbsd/330301cf149a46a780af2ee04b511fbffb09fb1d>

    todo: do not leave 15 year old todo lists in the tree.

<http://freshbsd.org/commit/openbsd/db48657ab11dec76434265d8620451980e9ccd38>

    This code is the reason perl has a name as a write only language.

<http://freshbsd.org/commit/openbsd/eadb750b87b4a90c1284f6361d6c3ea6d6e26f66>

    quoth the readme:
    NOTE: Don't expect any of these programs to work with current
    OpenSSL releases, or even with later SSLeay releases.

<http://freshbsd.org/commit/openbsd/a596f856fb6f6da6f5458029bddbe32e2c056d7b>

    spray the apps directory with anti-VMS napalm.
    so that its lovecraftian horror is not forever lost, i reproduce below
    a comment from the deleted code.
    
            /* 2011-03-22 SMS.
             * If we have 32-bit pointers everywhere, then we're safe, and
             * we bypass this mess, as on non-VMS systems.  (See ARGV,
             * above.)
             * Problem 1: Compaq/HP C before V7.3 always used 32-bit
             * pointers for argv[].
             * Fix 1: For a 32-bit argv[], when we're using 64-bit pointers
             * everywhere else, we always allocate and use a 64-bit
             * duplicate of argv[].
             * Problem 2: Compaq/HP C V7.3 (Alpha, IA64) before ECO1 failed
             * to NULL-terminate a 64-bit argv[].  (As this was written, the
             * compiler ECO was available only on IA64.)
             * Fix 2: Unless advised not to (VMS_TRUST_ARGV), we test a
             * 64-bit argv[argc] for NULL, and, if necessary, use a
             * (properly) NULL-terminated (64-bit) duplicate of argv[].
             * The same code is used in either case to duplicate argv[].
             * Some of these decisions could be handled in preprocessing,
             * but the code tends to get even uglier, and the penalty for
             * deciding at compile- or run-time is tiny.
             */

