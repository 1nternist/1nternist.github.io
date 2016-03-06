##
# name:      Module::Compile::Opt
# abstract:  Provide options to Module::Compile
# author:    Ingy döt Net <ingy@ingy.net>
# license:   perl
# copyright: 2006, 2011

package Module::Compile::Opt;
use strict;
use warnings;
# use XXX;

sub import {
    my ($class, @args) = @_;
    my $opts = $class->get_options(@args);
    $class->sanity_check($opts);
    require Module::Compile;
    require Module::Compile::Ext;
    Module::Compile::Ext->import(@{$opts->{ext}});

    # put coderef into @INC
    # Store PERL5OPT in .author
    # In Module::Compile, complain if PERL5OPT != .author/PERL5OPT
}

sub sanity_check {
    my $class = shift;
    die unless -e 'inc' and -e 'Makefile.PL';
}

1;

=head1 SYNOPSIS

    > export PERL5OPT=-MModule::Compile::Opt=-ext,p,pm
    > perl -c lib/Foo.p
    > cat lib/Foo.pm

=head1 DESCRIPTION

Module::Compile::Opt allows you to give runtime options to Module::Compile
By default Module::Compile compiles a module in a C<.pm> file into a C<.pmc>
file. 
