package Bullwinkle::Server::Role::Listening;

our $VERSION = '0.01_05';
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

version 0.01_05

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


=head2 CONTRIBUTORS


=head1 COPYRIGHT
 
Copyright E<copy> 2012, the Bullwinkle L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE
 
This library is free software and may be distributed under the same terms
as perl itself.


=cut
