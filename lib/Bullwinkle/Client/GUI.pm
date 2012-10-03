package Bullwinkle::Client::GUI;

use v5.10;
use strict;
use warnings;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
use rlib '.';


use Bullwinkle::Client::FBP::Main ();
use Bullwinkle::Client::Main;
use Bullwinkle::Client::Commands;

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
our $VERSION = '0.01_03';
use parent qw(
	Bullwinkle::Client::FBP::Main
);

#######
# setup
#######
my $main = Bullwinkle::Client::Main->new;

# p $commands;
say 'GUI run';

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
	my $data = $main->send_to_server($self->client_json->GetValue);
	$self->server_json->SetValue($data // BLANK);
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
    
    my ($okay, $response) = $main->connect_to_server();
    $self->{status_bar}->SetStatusText( sprintf( "Info: %s", $response ) );
    if ($okay) { 
	my $data = $main->read_from_server();
	$self->server_json->SetValue($data);
	$self->on_decode_clicked;
    }
    return;
}

sub disconnect_from_server {
    my $self = shift;
    
    my $response = $main->disconnect_from_server;
    if ($response) {
	$self->{send}->Disable;
	$self->auto_run;
	$self->{status_bar}->SetStatusText('Disconnected from Bullwinkle Server');
    }
    return;
}


sub status {
    my $self = shift;
    
    my $output = $main->status;
    $self->client_perl->SetValue($output);
    $self->auto_run;
    return;
}

sub quit {
    my $self = shift;

    my $output = $main->quit;
    $self->client_perl->SetValue($output);
    
    $self->auto_run;
    
    # if ($main->is_connected) {
    # close $socket or carp;
    # }
    # $main->is_connected = 0;
    # $self->{send}->Disable;
    
    return;
}

sub auto_run {
	my $self = shift;

	$self->client_json->SetValue(BLANK);
	$self->server_json->SetValue(BLANK);
	$self->server_perl->SetValue(BLANK);

	if ($main->is_connected) {
		$self->on_encode_clicked;
		$self->on_send_clicked;
		$self->on_decode_clicked;
	}

	return;
}


# sub continue_null {
# 	my $self = shift;

# 	my $output = Data::Dumper::Dumper( $commands->continue_null );
# 	$self->client_perl->SetValue($output);
# 	$self->auto_run;

# 	return;
# }

# sub continue_function {
# 	my $self = shift;

# 	my $output = Data::Dumper::Dumper( $commands->continue_function );
# 	$self->client_perl->SetValue($output);
# 	$self->auto_run;

# 	return;
# }

# sub continue_line {
# 	my $self = shift;

# 	my $output = Data::Dumper::Dumper( $commands->continue_line );
# 	$self->client_perl->SetValue($output);
# 	$self->auto_run;

# 	return;
# }

# sub continue_file {
# 	my $self = shift;

# 	my $output = Data::Dumper::Dumper( $commands->continue_file );
# 	$self->client_perl->SetValue($output);
# 	$self->auto_run;

# 	return;
# }

unless (caller) {
   my $gui_client =  Bullwinkle::Client::Main->new;;
   $gui_client->status;
   p $gui_client->client_perl->GetValue;

}

1;
