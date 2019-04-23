package Kaomojic::Fixtures::Kaomojic;
use Kaomojic::Strict;

use File::Spec;
use Text::CSV_XS;

use Kaomojic::Env;

sub load {
  state $path; $path //= File::Spec->catdir(Kaomojic::Env->rootdir, qw/fixtures kaomojic.csv/);
  return Text::CSV_XS->new({ binary => 1 })->csv(in => $path);
}

1;