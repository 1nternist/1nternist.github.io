package Archive::Any::Plugin;

use strict;
use warnings;

use Module::Find;
use Cwd;

=head1 NAME

Archive::Any::Plugin - Anatomy of an Archive::Any plugin.

=head1 SYNOPSIS

Explains what is required for a working plugin to Archive::Any.

=head1 PLUGINS

Archive::Any requires that your plugin define three methods, all of which are passed the absolute filename of the file.  This module uses the source of Archive::Any::Plugin::Tar as an example.

=over 4

=item B<Subclass Archive::Any::Plugin>

 use base 'Archive::Any::Plugin';

=item B<can_handle>

This returns an array of mime types that the plugin can handle.

 sub can_handle {
    return(
           'application/x-tar',
           'application/x-gtar',
           'application/x-gzip',
          );
 }

=item B<files>

Return a list of items inside the archive.

 sub files {
    my( $self, $file ) = @_;
    my $t = Archive::Tar->new( $file );
    return $t->list_files;
 }

=item B<extract>

This method should extract the contents of $file to the current directory.  L<Archive::Any::Plugin> handles negotiating directories for you.

 sub extract {
    my ( $self, $file ) = @_;
 
    my $t = Archive::Tar->new( $file );
    return $t->extract;
 }

=back

=head1 AUTHOR

Clint Moore E<lt>cmoore@cpan.orgE<gt>

=head1 SEE ALSO

Archive::Any

=cut


sub _extract {
    my($self, $file, $dir) = @_;

    my $orig_dir;
    if( defined $dir ) {
        $orig_dir = getcwd;
        chdir $dir;
    }

    my $success = $self->extract( $file );

    if( defined $dir) {
        chdir $orig_dir;
    }

    return 1;
}

1;
