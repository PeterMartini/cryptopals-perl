#!/usr/bin/perl
use v5.20;
use strict;
use warnings;
use feature 'signatures';
no warnings 'experimental';
use Test::More tests => 8;

sub unpad($text) {
  my $lastbyte = ord(substr($text,length($text)-1,1));
  my $match = chr($lastbyte) x $lastbyte;
  die "Bad padding - must be between 1 and 16"
    unless $lastbyte >= 1 and $lastbyte <= 16;
  die "Bad padding - must end with a run of $lastbyte bytes of $lastbyte"
    unless $text =~ /(.*)$match\Z/mg;
  return $1;
}

is unpad("ICE ICE BABY\x04\x04\x04\x04"), "ICE ICE BABY";
is eval { unpad("ICE ICE BABY\x05\x05\x05\x05") }, undef;
like $@, qr/Bad padding - must end with a run of 5 bytes of 5/;
is eval { unpad("ICE ICE BABY\x01\x02\x03\x04") }, undef;
like $@, qr/Bad padding - must end with a run of 4 bytes of 4/;
is eval { unpad("\x02") }, undef;
like $@, qr/Bad padding - must end with a run of 2 bytes of 2/;
is unpad("\x10" x 16), "", "If no padding is required, a block of 16 is appended anyway (this wasn't clear from this question or question 9)";
