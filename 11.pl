#!/usr/bin/perl
use v5.10;
use strict;
use warnings;
use Test::More tests => 30;

use Crypt::Mode::CBC;
use Crypt::Mode::ECB;
use MIME::Base64;
use List::MoreUtils qw(uniq);

sub randbytes { my $count = shift; return join "", map { chr(256*rand) } 0 .. $count - 1; }
sub padtext { my $text = shift; return randbytes(rand() * 5 + 5) . $text . randbytes(rand() * 5 + 5); }

sub ecb {
  my $text = padtext shift;
  my $key = randbytes 16;
  my $m = Crypt::Mode::ECB->new('AES');
  return $m->encrypt($text,$key);
}

sub cbc {
  my $text = padtext shift;
  my $key = randbytes 16;
  my $m = Crypt::Mode::CBC->new('AES');
  return $m->encrypt($text,$key, randbytes(16));
}

my $input = "A" x 400;
for (0..29) {
  my $func = rand() < .5 ? "ECB" : "CBC";
  my $ref  = $func eq "ECB" ? \&ecb : \&cbc;
  my $data = $ref->($input);
  my $unique = uniq (unpack("H*",$data) =~ /(.{32})/g);
  is $func, ($unique <= 4 ? "ECB" : "CBC"), "FUNC was $func, unique was $unique";
}
