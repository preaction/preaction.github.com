package WebGUI::Asset::HelloWorld;

use Moose;
use WebGUI::Definition::Asset;
extends 'WebGUI::Asset';

define 'assetName' => 'Hello World';

sub www_view {
    my ( $self ) = @_;
    $self->session->response->content_type('text/plain');
    return "Hello, World!\n";
}

1;
