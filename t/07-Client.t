#!/usr/bin/env perl

use strict;
use Test::More tests => 6;
use Test::SharedFork;

use Bullwinkle::Server;
use_ok('Bullwinkle::Client::IO');
my $io = Bullwinkle::Client::IO->new();
isa_ok( $io, 'Bullwinkle::Client::IO' );

if ( $io->is_connected ) { $io->disconnect }
is( $io->is_connected, 0, 'Should Not be connected to server now' );
my $server = Bullwinkle::Server->new();

if ($server) {

	my $pid = fork();
	if ( $pid == 0 ) {

		# child
		sleep 1;
		$io->start_connection;
		is( $io->is_connected, 1, 'Should be able to connect to server' );
		$io->disconnect;
		is( $io->is_connected, 0, 'Disconnect 2' );

	} elsif ($pid) {

		# parent
		$server->run;
		is( $server->is_listening, 1, 'Server is running' );
		waitpid( $pid, 0 );
	} else {
		die $!;
	}

}

done_testing();


