#!/usr/bin/perl

use strict;
use Test::More tests => 14;

use_ok( 'Bullwinkle::Client' );
use_ok( 'Bullwinkle::Server' );

BEGIN {
use_ok( 'Wx' );
use_ok( 'FindBin' );
}

diag( "Info: Testing Bullwinkle v$Bullwinkle::Client::VERSION" );
diag("Info: Perl $^V");

######
# let's check our lib's are here.
######
my $test_object;
require Bullwinkle::Client;
$test_object = new_ok('Bullwinkle::Client');

require Bullwinkle::Client::Commands;
$test_object = new_ok('Bullwinkle::Client::Commands');

require Bullwinkle::Client::IO;
$test_object = new_ok('Bullwinkle::Client::IO');

require Bullwinkle::Client::Main;
$test_object = new_ok('Bullwinkle::Client::Main');

require Bullwinkle::Client::FBP::Main;
$test_object = new_ok('Bullwinkle::Client::FBP::Main');

require Bullwinkle::Client::Parameters;
$test_object = new_ok('Bullwinkle::Client::Parameters');

require Bullwinkle::Server;
$test_object = new_ok('Bullwinkle::Server');

require Bullwinkle::Server::IO;
$test_object = new_ok('Bullwinkle::Server::IO');

require Bullwinkle::Server::Parameters;
$test_object = new_ok('Bullwinkle::Server::Parameters');

require Bullwinkle::Server::Response;
$test_object = new_ok('Bullwinkle::Server::Response');


done_testing();