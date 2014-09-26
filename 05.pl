#!/usr/bin/perl
use v5.10;
use Test::More tests => 1;

my $input = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal";
my $key = "ICE";
my $output = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f";

sub encrypt {
  my ($input, $key) = @_;
  my @key = map { ord } split //, $key;
  my $chunksize = @key;
  my $index = 0;
  my $output;
  for my $octet (split //, $input) {
    $output .= sprintf("%02x", ord($octet) ^ $key[$index]);
    $index = ($index + 1) % $chunksize;
  }
  return $output;
}

is $output, encrypt($input, $key);
