#!/usr/bin/perl

use v5.10;
use strict;
use warnings;
use Test::More tests => 4;

######
# let's check our subs/methods.
######

my @subs = qw( run OnInit );

use_ok( 'Bullwinkle::Client', @subs );

foreach my $subs (@subs) {
	can_ok( 'Bullwinkle::Client', $subs );
}

require Bullwinkle::Client;
my $client = Bullwinkle::Client::->new;
isa_ok( $client, 'Bullwinkle::Client' );


done_testing();
 
1;
 
__END__



