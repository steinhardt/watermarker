#!/usr/bin/perl

use Image::Magick;
use warnings;


# checks for single command line argument
$arguments = $#ARGV + 1;
if ($arguments != 1) {
  die "Usage: $0 path/to/file\n";
}


# defines new image objects
my $photo = Image::Magick->new;
my $logo = Image::Magick->new;


# imports photograph and logo
$photo->Read($ARGV[0]);

$logocheck = "logo_100px.png"; # $logocheck so-named to avoid duplicate variables later on
unless (-e $logocheck) {
	die "Cannot read logo file.\n";
}
$logo->Read($logocheck);


# determines image orientation (e.g. portrait) from dimensions
($width, $height) = $photo->Get('width','height');
print "Processing $ARGV[0] (width $width, height $height)...\n";


# lays watermark over photograph
if ($width == "640") {
	$photo->Composite (
		image=>$logo,
		compose=>'plus',
		blend=>'50x50',
		gravity=>"South", y=>'25',
	);
} elsif ($height == "480") {
	$photo->Composite (
		image=>$logo,
		compose=>'plus',
		blend=>'50x50',
		gravity=>"South", y=>'25',
	);
} else {
	die "Dimensions didn't match.\n";
}


# writes watermarked image
$photo->Write("finalimage.jpg");


exit;


# TODO Make dir `watermarked` in source dir if it doesn't exist already.
# TODO Save watermarked image with same name as source in new dir `watermarked` - fail if file already exists.
