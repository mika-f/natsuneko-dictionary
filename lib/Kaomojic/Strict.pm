package Kaomojic::Strict;
use strict;
use warnings;
use parent qw/Import::Base/;

our @IMPORT_MODULES = (
    'strict',
    'warnings',
    'feature' => [qw/:5.28/]
);
