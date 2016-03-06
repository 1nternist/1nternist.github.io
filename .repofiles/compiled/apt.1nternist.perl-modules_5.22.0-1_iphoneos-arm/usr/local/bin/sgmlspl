#!/usr/bin/perl
########################################################################
# sgmlspl: a simple SGML postprocesser for the SGMLS and NSGMLS
#          parsers (requires SGMLS.pm library).
#
# Copyright (c) 1995 by David Megginson <dmeggins@aix1.uottawa.ca>
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
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# $Log: sgmlspl.pl,v $
# Revision 1.8  1995/12/03  21:46:31  david
# Eliminated all use of the SGMLS_Event::key method.
#
# Revision 1.7  1995/11/15  20:22:24  david
# Changed "use Output" to "use SGMLS::Output".  Qualified the STDIN
# filehandle for the SGMLS object with the main:: package name.
#
# Revision 1.6  1995/08/12  16:15:14  david
# Revised version for 1.01 distribution.
#
# Revision 1.5  1995/04/27  11:52:25  david
# Changed 'print' to 'main::output' for re handler; empty string
# translates into an empty sub {} rather than a sub printing an empty
# string; instead of evaluating every argument as a perl script, take
# only the first as a perl script and the rest as its arguments; allow
# empty scripts or scripts which do not end with '1;'; pass the event
# itself as the second argument to each handler, after the event data.
#
# Revision 1.4  1995/04/23  14:44:58  david
# Use the Output package.  Fixed the $version variable.
#
# Revision 1.3  1995/04/22  21:02:49  david
# Added some missing 'last SWITCH;' statements in the sgmls function.
#
# Revision 1.2  1995/04/22  20:58:48  david
# Added $SGMLS_PL::version variable and changed SDATA notation from
# [SDATA] to |SDATA|.
#
# Revision 1.1  1995/04/22  14:40:50  david
# Initial revision
#
########################################################################

use SGMLS::Output;

package SGMLS_PL;
use SGMLS;

$version = '$Id: sgmlspl.pl,v 1.8 1995/12/03 21:46:31 david Exp $';

#
# Set up handler defaults.
#
$start_document_handler = sub {};
$end_document_handler = sub {};
$start_element_handlers = { '' => sub {} };
$end_element_handlers = { '' => sub {} };
$cdata_handler = sub { main::output($_[0]); };
$sdata_handlers = { '' => sub { main::output($_[0]);} };
$re_handler = sub { main::output("\n"); };
$pi_handler = sub { '' => sub {} };
$entity_handlers = { '' => sub {} };
$start_subdoc_handlers = { '' => sub {} };
$end_subdoc_handlers = { '' => sub {} };
$conforming_handler = sub {};

