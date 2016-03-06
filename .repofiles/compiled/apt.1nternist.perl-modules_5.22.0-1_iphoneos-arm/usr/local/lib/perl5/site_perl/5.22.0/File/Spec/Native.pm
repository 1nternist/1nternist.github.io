# vim: set ts=2 sts=2 sw=2 expandtab smarttab:
#
# This file is part of File-Spec-Native
#
# This software is copyright (c) 2011 by Randy Stauner.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict;
use warnings;

package File::Spec::Native;
BEGIN {
  $File::Spec::Native::VERSION = '1.002';
}
BEGIN {
  $File::Spec::Native::AUTHORITY = 'cpan:RWSTAUNER';
}
# ABSTRACT: Use native OS implementation of File::Spec from a subclass

use File::Spec (); #core
our @ISA = qw(File::Spec);

# TODO: import?  -as => NATIVE

1;


__END__
=pod

=for :stopwords Randy Stauner cpan testmatrix url annocpan anno bugtracker rt cpants
kwalitee diff irc mailto metadata placeholders

=head1 NAME

File::Spec::Native - Use native OS implementation of File::Spec from a subclass

=head1 VERSION

version 1.002

=head1 SYNOPSIS

  # This serves little purpose on its own but can be useful in some situations

  # For example:
  use Path::Class 0.24;

  # convert foreign file type into native type
  # without having to know what the current OS is
  foreign_file(Win32 => $win32_path)->as_foreign("Native");

  # or to build a file-spec dynamically (possibly taking the type from input):
  my $type = get_requested_file_spec(); # can return "Native"
  foreign_file($type => $file_path);

  # having $type be "Native" is an alternative to having to do:
  my $file = $type ? foreign_file($type, $file_path) : file($file_path);

=head1 DESCRIPTION

This module is a stupid hack to make the default L<File::Spec> behavior
available from a subclass.  This can be useful when using another module
that expects a subclass of L<File::Spec> but you want to use
the current, native OS format (automatically detected by L<File::Spec>).

For example: L<Path::Class/as_foreign> (as of version 0.24)
allows you to translate a L<Path::Class> object from one OS format to another.
However, there is no way to specify that you want to translate the path into
the current, native OS format without guessing at what that format is
(which may include peeking into C<@File::Spec::ISA>).

This module C<@ISA> L<File::Spec>.

=for test_synopsis my ($win32_path, $file_path);

=head1 SEE ALSO

=over 4

=item *

L<File::Spec>

=item *

L<Path::Class>

=item *

L<https://rt.cpan.org/Ticket/Display.html?id=49721>

=back

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc File::Spec::Native

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/File-Spec-Native>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=File-Spec-Native>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/File-Spec-Native>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/F/File-Spec-Native>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=File-Spec-Native>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=File::Spec::Native>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-file-spec-native at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=File-Spec-Native>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code


L<http://github.com/magnificent-tears/File-Spec-Native>

  git clone http://github.com/magnificent-tears/File-Spec-Native

=head1 AUTHOR

Randy Stauner <rwstauner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Randy Stauner.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

