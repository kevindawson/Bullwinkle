package Bullwinkle::Client::IO;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_05';

use Moo;
extends 'Bullwinkle::Client::Parameters';
with 'Bullwinkle::Client::Role::Connected';

use IO::Socket::IP 0.17;
use Carp 1.20 qw(carp croak);
use Try::Tiny;
use Data::Printer {
	caller_info => 0,
	colored     => 1,
};

use constant {
	TRUE  => 1,
	FALSE => 0,
	BLANK => qq{ },
	NONE  => q{},
};

# as requested, see role
sub is_connected {
	my $self = shift;
	return $self->{connected};
}

#######
# event handlers for menu options
#######
sub start_connection {
	my $self = shift;

	unless ( $self->is_connected ) {

		try {
			# Connect to Bullwinkle Server.
			$self->{client_socket} = IO::Socket::IP->new(
				PeerAddr => $self->{host},
				PeerPort => $self->{port},
				Proto    => $self->{porto} // 'tcp',

			) or carp "Could not connect to host 127.0.0.1:9000 ->$ERRNO";
			$self->connected(TRUE);
		};

	}

	return;# $self->{client_socket};
}

sub disconnect {
	my $self = shift;
	if ( $self->is_connected eq TRUE ) {
		close $self->{client_socket} or carp;
	}
	$self->connected(FALSE);
	return;
}

sub send {
	my ( $self, @data ) = @_;

	if ( $self->is_connected eq TRUE ) {
		print { $self->{client_socket} } "@data";
	}

	return;
}

sub receive {
	my $self = shift;
	my $data = BLANK;
	if ( $self->is_connected eq TRUE ) {
		$self->{client_socket}->recv( $data, 1024 );
	}
	return $data;
}


1;

__END__

=pod

=head1 NAME

Bullwinkle::Client::IO.

=head1 VERSION

version  0.01_04

=head1 DESCRIPTION

IO for the Bullwinkle Test Client


=head1 METHODS

=over 4

=item *	disconnect

=item *	is_connected

=item * receive

=item * send

=item *	start_connection

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
