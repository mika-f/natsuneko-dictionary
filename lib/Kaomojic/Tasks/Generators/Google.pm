package Kaomojic::Tasks::Generators::Google;
use Kaomojic::Strict;

use Data::Validator;
use File::BOM;
use File::Path qw/make_path/;
use Module::Load;

sub run {
  state $v; $v //= Data::Validator->new(
    fixture => { isa => 'Str' },
    dist    => { isa => 'Str' },
    aliased => { isa => 'Str', default => '' },
  )->with(qw/Method StrictSequenced/);
  my ($class, $args) = $v->validate(@_);
  my ($fixture, $dist, $aliased) = @$args{qw/fixture dist aliased/};

  die 'alias is empty' if $aliased eq '';
  die 'dist path is empty' unless $dist;

  make_path($dist) or die 'cannot create a directory tree.';

  my $cls = "Kaomojic::Fixtures::$fixture";
  load $cls;
  my @entries = map { [$_->[0], $_->[1]] } @{$cls->load};

  open(my $fh, '>:encoding(utf-8):via(File::BOM)', "$dist/kaomojic.txt") or die "cannot open the file: $dist/kaomojic.txt";
  
  foreach my $entry (@entries) {
    my $a = $entry->[0] || $aliased;
    my $b = $entry->[1];

    say $fh "$a\t$b\t顔文字\t";
  }

  close $fh;
}

1;

=pod

=head1 NAME

  Kaomojic::Tasks::Generators::Google

=head1 DESCRIPTION

指定された Fixture 辞書から Google IME に対応した辞書ファイルを生成します。

=head1 SYNOPSIS

  ./bin/runner.sh Generators::Google Kaomojic ./dist/google-ime/
  ./bin/runner.sh Generators::Google Kaomojic ./dist/google-ime/ かお

=cut
