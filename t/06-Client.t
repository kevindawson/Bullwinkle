#!/usr/bin/env perl

use strict;
use Test::More tests => 8;
use Test::Fork;

use Bullwinkle::Server;
use_ok('Bullwinkle::Client::IO');
my $io = Bullwinkle::Client::IO->new();
isa_ok( $io, 'Bullwinkle::Client::IO' );

if ( $io->is_connected ) { $io->disconnect }
is( $io->is_connected, 0, 'Should Not be connected to server now' );
my $server = Bullwinkle::Server->new();

if ($server) {
	
	fork_ok(
		2,
		sub {
			sleep 1;
			$io->start_connection;
			is( $io->is_connected, 1, 'Should be able to connect to server' );
			$io->disconnect;
			is( $io->is_connected, 0, 'Disconnect 2' );
		}
	);
	fork_ok(
		1,
		sub {
			$server->run;
			is( $server->is_listening, 1, 'running server' );

		}
	);
}

done_testing();

__END__


