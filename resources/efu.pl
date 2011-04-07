#!/usr/bin/perl -w
#
# Script that extracts all links from a given URL that end in
# given file extensions.
# Written by Thorsten Fischer <froschi@froschi.org>

use strict;
use Getopt::Long;
use WWW::Mechanize;

my $version = 0.2;

my @default_patterns = qw/jpg mp3 ogg zip/;
my @patterns = ();
my %regexps = ();
my @urls = ();

GetOptions (
	"ext=s" => \@patterns,
	"url=s" => \@urls
);

sub usage {
	print "Extract File URLs $version\n";
	print "efu.pl -e pattern[,pattern ...] [-e pattern ...] -u url [-u url ...]\n";
	print "[-] I am quite sure the syntax of the above is wrong.\n";
	print "  -e pattern  File extension to extract. Can be repeated multiple times.\n";
	print "              Also allows for comma-separated lists.\n";
	print "  -u url      URL to extract from. Can be repeated multiple times.\n";
}

sub extract_urls {
	my $source = shift;
	my @ls = ();

	foreach my $ext (@patterns) { 
		push (@ls, $source -> find_all_links (tag => "a", url_regex => $regexps {$ext}));
	}
	foreach my $l (@ls) {
		print $l -> url_abs () . "\n";
	}
}

# Split up possible comma-separated lists for extensions
@patterns = split (/,/,join (',', @patterns)) if @patterns;
if (not @patterns) {
	@patterns = @default_patterns;
}
if (not @urls) {
	usage ();
	exit;
}

# Pre-compile regular expressions
foreach my $pattern (@patterns) {
	$regexps {$pattern} = qr/\.$pattern$/i;
}

foreach my $url (@urls) {
	my $mech = WWW::Mechanize -> new ();
	my $response;

	$mech -> agent_alias ('Windows IE 6');

	$response = $mech -> get ($url);
	if (not $response) {
		print "Could not fetch URL $url\n";
		next;
	} else {
		extract_urls ($mech);
	}
}

exit;

1; # Huh?
