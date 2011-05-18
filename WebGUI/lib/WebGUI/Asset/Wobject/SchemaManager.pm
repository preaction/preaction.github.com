package WebGUI::Asset::Wobject::SchemaManager;
use Moose;
use WebGUI::Definition::Asset;
extends 'WebGUI::Asset::Wobject';
define 'assetName' => 'Schema Manager';
use My::Schema;
has 'schema' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = $_[0];
        My::Schema->connect(
            sub{ $self->session->db->dbh },
            { unsafe => 1 } 
        );
    },
);

has 'resultClass' => (
    is      => 'ro',
    default => 'My::Schema::Result::Employee',
);
has 'rs' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        $_[0]->schema->resultset( $_[0]->resultClass )
    },
);

sub www_view {
    my ( $self ) = @_;
    my $session = $self->session;
    my $rs = $self->rs;
    my $template
        = WebGUI::Asset->newById( $session, 'o61VdYlrT52-ErovFs45nA' );
    $template->setParam( rows => [ map { { $_->get_columns } } $rs->all ] );
    return $template;
}

use WebGUI::FormBuilder;
sub getRowForm {
    my ( $self, $row ) = @_;
    my $fb = WebGUI::FormBuilder->new( $self->session );
    $fb->addField( "ReadOnly",
        name        => 'id',
        label       => 'ID',
        value       => $row ? $row->id
                    : $self->session->id->generate,
    );
    $fb->addField( "Text",
        name        => 'name',
        label       => 'Name',
        value       => $row ? $row->name : '',
    );
    $fb->addField( "Text",
        name        => 'salary',
        label       => 'Salary',
        value       => $row ? $row->salary : '',
    );
    $fb->addField( "Textarea",
        name        => 'notes',
        label       => 'Notes',
        value       => $row ? $row->notes : '',
    );
    return $fb;
}

sub www_editRow {
    my ( $self ) = @_;
    my $ses = $self->session;
    my $row;
    if ( my $rowId = $ses->request->param('rowId') ) {
        $row = $self->rs->find({ id => $rowId });
    }

    my $fb = $self->getRowForm( $row );
    $fb->action( '?' );
    $fb->addField( 'Hidden', 
        name => 'func', value => 'editRowSave',
    );
    $fb->addField( 'Submit' );

    my $fb_css = $ses->url->extras('css/wg-formbuilder.css');
    return sprintf( '<link rel="stylesheet" href="%s"/>', $fb_css ) 
           . $fb->toHtml;
}

sub www_editRowSave {
    my ( $self ) = @_;
    my $req = $self->session->request;
    my $values = $self->getRowForm->process;
    my $row = $self->rs->update_or_create( $values );
    $self->session->response->setRedirect( $self->getUrl );
    return;
}

override dispatch => sub {
    my ( $self, $frag ) = @_;
    if ( $frag eq '.json' ) {
        return JSON->new->encode(
            [ map { { $_->get_columns } } $self->rs->all ]
        );
    }
    super();
};

1;
