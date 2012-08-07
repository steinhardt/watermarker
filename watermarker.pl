#!/usr/bin/perl

use Image::Magick;
use warnings;


# checks arguments
my $no_of_args = $#ARGV + 1; # Otherwise we'd be counting zeros, no?
if ($no_of_args != 1) {
  die "Usage: $0 path/to/directory/\n";
}

my $dir = $ARGV[0];
unless (-d $dir ) {
	die "Path given doesn't lead to a directory.\n";
} else {
	chomp $dir;
	$dir =~ s{/$}{};
}


# make directory to put watermarked images in
my $destination = "$dir/watermarked";
if (-e $destination ) {
	die "Already watermarked/ directory in $dir/. Delete it and try again.\n";
} else {
	mkdir "$destination", 0777 or die "Couldn't make new directory: $!\n";
	print "Created new directory $destination/.\n";
}


# repeats subroutine for all files in $dir
@files = <$dir>;
foreach $file (@files) { # TODO array @files should be stripped of any non-JPG files. Error "Could not find any .jpg files in directory.\n" if no files after strip.
	die "Noone's written this bit yet!\n";
	# &watermark_image($file);
}


# checks and defines logo to be used for watermarking
$logo_foo = "logo_100px.png"; # odd name avoids duplicate variables later on
unless (-e $logo_foo) {
	die "Cannot read file $logo_foo: $!\n";
}


# subroutine &watermark_image
sub watermark_image {
	my $photo = Image::Magick->new; # "creates" new image object
	my $logo = Image::Magick->new;  # "creates" new image object

	$photo->Read($_[0]); # reads photograph from $file, passed to sub as $_[0]
	$logo->Read($logo_foo); # reads logo from $logo_foo; defines it as $logo

	($width, $height) = $photo->Get('width','height'); # used later to determine image orientation

	print "Processing $_[0] (width $width, height $height)...\n";

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
		warn "Dimensions didn't match. Must be 640 px wide or 480 px high.\n";
	}

	$photo->Write("finalimage.jpg"); # TODO save watermarked image in watermarked/ dir, same name as source file - fail if file already exists.
}


exit;
