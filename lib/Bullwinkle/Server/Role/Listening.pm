package Bullwinkle::Server::Role::Listening;

our $VERSION = '0.01_04';
use Moo::Role;

use constant {
	TRUE => 1,
	FAUSE => 0,
};

requires qw( is_listening );

has 'listening' => (
	is      => 'rw',	
	default => sub {
		my $self = shift;
		return $_[0] // FAUSE;
	},
);

1;

__END__

=pod

=head1 NAME

Bullwinkle::Server::Role::Listening.

=head1 VERSION

version  0.01_04

=head1 DESCRIPTION

Requires the is_listening Role for the Bullwinkle Test Server


=head1 ATTRIBUTES

=over 4

=item *	listening

=back

=head1 BUGS AND LIMITATIONS

None known.

=head1 DEPENDENCIES

Moo

=head1 SEE ALSO

Bullwinkle::Server


=head1 AUTHOR

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>

Rocky Bernstein E<lt>rocky@cpan.orgE<gt>

=head1 LICENCE AND COPYRIGHT

Copyright &copy 2012, Kevin Dawson E<lt>bowtie@cpan.orgE<gt> Rocky Bernstein E<lt>rocky@cpan.orgE<gt>. All rights reserved.


This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut