#!perl -wT

use strict;
use warnings;
use Test::Most;
use Geo::Coder::XYZ;

CARP: {
	eval 'use Test::Carp';

	if($@) {
		plan(skip_all => 'Test::Carp needed to check error messages');
	} else {
		my $g = new_ok('Geo::Coder::XYZ');
		does_croak_that_matches(sub { my $location = $g->geocode(); }, qr/^Usage: geocode\(/);
		does_croak_that_matches(sub { my $location = $g->geocode(\'New Brunswick, Canada'); }, qr/^Usage: geocode\(/);
		done_testing();
	}
}
