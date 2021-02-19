#!perl -w

use warnings;
use strict;
use Test::Most tests => 9;
use Test::NoWarnings;

BEGIN {
	use_ok('Geo::Coder::XYZ');
}

CA: {
	SKIP: {
		if(!-e 't/online.enabled') {
			diag('Online tests disabled');
			skip('Test requires Internet access', 7);
		}

		eval {
			require Test::Number::Delta;

			Test::Number::Delta->import();
		};

		if($@) {
			diag('Test::Number::Delta not installed - skipping tests');
			skip('Test::Number::Delta not installed', 7);
		}

		my $ua;

		eval {
			require LWP::UserAgent::Throttled;

			LWP::UserAgent::Throttled->import();

			$ua = LWP::UserAgent::Throttled->new();
			$ua->throttle({ 'geocode.xyz' => 2 });
			$ua->env_proxy(1);
		};

		my $geocoder = new_ok('Geo::Coder::XYZ');

		if($ua) {
			$geocoder->ua($ua);
		}

		my $location = $geocoder->geocode('9235 Main St, Richibucto, New Brunswick, Canada');
		delta_within($location->{latt}, 46.7, 1e-1);
		delta_within($location->{longt}, -64.9, 1e-1);

		$location = $geocoder->geocode(location => '9235 Main St, Richibucto, New Brunswick, Canada');
		delta_within($location->{latt}, 46.7, 1e-1);
		delta_within($location->{longt}, -64.9, 1e-1);

		my $address = $geocoder->reverse_geocode(latlng => '46.67,-64.87');
		like($address->{'city'}, qr/Richibucto/i, 'test reverse');

		$address = $geocoder->reverse_geocode('46.67,-64.87');
		like($address->{'city'}, qr/Richibucto/i, 'test reverse, latng implied');
	}
}
