#!/usr/bin/perl

use v5.10;
use strict;
use warnings;
use Test::More tests => 15;
use Data::Printer {
	caller_info => 1,
	colored     => 1,
};
######
# let's check our subs/methods.
######

my @subs = qw( auto_run connect_to_server continue_file continue_function continue_line 
continue_null disconnect_from_server new on_decode_clicked on_encode_clicked 
on_send_clicked quit status );

use_ok( 'Bullwinkle::Client::Main', @subs );

foreach my $subs (@subs) {
	can_ok( 'Bullwinkle::Client::Main', $subs );
}

my @subs2 = qw( api file host port transport );
my $main = Bullwinkle::Client::Main->new;
isa_ok( $main, 'Bullwinkle::Client::Main' );

# foreach my $subs (@subs2) {
	# ok( $msg_com->$subs, $subs );
# }
# # p $msg_com->show_parameters;
# ok(ref($msg_com->show_parameters) eq "HASH", 'show parameters');

done_testing();
 
1;
 
__END__



