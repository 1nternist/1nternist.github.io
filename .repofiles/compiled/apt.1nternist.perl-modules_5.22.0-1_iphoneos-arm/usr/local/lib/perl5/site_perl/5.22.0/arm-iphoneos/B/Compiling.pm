use strict;
use warnings;

package B::Compiling;

our $VERSION = '0.02';

use B;
use XSLoader;

XSLoader::load(__PACKAGE__, $VERSION);

use Sub::Exporter -setup => {
    exports => ['PL_compiling'],
    groups  => { default => ['PL_compiling'] },
};

1;

__END__

=head1 NAME

B::Compiling - Expose PL_compiling to perl

=head1 SYNOPSIS

    use B::Compiling;

    BEGIN {
        warn "currently compiling ", PL_compiling->file;
    }

=head1 DESCRIPTION

This module exposes the perl interpreter's PL_compiling variable to perl.

=head1 FUNCTIONS

=head2 PL_compiling

This function returns a C<B::COP> object representing PL_compiling. It's
exported by default. See L<B> for documentation on how to use the returned
C<B::COP>.

=head1 SEE ALSO

L<B>

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2008  Florian Ragwitz

This module is free software. You can distribute it under the same terms as
perl itself.

=cut
