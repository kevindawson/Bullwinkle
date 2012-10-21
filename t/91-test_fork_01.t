#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
# Don't run tests during end-user installs
plan( skip_all => 'Author demo test only' )
	unless ( $ENV{RELEASE_TESTING} );

use Test::SharedFork;
 
my $pid = fork();
if ($pid == 0) {
    # child
    ok 1, "child $_" for 1..100;
} elsif ($pid) {
    # parent
    ok 1, "parent $_" for 1..100;
    waitpid($pid, 0);
} else {
    die $!;
}