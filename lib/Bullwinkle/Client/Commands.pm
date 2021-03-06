package Bullwinkle::Client::Commands;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_06';

use Moo;
use JSON::Types;
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
			command => 'quit',
		};
	},
);
has 'continue_null' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			command => 'continue',
		};
	},
);
has 'continue_function' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			command  => 'continue',
			location => {
				function => 'gcd'
			},
		};
	},
);
has 'continue_line' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			command  => 'continue',
			location => {
				line => JSON::Types::number(5),
			},
		};
	},
);
has 'continue_file' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return {
			command  => 'continue',
			location => {
				file => 'mymodule.pm',
				line => JSON::Types::number(5),
			},
		};
	},
);
has 'info_line' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			command => 'info_line',
		};
	},
);
has 'info_program' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			command => 'info_program',
		};
	},
);

1;

__END__

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
=pod

=head1 NAME

Bullwinkle::Client::Commands

=head1 VERSION

version 0.01_06

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


