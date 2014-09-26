#!/usr/bin/perl
use Test::More tests => 1;

my $stringa = "1c0111001f010100061a024b53535009181c";
my $stringb = "686974207468652062756c6c277320657965";

my $answer  = "746865206b696420646f6e277420706c6179";

is $answer, unpack("H*", pack("H*",$stringa) ^ pack("H*",$stringb));
