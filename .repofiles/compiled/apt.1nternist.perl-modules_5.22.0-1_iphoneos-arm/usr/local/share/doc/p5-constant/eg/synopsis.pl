#!/usr/bin/perl
# 
# Straight from the synopsis.
#
use strict;

use constant PI    => 4 * atan2(1, 1);
use constant DEBUG => 0;

print "Pi equals ", PI, "...\n" if DEBUG;

use constant {
    SEC   => 0,
    MIN   => 1, 
    HOUR  => 2,
    MDAY  => 3,
    MON   => 4,
    YEAR  => 5,
    WDAY  => 6,
    YDAY  => 7,
    ISDST => 8,
};

use constant WEEKDAYS => qw(
    Sunday Monday Tuesday Wednesday Thursday Friday Saturday
);

print "Today is ", (WEEKDAYS)[ (localtime)[WDAY] ], ".\n";
