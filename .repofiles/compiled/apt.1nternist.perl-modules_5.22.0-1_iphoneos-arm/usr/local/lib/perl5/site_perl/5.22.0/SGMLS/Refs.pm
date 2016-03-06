package SGMLS::Refs;

use Carp;

$version = '$Id: Refs.pm,v 1.5 1995/12/03 21:28:36 david Exp $';

=head1 NAME

SGMLS::Refs

=head1 SYNOPSIS

  use SGMLS::Refs;

To create a new reference-manager object using the file "foo.refs":

  my $refs = new SGMLS::Refs("foo.refs");

To create a new reference-manager object using the file "foo.refs" and
logging changes to the file "foo.log":

  my $refs = new SGMLS::Refs("foo.refs","foo.log");

To record a reference:

  $refs->put("document title",$title);

To retrieve a reference:

  $title = $refs->get("document title");

To return the number of references changed since the last run:

  $num = $refs->changed;

To print a LaTeX-like warning if any references have changed:

  $refs->warn;

=head1 DESCRIPTION

This library can be used together with the B<SGMLS> package to keep
track of forward references from one run to another, like the B<LaTeX>
C<.aux> files.  Each reference manager is an object which reads and
then rewrites a file of perl source, with the file name provided by
the caller.

Example:

  # Start up the reference manager before the parse.
  sgml('start', sub { $refs = new SGMLS::Refs("foo.refs"); });

  # Warn about any changed references at the end.
  sgml('end', sub { $refs->warn; });

  # Look up the title from the last parse, if available.
  sgml('<div>', sub { 
    my $element = shift;
    my $id = $element->attribute(ID)->value;
    my $title = $refs->get("title:$id") || "[no title available]";

    $current_div_id = $id;

    output "\\section{$title}\n\n";
  });


  # Save the title for the next parse.
  sgml('<head>', sub { push_output('string'); });
  sgml('</head>', sub {
    my $title = pop_output();
    my $id = $current_div_id;

    $refs->put("title:$id",$title);
  });
  

=head1 AUTHOR AND COPYRIGHT

Copyright 1994 and 1995 by David Megginson,
C<dmeggins@aix1.uottawa.ca>.  Distributed under the terms of the Gnu
General Public License (version 2, 1991) -- see the file C<COPYING>
which is included in the B<SGMLS.pm> distribution.


=head1 SEE ALSO:

L<SGMLS>, L<SGMLS::Output>.

=cut

#
# Create a new instance of a reference manager.  The first argument is
# the filename for the database, and the second (if present) is a
# filename for logging changes.
#
sub new {
    my ($class,$filename,$logname) = (@_);
    my $self = {};
    my $handle = generate_handle();
    my $loghandle = generate_handle() if $logname;
    my $oldRS = $/;		# Save old record separator.

    # Read the current contents of the reference file (if any).
    if (open($handle,"<$filename")) {
	$/ = 0777;
	$self->{'refs'} = eval <$handle> || {};
	close $handle;
    } else {
	$self->{'refs'} = {};
    }

    # Open the reference file.
    open($handle,">$filename") || croak $@;

    # Open the log file, if any.
    if ($logname) {
	open($loghandle,">$logname") || croak $@;
    }

    # Note pertinent information.
    $self->{'change_count'} = 0;
    $self->{'handle'} = $handle;
    $self->{'loghandle'} = $loghandle;
    $self->{'filename'} = $filename;
    $self->{'logname'} = $logname;

    $/ = $oldRS;		# Restore old record separator.
    return bless $self;
}

#
# Set a reference's value.  If the value is unchanged, don't do anything;
# otherwise, note the change by counting it and (optionally) logging it
# to the file handle provided when the object was created.
#
sub put {
    my ($self,$key,$value) = (@_);
    my $loghandle = $self->{'loghandle'};
    my $oldvalue = $self->{'refs'}->{$key};
    
    if ($oldvalue ne $value) {
	$self->{'change_count'}++;
	if ($loghandle) {
	    print $loghandle "\"$key\" changed from " .
	      
	      "\"$oldvalue\" to \"$value\".\n";
	}
	$self->{'refs'}->{$key} = $value;
    }

    return $oldvalue;
}

#
# Grab the value of a reference.
#
sub get {
    my ($self,$key) = (@_);

    return $self->{'refs'}->{$key};
}

#
# Return the number of changed references.
#
sub changed {
    my $self = shift;
    return $self->{'changed_count'};
}

#
# Print a warning if any references have
# changed (a la LaTeX -- so that the user knows that another pass is
# necessary).  Return 1 if a warning has been printed, or 0 if it
# was unnecessary.
#
sub warn {
    my $self = shift;
    my $count = $self->{'change_count'};
    my $filename = $self->{'filename'};
    my $plural = "references have";

    $plural = "reference has" if $count == 1;
    if ($count > 0) {
	warn "SGMLS::Refs ($filename): $count $plural changed.\n";
	return 1;
    }
    return 0;
}

sub DESTROY {
    my $self = shift;
    my $handle = $self->{'handle'};

    close $self->{'loghandle'};

    print $handle "{\n";
    foreach $key (keys %{$self->{'refs'}}) {
	my $value = $self->{'refs'}->{$key};
	$key =~ s/\\/\\\\/g;
	$key =~ s/'/\\'/g;
	$value =~ s/\\/\\\\/g;
	$value =~ s/'/\\'/g;
	print $handle "  '$key' => '$value',\n";
    }
    print $handle "  '' => ''\n}\n";
}

$handle_counter = 1;
sub generate_handle {
    return "Handle" . $handle_counter++;
}

1;

