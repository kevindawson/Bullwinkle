package Bullwinkle::Client::Role::Connected;

our $VERSION = '0.01_04';
use Moo::Role;

use constant {
	TRUE => 1,
	FALSE => 0,
};

requires qw( is_connected );

has 'connected' => (
	is      => 'rw',	
	default => sub {
		my $self = shift;
		return $_[0] // FALSE;
	},
);

1;
__END__

=pod

=head1 NAME

Bullwinkle::Client::Role::Connected.

=head1 VERSION

version  0.01_04

=head1 DESCRIPTION

Requires the is_connected Role for the Bullwinkle Test Client


=head1 ATTRIBUTES

=over 4

=item *	connected

=back

=head1 BUGS AND LIMITATIONS

None known.

=head1 DEPENDENCIES

Moo

=head1 SEE ALSO

Bullwinkle::Client


=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

Rocky Bernstein E<lt>rocky@cpan.orgE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright &copy 2012, Kevin Dawson E<lt>bowtie@cpan.orgE<gt> Rocky Bernstein E<lt>rocky@cpan.orgE<gt>. All rights reserved.


This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut