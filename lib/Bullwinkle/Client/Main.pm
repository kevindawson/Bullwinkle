package Bullwinkle::Client::Main;

use v5.10;
use strict;
use warnings;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

use Bullwinkle::Client::FBP::Main ();
use Bullwinkle::Client::Commands;

use IO::Socket::IP 0.17;
use Carp 1.20 qw(carp croak);
use Try::Tiny;
use JSON::XS;
use Data::Dumper;
$Data::Dumper::Purity = 1;
$Data::Dumper::Terse  = 1;
$Data::Dumper::Indent = 1;

use Data::Printer {
	caller_info => 1,
	colored     => 1,
};
use constant {
	BLANK => qq{ },
	NONE  => q{},
};
our $VERSION = '0.01_02';
use parent qw(
	Bullwinkle::Client::FBP::Main
);

#######
# setup
#######
my $commands = Bullwinkle::Client::Commands->new;
my $socket;
my $connect_flag = 0;

# p $commands;
say 'run';



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
	if ($connect_flag) {
		try {
			my $json_text = $self->client_json->GetValue;
			if ( $json_text eq BLANK ) { return; }
			my $perl_scalar = JSON::XS->new->utf8->decode($json_text);

			# p $perl_scalar;
			print {$socket} JSON::XS->new->utf8->encode($perl_scalar) . "\n";
			$socket->recv( $data, 1024 );
		};

	}
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
sub connect_to_server {
	my $self = shift;

	say 'connect';
	unless ($connect_flag) {

		# Connect to Bullwinkle Server.
		$socket = IO::Socket::IP->new(
			PeerAddr => $self->{host}  // '127.0.0.1',
			PeerPort => $self->{port}  // 9_000,
			Proto    => $self->{porto} // 'tcp',

		) or carp "Could not connect to host 127.0.0.1:9000 ->$ERRNO";

		$connect_flag = 1;

		$socket->recv( my $data, 1024 );
		$self->server_json->SetValue($data);

		$self->on_decode_clicked;
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
	if ($connect_flag) {
		close $socket or carp;
	}
	$connect_flag = 0;

	return;
}

sub auto_run {
	my $self = shift;

	$self->client_json->SetValue(BLANK);
	$self->server_json->SetValue(BLANK);
	$self->server_perl->SetValue(BLANK);

	if ($connect_flag) {
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
