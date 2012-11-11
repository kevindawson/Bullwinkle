#!/usr/bin/env perl

use strict;
use Test::More tests => 4;
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

		# send plane text
		$client->send( 'hello' . "\n" );
		$data_packet = $client->receive;
		# p $data_packet;
		ok( my $perl_scalar = JSON::XS->new->utf8->decode($data_packet), 'received a valid JSON message' );
		# p $perl_scalar;
		cmp_deeply(
			$perl_scalar,
			{   bullwinkle => {
					error   => 90,
					message => 'Encoding not supported, Bullwinkle only talks in JSON',
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


