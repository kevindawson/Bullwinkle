#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;
use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;
use Test::More tests => 13;

use_ok('Bullwinkle::Server');


SCOPE: {
	my $server1 = Bullwinkle::Server->new(
		api       => 'bullwinkle', port => 9_000, host => '127.0.0.1', file => 'test.pl',
		transport => 'tcp/ip'
	);
	isa_ok( $server1, 'Bullwinkle::Server' );
	ok( $server1->init, 'init server1 with all parameters' );
	$server1->start_host('tcp/ip');
	is( $server1->is_listening, 1, 'Should be able to connect to server1' );

	SCOPE: {
		my $server2 = Bullwinkle::Server->new(
			api       => 'bullwinkle', port => 9_000, host => '127.0.0.1', file => 'test.pl',
			transport => 'tcp/ip'
		);
		isa_ok( $server2, 'Bullwinkle::Server' );
		ok( $server2->init, 'init server2 with all parameters' );
		$server2->start_host('tcp/ip');
		is( $server2->is_listening, 0, 'Should Not be able to connect to server2' );
	}
}

SCOPE: {
	my $server3 = Bullwinkle::Server->new();
	isa_ok( $server3, 'Bullwinkle::Server' );

	ok( $server3->init, 'init server3 with No parameters' );
	$server3->tcp_ip;
	is( $server3->is_listening, 1, 'Should be able to connect to server3' );

	SCOPE: {
		my $server4 = Bullwinkle::Server->new;
		isa_ok( $server4, 'Bullwinkle::Server' );

		ok( $server4->init, 'init server4 with No parameters' );
		$server4->tcp_ip;
		is( $server4->is_listening, 0, 'Should Not be able to connect to server4' );
	}
}


done_testing();

