##
# name:      Module::Install::Admin::PMC
# abstract:  Author Support for Perl Compilation (.pmc)
# author:    Ingy döt Net <ingy@ingy.net>
# license:   perl
# copyright: 2006, 2011
# see:
# - Module::Install
# - Module::Compile

package Module::Install::Admin::PMC;

use strict;
use Module::Install::Base;
use File::Basename ();

use vars qw{$VERSION @ISA};
BEGIN {
    $VERSION = '0.61';
    @ISA     = qw{Module::Install::Base};
}

# Admin support for author side pmc management
sub pmc_support {
    my $self = shift;
    require File::Find;

    # Need to find all the .pm files at `perl Makefile.PL` time
    my @pms = glob('*.pm');
    File::Find::find( sub {
        push @pms, $File::Find::name if /\.pm$/i;
    }, 'lib');

    # Then pre-force them to .pmc files (if they do pmc stuff)
    for my $pm (@pms) {
        system("$^X -c $pm")
          unless -e $pm . 'c';
    }

    # So we know which files require pmc support in the Makefile.
    my @pmcs = glob('*.pmc');
    File::Find::find( sub {
        push @pmcs, $File::Find::name if /\.pmc$/i;
    }, 'lib');

    # Need to refresh all .pmc files before moving them to blib
    # Also provide a PHONY pmc target for `make pmc`
    my $postamble = <<'.';
config :: pmc

pmc ::
.

    for my $pmc (@pmcs) {
        my $pm = $pmc;
        chop $pm;
        # Add action for `make pmc`
        $postamble .= <<".";
\t\$(PERL) -c $pm
.
    }

    $self->postamble($postamble)
        if @pms;
}

1;
