package Kaomojic::Tasks::Generators::Atok;
use Kaomojic::Strict;

use Data::Validator;
use Encode qw/decode_utf8 encode encode_utf8/;
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
  my @entries = map { encode_utf8($_->[1]) } @{$cls->load};

  # UTF-16LE にうまく出力できないので、 UTF-8 → nkf でやる
  open(FH, '>:raw', $dist) or die "cannot open the file: $dist";

  say FH $class->_str('!!ATOK_TANGO_TEXT_HEADER_1');
  say FH $class->_str('!!一覧出力');
  say FH $class->_str('!!対象辞書;Kaomojic.dic');
  say FH $class->_str('!!単語種類;登録単語(*)');
  say FH $class->_str('');

  say FH $class->_str("$aliased\t$_\t顔文字*") foreach @entries;

  close FH;

  die 'nkf command not found' unless `command -v nkf`;
  `nkf -w16L --overwrite $dist`;
}

sub _str {
  my ($self, $text) = @_;
  return $text;
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