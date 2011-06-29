package MyApp;
use Moose;
use Template::Simple;
extends 'Plack::Component';
has posts => (
    is      => 'rw',
    default => sub { [] },
);
has tmpl => (
    is      => 'ro',
    default => sub {
        Template::Simple->new(
            templates => {
                view => <<'ENDTMPL',
<form><label>Name:<input name="name"/></label>
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
    return $self->posts_html;
}
sub add_post {
    my ( $self, $row ) = @_;
    push @{$self->posts}, $row;
}
sub posts_html {
    my ( $self ) = @_;
    return $self->tmpl->render( $posts );
}

1;
