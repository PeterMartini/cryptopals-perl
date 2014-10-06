#!/usr/bin/perl
use v5.10;
use MIME::Base64;
use Crypt::Cipher::AES;
use Test::More tests => 1;

my $key = "YELLOW SUBMARINE";
my $c = Crypt::Cipher::AES->new($key);

sub blockkey { return $c->encrypt(pack("q<q<",0,shift())); }
sub apply {
  my @blocks = (shift() =~ /(.{1,16})/mg);
  my $ret;
  for my $ix (0..$#blocks) {
    $ret .= substr($blocks[$ix] ^ blockkey($ix),0,length($blocks[$ix]));
  }
  return $ret;
}

my $text = decode_base64("L77na/nrFsKvynd6HzOoG7GHTLXsTVu9qvY/2syLXzhPweyyMTJULu/6/kXX0KSvoOLSFQ==");
is apply($text), "Yo, VIP Let's kick it Ice, Ice, baby Ice, Ice, baby ";
