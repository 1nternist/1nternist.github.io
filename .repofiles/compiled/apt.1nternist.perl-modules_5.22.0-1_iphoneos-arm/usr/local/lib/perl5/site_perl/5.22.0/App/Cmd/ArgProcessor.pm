use strict;
use warnings;

package App::Cmd::ArgProcessor;
{
  $App::Cmd::ArgProcessor::VERSION = '0.317';
}
# ABSTRACT: App::Cmd-specific wrapper for Getopt::Long::Descriptive

sub _process_args {
  my ($class, $args, @params) = @_;
  local @ARGV = @$args;

  require Getopt::Long::Descriptive;
  Getopt::Long::Descriptive->VERSION(0.084);

  my ($opt, $usage) = Getopt::Long::Descriptive::describe_options(@params);

  return (
    $opt,
    [ @ARGV ], # whatever remained
    usage => $usage,
  );
}

1;

__END__
=pod

=head1 NAME

App::Cmd::ArgProcessor - App::Cmd-specific wrapper for Getopt::Long::Descriptive

=head1 VERSION

version 0.317

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

