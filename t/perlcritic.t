#!/usr/bin/env perl

# Test that the module passes perlcritic
use strict;
use warnings;

# Turn on $OUTPUT_AUTOFLUSH
$| = 1;

my @MODULES = (
	'Perl::Critic 1.098',
	'Test::Perl::Critic 1.01',
);

# Don't run tests during end-user installs
use Test::More;
plan( skip_all => 'Author tests not required for installation' )
	unless ( $ENV{RELEASE_TESTING} );

# Load the testing modules
foreach my $MODULE ( @MODULES ) {
	eval "use $MODULE";
	if ( $@ ) {
		$ENV{RELEASE_TESTING}
		? die( "Failed to load required release-testing module $MODULE" )
		: plan( skip_all => "$MODULE not available for testing" );
	}
}

Test::Perl::Critic->import(
	-severity => 4,
	-verbose  => 4,
	-exclude  => [ 'RequireRcsKeywords', ],
);

# my @DIRECTORIES = qw(
	# lib/Padre/Plugin/Cookbook/Recipe01
	# lib/Padre/Plugin/Cookbook/Recipe02
	# lib/Padre/Plugin/Cookbook/Recipe03
# );


all_critic_ok( );
# all_critic_ok(@DIRECTORIES);


done_testing();