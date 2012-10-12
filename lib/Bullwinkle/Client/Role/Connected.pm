package Bullwinkle::Client::Role::Connected;

our $VERSION = '0.01_03';
use Moo::Role;

use constant {
	TRUE => 1,
	FALSE => 0,
};

requires qw( is_connected );

has 'connected' => (
	is      => 'rw',	
	default => sub {
		my $self = shift;
		return $_[0] // FALSE;
	},
);

1;
