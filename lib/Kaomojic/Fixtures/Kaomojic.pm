package Kaomojic::Fixtures::Kaomojic;
use Kaomojic::Strict;

use Kaomojic::Env;

use File::Spec;
use YAML::Syck;

sub load {
  state $path; $path //= File::Spec->catdir(Kaomojic::Env->rootdir, qw/fixtures kaomojic.yml/);
  return LoadFile($path)->{dictionary};
}

1;