#!/usr/bin/perl

use v5.10;
use strict;
use warnings;
use Test::More tests => 1;

######
# let's check our subs/methods.
######

my @subs = qw( );

use_ok( 'Bullwinkle::Client::Role::Connected' );
foreach my $subs (@subs) {
	can_ok( 'Bullwinkle::Client::Role::Connected', $subs );
}


done_testing();
 
1;
 
__END__



