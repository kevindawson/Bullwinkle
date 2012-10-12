package Bullwinkle::Client::Parameters;

use v5.10;
our $VERSION = '0.01_03';
use Moo;

has 'api' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		# No hablo
		return $_[0] // 'bullwinkle';
	},
);
has 'port' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return $_[0] // '9000';
	},
);
has 'host' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return $_[0] // '127.0.0.1';

	},
);
has 'file' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return $_[0] // "I don't need a file as I just pretend";

	},
);
has 'transport' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		# I only know how to do tcp/ip
		return $_[0] // 'tcp/ip';

	},
);

sub show_parameters {
	my $self = shift;
	say 'api: ' . $self->api;
	say 'port: ' . $self->port;
	say 'host: ' . $self->host;
	say 'file: ' . $self->file;
	say 'transport: ' . $self->transport;
	return;
}


1;
