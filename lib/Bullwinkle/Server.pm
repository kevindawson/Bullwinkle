package Bullwinkle::Server;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_01';
use autodie qw(:all);             # Recommended more: defaults and system/exec.

use Moo;
use Bullwinkle::Server::Response;
use IO::Socket::IP 0.17;
use Carp 1.20 qw(carp croak);
use Try::Tiny;
use JSON::XS;
use Data::Dumper;
$Data::Dumper::Purity = 1;
$Data::Dumper::Terse  = 1;
$Data::Dumper::Indent = 1;

use Data::Printer {
	caller_info => 0,
	colored     => 1,
};



has 'api' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return $_[0] // 'No hablo';
	},
);
has 'port' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return $_[0] // '9000';
	},
);
has 'host' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return $_[0] // '127.0.0.1';

	},
);
has 'file' => (
	is      => 'ro',
	default => sub {
		my $self = shift;
		return $_[0] // "I don't need a file as I just pretend";

	},
);

sub run {
	my $self     = shift;
	my $response = Bullwinkle::Server::Response->new;
	$self->{response} = $response;
	$self->start_host;
	$self->service_socket;

	return;
}

sub start_host {
	my $self = shift;

	say $self->{host} . ':' . $self->{port};


	#for IO::Socket::IP
	$self->{porto}      = 'tcp';
	$self->{listen}     = 1;
	$self->{reuse_addr} = 1;


	# Open a socket for the bullwinkle client to connect to.
	my $sock = IO::Socket::IP->new(
		LocalHost => $self->{host},
		LocalPort => $self->{port},
		Proto     => $self->{porto},
		Listen    => $self->{listen},
		ReuseAddr => $self->{reuse_addr},

		# Open      => 1,
	) or carp "Could not establish the socket $self->{host}:$self->{port} ->$!";

	$self->{socket} = $sock->accept() or die sprintf "ERRRR(%d)(%s)(%d)(%s)", $!, $!, $^E, $^E;

	return;
}

sub service_socket {
	my $self = shift;

	my $msg = sprintf(
		"Waiting for a connection on port %d at " . "address %s...",
		$self->{port}, $self->{host}
	);
	say $msg;

	say 'Got connection';

	#send initilzation message
	$self->json_to_client( $self->{response}->init );

	my $socket = $self->{socket};

	while (<$socket>) {
		my $client_json = $_;
		p $client_json;
		my $perl_scalar;
		try {
			$perl_scalar = JSON::XS->new->utf8->decode($client_json);
			# eitor or depending on your preferance
			# p $perl_scalar;
			say Data::Dumper::Dumper( JSON::XS->new->utf8->decode($client_json) );
		}
		catch {
			$self->json_to_client( $self->{response}->bullwinkle );
		};

		given ($perl_scalar) {
			when ( defined $perl_scalar->{quit} ) { $self->close_socket; last; }
			when ( defined $perl_scalar->{status} ) { $self->status($perl_scalar) }

			# when ( $_ eq 'incompatible' ) { $self->{list}->SetItemTextColour( $index, DARK_GRAY ); }
			# when ( $_ eq 'error' )        { $self->{list}->SetItemTextColour( $index, RED ); }
			default { $self->json_to_client( $self->{response}->recived ); }

		}
	}

	return;
}

#######
# Internal Method _send
#######
sub text_to_client {
	my $self  = shift;
	my $input = shift;

	$self->{socket}->syswrite( $input . "\n" );
	return;
}

sub json_to_client {
	my $self  = shift;
	my $input = shift;

	$self->{socket}->syswrite( JSON::XS->new->utf8->pretty(1)->encode($input) );
	return;
}

sub close_socket {
	my $self = shift;
	say 'closing socket';
	$self->text_to_client('so long and thanks for all the fish');
	close( $self->{socket} );
	say 'so long and thanks for all the fish';
	return;
}

sub status {
		my $self = shift;
		my $status = shift;
		p $status;
		$self->json_to_client( $self->{response}->status );
		return;
}



1; # Magic true value required at end of module
__END__

=head1 NAME

Bullwinkle::Server - [One line description of module's purpose here]


=head1 VERSION

This document describes Bullwinkle::Server version  0.01_01


=head1 SYNOPSIS

    use Bullwinkle::Server;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Bullwinkle::Server requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-bullwinkle-server@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Rocky Bernstein E<lt>rocky@cpan.orgE<gt>

Kevin Dawson E<lt>bowtie@cpan.orgE<gt>


=head1 LICENCE AND COPYRIGHT

Copyright &copy 2012, Rocky Bernstein E<lt>rocky@cpan.orgE<gt> Kevin Dawson E<lt>bowtie@cpan.orgE<gt>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
