#!/usr/bin/env perl

use Mojolicious::Lite;
use Mojo::JSON;

use Mango;
use Mango::BSON qw( bson_oid );
my $mango = Mango->new;
$mango->default_db( 'jade_kingdom' );

get '/' => 'index';

get '/api/user' => sub {
    my ( $self ) = @_;
    $self->render(
        json => $mango->db->collection('user')->find->all,
    );
} => 'user_list';

post '/api/user/:id' => sub {
    my ( $self ) = @_;
    my $id = $self->stash( 'id' );
    my $update = $self->req->json;
    $update->{_id} = bson_oid $update->{_id};
    $mango->db->collection('user')->save( $update );
    return $self->redirect_to( url_for('user', id => $id, method => 'GET' ) );
} => 'user_save';

get '/api/user/:id' => sub {
    my ( $self ) = @_;
    my $id = bson_oid $self->stash( 'id' );
    $self->render(
        json => $mango->db->collection('user')->find_one({ _id => $id }) || {},
    );
} => 'user';

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
        <script src="/js/angular.js"></script>
        <script src="/js/angular-resource.js"></script>
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
