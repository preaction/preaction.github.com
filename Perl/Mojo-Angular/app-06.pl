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
<!DOCTYPE html>
<html id="ng-app" ng-app="MyApp">
    <body ng-controller="UserCtrl">
        <table>
            <tr>
                <th>E-mail</th>
                <th>Created</th>
                <th>Last Seen</th>
                <th>Can Play</th>
            </tr>
            <tr ng-repeat="user in users">
                <td>{{user.email}}</td>
                <td>{{user.date_created}}</td>
                <td>{{user.date_last_seen}}</td>
                <td>{{user.can_play}}</td>
            </tr>
        </table>
        <script src="/js/angular.min.js"></script>
        <script src="/js/angular-resource.min.js"></script>
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
                    }
                ]
            )
            ;
        </script>
    </body>
</html>
