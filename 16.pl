#!/usr/bin/perl
use v5.10;
use MIME::Base64;
use Crypt::Mode::CBC;
use List::MoreUtils qw(uniq);
use Test::More tests => 5;

package C16 {
  use POSIX qw(ceil);
  use constant blocksize => 16;
  my $m = Crypt::Mode::CBC->new("AES",0);
  my $key = randc(blocksize);
  my $iv = randc(blocksize);
  sub randc { my $c = shift; return join "", map { chr(256*rand) } 0 .. $c - 1;}
  sub encrypt { my $enc = $m->encrypt(pad(shift),$key,$iv), $iv; return $enc; }
  sub decrypt { return $m->decrypt(shift,$key,$iv); }
  sub unpad {
    my $text = shift;
    my $lastbyte = ord(substr($text,length($text)-1,1));
    my $match = chr($lastbyte) x $lastbyte;
    die "Bad padding - must be between 1 and " . blocksize
      unless $lastbyte >= 1 and $lastbyte <= blocksize;
    die "Bad padding - must end with a run of $lastbyte bytes of $lastbyte"
      unless $text =~ /(.*)$match\Z/mg;
    return $1;
  }
  sub pad {
    my $text = shift;
    my $size = blocksize * ceil(length($text)/blocksize);
    my $padbytes = $size - length($text);
    if ($padbytes) {
      return $text . chr($padbytes) x $padbytes;
    } else {
      return $text . chr(16) x 16;
    }
  }
}

sub first_function {
  my $text = shift;
  $text =~ s/&/&amp/g;
  $text =~ s/;/&semi/g;
  $text =~ s/=/&equal/g;
  my $prefix = "comment1=cooking%20MCs;userdata=";
  my $suffix = ";comment2=%20like%20a%20pound%20of%20bacon";
  $text = "${prefix}${text}${suffix}";
  return C16::encrypt $text;
}

sub second_function {
  my $ciphertext = shift;
  my $text = C16::unpad C16::decrypt $ciphertext;
  return $text =~ /;admin=true;/;
}

ok !second_function(first_function(";admin=true;"));
ok !second_function(first_function(";admin=true;"));
ok !second_function(first_function(";admin=true;"));
ok !second_function(first_function(";admin=true;"));

my $text = ";admin=true;";
substr($text,0,1) = ";" ^ chr(1); # Flip a bit in the first ';' character
substr($text,6,1) = "=" ^ chr(1); # Flip a bit in the '=' character
substr($text,11,1) = ";" ^ chr(1); # Flip a bit in the second ';' character

my $ciphertext = first_function($text);
substr($ciphertext,16,1) = substr($ciphertext,16,1) ^ chr(1);
substr($ciphertext,22,1) = substr($ciphertext,22,1) ^ chr(1);
substr($ciphertext,27,1) = substr($ciphertext,27,1) ^ chr(1);

ok second_function($ciphertext);
