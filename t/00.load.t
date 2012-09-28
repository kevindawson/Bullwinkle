#!/usr/bin/perl

use strict;
use Test::More tests => 4;

use_ok( 'Bullwinkle::Client' );
use_ok( 'Bullwinkle::Server' );

BEGIN {
use_ok( 'Wx' );
use_ok( 'FindBin' );
}

diag( "Testing Bullwinkle $Bullwinkle::VERSION" );
