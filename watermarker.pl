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


# subroutine &watermark_image
sub watermark_image {
	my $photo = Image::Magick->new; # "creates" new image object
	my $logo = Image::Magick->new;  # "creates" new image object

	$photo->Read($_[0]); # reads photograph from $file, passed to sub as $_[0]

	$logocheck = "logo_100px.png"; # $logocheck so-named to avoid duplicate variables later on
	unless (-e $logocheck) {
		die "Cannot read logo file.\n";
	}
	$logo->Read($logocheck);

	# determines image orientation (e.g. portrait) from dimensions
	($width, $height) = $photo->Get('width','height');
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
		die "Dimensions didn't match. Must be 640 px wide or 480 px high.\n";
	}

	$photo->Write("finalimage.jpg"); # TODO save watermarked image in watermarked/ dir, same name as source file - fail if file already exists.
}


exit;
