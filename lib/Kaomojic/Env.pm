package Kaomojic::Env;
use Kaomojic::Strict;

use File::Basename;
use File::Spec;

sub rootdir {
  state $root; $root //= File::Spec->catdir(dirname(__FILE__), qw/.. ../);
  return $root;
}

1;