#!/usr/bin/env perl
use strict;
use feature qw/say/;
use utf8;

my (%dictionary, @duplications, $i);

while (my $line = <>) {
    chomp $line;
    $i++;

    if (defined $dictionary{$line}) {
        push @duplications, +{line => $i, entry => $line};
        next;
    }
    $dictionary{$line} = 1;
}

if (scalar(@duplications) > 0) {
    say "duplication entries:";
    say "line: " . $_->{line} . ", entry: " . $_->{entry} for @duplications;
    exit 1;
}

