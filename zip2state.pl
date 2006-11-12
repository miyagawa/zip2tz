#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

my %zip2state;
for (0..99) {
    my $url = sprintf "http://www.downloadzipcode.com/%02d.html", $_;
    warn "GET $url";
    my $html = get $url;
    while ($html =~ m!<a href="/(\w{2})/(\d{5})/">!g) {
        $zip2state{$2} = $1;
    }
}

use YAML;
print YAML::Dump \%zip2state;

