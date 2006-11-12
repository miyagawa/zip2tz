#!/usr/bin/perl
use strict;
use warnings;
use URI::Escape;
use YAML;

my %abbr;
while (<DATA>) {
    /^(.*?)\s+(\w\w)$/
        and $abbr{uc($1)} = $2;
}

my %tzs = (
    'AKST' => 'America/Anchorage',
    'CST' => 'America/Chicago',
    'EST' => 'America/New_York',
    'HST without DST' => 'Pacific/Honolulu',
    'MST' => 'America/Denver',
    'PST' => 'America/Los_Angeles',
    'UTC-11 without DST' => 'Pacific/Pago_Pago',
    'UTC+10 without DST' => 'Pacific/Guam',
    'MST without DST' => 'America/Phoenix',
    'AST without DST' => 'America/Puerto_Rico',
);


# GET http://en.wikipedia.org/wiki/List_of_U.S._states_by_time_zone
my %state2olson;
while (<>) {
    chomp;
    my($abbr_state, $olson);
    if (m!^<li><a href="/wiki/([^\"]+)" title=".*?">.*?</a>:.*<b>!) {
        $abbr_state = abbr_state($1) or warn "XXX $1";
        my $tz = (m!<b>(.*?)</b>!)[0];
        $olson = $tzs{$tz} or warn "YYY $abbr_state $tz $_";
    }
    elsif (m!<li><a href="/wiki/([^\"]+)" title=".*?">.*?</a>:?$!) {
        $abbr_state = abbr_state($1) or warn "XXX $1";
        <>; # <ul>
        $_ = <>;
        my $tz = (m!<b>(.*?)</b>!)[0];
        $olson = $tzs{$tz} or warn "YYY $abbr_state $tz";
        $_ = <> until m!</ul>!;
    }

    if ($abbr_state && $olson) {
        $state2olson{$abbr_state} = $olson;
    }
}

print YAML::Dump \%state2olson;

sub abbr_state {
    my $state = uri_unescape(shift);
    $state =~ s/_/ /g;
    $state =~ s/ \(U\.S\. state\)$//;
    $state =~ s/^U\.S\. //;
    $state = "DISTRICT OF COLUMBIA" if $state eq 'Washington, DC';
    return $abbr{uc($state)};
}

__DATA__
# http://www.usps.com/ncsc/lookups/abbr_state.txt
State/Possession		Abbreviation

ALABAMA                         AL
ALASKA                          AK
AMERICAN SAMOA                  AS
ARIZONA                         AZ
ARKANSAS                        AR
CALIFORNIA                      CA
COLORADO                        CO
CONNECTICUT                     CT
DELAWARE                        DE
DISTRICT OF COLUMBIA            DC
FEDERATED STATES OF MICRONESIA  FM
FLORIDA                         FL
GEORGIA                         GA
GUAM                            GU
HAWAII                          HI
IDAHO                           ID
ILLINOIS                        IL
INDIANA                         IN
IOWA                            IA
KANSAS                          KS
KENTUCKY                        KY
LOUISIANA                       LA
MAINE                           ME
MARSHALL ISLANDS                MH
MARYLAND                        MD
MASSACHUSETTS                   MA
MICHIGAN                        MI
MINNESOTA                       MN
MISSISSIPPI                     MS
MISSOURI                        MO
MONTANA                         MT
NEBRASKA                        NE
NEVADA                          NV
NEW HAMPSHIRE                   NH
NEW JERSEY                      NJ
NEW MEXICO                      NM
NEW YORK                        NY
NORTH CAROLINA                  NC
NORTH DAKOTA                    ND
NORTHERN MARIANA ISLANDS        MP
OHIO                            OH
OKLAHOMA                        OK
OREGON                          OR
PALAU                           PW
PENNSYLVANIA                    PA
PUERTO RICO                     PR
RHODE ISLAND                    RI
SOUTH CAROLINA                  SC
SOUTH DAKOTA                    SD
TENNESSEE                       TN
TEXAS                           TX
UTAH                            UT
VERMONT                         VT
VIRGIN ISLANDS                  VI
VIRGINIA                        VA
WASHINGTON                      WA
WEST VIRGINIA                   WV
WISCONSIN                       WI
WYOMING                         WY


Military "State"		Abbreviation

Armed Forces Africa		AE
Armed Forces Americas		AA
(except Canada)
Armed Forces Canada		AE
Armed Forces Europe		AE
Armed Forces Middle East	AE
Armed Forces Pacific		AP

