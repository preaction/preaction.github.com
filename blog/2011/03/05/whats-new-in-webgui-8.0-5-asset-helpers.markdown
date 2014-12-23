---
title: What's New in WebGUI 8.0 #5 - Asset Helpers
author: preaction
tags: webgui
last_modified: 2014-06-21 01:28:00
links:
    crosspost:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2011/03/whats-new-in-webgui-80-5---asset-helpers.html
---

By far the biggest change we've made in WebGUI 8 is the new Admin Console.
Though parts of it may look familiar, it has been completely rewritten from
the ground up to be a flexible, extensible, responsive JavaScript application
making calls to JSON services in Perl.

I could talk about how to use the admin interface, but I don't think that's
why you would read this blog, so instead I'm going to talk about how you can add functionality to it.

---

## Asset Services

Since Assets are the basic unit of both application and content in WebGUI,
much of the Admin Console is spent interacting with Assets. It does so by
calling out to Asset Helpers.

By default, every asset has a helper to Cut, Copy, Duplicate, Delete, and
more. When a helper gets called, it returns a JSON data structure explaining
to the Admin Console what to do next.

We can simply show the user a message:

    message     => 'The work is done, here's what happened.'
    error       => 'Something went wrong.'

Or we can open up new dialogs or tabs to allow the user to give us more data:

    openDialog  => '/helper/get_input'
    openTab     => '/helper/get_input'

We can let the user know their command is running in a forked process:

    forkId      => '...' # GUID for WebGUI::Fork object

We can even load and run any external JS file:

    scriptFile  => '/extras/newscript.js',  # Load a new script file
    scriptFunc  => 'myFunction',            # Call a function in that script
    scriptArgs  => [ "arg1", "arg2", ],     # Pass some arguments to that func

To write an Asset Helper, we inherit from WebGUI::AssetHelper and override the
process() method to send back one of the message types from above.

    package MyHelper;
    use base 'WebGUI::AssetHelper';

    sub process {
        my ( $self ) = @_;

        return { error => 'Cry Havoc!' } if !$self->asset->canEdit;

        # Do some work

        return { message => 'Work is done!' };
    }

If our Asset Helper needs to get some input from the user, we can open a
dialog. Like most everything in WebGUI, Asset Helpers can also have www_
methods.

    package MyFormHelper;
    use base 'WebGUI::AssetHelper';

    sub process {
        my ( $self ) = @_;
        my $url = $self->getUrl( "showForm" );
        return { openDialog => $url };
    }

    sub www_showForm {
        my ( $self ) = @_;
        my $form    = $self->getForm( 'processForm' ); # WebGUI::FormBuilder
        $form->addField( "text", name => 'why' );
        return $form->toHtml;
    }

    sub www_processForm {
        my ( $self ) = @_;
        my $input = $self->session->form->get( 'why' ); # input from the form
        return { message => $input }; # Why not?
    }

But our asset helpers are not only useful inside of the Admin Console. Because
they're all built on a simple JSON API, you can call them from anywhere. For
example, the Asset Helper to resize and rotate images could be used by anyone
with edit privileges to the Image.

Because we already have these Asset Helpers, the new Asset Manager (now called 
the Tree view) uses them to perform all of its tasks. This means, again, more
code reuse and less code in WebGUI.

Side note: I love deleting code much more than writing it.

## Adding Helpers

What would a plugin point be without a way to override what already exists? In
our case, if you want another helper to handle the "cut" operation, you can
make it happen.

If you have your own asset, you can override the getHelpers method, which
returns a hashref of helper descriptions:

    package MyAsset;

    around getHelpers => sub {
        my ( $orig, $self ) = @_;
        my $helpers = $self->$orig;
        $helpers->{ "cut" } = {
            className   => 'MyCutHelper',
            label       => 'SuperCuts',
        };
        return $helpers;
    };

Or if you don't want to edit the asset's code, you could add your helpers to
the configuration file:

    {
        "assets" : {
            "WebGUI::Asset::Snippet" : {
                "helpers" : {
                    "cut" : {
                        "className" : "MyCutHelper",
                        "label"     : "SuperCuts"
                    }
                }
            }
        }
    }

Side Note: Deep data-structure is deep.

A Helper doesn't have to be its own class, it could be any URL at all:

    $helpers->{ "edit" } = {
        url     => './edit',
        label   => 'Edit',
    };

So Asset Helpers are the new way to add related tasks to your assets. Come
back next time when I introduce WebGUI::FormBuilder.

