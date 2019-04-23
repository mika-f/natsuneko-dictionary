package Kaomojic::Tasks::ConvertFromOldFormat;
use Kaomojic::Strict;

use Data::Validator;
use Text::CSV_XS;

sub run {
  state $v; $v //= Data::Validator->new(
    in  => { isa => 'Str' },
    out => { isa => 'Str' }, 
  )->with(qw/Method StrictSequenced/);
  my ($class, $args) = $v->validate(@_);
  my ($in, $out) = @$args{qw/in out/};

  my @entries = $class->_read_entries($in);
  $class->_write_entries($out, \@entries);
}

sub _read_entries {
  my ($self, $path) = @_;
  my @entries;

  die 'input path is empty' unless $path;
  open(my $fh, '<:encoding(utf8)', $path) or die "cannot open the file: $path";
  
  while (my $line = <$fh>) {
    chomp $line;
    push @entries, [undef, $line];
  }
  close $fh;

  return @entries;
}

sub _write_entries {
  my ($self, $path, $entries) = @_;

  die 'output path is empty' unless $path;
  open(my $fh, '>:encoding(utf8)', $path) or die "cannot open the file: $path";

  my $csv = Text::CSV_XS->new({ binary => 1});
  $csv->say($fh, $_) for @$entries;
  close $fh;
}

1;

=pod

=head1 NAME

  Kaomojic::Tasks::ConvertFromOldFormat

=head1 DESCRIPTION

Convert from old Kaomojic dictionary (plain text) to new Kaomojic dictionary (YAML).

=cut