#!/usr/bin/env perl

use Test::More;
use Test::WWW::Mechanize::PSGI;
use MyApp;
my $mech = Test::WWW::Mechanize::PSGI->new( app => MyApp->new->to_app );

$mech->get_ok( '/', 'get the form' );
$mech->submit_form_ok(
    {
        fields  => {
            name    => 'Scrappy Doo',
            text    => 'Puppy power!',
        },
    },
    "Add a guestbook entry",
);

$mech->content_contains( "Scrappy Doo" );
$mech->content_contains( "Puppy power!" );

done_testing;
