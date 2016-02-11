# A debhelper build system class for handling Perl MakeMaker based projects.
#
# Copyright: © 2008-2009 Joey Hess
#            © 2008-2009 Modestas Vainius
# License: GPL-2+

package Debian::Debhelper::Buildsystem::perl_makemaker;

use strict;
use Debian::Debhelper::Dh_Lib qw(compat);
use base 'Debian::Debhelper::Buildsystem::makefile';
use Config;

sub DESCRIPTION {
	"Perl ExtUtils::MakeMaker (Makefile.PL)"
}

sub check_auto_buildable {
	my $this=shift;
	my ($step)=@_;

	# Handles everything if Makefile.PL exists. Otherwise - next class.
	if (-e $this->get_sourcepath("Makefile.PL")) {
		if ($step eq "configure") {
			return 1;
		}
		else {
			return $this->SUPER::check_auto_buildable(@_);
		}
	}
	return 0;
}

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);
	$this->enforce_in_source_building();
	return $this;
}

sub configure {
	my $this=shift;
	my @flags;
	# If set to a true value then MakeMaker's prompt function will
	# # always return the default without waiting for user input.
	$ENV{PERL_MM_USE_DEFAULT}=1;
	# This prevents  Module::Install from interactive behavior.
	$ENV{PERL_AUTOINSTALL}="--skipdeps";

	if ($ENV{CFLAGS} && ! compat(8)) {
		push @flags, "OPTIMIZE=$ENV{CFLAGS} $ENV{CPPFLAGS}";
	}
	if ($ENV{LDFLAGS} && ! compat(8)) {
		push @flags, "LD=$Config{ld} $ENV{CFLAGS} $ENV{LDFLAGS}";
	}

	$this->doit_in_sourcedir("perl", "Makefile.PL", "INSTALLDIRS=vendor",
		# if perl_build is not tested first, need to pass packlist
		# option to handle fallthrough case
		(compat(7) ? "create_packlist=0" : ()),
		@flags, @_);
}

sub test {
	my $this=shift;
	# Make tests verbose
	$this->SUPER::test("TEST_VERBOSE=1", @_);
}

sub install {
	my $this=shift;
	my $destdir=shift;

	# Special case for Makefile.PL that uses
	# Module::Build::Compat. PREFIX should not be passed
	# for those; it already installs into /usr by default.
	my $makefile=$this->get_sourcepath("Makefile");
	if (system(qq{grep -q "generated automatically by MakeMaker" $makefile}) != 0) {
		$this->SUPER::install($destdir, @_);
	}
	else {
		$this->SUPER::install($destdir, "PREFIX=/usr", @_);
	}
}

1

# Local Variables:
# indent-tabs-mode: t
# tab-width: 4
# cperl-indent-level: 4
# End:
