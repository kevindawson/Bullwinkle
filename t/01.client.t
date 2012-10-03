#!/usr/bin/perl

use strict;
use Test::More;

use rlib '../lib';
use_ok( 'Bullwinkle::Client::Main' );
use_ok( 'Bullwinkle::Server' );
my $main = Bullwinkle::Client::Main->new();
ok($main);
$main->disconnect_from_server if $main->is_connected;
is($main->is_connected, 0, 'Should not be connected to server now');
my $server = Bullwinkle::Server->new( api => 'bullwinkle', port => '9000', host => '127.0.0.1', file => 'test.pl', );
if ($server) {
    my $pid = fork();
    if ($pid) {
	for(my $i; $i<10; $i++) { 
	    my ($ok, $response) = $main->connect_to_server;
	    last if $ok;		
	    sleep 1;
	}
	is($main->is_connected, 1, 'Should be able to connect to server');
	$main->disconnect_from_server;
	is($main->is_connected, 0, 'Disconnect 2');
	waitpid($pid, 0);
    } else {
	$server->run;
    }
}
    
done_testing();

