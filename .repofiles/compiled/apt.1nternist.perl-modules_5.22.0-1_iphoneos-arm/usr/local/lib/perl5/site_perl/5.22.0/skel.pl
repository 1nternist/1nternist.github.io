########################################################################
# skel.pl: an SGMLSPL script for producing scripts (!!).
#
# Copyright (c) 1995 by David Megginson <dmeggins@aix1.uottawa.ca>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#
# Changes:
#
# $Log: skel.pl,v $
# Revision 1.4  1995/11/15  20:21:07  david
# Changed "use Output" to "use SGMLS::Output".
#
# Revision 1.3  1995/08/24  15:04:38  david
# Fixed commented-out 're' handler.
#
# Revision 1.2  1995/08/12  16:16:42  david
# Revised version for 1.01 distribution.
#
# Revision 1.1  1995/04/23  14:49:35  david
# Initial revision
#
########################################################################

use SGMLS;
use SGMLS::Output;

$version = '$Id: skel.pl,v 1.4 1995/11/15 20:21:07 david Exp $';

%subdocs = ();			# Subdocument entities seen so far.
%entities = ();			# External data entities seen so far.
%sdata = ();			# SDATA strings seen so far.
%elements = ();			# Elements seen so far.
$pi = 0;			# Any processing instructions?

$intro = 0;			# Have we printed the banner yet?

$| = 1;

sgml('end_element', '');	# Ignore the ends of elements.
sgml('end_subdoc', '');		# Ignore the ends of subdocument entities.
sgml('cdata', '');		# Ignore CDATA.
sgml('re', '');			# Ignore Record Ends.

				# Note any processing instructions.
sgml('pi', sub { $pi = 1; });

				# Keep track of all subdocument entities.
sgml('start_subdoc', sub {
    my $entity = shift;
    $entities{$entity->name} = 1;
});
				# Keep track of all external data entities.
sgml('entity', sub {
    my $entity = shift;
    $entities{$entity->name} = 1;
});
				# Keep track of all SDATA strings
sgml('sdata', sub {
    my $sdata = shift;
    $sdata{$sdata} = 1;
});

				# Display element handlers as they appear.
sgml('start_element', sub {
    my $element = shift;
    unless ($intro) {
	$intro = 1;
	do_intro($element->name);
    }
    if (!$elements{$element->name}) {
	output "# Element: " . $element->name . "\n";
	output "sgml('<" . $element->name . ">', \"\");\n";
	output "sgml('</" . $element->name . ">', \"\");\n\n";
	$elements{$element->name} = 1;
    }
});

sgml('end', sub {
				# generate subdoc handlers
    my @keys = keys(%subdocs);
    if ($#keys > 0) {
	output "#\n# Subdocument Entity Handlers\n#\n\n";
        foreach (@keys) {
	    output "# Subdocument Entity: $_\n";
	    output "sgml('{" . $_ . "}', \"\");\n";
	    output "sgml('{/" . $_ . "}', \"\");\n\n";
	}
    }
				# generate entity handlers
    my @keys = keys(%entities);
    if ($#keys > 0) {
	output "#\n# External Data Entity Handlers\n#\n\n";
        foreach (@keys) {
	    output "sgml('&" . $_ . ";', \"\");\n";
	}
    }
				# generate sdata handlers
    my @keys = keys(%sdata);
    if ($#keys > 0) {
	output "#\n# SDATA Handlers\n#\n\n";
        foreach (@keys) {
	    output "sgml('|" . $_ . "|', \"\");\n";
	}
    }

    if ($pi) {
	output "#\n# Processing-Instruction Handler\n#\n";
	output "sgml('pi', sub {});\n\n";
    }

    output <<END;
#
# Default handlers (uncomment these if needed).  Right now, these are set
# up to gag on any unrecognised elements, sdata, processing-instructions,
# or entities.
#
# sgml('start_element',sub { die "Unknown element: " . \$_[0]->name; });
# sgml('end_element','');
# sgml('cdata',sub { output \$_[0]; });
# sgml('sdata',sub { die "Unknown SDATA: " . \$_[0]; });
# sgml('re',"\\n");
# sgml('pi',sub { die "Unknown processing instruction: " . \$_[0]; });
# sgml('entity',sub { die "Unknown external entity: " . \$_[0]->name; });
# sgml('start_subdoc',sub { die "Unknown subdoc entity: " . \$_[0]->name; });
# sgml('end_subdoc','');
# sgml('conforming','');

1;
END
});



				# Function to print the banner.
sub do_intro {
    my $doctype = shift;
    output <<END;
########################################################################
# SGMLSPL script produced automatically by the script sgmlspl.pl
#
# Document Type: $doctype
# Edited by: 
########################################################################

use SGMLS;			# Use the SGMLS package.
use SGMLS::Output;		# Use stack-based output.

#
# Document Handlers.
#
sgml('start', sub {});
sgml('end', sub {});

#
# Element Handlers.
#

END
}

1;
	 
    

