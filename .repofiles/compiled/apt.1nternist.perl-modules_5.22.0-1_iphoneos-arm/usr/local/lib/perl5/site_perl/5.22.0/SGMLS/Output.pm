package SGMLS::Output;
use Carp;

use Exporter;
@ISA = Exporter;
@EXPORT = qw(output push_output pop_output);

$version = '$Id: Output.pm,v 1.6 1995/12/05 12:21:51 david Exp $';

=head1 NAME

SGMLS::Output - Stack-based Output Procedures

=head1 SYNOPSIS

  use SGMLS::Output;

To print a string to the current output destination:

  output($data);

To push a new output level to the filehandle DATA:

  push_output('handle',DATA);

To push a new output level to the file "foo.data" (which will be
opened and closed automatically):

  push_output('file','foo.data');

To push a new output level to a pipe to the shell command "sort":

  push_output('pipe','sort');

To push a new output level I<appending> to the file "foo.data":

  push_output('append','foo.data');

To push a new output level to an empty string:

  push_output('string');

To push a new output level appending to the string "David is ":

  push_output('string',"David is ");

To push a new output level to The Great Beyond:

  push_output('nul');

To revert to the previous output level:

  pop_output();

To revert to the previous output level, returning the contents of an
output string:

  $data = pop_output();

=head1 DESCRIPTION

This library allows redirectable, stack-based output to files, pipes,
handles, strings, or nul.  It is especially useful for packages like
L<SGMLS>, since handlers for individual B<SGML> elements can
temporarily change and restore the default output destination.  It is
also particularly useful for capturing the contents of an element (and
its sub-elements) in a string.

Example:

  sgmls('<title>', sub{ push_output('string'); });
  sgmls('</title>', sub{ $title = pop_output(); });

In between, anything sent to B<output> (such as CDATA) will be
accumulated in the string returned from B<pop_output()>.

Example:

  sgmls('<tei.header>', sub { push_output('nul'); });
  sgmls('</tei.header>', sub { pop_output(); });

All output will be ignored until the header has finished.


=head1 AUTHOR AND COPYRIGHT

Copyright 1994 and 1995 by David Megginson,
C<dmeggins@aix1.uottawa.ca>.  Distributed under the terms of the Gnu
General Public License (version 2, 1991) -- see the file C<COPYING>
which is included in the B<SGMLS.pm> distribution.


=head1 SEE ALSO:

L<SGMLS>.

=cut

#
# Anonymous subroutines for handling different types of references.
#
$output_handle_sub = sub {
    print $current_output_data @_;
};

$output_file_sub = sub {
    print $current_output_data @_;
};

$output_string_sub = sub {
    $current_output_data .= shift;
    foreach (@_) {
	$current_output_data .= $, . $_;
    }
    $current_output_data .= $\;
};

$output_nul_sub = sub {};

#
# Status variables
#
$current_output_type = 'handle';
$current_output_data = STDOUT;
$current_output_sub = $output_handle_sub;
@output_stack = qw();

#
# Externally-visible functions
#

				# Send data to the output.
sub output {
    &{$current_output_sub}(@_);
}

				# Push a new output destination.
sub push_output {
    my ($type,$data) = @_;
    push @output_stack, [$current_output_type,$current_output_data,
			 $current_output_sub];
  SWITCH: {
      $type eq 'handle' && do {
          # Force unqualified filehandles into caller's package
          my ($package) = caller;
          $data =~ s/^[^':]+$/$package\:\:$&/;

	  $current_output_sub = $output_handle_sub;
	  $current_output_type = 'handle';
	  $current_output_data = $data;
	  last SWITCH;
      };
      $type eq 'file' && do {
	  $current_output_sub = $output_file_sub;
	  my $handle = new_handle();
	  open($handle,">$data") || croak "Cannot create file $data.\n";
	  $current_output_type = 'file';
	  $current_output_data = $handle;
	  last SWITCH;
      };
      $type eq 'pipe' && do {
	  $current_output_sub = $output_file_sub;
	  my $handle = new_handle();
	  open($handle,"|$data") || croak "Cannot open pipe to $data.\n";
	  $current_output_type = 'file';
	  $current_output_data = $handle;
	  last SWITCH;
      };
      $type eq 'append' && do {
	  $current_output_sub = $output_file_sub;
	  my $handle = new_handle();
	  open($handle,">>$data") || croak "Cannot append to file $data.\n";
	  $current_output_type = 'file';
	  $current_output_data = $handle;
	  last SWITCH;
      };
      $type eq 'string' && do {
	  $current_output_sub = $output_string_sub;
	  $current_output_type = 'string';
	  $current_output_data = $data;
	  last SWITCH;
      };
      $type eq 'nul' && do {
	  $current_output_sub = $output_nul_sub;
	  $current_output_type = 'nul';
	  $current_output_data = '';
	  last SWITCH;
      };
      croak "Unknown output type: $type.\n";
  }
}

				# Pop the current output destination.
sub pop_output {
    my ($old_type,$old_data) = ($current_output_type,$current_output_data);
    ($current_output_type,$current_output_data,$current_output_sub) =
	@{pop @output_stack};
  SWITCH: {
      $old_type eq 'handle' && do {
	  return $old_data;
      };
      $old_type eq 'file' && do {
	  close($old_data);
	  return '';
      };
      $old_type eq 'string' && do {
	  return $old_data;
      };
      $old_type eq 'nul' && do {
	  return '';
      };
      croak "Unknown output type: $type.\n";
  }
}

#
# Local Utility functions.
#
$new_handle_counter = 1;

sub new_handle {
    return "IOHandle" . $new_handle_counter++;
}

1;
