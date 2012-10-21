package Bullwinkle::Server::IO;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_05';

use Moo;
extends 'Bullwinkle::Server::Parameters';
with 'Bullwinkle::Server::Role::Listening';

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
};

# as requested, see role
sub is_listening {
	my $self = shift;
	return $self->{listening};
}

#######
# run required transport
#######
sub start_host {
	my $self = shift;

	# my $transport = shift;

	given ( $self->{transport} ) {
		when ( $_ eq 'tcp/ip' ) { $self->tcp_ip; }

		# default { $self->tcp_ip; }
	}

	return 1;
}

#######
# default tcp_ip
#######
sub tcp_ip {
	my $self = shift;

	$self->{porto}      = 'tcp';
	$self->{listen}     = 1;
	$self->{reuse_addr} = 1;

	my $server;
	try {
		$server = IO::Socket::IP->new(
			LocalHost => $self->{host},
			LocalPort => $self->{port},
			Proto     => $self->{porto},
			Listen    => $self->{listen},
			ReuseAddr => $self->{reuse_addr},

		) or croak "Error: Could not establish the socket $self->{host}:$self->{port} ->$ERRNO 'lsof -i :9000'";
		$self->listening(TRUE);
	}
	catch {
		if ($_) {
			say "Error: Could not establish the socket $self->{host}:$self->{port} -> $ERRNO";
			say "you can see ware -> sudo lsof -i :$self->{port}";
			$self->listening(FALSE);
		}
	};

	$self->{server} = $server;

	return;
}

#######
# compose method accept
#######
sub accept {
	my $self = shift;

	if ( $self->is_listening eq TRUE ) {

		my $msg = sprintf(
			"Waiting for a connection on port %d at address %s...",
			$self->{port}, $self->{host}
		);
		say $msg;

		$self->{socket} = $self->{server}->accept or carp;
	}

	return;
}


1;

__END__


=pod

=head1 NAME

Bullwinkle::Server::IO.

=head1 VERSION

version  0.01_04

=head1 DESCRIPTION

IO for the Bullwinkle Test Server

=head1 METHODS

=over 4

=item * accept

=item *	is_listening

=item * start_host

=item * tcp_ip

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
