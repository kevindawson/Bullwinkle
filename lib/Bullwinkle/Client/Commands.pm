package Bullwinkle::Client::Commands;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_05';

use Moo;
has 'status' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return {
			status => 'info',
		};
	},
);
has 'quit' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return {
			quit => 'so long',
		};
	},
);
has 'continue_null' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			continue => {},
		};
	},
);
has 'continue_function' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			continue => {
				location => {
					function => 'gcd',
				},
			},
		};
	},
);
has 'continue_line' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			continue => {
				location => {
					line => '5',
				},
			},
		};
	},
);
has 'continue_file' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			continue => {
				location => {
					file => 'mymodule.pm',
					line => '5',
				},
			},
		};
	},
);


1;

__END__

=pod

=head1 NAME

Bullwinkle::Client::Commands

=head1 VERSION

version 0.01_05

=head1 DESCRIPTION

Provides the Message blocks for the Bullwinkle Test Client


=head1 ATTRIBUTES

=over 4

=item *	continue_file

=item *	continue_function

=item *	continue_line

=item *	continue_null

=item *	quit

=item *	status

=back

=head1 BUGS AND LIMITATIONS

None known.

=head1 DEPENDENCIES

Moo

=head1 SEE ALSO

Bullwinkle::Server::Response


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


