#!/usr/bin/perl

use v5.10;
use strict;
use warnings;
use Test::More tests => 5;
use Test::SharedFork;

######
# let's check our subs/methods.
######

my @subs = qw( run OnInit );

use_ok( 'Bullwinkle::Client', @subs );

foreach my $subs (@subs) {
	can_ok( 'Bullwinkle::Client', $subs );
}


my $pid = fork();
if ( $pid == 0 ) {

	# we're the child
	require Bullwinkle::Client;
	ok(my $client = Bullwinkle::Client::->new, 'new Client' );
	isa_ok( $client, 'Bullwinkle::Client' );

	ok( $client->run, 'running Client' );

} else {

	# parent
	sleep 3; # give the child a chance
	kill 1, $pid; # nighty-night
}


done_testing();

1;

__END__



