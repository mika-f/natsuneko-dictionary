package main;
use strict;
use warnings;
use utf8;
use feature qw/say/;

use Encode::Locale;
use FindBin;
use Module::Load;
use lib "$FindBin::Bin/../lib";

sub run {
    Encode::Locale::decode_argv;
    if (scalar(@ARGV) < 1) {
        say "Usage: ./runner.pl Kaomojic::Foo::Bar arg1 arg2...";
        die;
    }

    my $cls = "Kaomojic::Tasks::" . shift @ARGV;
    load $cls;

    $cls->run(@ARGV);
}

run;

=pod

=head1 NAME

  Kaomojic::Runner

=head1 SYNOPSYS

  carton exec perl ./bin/runner.pl TaskA arg1 arg2...

=cut