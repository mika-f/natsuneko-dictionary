package Kaomojic::Tasks::Generators::Atok;
use Kaomojic::Strict;

use Data::Validator;
use List::MoreUtils qw/natatime/;
use Module::Load;

sub run {
  state $v; $v //= Data::Validator->new(
    fixture => { isa => 'Str' },
    dist    => { isa => 'Str' },
    aliased => { isa => 'Str', default => '' },
  )->with(qw/Method StrictSequenced/);
  my ($class, $args) = $v->validate(@_);
  my ($fixture, $dist, $aliased) = @$args{qw/fixture dist aliased/};

  # TODO: まだ対応してないよ (fixture が)
  die 'alias is empty' if $aliased eq '';
  die 'dist path is empty' unless $dist;

  my $cls = "Kaomojic::Fixtures::$fixture";
  load $cls;
  my @entries = map { [$_->[0], $_->[1]] } @{$cls->load};

  # UTF-16LE にうまく出力できないので、 UTF-8 → nkf でやる
  # 1辞書あたり同じ読みは最大512エントリーのようなので、(めんどうなので読みに関係なく) 512エントリーずつ分割しておく
  my $iterator = natatime 512, @entries;
  my $separate = 1;
  while (my @chunk = $iterator->()) {
    open(my $fh, '>:raw:encoding(utf-16le)', "$dist/kaomojic$separate.txt") or die "cannot open the file: $dist/kaomojic$separate.txt";
    print $fh "\x{FEFF}"; # BOM for Unicode
    say $fh '!!ATOK_TANGO_TEXT_HEADER_1';
    say $fh '!!一覧出力';
    say $fh '!!対象辞書;Kaomojic.dic';
    say $fh '!!単語種類;登録単語(*)';
    say $fh '';

    foreach my $entry (@chunk) {
      my $a = $entry->[0] || $aliased;
      my $b = $entry->[1];

      say $fh "$a\t$b\t顔文字*";
    }

    close $fh;
    $separate += 1;
  }
}

1;

=pod

=head1 NAME

  Kaomojic::Tasks::Generators::Atok

=head1 DESCRIPTION

指定された Fixture 辞書から ATOK に対応した辞書ファイルを生成します。

=head1 SYNOPSIS

  ./bin/runner.sh Generators::Atok Kaomojic ./dist/atok/kaomojic.txt
  ./bin/runner.sh Generators::Atok Kaomojic ./dist/atok/default.txt かお

=cut