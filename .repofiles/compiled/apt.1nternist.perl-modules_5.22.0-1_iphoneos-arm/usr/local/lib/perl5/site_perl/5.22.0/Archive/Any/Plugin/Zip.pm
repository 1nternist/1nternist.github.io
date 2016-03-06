package Archive::Any::Plugin::Zip;

use strict;
use vars qw($VERSION);
$VERSION = 0.03;

use base qw(Archive::Any::Plugin);

use Archive::Zip qw(:ERROR_CODES);

=head1 NAME

Archive::Any::Plugin::Zip - Archive::Any wrapper around Archive::Zip

=head1 SYNOPSIS

B<DO NOT USE THIS MODULE DIRECTLY>

Use Archive::Any instead.

=head1 DESCRIPTION

Wrapper around Archive::Zip for Archive::Any.

=cut

sub can_handle {
    return(
           'application/x-zip',
           'application/x-jar',
           'application/zip',
          );
}

sub files {
    my( $self, $file ) = @_;

    my $z = Archive::Zip->new( $file );
    return $z->memberNames;
}


sub extract {
    my($self, $file) = @_;

    my $z = Archive::Zip->new( $file );
    $z->extractTree;

    return 1;
}

sub type {
    my $self = shift;
    return 'zip';
}


=head1 SEE ALSO

Archive::Any, Archive::Zip

=cut

1;
