#!/usr/bin/env perl

use strict;
use Test::More tests => 5;
use Test::Deep;
use Test::SharedFork;

use JSON::XS;
use Data::Printer {
	caller_info => 1,
	colored     => 1,
};

#runup client
use Bullwinkle::Client::IO;
my $client = Bullwinkle::Client::IO->new();
if ( $client->is_connected ) { $client->disconnect }

# is( $client->is_connected, 0, 'Should Not be connected to server now' );

use_ok('Bullwinkle::Client::Commands');
my $commands = Bullwinkle::Client::Commands->new;

#runup server
use Bullwinkle::Server;
my $server = Bullwinkle::Server->new();

if ($server) {

	my $pid = fork();
	if ( $pid == 0 ) {

		# child
		sleep 1;
		$client->start_connection;
		is( $client->is_connected, 1, 'Client connected to server' );

		#get init message
		my $data_packet = $client->receive;
		$client->send( JSON::XS->new->utf8->encode( $commands->status ) . "\n" );
		$data_packet = $client->receive;
		# p $data_packet;
		ok( my $perl_scalar = JSON::XS->new->utf8->decode($data_packet), 'recived a valid JSON message' );
		# p $perl_scalar;
		cmp_deeply(
			$perl_scalar,
			{   response => {
					status  => 'running',
					command => 'status',
					reason  => 'ok',
				},
			},
			'we got a Status response message '
		);

		$client->disconnect;

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


