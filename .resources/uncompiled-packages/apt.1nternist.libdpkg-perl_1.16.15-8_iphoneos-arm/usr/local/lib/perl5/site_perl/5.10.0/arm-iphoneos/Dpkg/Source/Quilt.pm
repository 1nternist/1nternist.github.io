# Copyright © 2008-2012 Raphaël Hertzog <hertzog@debian.org>
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

package Dpkg::Source::Quilt;

use strict;
use warnings;

our $VERSION = "0.01";

use Dpkg::Gettext;
use Dpkg::ErrorHandling;
use Dpkg::Source::Patch;
use Dpkg::Source::Functions qw(erasedir fs_time);
use Dpkg::Vendor qw(get_current_vendor);

use File::Spec;
use File::Copy;
use File::Find;
use File::Path qw(make_path);
use File::Basename;

sub new {
    my ($this, $dir, %opts) = @_;
    my $class = ref($this) || $this;

    my $self = {
        'dir' => $dir,
    };
    bless $self, $class;

    $self->load_series();
    $self->load_db();

    return $self;
}

sub setup_db {
    my ($self) = @_;
    my $db_dir = $self->get_db_file();
    if (not -d $db_dir) {
        mkdir $db_dir or syserr(_g("cannot mkdir %s"), $db_dir);
    }
    my $file = $self->get_db_file(".version");
    if (not -e $file) {
        open(VERSION, ">", $file) or syserr(_g("cannot write %s"), $file);
        print VERSION "2\n";
        close(VERSION);
    }
    # The files below are used by quilt to know where patches are stored
    # and what file contains the patch list (supported by quilt >= 0.48-5
    # in Debian).
    $file = $self->get_db_file(".quilt_patches");
    if (not -e $file) {
        open(QPATCH, ">", $file) or syserr(_g("cannot write %s"), $file);
        print QPATCH "debian/patches\n";
        close(QPATCH);
    }
    $file = $self->get_db_file(".quilt_series");
    if (not -e $file) {
        open(QSERIES, ">", $file) or syserr(_g("cannot write %s"), $file);
        my $series = $self->get_series_file();
        $series = (File::Spec->splitpath($series))[2];
        print QSERIES "$series\n";
        close(QSERIES);
    }
}

sub load_db {
    my ($self) = @_;

    my $pc_applied = $self->get_db_file("applied-patches");
    $self->{'applied-patches'} = [ $self->read_patch_list($pc_applied) ];
}

sub write_db {
    my ($self) = @_;

    $self->setup_db();
    my $pc_applied = $self->get_db_file("applied-patches");
    open(APPLIED, ">", $pc_applied) or syserr(_g("cannot write %s"), $pc_applied);
    foreach my $patch (@{$self->{'applied-patches'}}) {
        print APPLIED "$patch\n";
    }
    close(APPLIED);
}

sub load_series {
    my ($self, %opts) = @_;

    my $series = $self->get_series_file();
    $self->{'series'} = [ $self->read_patch_list($series, %opts) ];
}

sub series {
    my ($self) = @_;
    return @{$self->{'series'}};
}

sub applied {
    my ($self) = @_;
    return @{$self->{'applied-patches'}};
}

sub top {
    my ($self) = @_;
    my $count = scalar @{$self->{'applied-patches'}};
    return $self->{'applied-patches'}[$count - 1] if $count;
    return undef;
}

sub next {
    my ($self) = @_;
    my $count_applied = scalar @{$self->{'applied-patches'}};
    my $count_series = scalar @{$self->{'series'}};
    return $self->{'series'}[$count_applied] if ($count_series > $count_applied);
    return undef;
}

sub push {
    my ($self, %opts) = @_;
    $opts{"verbose"} = 0 unless defined($opts{"verbose"});
    $opts{"timestamp"} = fs_time($self->{'dir'}) unless defined($opts{"timestamp"});

    my $patch = $self->next();
    return unless defined $patch;

    my $path = $self->get_patch_file($patch);
    my $obj = Dpkg::Source::Patch->new(filename => $path);

    info(_g("applying %s"), $patch) if $opts{"verbose"};
    eval {
        $obj->apply($self->{'dir'}, timestamp => $opts{"timestamp"},
                    verbose => $opts{"verbose"},
                    force_timestamp => 1, create_dirs => 1, remove_backup => 0,
                    options => [ '-t', '-F', '0', '-N', '-p1', '-u',
                                 '-V', 'never', '-g0', '-E', '-b',
                                 '-B', ".pc/$patch/", '--reject-file=-' ]);
    };
    if ($@) {
        info(_g("fuzz is not allowed when applying patches"));
        info(_g("if patch '%s' is correctly applied by quilt, use '%s' to update it"),
             $patch, "quilt refresh");
        $self->restore_quilt_backup_files($patch, %opts);
        erasedir($self->get_db_file($patch));
        die $@;
    }
    CORE::push @{$self->{'applied-patches'}}, $patch;
    $self->write_db();
}

