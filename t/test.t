use strict;
use warnings;
use Test::Base;
use DateTime::TimeZone::FromState::US;

filters {
    input => [ 'state2tz', 'tz2name' ],
};

sub state2tz { DateTime::TimeZone::FromState::US->new_from_state(state => $_[0]) }
sub tz2name  { $_[0]->name }

__DATA__

===
--- input: CA
--- expected: America/Los_Angeles

===
--- input: MN
--- expected: America/Chicago

===
--- input: MP
--- expected: Pacific/Guam

===
--- input: IN
--- expected: America/New_York
