package Kaomojic::Tasks::OrderFixture;
use Kaomojic::Strict;

use Data::Validator;
use List::MoreUtils qw/sort_by/;
use Text::CSV_XS;
use Module::Load;

sub run {
  state $v; $v //= Data::Validator->new(
    fixture => { isa => 'Str' },
  )->with(qw/Method StrictSequenced/);
  my ($class, $args) = $v->validate(@_);
  my ($fixture) = @$args{qw/fixture/};

  my $cls = "Kaomojic::Fixtures::$fixture";
  load $cls;
  my @entries =
    sort_by { $_->[0] }
    map { [$_->[0] || '', $_->[1]] }
    @{$cls->load};

  # overwrite to fixture
  open(my $fh, '>:encoding(utf8)', $cls->path) or die 'cannot open the file: ' . $cls->path;

  my $csv = Text::CSV_XS->new({ binary => 1 });
  $csv->say($fh, $_) for @entries;
  close $fh;
}

1;