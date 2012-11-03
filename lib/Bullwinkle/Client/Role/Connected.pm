package Bullwinkle::Client::Role::Connected;

our $VERSION = '0.01_06';
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

version 0.01_06

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


=head2 CONTRIBUTORS


=head1 COPYRIGHT
 
Copyright E<copy> 2012, the Bullwinkle L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE
 
This library is free software and may be distributed under the same terms
as perl itself.


=cut
