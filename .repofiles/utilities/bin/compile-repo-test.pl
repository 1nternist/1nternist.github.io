#!/usr/bin/env perl

# Author: Patrick Muff <muff.pa@gmail.com>
# Purpose: Compiles a Cydia repository

use Digest::MD5;
use Digest::SHA;

sub md5sum {   
    my $file = shift;
    my $digest = "";
    eval {
	open(FILE, $file) or die "Can't find file $file\n";
	my $ctx = Digest::MD5->new;
	$ctx->addfile(*FILE);
	$digest = $ctx->hexdigest;
	close(FILE);
    };
    if ($@) {
	print $@;
	return ""; 
    }  
    return $digest;
}

sub sha1sum {	
    my $file = shift;
    my $digest = "";
    eval {
	open(FILE, $file) or die "Can't find file $file\n";
	my $ctx = Digest::SHA->new;
	$ctx->addfile(*FILE);
	$digest = $ctx->hexdigest;
	close(FILE);
    };
    if ($@) {
	print $@;
	return ""; 
    }  
    return $digest;
}
# build packages into debs/ 
system("chmod -R 0755 .repofiles/uncompiled-packages/");

# remove Packages file
system("rm -rf Packages*");

my $directory = '.repofiles/uncompiled-packages/';
opendir (DIR, $directory) or die $!;
while (my $file = readdir(DIR)) {
	system("dpkg-deb -b .repofiles/uncompiled-packages/".$file." debs/".$file.".deb");
}
closedir(DIR);

# scan the packages and write output to file Packages 
system(".repofiles/utilities/bin/dpkg-scanpackages -m debs /dev/null > Packages");

# bzip2 it to a new file 
system("bzip2 -fks < Packages > Packages.bz2");

# gzip it  
system("gzip -f < Packages > Packages.gz");

# scan again because we zipped the original file  
##system("dpkg-scanpackages debs / > Packages");

# calculate the hashes and write to Release  
system("cp Release-Template Release");
open(RLS, ">>Release");

@files = ("Packages", "Packages.gz", "Packages.bz2");
my $output = "";

foreach (@files) {
	my $fname = $_;
	my $md5 =  md5sum($fname);
	my $size = -s $fname;
	$output = $output.$md5." ".$size." ".$fname."\n";
};

foreach (@files) {
	my $fname = $_;
	my $sha1 =  sha1sum($fname);
	my $size = -s $fname;
	$output = $output.$sha1." ".$size." ".$fname."\n";
};

print RLS $output;
close(RLS);

# remove Release.gpg  
system("rm -rf Release.gpg");

# generate Release.gpg	
system("gpg --passphrase-file /usr/share/keyrings/passwd/github --batch -abs -u dc1nternist -o Release.gpg Release");



exit 0;