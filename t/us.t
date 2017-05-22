#!perl -wT

use strict;
use warnings;
use Test::Most tests => 6;
use Test::NoWarnings;

eval 'use autodie qw(:all)';	# Test for open/close failures

BEGIN {
	use_ok('Geo::Coder::XYZ');
}

XYZ: {
	SKIP: {
		skip 'Test requires Internet access', 4 unless(-e 't/online.enabled');

		eval {
			require Test::Number::Delta;

			Test::Number::Delta->import();
		};

		if($@) {
			diag('Geo::Coder::XYZ not installed - skipping tests');
			skip 'Geo::Coder::XYZ not installed', 4;
		} else {
			diag("Using Geo::Coder::XYZ $Geo::Coder::XYZ::VERSION");
		}

		my $geocoder = new_ok('Geo::Coder::XYZ');

		# Check list context finds both Portland, ME and Portland, OR
		my @locations = $geocoder->geocode('Portland, USA');

		ok(scalar(@locations) > 1);

		my ($maine, $oregon);

		foreach my $state(map { $_->{'state'} } @locations) {
			# diag($state);
			if($state eq 'ME') {
				$maine++;
			} elsif($state eq 'OR') {
				$oregon++;
			}
		}

		ok($maine == 1);
		ok($oregon == 1);

		# diag('There are Portlands in ', join (', ', map { $_->{'state'} } @locations));
	}
}
