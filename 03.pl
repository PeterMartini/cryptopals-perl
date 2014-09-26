#!/usr/bin/perl
use Test::More tests => 1;
use strict;
use warnings;

my $encrypted = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736";
my $decrypted = "Cooking MC's like a pound of bacon";
my $anycommon = qr/[ETAOIN SHRDLU]/i;

sub score {
  my $string = shift;
  my $nonword =()= $string =~ /[^[:graph:] ]/g;
  my $common =()= $string =~ /$anycommon/g;
  return 0 if $nonword > 0;
  return $common;
}

sub decrypt {
  my $target = shift;
  my @bytes = map { hex } $target =~ /(..)/g;

  my ($text, $best) = ("", 0);
  for my $key (0 .. 127) {
    my $string = join("", map { chr($key ^ $_) } @bytes);
    my $score = score($string);
    if ($score > $best) {
      $text = $string;
      $best = $score;
    }
  }

  return $text;
}
  
is $decrypted, decrypt($encrypted);
