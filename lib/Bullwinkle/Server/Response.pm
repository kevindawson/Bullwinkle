package Bullwinkle::Server::Response;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.06';

use Moo;
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

Padre::Plugin::Nopaste::Services - NoPaste plugin for Padre, The Perl IDE.

=head1 VERSION

version  0.06

=head1 DESCRIPTION

This just a utility module with information about App::Nopaste Services and 
Channels respectively serviced known to us.


=head1 ATTRIBUTES

=over 4

=item *	Codepeek

=item *	Debian

=item *	Gist

=item *	PastebinCom

=item *	Pastie

=item *	Shadowcat

=item *	Snitch

=item *	Ubuntu

=item *	channels

=item *	servers

=item *	ssh

=back

=head1 BUGS AND LIMITATIONS

None known.

=head1 DEPENDENCIES

Moo

=head1 SEE ALSO

For all related information (bug reporting, source code repository,
etc.), refer to L<Padre::Plugin::Nopaste>.

=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2012 kevin dawson, all rights reserved.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


# Copyright 2008-2012 The Padre development team as listed in Padre.pm.
# LICENSE
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl 5 itself.

