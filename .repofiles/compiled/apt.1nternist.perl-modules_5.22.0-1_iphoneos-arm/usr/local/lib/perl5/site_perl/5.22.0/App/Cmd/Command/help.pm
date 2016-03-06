use strict;
use warnings;

package App::Cmd::Command::help;
{
  $App::Cmd::Command::help::VERSION = '0.317';
}
use App::Cmd::Command;
BEGIN { our @ISA = 'App::Cmd::Command'; }

# ABSTRACT: display a command's help screen


sub command_names { qw/help --help -h -?/ }

sub description {
"This command will either list all of the application commands and their
abstracts, or display the usage screen for a subcommand with its
description.\n"
}

sub execute {
  my ($self, $opts, $args) = @_;

  if (!@$args) {
    my $usage = $self->app->usage->text;
    my $command = $0;

    # chars normally used to describe options
    my $opt_descriptor_chars = qr/[\[\]<>\(\)]/;

    if ($usage =~ /^(.+?) \s* (?: $opt_descriptor_chars | $ )/x) {
      # try to match subdispatchers too
      $command = $1;
    }

    # evil hack ;-)
    bless
      $self->app->{usage} = sub { return "$command help <command>\n" }
      => "Getopt::Long::Descriptive::Usage";

    $self->app->execute_command( $self->app->_prepare_command("commands") );
  } else {
    my ($cmd, $opt, $args) = $self->app->prepare_command(@$args);

    local $@;
    my $desc = $cmd->description;
    $desc = "\n$desc" if length $desc;

    my $ut = join "\n",
      eval { $cmd->usage->leader_text },
      $desc,
      eval { $cmd->usage->option_text };

    print $ut;
  }
}

1;

__END__
=pod

=head1 NAME

App::Cmd::Command::help - display a command's help screen

=head1 VERSION

version 0.317

=head1 DESCRIPTION

This command plugin implements a "help" command.  This command will either list
all of an App::Cmd's commands and their abstracts, or display the usage screen
for a subcommand with its description.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

