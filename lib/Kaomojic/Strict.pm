package Kaomojic::Strict;
use strict;
use warnings;
use utf8;
use parent qw/Import::Base/;

our @IMPORT_MODULES = (
    'strict',
    'warnings',
    'utf8',
    'feature' => [qw/:5.28/]
);
