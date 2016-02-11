# Copyright © 2008 Raphaël Hertzog <hertzog@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

package Dpkg::Source::Package::V3::native;

use strict;
use warnings;

our $VERSION = "0.01";

use base 'Dpkg::Source::Package';

use Dpkg;
use Dpkg::Gettext;
use Dpkg::ErrorHandling;
use Dpkg::Compression;
use Dpkg::Exit;
use Dpkg::Source::Archive;
use Dpkg::Source::Functions qw(erasedir);

use POSIX;
use File::Basename;
use File::Temp qw(tempfile);

our $CURRENT_MINOR_VERSION = "0";

sub do_extract {
    my ($self, $newdirectory) = @_;
    my $sourcestyle = $self->{'options'}{'sourcestyle'};
    my $fields = $self->{'fields'};

    my $dscdir = $self->{'basedir'};
    my $basename = $self->get_basename();
    my $basenamerev = $self->get_basename(1);

    my $tarfile;
    foreach my $file ($self->get_files()) {
	if ($file =~ /^\Q$basenamerev\E\.tar\.$compression_re_file_ext$/) {
            error(_g("multiple tarfiles in v1.0 source package")) if $tarfile;
            $tarfile = $file;
	} else {
	    error(_g("unrecognized file for a native source package: %s"), $file);
	}
    }

    error(_g("no tarfile in Files field")) unless $tarfile;

    erasedir($newdirectory);
    info(_g("unpacking %s"), $tarfile);
    my $tar = Dpkg::Source::Archive->new(filename => "$dscdir$tarfile");
    $tar->extract($newdirectory);
}

sub can_build {
    return 1;
}

sub do_build {
    my ($self, $dir) = @_;
    my @tar_ignore = map { "--exclude=$_" } @{$self->{'options'}{'tar_ignore'}};
    my @argv = @{$self->{'options'}{'ARGV'}};

    if (scalar(@argv)) {
        usageerr(_g("-b takes only one parameter with format `%s'"),
                 $self->{'fields'}{'Format'});
    }

    my $sourcepackage = $self->{'fields'}{'Source'};
    my $basenamerev = $self->get_basename(1);
    my $tarname = "$basenamerev.tar." . $self->{'options'}{'comp_ext'};

    info(_g("building %s in %s"), $sourcepackage, $tarname);

    my ($ntfh, $newtar) = tempfile("$tarname.new.XXXXXX",
                                   DIR => getcwd(), UNLINK => 0);
    push @Dpkg::Exit::handlers, sub { unlink($newtar) };

    my ($dirname, $dirbase) = fileparse($dir);
    my $tar = Dpkg::Source::Archive->new(filename => $newtar,
                compression => compression_guess_from_filename($tarname),
                compression_level => $self->{'options'}{'comp_level'});
    $tar->create(options => \@tar_ignore, 'chdir' => $dirbase);
    $tar->add_directory($dirname);
    $tar->finish();
    rename($newtar, $tarname) ||
        syserr(_g("unable to rename `%s' (newly created) to `%s'"),
               $newtar, $tarname);
    pop @Dpkg::Exit::handlers;
    chmod(0666 &~ umask(), $tarname) ||
        syserr(_g("unable to change permission of `%s'"), $tarname);

    $self->add_file($tarname);
}

# vim: set et sw=4 ts=8
1;
