package Bullwinkle::Client::Main;

use v5.10;
use strict;
use warnings;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

use Bullwinkle::Client::FBP::Main ();
use Bullwinkle::Client::Commands;
use Bullwinkle::Client::IO;

# use IO::Socket::IP 0.17;
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
	BLANK => qq{ },
	NONE  => q{},
};
our $VERSION = '0.01_04';
use parent qw(
	Bullwinkle::Client::FBP::Main
);


#######
# Method new
#######
sub new {
	my ( $class, @args ) = @_; # What class are we constructing?

	my $self = $class->SUPER::new();

	$self->_initialize(@args);
	# p $self;

	return $self;
}

#######
# _initialize
#######
sub _initialize {
	my ( $self, %args ) = @_;

	#ToDo pram passing all the way from client.pl
	# $self->{local_host} = $args{host}  // 'localhost';
	# $self->{local_port} = $args{port}  // 9_000;
	# $self->{porto}      = $args{proto} // 'tcp';

	my $io = Bullwinkle::Client::IO->new;
	$self->{input_output} = $io;
	$self->{input_output}->show_parameters;

	my $commands = Bullwinkle::Client::Commands->new;
	$self->{commands} = $commands;

	say 'Client running, see status bar for info messages';
}


#######
# button event handlers
#######

sub on_encode_clicked {
	my $self = shift;

	my $hash_ref = eval $self->client_perl->GetValue;
	$self->client_json->SetValue(BLANK);

	if ( defined $hash_ref ) {

		try {
			$self->client_json->SetValue( JSON::XS->new->utf8->pretty(1)->encode($hash_ref) );
		};

	} else {
		$self->client_json->SetValue("info: JSON::XS->encode \nfailed to encode \n<- client_perl");
	}

	return;
}

sub on_send_clicked {
	my $self = shift;

	my $data = BLANK;
	if ( $self->{input_output}->is_connected ) {

		my $json_text = $self->client_json->GetValue;
		if ( $json_text eq BLANK ) { return; }

		# my $perl_scalar;
		try {
			my $perl_scalar = JSON::XS->new->utf8->decode($json_text);

			$self->{input_output}->send( JSON::XS->new->utf8->encode($perl_scalar) . "\n" );
		}
		catch {
			$self->{input_output}->send($json_text);
		};

		$data = $self->{input_output}->receive;
	}
	p $data;
	$self->server_json->SetValue($data);
	$self->server_perl->SetValue(BLANK);

	return;
}

sub on_decode_clicked {
	my $self = shift;

	my $server_json = $self->server_json->GetValue;
	$self->server_perl->SetValue(BLANK);

	if ( defined $server_json ) {

		try {
			if ( decode_json $server_json ) {

				my $output = Data::Dumper::Dumper( JSON::XS->new->utf8->decode($server_json) );
				$self->server_perl->SetValue($output);
				return;
			}
		}
		catch {
			$self->server_perl->SetValue("info: JSON::XS->decode \nfailed to decode \n<- server_json");
			return;
		};

	} else {
		$self->server_perl->SetValue("info: JSON::XS->decode \nfailed to decode \n<- server_json");
	}

	return;
}


sub disconnect_from_server {
	my $self = shift;

	$self->{input_output}->disconnect;

	$self->{send}->Disable;
	$self->auto_run;
	$self->{status_bar}->SetStatusText('Disconnected from Bullwinkle Server');
	return;
}

#######
# event handlers for menu options
#######
sub connect_to_server {
	my $self = shift;

	$self->{input_output}->start_connection;

	if ( $self->{input_output}->is_connected ) {

		$self->{send}->Enable;
		$self->{status_bar}->SetStatusText(
			sprintf(
				"Connected to a Bullwinkle Server %s:%s",
				$self->{input_output}->{host},
				$self->{input_output}->{port},
			)
		);

		my $data = $self->{input_output}->receive;
		$self->server_json->SetValue($data);
		$self->on_decode_clicked;

	} else {
		$self->disconnect_from_server;
		$self->{status_bar}->SetStatusText( sprintf( "Info: %s", $ERRNO ) );
	}

	return;
}


sub status {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $self->{commands}->status );
	$self->client_perl->SetValue($output);

	$self->auto_run;
	return;
}

sub quit {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $self->{commands}->quit );
	$self->client_perl->SetValue($output);

	$self->auto_run;
	$self->disconnect_from_server;

	return;
}

sub auto_run {
	my $self = shift;

	$self->client_json->SetValue(BLANK);
	$self->server_json->SetValue(BLANK);
	$self->server_perl->SetValue(BLANK);

	if ( $self->{input_output}->is_connected ) {
		$self->on_encode_clicked;
		$self->on_send_clicked;
		$self->on_decode_clicked;
	}

	return;
}


sub continue_null {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $self->{commands}->continue_null );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

sub continue_function {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $self->{commands}->continue_function );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

sub continue_line {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $self->{commands}->continue_line );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

sub continue_file {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $self->{commands}->continue_file );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

1;

__END__

=head1 NAME

Bullwinkle::Client::Main - [One line description of module's purpose here]


=head1 VERSION

This document describes Bullwinkle::Client::Main version  0.01_04


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

=item * auto_run

=item *	connect_to_server

=item * continue_file

=item * continue_function

=item * continue_line

=item *	continue_null

=item *	disconnect_from_server

=item * new

=item *	on_decode_clicked

=item *	on_encode_clicked

=item *	on_send_clicked

=item *	quit

=item *	status

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
