#!/usr/bin/perl
use Test::More tests => 1;

my $question = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d";
my $answer = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t";

use MIME::Base64;
is $answer, encode_base64(pack("H*", $question), "");
