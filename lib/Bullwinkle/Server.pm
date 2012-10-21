package Bullwinkle::Server;

use v5.10;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
our $VERSION = '0.01_05';
use autodie qw(:all);             # Recommended more: defaults and system/exec.

use Moo;
extends 'Bullwinkle::Server::IO';
use Bullwinkle::Server::Response;

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
use constant {
	TRUE  => 1,
	FALSE => 0,
};


sub init {
	my $self     = shift;
	my $response = Bullwinkle::Server::Response->new;
	$self->{response} = $response;
	return 1;
}


sub run {
	my $self = shift;

	$self->init;
	$self->start_host;
	# $self->start_host( $self->{transport} );

	# say 'is_listening = ' . $self->is_listening;

	if ( $self->is_listening eq TRUE ) {

		# $self->accept;
		# say 'polling socket';
		$self->service_socket;

	} else {
		say 'exiting see error above';
	}

	return;
}


sub service_socket {
	my $self = shift;

	$self->accept;
	my $socket = $self->{socket};

	my $client_host = $socket->peerhost;
	my $client_port = $socket->peerport;
	say "Received connection from Client $client_host:$client_port";

	#send initialisation message
	$self->json_to_client( $self->{response}->init );

	while (<$socket>) {
		# p $_;
		$self->send_response($_);
	}

	return;
}

#######
# composed method recived_data
#######
sub check_data {
	my $self    = shift;
	my $data    = shift;
	my $is_json = TRUE;

	#echo to console
	p $data;

	try {
		$self->{perl_scalar} = JSON::XS->new->utf8->decode($data) // undef;
		# say Data::Dumper::Dumper( JSON::XS->new->utf8->decode($data) );
	}
	catch {
		$self->json_to_client( $self->{response}->bullwinkle );
		$is_json = FALSE;
	};

	return $is_json;
}
#######
# composed method recived_data
#######
sub send_response {
	my $self = shift;
	my $data = shift;

	if ( $self->check_data($data) ) {

		given ( $self->{perl_scalar} ) {
			when ( defined $self->{perl_scalar}->{quit} ) { $self->close_socket; last; }
			when ( defined $self->{perl_scalar}->{status} )                   { $self->status( $self->{perl_scalar} ) }
			when ( defined $self->{perl_scalar}->{continue}{location}{file} ) { $self->continue_file; }

			# when ( $_ eq 'error' )        { $self->{list}->SetItemTextColour( $index, RED ); }
			default { $self->received( $self->{perl_scalar} ); }

		}
	}
	return;
}



#######
# Response messages
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
	$self->json_to_client( $self->{response}->quit );
	close $self->{socket} or carp;
	say 'so long and thanks for all the fish';
	return;
}

sub status {
	my $self   = shift;
	my $status = shift;

	# p $status;
	$self->json_to_client( $self->{response}->status );
	return;
}

sub continue_file {
	my $self = shift;
	$self->json_to_client( $self->{response}->continue_file );
	return;
}


sub received {
	my $self   = shift;
	my $echo   = shift;
	my $output = $self->{response}->received;
	# p $output;
	$output->{echo} = $echo;
	# p $output;
	$self->json_to_client($output);
	return;
}


1; # Magic true value required at end of module

__END__


=head1 NAME

Bullwinkle::Server - [One line description of module's purpose here]


=head1 VERSION

This document describes Bullwinkle::Server version  0.01_05


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


=head1 METHODS

=over 4

=item * check_data

=item *	close_socket

=item * continue_file

=item * init

=item *	json_to_client

=item *	received

=item *	run

=item *	send_response

=item *	service_socket

=item *	status

=item *	text_to_client

=back


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
