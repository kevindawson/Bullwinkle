package Bullwinkle::Server::Parameters;

use v5.10;
our $VERSION = '0.01_05';
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
	my $current_values = { 
		api => $self->api,
		port => $self->port,
		host => $self->host,
		file => $self->file,
		transport => $self->transport,
	};
	# p $current_values;
	return $current_values;
}

1;

__END__

=pod

=head1 NAME

Bullwinkle::Server::Parameters.

=head1 VERSION

version 0.01_05

=head1 DESCRIPTION

Provides the IO Parameters for the Bullwinkle Server


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

Bullwinkle::Server::IO


=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

Rocky Bernstein E<lt>rocky@cpan.orgE<gt>

=head2 CONTRIBUTORS


=head1 COPYRIGHT
 
Copyright E<copy> 2012, the Bullwinkle L</AUTHOR> and L</CONTRIBUTORS>
as listed above.
 
=head1 LICENSE
 
This library is free software and may be distributed under the same terms
as perl itself.

=cut
