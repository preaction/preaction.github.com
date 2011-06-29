package MyApp;
use Moose;
use Template::Simple;
use Plack::Request;
use Plack::Response;
extends 'Plack::Component';
has posts => (
    is      => 'rw',
    lazy    => 1,
    default => sub { [] },
);
has tmpl => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        Template::Simple->new(
            templates => {
                view => <<'ENDTMPL',
<form method="post"><label>Name:<input name="name"/></label>
<label>Comment:<textarea name="text"></textarea></label></form>
[% START posts %]
<p>[% name %] -- [% text %]</p>
[% END posts %]
ENDTMPL
            },
        );
    }
);
sub call {
    my ( $self, $env ) = @_;

    my $req = Plack::Request->new( $env );
    if ( $req->method eq 'POST' ) {
        $self->add_post( $req->parameters );
    }

    my $res = Plack::Response->new(200);
    $res->content_type('text/html');
    $res->body( $self->posts_html );
    return $res->finalize;
}
sub add_post {
    my ( $self, $row ) = @_;
    push @{$self->posts}, $row;
}
sub posts_html {
    my ( $self ) = @_;
    return ${ $self->tmpl->render( 'view', { posts => $self->posts } ) };
}

1;
