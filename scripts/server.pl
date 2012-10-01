#!/usr/bin/perl

use v5.10;
use utf8;
use strict;
use warnings;
use Carp::Always::Color;

use FindBin qw($Bin);
use lib ("$Bin/../lib");


use Bullwinkle::Server ();

our $VERSION = '0.01_03';

my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => '9000', host => '127.0.0.1', file => 'test.pl', );

# my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => '9000', host => '127.0.0.1', );
# my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => '9000', file => 'test.pl', );
# my $server = Bullwinkle::Server->new( api => 'bullwinkle', host => '127.0.0.1', file => 'test.pl', );
# my $server = Bullwinkle::Server->new( port => '9000', host => '127.0.0.1', file => 'test.pl', );
# my $server = Bullwinkle::Server->new( );

say $server->api;
say $server->port;
say $server->host;
say $server->file;

$server->run;

exit(0);
