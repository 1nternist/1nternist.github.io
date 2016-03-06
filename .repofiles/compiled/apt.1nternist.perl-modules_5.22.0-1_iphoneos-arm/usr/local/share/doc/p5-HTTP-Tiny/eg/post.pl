#!/usr/bin/perl
#
# This file is part of HTTP-Tiny
#
# This software is copyright (c) 2011 by Christian Hansen.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#

use strict;
use warnings;

use HTTP::Tiny;
use URI::Escape qw/uri_escape_utf8/;

my $url = 'http://search.cpan.org/search';

my %form_data = (
  query => 'DAGOLDEN',
  mode => 'author',
);

my @params;
while( my @pair = each %form_data ) {
  push @params, join("=", map { uri_escape_utf8($_) } @pair);
}

my $response = HTTP::Tiny->new->request('POST', $url, {
  content => join("&", @params),
  headers => { 'content-type' => 'application/x-www-form-urlencoded' }
});

print "$response->{status} $response->{reason}\n";

print $response->{content};

