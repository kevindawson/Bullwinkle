#!/usr/bin/env perl

use v5.10;
use utf8;
use strict;
use warnings;
use Carp::Always::Color;

use FindBin qw($Bin);
use lib map "$Bin/$_", 'lib', '../lib';

use Bullwinkle::Client ();

our $VERSION = '0.01_04';

Bullwinkle::Client->run;

exit(0);
