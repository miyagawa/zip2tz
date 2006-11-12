#!/usr/bin/perl
use strict;
use warnings;
use YAML;

my $state2tz  = YAML::LoadFile($ARGV[0]);

use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Terse  = 1;

my $module = <<'MODULE';
package DateTime::TimeZone::FromState::US;
use strict;
use Carp;
use DateTime::TimeZone;

our $state2tz  = __S2T__;

sub new_from_state {
    my($class, %p) = @_;

    my $state = $p{state}            or croak 'new_from_state: state is empty';
       $state =~ /^[A-Za-z]{2}$/     or croak "new_from_state: needs 2 letters State name: $state";
    my $tz = $state2tz->{uc($state)} or croak "Data error: TZ for $state is unknown";

    DateTime::TimeZone->new(name => $tz);
}

1;
MODULE

$module =~ s/__S2T__/Dumper($state2tz)/e;

print $module;


