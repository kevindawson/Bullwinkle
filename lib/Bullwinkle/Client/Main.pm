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
our $VERSION = '0.01_03';
use parent qw(
	Bullwinkle::Client::FBP::Main
);

#######
# setup
#######
my $commands = Bullwinkle::Client::Commands->new;
my $io       = Bullwinkle::Client::IO->new;
p $io;
p $io->is_connected;

# my $connect_flag = 0;
my $socket;

# p $commands;
say 'Client running, see status bar for info messages';



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
	if ( $io->is_connected ) {

		my $json_text = $self->client_json->GetValue;
		if ( $json_text eq BLANK ) { return; }

		# my $perl_scalar;
		try {
			my $perl_scalar = JSON::XS->new->utf8->decode($json_text);
			print {$socket} JSON::XS->new->utf8->encode($perl_scalar) . "\n";
		}
		catch {
			print {$socket} "$json_text";
		};
		$socket->recv( $data, 1024 );
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


#######
# event handlers for menu options
#######
# sub connect_to_server {
# my $self = shift;

# unless ($connect_flag) {

# $self->{host} //= '127.0.0.1';

# $self->{port} //= 9_000;
# # $self->{port} //= 4_567;

# try {
# # Connect to Bullwinkle Server.
# $socket = IO::Socket::IP->new(
# PeerAddr => $self->{host},
# PeerPort => $self->{port},
# Proto    => $self->{porto} // 'tcp',

# ) or die; #or carp "Could not connect to host 127.0.0.1:9000 ->$ERRNO";

# }
# catch {
# $self->disconnect_from_server;
# $self->{status_bar}->SetStatusText( sprintf( "Info: %s", $ERRNO ) );
# return;
# }
# finally {
# unless (@_) {

# $connect_flag = 1;
# $self->{send}->Enable;
# $self->{status_bar}->SetStatusText(
# sprintf(
# "Connected to a Bullwinkle Server %s:%s",
# $self->{host},
# $self->{port},
# )
# );
# $socket->recv( my $data, 1024 );
# $self->server_json->SetValue($data);
# $self->on_decode_clicked;

# }
# };

# }

# return;
# }

sub disconnect_from_server {
	my $self = shift;

	$io->disconnect;

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

	$socket = $io->start_connection;

	if ( $io->is_connected ) {

		# $self->connected( TRUE );
		$self->{send}->Enable;
		$self->{status_bar}->SetStatusText(
			sprintf(
				"Connected to a Bullwinkle Server %s:%s",
				$io->{host},
				$io->{port},
			)
		);
		$socket->recv( my $data, 1024 );
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

	my $output = Data::Dumper::Dumper( $commands->status );
	$self->client_perl->SetValue($output);

	$self->auto_run;
	return;
}

sub quit {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $commands->quit );
	$self->client_perl->SetValue($output);

	$self->auto_run;
	$self->disconnect_from_server;

	# if ($connect_flag) {
	# close $socket or carp;
	# }
	# $connect_flag = 0;
	# $self->{send}->Disable;

	return;
}

sub auto_run {
	my $self = shift;

	$self->client_json->SetValue(BLANK);
	$self->server_json->SetValue(BLANK);
	$self->server_perl->SetValue(BLANK);

	if ( $io->is_connected ) {
		$self->on_encode_clicked;
		$self->on_send_clicked;
		$self->on_decode_clicked;
	}

	return;
}


sub continue_null {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $commands->continue_null );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

sub continue_function {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $commands->continue_function );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

sub continue_line {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $commands->continue_line );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

sub continue_file {
	my $self = shift;

	my $output = Data::Dumper::Dumper( $commands->continue_file );
	$self->client_perl->SetValue($output);
	$self->auto_run;

	return;
}

1;
