package Kaomojic::Fixtures::Ekimemo;
use Kaomojic::Strict;

use File::Spec;
use Text::CSV_XS;

use Kaomojic::Env;

sub load {
  my ($self) = @_;
  return Text::CSV_XS->new({ binary => 1 })->csv(in => $self->path);
}

sub path {
  state $path; $path //= File::Spec->catdir(Kaomojic::Env->rootdir, qw/fixtures ekimemo.csv/);
  return $path;
}

1;