package Bullwinkle::Server::Response;

use v5.10;
use Moo;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_04';

has 'init' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return {
			init => {
				language         => 'perl',
				protocol_version => '2.0',
				fileuri          => 'file://path/to/file',
			},
		};
	},
);
has 'bullwinkle' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			bullwinkle => {
				error   => '90',
				message => 'Encoding not supported, Bullwinkle only talks in JSON',
			}
		};
	},
);
has 'received' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return { 
			recived => 'with thanks', 
			echo => 'echo', 
			};
	},
);
has 'status' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			response => {
				command => 'status',
				status  => 'running',
				reason  => 'ok',
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
has 'quit' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			response => {
				command => 'quit',
				status  => 'stopped',
				reason  => 'ok',
			},
		};
	},
);

1;

__END__

=pod

=head1 NAME

Bullwinkle::Server::Response.

=head1 VERSION

version  0.01_04

=head1 DESCRIPTION

Provides the Message blocks for the Bullwinkle Test Server


=head1 ATTRIBUTES

=over 4

=item *	bullwinkle

=item *	continue_file

=item *	init

=item *	quit

=item *	received

=item *	status

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


=head2 CONTRIBUTORS


=head1 COPYRIGHT
 
Copyright E<copy> 2012, the Bullwinkle L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE
 
This library is free software and may be distributed under the same terms
as perl itself.


=cut

