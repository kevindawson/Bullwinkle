package Bullwinkle::Server::Response;

use v5.10;
use Moo;
use JSON::Types;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_06';

has 'init' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return {
			location => {
				canonic_filename => '/home/kevin/GitHub/Bullwinkle/scripts/rocky001.pl',
				line_number      => JSON::Types::number(10),
				filename         => '/home/kevin/GitHub/Bullwinkle/scripts/rocky001.pl',
				op_addr          => JSON::Types::number(151544232)
			},
			text    => 'print "there!\\n";',
			name    => 'stop_location',
			event   => 'line',
			package => 'main',
		};
	},
);
has 'bullwinkle' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			bullwinkle => {
				error   => JSON::Types::number(90),
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
			received => 'with thanks',
			echo     => 'echo',
		};
	},
);
has 'status_ready' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			response => {
				status => 'ready',
			},
		};
	},
);
has 'status_error' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			response => {
				status => 'error',
				error  => JSON::Types::number(20),
			},
		};
	},
);
has 'status_paused' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			response => {
				status => 'paused',
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
					line => JSON::Types::number(5),
				},
			},
		};
	},
);
has 'info_line' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			name     => 'info_line',
			location => {
				canonic_filename => '/home/kevin/GitHub/Bullwinkle/scripts/rocky001.pl',
				line_number      => JSON::Types::number(10),
				filename         => 'scripts/rocky001.pl',
				op_addr          => 'print "there!\\n";',
			},
		};
	},
);
has 'info_program' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return {
			name    => 'info_program',
			address => JSON::Types::number(153997736),
			event   => 'line',
			program => '/home/kevin/GitHub/Bullwinkle/scripts/rocky001.pl',
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










=pod

=head1 NAME

Bullwinkle::Server::Response.

=head1 VERSION

version 0.01_06

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

