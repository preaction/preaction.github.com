package My::Schema::Result::Employee;
use base 'DBIx::Class::Core';
__PACKAGE__->table('employee');
__PACKAGE__->add_columns(qw/ id name salary notes /);
__PACKAGE__->set_primary_key('id');

1;
