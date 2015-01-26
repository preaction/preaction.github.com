#!/usr/bin/env perl

use Mojolicious::Lite;

get '/' => sub {
    my ( $self ) = @_;
    $self->render( 'index' );
};

app->start;
__DATA__
@@ index.html.ep
<h1>It works!</h1>
