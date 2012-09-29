package Bullwinkle::Client::Commands;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_01';

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
has 'continue' => (
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

version  0.01_01

=head1 DESCRIPTION

Provides the Message blocks for the Bullwinkle Test Client


=head1 ATTRIBUTES

=over 4

=item *	continue

=item *	continue_file

=item *	continue_function

=item *	continue_line

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

=head1 LICENCE AND COPYRIGHT

Copyright &copy 2012, Kevin Dawson E<lt>bowtie@cpan.orgE<gt> Rocky Bernstein E<lt>rocky@cpan.orgE<gt>. All rights reserved.


This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

