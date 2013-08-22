#!/usr/bin/env perl

use Mojolicious::Lite;
use Mojo::JSON;

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

post '/api/user/:id' => sub {
    my ( $self, $id ) = @_;
    my $update = Mojo::JSON->new->decode( $self->req->body );
    $mango->db->collection('user')->update( { _id => $id }, $update );
    $self->redirect_to( '/api/user/' . $id );
};

get '/api/user/:id' => sub {
    my ( $self, $id ) = @_;
    $self->render(
        json => $mango->db->collection('user')->find_one({ _id => $id }),
    );
};

app->start;
__DATA__
@@ index.html.ep
<!DOCTYPE html>
<html id="ng-app" ng-app="MyApp">
    <head>
        <link rel="stylesheet" href="/css/bootstrap.min.css" />
    </head>
    <body ng-controller="UserCtrl" class="container">
        <table class="table table-striped">
            <tr>
                <th>E-mail</th>
                <th>Created</th>
                <th>Last Seen</th>
                <th>Can Play</th>
            </tr>
            <tr ng-repeat="user in users">
                <td>{{user.email}}</td>
                <td>{{format_date(user.date_created)}}</td>
                <td>{{format_date(user.date_last_seen)}}</td>
                <td><input type="checkbox" ng-model="user.can_play" ng-change="user.$save()" /></td>
            </tr>
        </table>
        <script src="/js/jquery.min.js"></script>
        <script src="/js/bootstrap.min.js"></script>
        <script src="/js/angular.min.js"></script>
        <script src="/js/angular-resource.min.js"></script>
        <script src="/js/moment.js"></script>
        <script>
            angular.module( 'MyApp', [ 'ngResource' ] )
            .factory( 'User', [ '$resource',
                    function ( $resource ) {
                        return $resource( '/api/user/:id', { id: '@_id' } );
                    }
                ]
            )
            .controller( 'UserCtrl', [ '$scope', 'User',
                    function ( $scope, User ) {
                        $scope.users = User.query();
                        $scope.format_date = function ( epoch ) {
                            if ( !epoch ) return;
                            return moment( epoch ).calendar();
                        };
                    }
                ]
            )
            ;
        </script>
    </body>
</html>