#
# Main access point: declare handlers for different SGML events.
#
# Usage: sgml(event, handler);
#
# The event may be one of the following strings, or a special pattern.
# The generic events are as follow:
#
#   'start'                 The beginning of the document.
#   'end'                   The end of the document.
#   'start_element'         The beginning of an element.
#   'end_element'           The end of an element.
#   'cdata'                 Regular character data.
#   'sdata'                 Special system-specific data.
#   're'                    A record-end.
#   'pi'                    A processing instruction.
#   'entity'                An external-entity reference.
#   'start_subdoc'          The beginning of a subdocument entity.
#   'end_subdoc'            The end of a subdocument entity.
#   'conforming'            The document is conforming.
#
# In addition to these generic events, it is possible to handlers
# for certain specific, named events, as follow:
#
#   '<GI>'                  The beginning of element GI.
#   '</GI>'                 The end of element GI.
#   '[SDATA]'               The system-specific data SDATA.
#   '&ENAME;'               A reference to the external entity ENAME.
#   '{ENAME}'               The beginning of the subdocument-entity ENAME.
#   '{/ENAME}'              The end of the subdocument-entity ENAME.
#
#
# The handler may be a string, which will simply be printed when the
# event occurs (this is usually useful only for the specific, named
# events), or a reference to an anonymous subroutine, which will
# receive two arguments: the event data and the event itself.  For 
# example,
#
#   sgml('<FOO>', "\n\\begin{foo}\n");
#
# and
#
#   sgml('<FOO>', sub { output("\n\\begin{foo}\n"); });
#
# will have identical results.
#
sub main::sgml {
    my ($spec,$handler) = (@_);
    if (ref($handler) ne 'CODE') {
	$handler =~ s/\\/\\\\/g;
	$handler =~ s/'/\\'/g;
	if ($handler eq '') {
	    $handler = sub {};
	} else {
	    $handler = eval "sub { main::output('$handler'); };";
	}
    }
  SWITCH: {
				# start-document handler
      $spec eq 'start' && do {
	  $start_document_handler = $handler;
	  last SWITCH;
      };
				# end-document handler
      $spec eq 'end' && do {
	  $end_document_handler = $handler;
	  last SWITCH;
      };
				# start-element handler
      $spec =~ /^<([^\/].*|)>$/ && do {
	  $start_element_handlers->{$1} = $handler;
	  last SWITCH;
      };
				# generic start-element handler
      $spec eq 'start_element' && do {
	  $start_element_handlers->{''} = $handler;
	  last SWITCH;
      };
				# end-element handler
      $spec =~ /^<\/(.*)>$/ && do {
	  $end_element_handlers->{$1} = $handler;
	  last SWITCH;
      };
				# generic end-element handler
      $spec =~ 'end_element' && do {
	  $end_element_handlers->{''} = $handler;
	  last SWITCH;
      };
				# cdata handler
      $spec eq 'cdata' && do {
	  $cdata_handler = $handler;
	  last SWITCH;
      };
				# sdata handler
      $spec =~ /^\|(.*)\|$/ && do {
	  $sdata_handlers->{$1} = $handler;
	  last SWITCH;
      };
				# generic sdata handler
      $spec eq 'sdata' && do {
	  $sdata_handlers->{''} = $handler;
	  last SWITCH;
      };
				# record-end handler
      $spec eq 're' && do {
	  $re_handler = $handler;
	  last SWITCH;
      };
				# processing-instruction handler
      $spec eq 'pi' && do {
	  $pi_handler = $handler;
	  last SWITCH;
      };
				# entity-reference handler
      $spec =~ /^\&(.*);$/ && do {
	  $entity_handlers->{$1} = $handler;
	  last SWITCH;
      };
				# generic entity-reference handler
      $spec eq 'entity' && do {
	  $entity_handlers->{''} = $handler;
	  last SWITCH;
      };
				# start-subdoc handler
      $spec =~ /^\{([^\/].*|)\}$/ && do {
	  $start_subdoc_handlers->{$1} = $handler;
	  last SWITCH;
      };
				# generic start-subdoc handler
      $spec eq 'start_subdoc' && do {
	  $start_subdoc_handlers->{''} = $handler;
	  last SWITCH;
      };
				# end-subdoc handler
      $spec =~ /^\{\/(.*)\}$/ && do {
	  $end_subdoc_handlers->{$1} = $handler;
	  last SWITCH;
      };
				# generic end-subdoc handler
      $spec eq 'end_subdoc' && do {
	  $end_subdoc_handlers->{''} = $handler;
	  last SWITCH;
      };
				# conforming handler
      $spec eq 'conforming' && do {
	  $conforming_handler = $handler;
	  last SWITCH;
      };

      die "Bad SGML handler pattern: $spec\n";
  }
}


#
# The first argument on the command line is a perl module which will be
# read here and evaluated in the 'main' package -- everything else will
# be an argument to it.
#
package main;

$ARGV = shift;
unless ($ARGV eq '' || do $ARGV) {
    if (!-e $ARGV) {
	die "FATAL: $ARGV does not exist.\n";
    } elsif (!-r $ARGV) {
	die "FATAL: $ARGV exists but is read-protected.\n";
    } elsif ($@) {
	die "FATAL: $@\n";
    }
}


#
# Do the actual work, using the SGMLS package.
#
package SGMLS_PL;

$parse = new SGMLS(main::STDIN);	# a new parse object

&{$start_document_handler}();	# run the start handler.

				# run the appropriate handler for each
				# event
while ($event = $parse->next_event) {
    my $type = $event->type;
  SWITCH: {
      $type eq 'start_element' && do {
	  &{($start_element_handlers->{$event->data->name}||
		$start_element_handlers->{''} || sub {})}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'end_element' && do {
	  &{($end_element_handlers->{$event->data->name}||
		$end_element_handlers->{''} || sub {})}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'cdata' && do {
	  &{$cdata_handler}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'sdata' && do {
	  &{($sdata_handlers->{$event->data}||
	     $sdata_handlers->{''} || sub {})}($event->data,$event);
	  last SWITCH;
      };
      $type eq 're' && do {
	  &{$re_handler}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'pi' && do {
	  &{$pi_handler}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'entity' && do {
	  &{($entity_handlers->{$event->data->name}||
	     $entity_handlers->{''} || sub {})}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'start_subdoc' && do {
	  &{($start_subdoc_handlers->{$event->data->name}||
	     $start_subdoc_handlers->{''} || sub {})}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'end_subdoc' && do {
	  &{($end_subdoc_handlers->{$event->data->name}||
	     $end_subdoc_handlers->{''} || sub {})}($event->data,$event);
	  last SWITCH;
      };
      $type eq 'conforming' && do {
	  &{$conforming_handler}($event->data,$event);
	  last SWITCH;
      };

      die "Unknown SGML event type: $type\n";
  }
}
				
&{$end_document_handler}();	# run the end handler
