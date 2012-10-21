#!/usr/bin/env perl

use v5.10;
use utf8;
use strict;
use warnings;
use Carp::Always::Color;
use Data::Printer {
	caller_info => 1,
	colored     => 1,
};

use FindBin qw($Bin);
use lib map "$Bin/$_", 'lib', '../lib';

use Bullwinkle::Server ();

our $VERSION = '0.01_05';

# my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => '9000', host => '127.0.0.1', file => 'test.pl', transport => 'tcp/ip');
# my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => 4_567, transport => 'tcp/ip' );
# my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => 4_567, );
# my $server = Bullwinkle::Server->new( api => 'bullwinkle', transport => 'tcp/ip' );
# p $server;

# my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => '9000', host => '127.0.0.1', );
# my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => '9000', file => 'test.pl', );
# my $server = Bullwinkle::Server->new( api => 'bullwinkle', host => '127.0.0.1', file => 'test.pl', );
# my $server = Bullwinkle::Server->new( port => '9000', host => '127.0.0.1', file => 'test.pl', );
my $server = Bullwinkle::Server->new( );
say 'Bullwinkle Server configured with the following parameters;';

$server->show_parameters;
say 'Starting Server Now';
$server->run;

# $server->init;
# $server->start_host( $server->{transport} );
# say 'is_listening = '. $server->is_listening;
# $server->service_socket;
# say 'is_listening = '. $server->is_listening;

exit(0);
