package Bullwinkle::Client::Parameters;

use v5.10;
our $VERSION = '0.01_04';
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

__END__

=pod

=head1 NAME

Bullwinkle::Client::Parameters.

=head1 VERSION

version  0.01_01

=head1 DESCRIPTION

Provides the Message blocks for the Bullwinkle Test Server


=head1 METHODS

=over 4

=item * show_parameters

=back

=head1 ATTRIBUTES

=over 4

=item *	api

=item *	file

=item *	host

=item *	port

=item *	transport

=back

=head1 BUGS AND LIMITATIONS

None known.

=head1 DEPENDENCIES

Moo

=head1 SEE ALSO

Bullwinkle::Client::Commands


=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

Rocky Bernstein E<lt>rocky@cpan.orgE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright &copy 2012, Kevin Dawson E<lt>bowtie@cpan.orgE<gt> Rocky Bernstein E<lt>rocky@cpan.orgE<gt>. All rights reserved.


This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut