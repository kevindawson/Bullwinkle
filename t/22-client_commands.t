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

my @subs = qw( continue_file continue_function continue_line continue_null quit status );

use_ok( 'Bullwinkle::Client::Commands', @subs );

foreach my $subs (@subs) {
	can_ok( 'Bullwinkle::Client::Commands', $subs );
}

my $msg_com = Bullwinkle::Client::Commands->new;
isa_ok( $msg_com, 'Bullwinkle::Client::Commands' );

foreach my $subs (@subs) {
	ok( $msg_com->$subs, $subs );
}

done_testing();
 
1;
 
__END__

	my $server1 = Bullwinkle::Server->new(
		api       => 'bullwinkle', port => 9_000, host => '127.0.0.1', file => 'test.pl',
		transport => 'tcp/ip'
	);
	isa_ok( $server1, 'Bullwinkle::Server' );