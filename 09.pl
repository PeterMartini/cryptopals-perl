#!/usr/bin/perl
use v5.10;
use strict;
use warnings;
use Test::More tests => 1;

use POSIX qw(ceil);

sub padit {
  my ($text, $blocksize) = @_;
  my $size = $blocksize * ceil(length($text)/$blocksize);
  my $padbytes = $size - length($text);
  if ($padbytes) {
    return $text . chr($padbytes) x $padbytes;
  } else {
    return $text;
  }
}

is padit("YELLOW SUBMARINE",10), "YELLOW SUBMARINE\x04\x04\x04\x04";
