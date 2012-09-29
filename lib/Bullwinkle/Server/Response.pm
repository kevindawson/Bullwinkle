package Bullwinkle::Server::Response;

use v5.10;
use Moo;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_01';

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
has 'recived' => (
	is      => 'ro',
	default => sub {
		my $self = shift;

		return { recived => 'with thanks', };
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


1;

__END__

=pod

=head1 NAME

Bullwinkle::Server::Response.

=head1 VERSION

version  0.01_01

=head1 DESCRIPTION

none


=head1 ATTRIBUTES

=over 4

=item *	bullwinkle

=item *	continue_file

=item *	init

=item *	recived

=item *	status

=back

=head1 BUGS AND LIMITATIONS

None known.

=head1 DEPENDENCIES

Moo

=head1 SEE ALSO

none


=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

Rocky Bernstein E<lt>rocky@cpan.orgE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright &copy 2012, Kevin Dawson E<lt>bowtie@cpan.orgE<gt> Rocky Bernstein E<lt>rocky@cpan.orgE<gt>. All rights reserved.


This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
