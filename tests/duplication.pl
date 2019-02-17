#!/usr/bin/env perl
use strict;
use feature qw/say/;
use utf8;

my (%dictionary, @duplications);

while (my $line = <>) {
    chomp $line;
    if (defined $dictionary{$line}) {
        push @duplications, $line;
        next;
    }
    $dictionary{$line} = 1;
}

if (scalar(@duplications) > 0) {
    say "duplication entries:";
    say $_ for @duplications;
    exit 1;
}

