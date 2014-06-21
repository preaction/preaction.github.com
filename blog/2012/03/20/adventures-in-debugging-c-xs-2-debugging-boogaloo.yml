---
author: preaction
last_modified: 2012-03-20
tags: perl, xs
title: Adventures in Debugging C/XS 2: Debugging Boogaloo
---
... or "Ask Not To Whom The Pointer Points, It Points To Thee."

TL;DR: A pointer is not a reference. A pointer knows nothing about the data
being pointed to. Returning multiple values requires actual work.

Everything went wrong when I wanted a string with a `NUL` character inside it.
C strings are not Perl scalars, they don't know how long they are. So to mark
the end of a string, C uses the `NUL` character, `\0`. The `strcpy` function will
copy to your destination until the first `\0` from your source. When you want to
have a string with a `\0` inside of it that does not mark the end of the string,
you need to know exactly how long the string is. This is not difficult to do,
but you also have to return that length from the function that creates your
string.

C functions do not have more than one return value.

    (char* buffer, int bufferSize) = get_string_with_nuls();
    // You thought it could be that easy?

So in order for your function to result in more than one value, you have to
pass in references to be used to fill in with actual values.

    char* buffer;
    int bufferSize = get_string_with_nuls( buffer );
    // C programmers will already know what I did wrong here

Thinking like a Perl programmer, I thought I could just pass in the pointer to
the function and the function could fill it with data. Two problems:

1. I passed in the pointer itself, not a reference to the pointer: `&buffer`
2. I did not initialize the pointer to anything.

A more correct way would be:

    char* buffer = malloc( 128 * sizeof( char ) );
    int bufferSize = get_string_with_nuls( &buffer );

But this suffers from another problem: I have to know beforehand how big my
string is going to be and allocate that much memory beforehand.

The way I ended up succeeding was:

    int bufferSize;
    char* buffer = get_string_with_nuls( &bufferSize );

This way, `get_string_with_nuls` can handle the `malloc` with exactly the correct
size and give it to me. I don't have to guess at a size beforehand.

Of course, a struct could do this better, or since I'm actually in C++, an
object. I'll be planning a new API as soon as I confirm this one actually
works and has proper tests (written in Perl, of course).
