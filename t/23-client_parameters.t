#!/usr/bin/perl

use v5.10;
use strict;
use warnings;
use Test::More tests => 14;
use Data::Printer {
	caller_info => 1,
	colored     => 1,
};
######
# let's check our subs/methods.
######

my @subs = qw( show_parameters api file host port transport );

use_ok( 'Bullwinkle::Client::Parameters' );

foreach my $subs (@subs) {
	can_ok( 'Bullwinkle::Client::Parameters', $subs );
}

my @subs2 = qw( api file host port transport );
my $msg_com = Bullwinkle::Client::Parameters->new;
isa_ok( $msg_com, 'Bullwinkle::Client::Parameters' );

foreach my $subs (@subs2) {
	ok( $msg_com->$subs, $subs );
}
# p $msg_com->show_parameters;
ok(ref($msg_com->show_parameters) eq "HASH", 'show parameters');

done_testing();
 
1;
 
__END__

	my $server1 = Bullwinkle::Server->new(
		api       => 'bullwinkle', port => 9_000, host => '127.0.0.1', file => 'test.pl',
		transport => 'tcp/ip'
	);
	isa_ok( $server1, 'Bullwinkle::Server' );
	
	
show_parameters api file host port transport