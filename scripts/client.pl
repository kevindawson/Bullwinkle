#!/usr/bin/perl

use v5.10;
use utf8;
use strict;
use warnings;
use Carp::Always::Color;

use FindBin qw($Bin);
use lib ("$Bin/../lib");


use Bullwinkle::Client ();

our $VERSION = '0.01_02';

Bullwinkle::Client->run;

exit(0);
