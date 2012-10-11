package Bullwinkle::Server::Role::Listening;

our $VERSION = '0.01_03';
use Moo::Role;

use constant {
	TRUE => 1,
	FAUSE => 0,
};

requires qw( is_listening );

has 'listening' => (
	is      => 'rw',	
	default => sub {
		my $self = shift;
		return $_[0] // FAUSE;
	},
);

1;