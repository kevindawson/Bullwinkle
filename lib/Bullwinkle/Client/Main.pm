package Bullwinkle::Client::Main;

use v5.10;
use strict;
use warnings;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
use rlib '.';

use Bullwinkle::Client::Commands;

use IO::Socket::IP 0.17;
use Carp 1.20 qw(carp croak);
use Try::Tiny;
use JSON::XS;
use Data::Dumper;
$Data::Dumper::Purity = 1;
$Data::Dumper::Terse  = 1;
$Data::Dumper::Indent = 1;

use constant {
	BLANK => qq{ },
	NONE  => q{},
};
our $VERSION = '0.01_03';

#######
# setup
#######
sub new($) {
    my $class = shift;
    my $self = {
        commands     => Bullwinkle::Client::Commands->new,
	connect_flag => 0,
	socket       => undef,
    };

    # p $self->{commands};
    say 'Main run';
    bless $self, $class;
    $self;
}


sub is_connected($) {
    my $self = shift;
    return $self->{connect_flag};
}

sub connect_to_server($) 
{
    my $self = shift;
    
    return (1, 'already_connected') if $self->is_connected();
	
    $self->{host} //= '127.0.0.1';
    $self->{port} //= 9_000;
    
    try {
	# Connect to Bullwinkle Server.
	$self->{socket} = IO::Socket::IP->new(
	    PeerAddr => $self->{host},
	    PeerPort => $self->{port},
	    Proto    => $self->{porto} // 'tcp',
	    
	    ) or return(0, "Could not connect to host 127.0.0.1:9000 ->$ERRNO");
	
	$self->{connect_flag} = 1;
	my $response = 
	    sprintf(
		"Connected to a Bullwinkle Server %s:%s",
		$self->{host},
		$self->{port},
	    );
	return (1, $response);
    }
    catch {
	$self->disconnect_from_server;
	return (0, $ERRNO);
    };
}

sub read_from_server {
    my $self = shift;
    $self->{socket}->recv( my $data, 1024 );
    return $data;
}

sub send_to_server {
    my ($self, $json_text) = @_;
    return undef unless $self->is_connected;
    try {
	return undef if $json_text eq BLANK;
	my $perl_scalar = JSON::XS->new->utf8->decode($json_text);
	# p $perl_scalar;
	print {$self->{socket}} JSON::XS->new->utf8->encode($perl_scalar) . "\n";
	return $self->{socket}->recv( my $data, 1024 );
    }
    return undef;
}

sub disconnect_from_server {
    my $self = shift;
    if ($self->{connect_flag}) {
	close $self->{socket} or carp;
    }
    $self->{connect_flag} = 0;
    return 1;
}


sub status {
    my $self = shift;
    my $output = Data::Dumper::Dumper( $self->{commands}->status );
    return $output;
}

sub quit {
    my $self = shift;
    $self->disconnect_from_server;
    my $output = Data::Dumper::Dumper( $self->{commands}->quit );
    return $output;
}


#  See GUI: for possible "continue" command things.

unless (caller) {
    my $main = Bullwinkle::Client::Main->new();
    eval {
	use Data::Printer {
	    # caller_info => 1,
	     colored     => 0,
	}
    };
    p $main->status;
    printf "Is connected %d\n", $main->is_connected();
    $main->connect_to_server;
    printf "Is connected %d\n", $main->is_connected();
    $main->disconnect_from_server;
    printf "Is connected %d\n", $main->is_connected();
}


1;
