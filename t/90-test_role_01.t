#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
# Don't run tests during end-user installs
plan( skip_all => 'Author demo test only' )
	unless ( $ENV{RELEASE_TESTING} );
	
use Test::Most;
use Test::Moose;
use MooseX::ClassCompositor;
use Bullwinkle::Client::Role::Connected 0.01; #To test for version availability

my @attributes = qw( first_attribute );
my @methods    = qw( is_connected );
my ($instance);

my $class = MooseX::ClassCompositor->new(
	{   class_basename => 'Test',
	}
	)->class_for(
	'Bullwinkle::Client::Role::Connected',
	);
map has_attribute_ok( $class, $_ ), @attributes;
map can_ok( $class, $_ ), @methods;
lives_ok {
	$instance = $class->new(
		first_attribute => 'cool',
	);
}
'Test creation of an instance';

# other cool tests, for example;
# is( 42, $instance->important_method( '?' ), 'The answer') )
done_testing();
