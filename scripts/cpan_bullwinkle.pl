#!/usr/bin/env perl

use 5.014;
use strict;
use warnings;

# Turn on $OUTPUT_AUTOFLUSH
$| = 1;

use feature 'unicode_strings';
use autodie;
use diagnostics;


say 'START';

eval { use CPAN };
die('Failed to load required module CPAN') if $@;


CPAN::HandleConfig->load;
CPAN::Shell::setup_output;
CPAN::Index->reload;

my @modules = qw(
	Carp
	Carp::Always::Color
	Data::Dumper
	Data::Printer
	IO::Socket::IP
	JSON::XS
	Moo
	Thread::Semaphore
	Try::Tiny
	Wx
	Test::Deep
	Test::More
	Test::SharedFork
);


# install Bullwinkle required modules:
for my $mod (@modules) {
	CPAN::Shell->install($mod);
}


say 'END';

1;

__END__
