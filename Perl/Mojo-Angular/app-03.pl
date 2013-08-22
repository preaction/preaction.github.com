#!/usr/bin/env perl

use Mojolicious::Lite;

use Mango;
my $mango = Mango->new;
$mango->default_db( 'jade_kingdom' );

get '/' => sub {
    my ( $self ) = @_;
    $self->render( 'index' );
};

get '/api/user' => sub {
    my ( $self ) = @_;
    $self->render(
        json => $mango->db->collection('user')->find->all,
    );
};

app->start;
__DATA__
@@ index.html.ep
<h1>It works!</h1>
