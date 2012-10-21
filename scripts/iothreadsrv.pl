#!/usr/bin/env perl
# iothreadserv.pl

use v5.10;
use warnings;
use strict;
our $VERSION = '0.01_05';
use Carp::Always::Color;
use Carp 1.20 qw(carp croak);
use Try::Tiny;
use Data::Printer {
	caller_info => 0,
	colored     => 1,
};

use FindBin qw($Bin);
use lib map "$Bin/$_", 'lib', '../lib';

BEGIN {
	use Config;
	carp "No thread support!\n" unless $Config{usethreads};
}

use threads;
use Thread::Semaphore;
my $semaphore = Thread::Semaphore->new(1);

# use IO::Socket;
use IO::Socket::IP 0.17;


use English qw( -no_match_vars ); # Avoids regex performance penalty
local $OUTPUT_AUTOFLUSH = 1;

# local $SIG{PIPE} = 'IGNORE'; # Ignore clients that do not cleanly drop connection
local $SIG{PIPE} = sub { carp 'spooler pipe broke' };
my $port = 9_000;
my $host = '127.0.0.1';

# my $host = '172.18.2.13';

my $server = IO::Socket::IP->new(
	Domain    => PF_INET,
	LocalHost => $host,
	LocalPort => $port,
	Proto     => 'tcp',
	Listen    => 1,
	ReuseAddr => 1,
) or croak "Could not establish the socket $host:$port ->$ERRNO";

say "Multiplex server running on port $port...";

while ( my $connection = $server->accept ) {

	# Decrement the semaphore only if it would immediately succeed.
	if ( $semaphore->down_nb() ) {

		# $semaphore->down;
		my $thread = threads->create( \&connection, $connection );

		say sprintf(
			"Created thread %s for new Client at %s:%s",
			$thread->tid, $connection->peerhost, $connection->peerport,
		);

		$thread->detach;

	} else {
		$connection->syswrite( "I'm a Monogamous Server \nConnection dropped \nsuggest you try counting sheep \n" );
		say 'Thanks another unwanted Client banished';
	}

}

# child thread - handle connection
sub connection {
	my $connection = shift;
	$connection->autoflush(1);
	$connection->syswrite("You're connected to the \nBullwinkle Multiplex server!\n");

	while (<$connection>) {

		print sprintf(
			"Client %s:%s says: %s",
			$connection->peerhost, $connection->peerport, $_,
		);

		$connection->syswrite( 'Message received OK' . "\n" );

		if ( $_ =~ /quit/sm ) {
			$connection->syswrite( 'So long and thanks for all the fish!' . "\n" );
			exit(0);
			return;
		}
	}

	say sprintf(
		"Closing %s:%s, Client has left",
		$connection->peerhost, $connection->peerport,
	);

	$semaphore->up;
	$connection->shutdown(SHUT_RDWR);

	return;
}


exit(0);