sub pop {
    my ($self, %opts) = @_;
    $opts{"verbose"} = 0 unless defined($opts{"verbose"});
    $opts{"timestamp"} = fs_time($self->{'dir'}) unless defined($opts{"timestamp"});
    $opts{"reverse_apply"} = 0 unless defined($opts{"reverse_apply"});

    my $patch = $self->top();
    return unless defined $patch;

    info(_g("unapplying %s"), $patch) if $opts{"verbose"};
    my $backup_dir = $self->get_db_file($patch);
    if (-d $backup_dir and not $opts{"reverse_apply"}) {
        # Use the backup copies to restore
        $self->restore_quilt_backup_files($patch);
    } else {
        # Otherwise reverse-apply the patch
        my $path = $self->get_patch_file($patch);
        my $obj = Dpkg::Source::Patch->new(filename => $path);

        $obj->apply($self->{'dir'}, timestamp => $opts{"timestamp"},
                    verbose => 0, force_timestamp => 1, remove_backup => 0,
                    options => [ '-R', '-t', '-N', '-p1',
                                 '-u', '-V', 'never', '-g0', '-E',
                                 '--no-backup-if-mismatch' ]);
    }

    erasedir($backup_dir);
    pop @{$self->{'applied-patches'}};
    $self->write_db();
}

sub get_db_version {
    my ($self) = @_;
    my $pc_ver = $self->get_db_file(".version");
    if (-f $pc_ver) {
        open(VER, "<", $pc_ver) || syserr(_g("cannot read %s"), $pc_ver);
        my $version = <VER>;
        chomp $version;
        close(VER);
        return $version;
    }
    return undef;
}

sub find_problems {
    my ($self) = @_;
    my $patch_dir = $self->get_patch_file();
    if (-e $patch_dir and not -d _) {
        return sprintf(_g("%s should be a directory or non-existing"), $patch_dir);
    }
    my $series = $self->get_series_file();
    if (-e $series and not -f _) {
        return sprintf(_g("%s should be a file or non-existing"), $series);
    }
    return undef;
}

sub get_series_file {
    my ($self) = @_;
    my $vendor = lc(get_current_vendor() || "debian");
    # Series files are stored alongside patches
    my $default_series = $self->get_patch_file("series");
    my $vendor_series = $self->get_patch_file("$vendor.series");
    return $vendor_series if -e $vendor_series;
    return $default_series;
}

sub get_db_file {
    my $self = shift;
    return File::Spec->catfile($self->{'dir'}, ".pc", @_);
}

sub get_db_dir {
    my ($self) = @_;
    return $self->get_db_file();
}

sub get_patch_file {
    my $self = shift;
    return File::Spec->catfile($self->{'dir'}, "debian", "patches", @_);
}

sub get_patch_dir {
    my ($self) = @_;
    return $self->get_patch_file();
}

## METHODS BELOW ARE INTERNAL ##

sub read_patch_list {
    my ($self, $file, %opts) = @_;
    return () if not defined $file or not -f $file;
    $opts{"warn_options"} = 0 unless defined($opts{"warn_options"});
    my @patches;
    open(SERIES, "<" , $file) || syserr(_g("cannot read %s"), $file);
    while(defined($_ = <SERIES>)) {
        chomp; s/^\s+//; s/\s+$//; # Strip leading/trailing spaces
        s/(^|\s+)#.*$//; # Strip comment
        next unless $_;
        if (/^(\S+)\s+(.*)$/) {
            $_ = $1;
            if ($2 ne '-p1') {
                warning(_g("the series file (%s) contains unsupported " .
                           "options ('%s', line %s); dpkg-source might " .
                           "fail when applying patches"),
                        $file, $2, $.) if $opts{"warn_options"};
            }
        }
        error(_g("%s contains an insecure path: %s"), $file, $_) if m{(^|/)\.\./};
        CORE::push @patches, $_;
    }
    close(SERIES);
    return @patches;
}

sub restore_quilt_backup_files {
    my ($self, $patch, %opts) = @_;
    my $patch_dir = $self->get_db_file($patch);
    return unless -d $patch_dir;
    info(_g("restoring quilt backup files for %s"), $patch) if $opts{'verbose'};
    find({
        no_chdir => 1,
        wanted => sub {
            return if -d $_;
            my $relpath_in_srcpkg = File::Spec->abs2rel($_, $patch_dir);
            my $target = File::Spec->catfile($self->{'dir'}, $relpath_in_srcpkg);
            if (-s $_) {
                unlink($target);
                make_path(dirname($target));
                unless (link($_, $target)) {
                    copy($_, $target) ||
                        syserr(_g("failed to copy %s to %s"), $_, $target);
                    chmod((stat(_))[2], $target) ||
                        syserr(_g("unable to change permission of `%s'"), $target);
                }
            } else {
                # empty files are "backups" for new files that patch created
                unlink($target);
            }
        }
    }, $patch_dir);
}

# vim:et:sw=4:ts=8
1;
