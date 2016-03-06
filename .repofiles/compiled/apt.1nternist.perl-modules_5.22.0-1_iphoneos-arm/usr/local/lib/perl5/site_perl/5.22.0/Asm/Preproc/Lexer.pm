# $Id: Lexer.pm,v 1.3 2010/10/15 15:55:26 Paulo Exp $

package Asm::Preproc::Lexer;

#------------------------------------------------------------------------------

=head1 NAME

Asm::Preproc::Lexer - Lexer generator

=cut

#------------------------------------------------------------------------------

use strict;
use warnings;

use Carp;
use Text::Template 'fill_in_string';

use Asm::Preproc::Stream;
use Asm::Preproc::Line;
use Asm::Preproc::Token;

our $VERSION = '0.06';

#------------------------------------------------------------------------------

=head1 SYNOPSIS

  use Asm::Preproc::Lexer;
  my @tokens = (
     BLANKS  => qr/\s+/,       sub {()},
     COMMENT => [qr/\/\*/, qr/\*\//],
                               undef,
     QSTR    => [qr/'/],       sub { my($type, $value) = @_;
                                     [$type, 
                                      substr($value, 1, length($value)-2)] },
     QQSTR   => [qr/"/, qr/"/],
     NUM     => qr/\d+/,
     ID      => qr/[a-z]+/,    sub { my($type, $value) = @_; 
                                     [$type, $value] },
     SYM     => qr/(.)/,       sub { [$1, $1] },
  );
  my $lex = Asm::Preproc::Lexer->new(@tokens);
  my $lex2 = $lex->clone;
  $lex->from(sub {});          # read Asm::Preproc::Line from iterator
  $lex->from(@lines);          # read Asm::Preproc::Line from list
  my $token = $lex->get;       # isa Asm::Preproc::Token

=head1 DESCRIPTION

This module creates a tokenizer based on the specification given to the 
C<new> constructor.

The tokenizer reads L<Asm::Preproc::Line|Asm::Preproc::Line> objects and
splits them in L<Asm::Preproc::Token|Asm::Preproc::Token> objects on each
C<get> call. C<get> returns C<undef> on end of input.

=head1 FUNCTIONS

=head2 new

Creates a new tokenizer object for the given token specification.
Each token is specified by the following elements:

=over 4

=item type

String to identify the token type, unused if the token is discarded (see 
C<BLANKS> and C<COMMENT> above).

=item regexp

One of:

=over 4

=item 1

A single regular expression to match the token at the current input position.

=item 2

A list of one regular expression, to match delimited tokens that use the 
same delimiter for the start and the end. 
The token can span multiple lines.
See see C<QSTR> above for an example for multi-line single-quoted strings.

=item 3

A list of two regular expressions, to match the start 
of the token at the current input position, and the end of the token.
The token can span multiple lines.
See see C<COMMENT> above for an example for multi-line comments.

=back

The regular expression is matched where the previous match finished, 
and each sub-expression cannot span multiple lines.
Parentheses may be used to capture sub-expressions in C<$1>, C<$2>, etc.

It is considered an error, and the tokeninzer dies with an error message
when reading input, if some input cannot be recognized by any of the 
given C<regexp> espressions. Therefore the C<SYM> token above contains the
catch-all expression C<qr/(.)/>.

=item transform (optional)

The optional code reference is a transform subroutine. It receives 
the C<type> and C<value> of the recognized token, and returns one of:

=over 4

=item 1

An array ref with two elements C<[$type, $value]>, 
the new C<type> and C<value> to be 
returned in the L<Asm::Preproc::Token|Asm::Preproc::Token> object.

=item 2

An empty array C<()> to signal that this token shall be dicarded.

=back

As an optimization, the transform subroutine code reference may be
set to C<undef>, to signal that the token will be dicarded 
and there is no use in accumulating it while matching. 
This is usefull to discard comments upfront, instead of
collecting the whole comment, and then pass it to the transform subroutine
just to be discarded afterwards.
See see C<COMMENT> above for an example of usage.

=back

=head2 clone

Creates a copy of this tokenizer object without compiling a new 
lexing subroutine. The copied object has all pending input cleared.

=head2 input

L<Asm::Preproc::Stream|Asm::Preproc::Stream> object from which new lines
to process are read.

=cut

#------------------------------------------------------------------------------
use constant TEXT => 3;			# need to access as $self->[TEXT] to get pos()
use Class::XSAccessor::Array {
	accessors 		=> {
		_lexer		=> 0,
		input		=> 1,
		_line		=> 2,		# current line being processed
		_text		=> TEXT,	# text being parsed
	},
};

sub new { 
	my($class, @tokens) = @_;
	my $self = $class->_new(sub {undef});
	$self->_lexer( $self->_make_lexer(@tokens) );
	$self;
}

sub clone {
	my($self) = @_;
	$self->_new($self->_lexer);
}

sub _new { 
	my($class, $lexer) = @_;
	return bless [
					$lexer, 	 				# _lexer
					Asm::Preproc::Stream->new,	# input
					undef, "",					# _line, _rtext
		], ref($class) || $class;
};

#------------------------------------------------------------------------------
# compile the lexing subroutine
sub _make_lexer {
	my($self, @tokens) = @_;
	@tokens or croak "tokens expected";
	
	# closure for each token attributes, indexed by token sequence nr
	my @type;			# token type
	my @start_re;		# match start of token
	my @end_re;			# match end of token
	my @transform;		# transform subroutine
	my @discard;		# true to discard multi-line token
	my @comment;		# comment to show all options of each token branch
	
	# parse the @tokens list
	for (my $id = 0; @tokens; $id++) {
		# read type
		$type[$id] = shift @tokens;
		
		# read regexp
		my $re = shift @tokens or croak "regexp expected";
		
		if (ref $re eq 'Regexp') {
			$start_re[$id] = $re;
		}
		elsif (ref $re eq 'ARRAY') {
			@$re == 1 and push @$re, $re->[0];
			@$re == 2 or croak "invalid regexp list";
			($start_re[$id], $end_re[$id]) = @$re;
		}
		else {
			croak "invalid regexp";
		}

		# read transform, define discard
		if (@tokens) {
			if (! defined($tokens[0])) {
				$discard[$id] = 1;
				shift @tokens;
			}
			elsif (ref($tokens[0]) eq 'CODE') {
				$transform[$id] = shift @tokens;
			}
		}
	
		# comment
		$comment[$id] = join('  ', map {defined($_) ? $_ : ''}
								$id, 
								$type[$id], 
								$start_re[$id], 
								$end_re[$id],
								$transform[$id], 
								$discard[$id]);
		$comment[$id] =~ s/\n/\\n/g;
		
	}

	# LEXER code
	my $template_data = { 
		end_re			=> \@end_re,
		transform		=> \@transform,
		discard			=> \@discard,
		comment 		=> \@comment,
	};
	my @template_args = (
		DELIMITERS 	=> [ '<%', '%>' ],
		HASH 		=> $template_data,
	);

	my $code = fill_in_string(<<'END_CODE', @template_args);
	
	sub {
		my($self) = @_;

		for ($self->[TEXT]) {
			LINE:
			while (1) {								# read lines
				while ((pos()||0) >= length()) {	# last line consumed
					$self->_read_line or return undef;
				}
		
				TOKEN:
				while (1) {							# read tokens
					my $token_line = $self->_line;	# start of token line
					my $pos0 = pos()||0;			# position before match
					
					# need to read new line
					if (/ \G \z /gcx) {
						next LINE;
					}
END_CODE

	for my $id (0 .. $#type) {
		$template_data->{id} = $id;
		$template_data->{LINE_BLOCK} 
			= fill_in_string(<<'END_CODE', @template_args);
			
						BLOCK:	
						while (1) {			# read  multi-line block
							<% $discard[$id] ? '' : '$pos0 = pos()||0;' %>
							
							# need to read new line
							if (/ \G \z /gcx) {
								$self->_read_line 
									or $token_line->error(
											"unbalanced token at: ".$value);
							}
							# end
							elsif (/ \G (?s: .*?) $end_re[<% $id %>] /gcx) {
								<% $discard[$id] ? '' : 
									'$value .= $self->_capture($pos0);' %>
								last BLOCK;	# collected whole token
							}
							# consume all
							else {
								pos() = length();
								<% $discard[$id] ? '' : 
									'$value .= $self->_capture($pos0);' %>
							}
						}
END_CODE
			
		$template_data->{TRANSFORM} 
			= fill_in_string(<<'END_CODE', @template_args);
			
						# call transform routine
						my $ret = $transform[<% $id %>]->($type, $value);
						next unless $ret;		# discard token
						($type, $value) = @$ret;
END_CODE
		$code .= fill_in_string(<<'END_CODE', @template_args);
		
					# <% $comment[$id] %>
					elsif (/ \G $start_re[<% $id %>] /gcx) {
						my($type, $value) = <%
								'' %> ($type[<% $id %>], $self->_capture($pos0));
						<% $end_re[$id] ? $LINE_BLOCK : '' %>
						<% $transform[$id] ? $TRANSFORM : '' %>
						
						<% $discard[$id] ? 'next;' : '' %>
						
						return Asm::Preproc::Token->new(
											$type, $value, $token_line);
					}
END_CODE
	}
	
	$code .= fill_in_string(<<'END_CODE', @template_args);
					# no token recognized, consume rest of line and die
					else {
						pos() = length();
						$token_line->error("no token recognized at: ".
											substr($_, $pos0));
					}
				}
			}
		}
	};
END_CODE

	#warn $code;
	my $lexer = eval $code;
	$@ and croak "$code\n$@";
	
	return $lexer;
}

#------------------------------------------------------------------------------
# get the next line from input, save in _line, _rtext
sub _read_line {
	my($self) = @_;
	
	# get one line
	my $line = $self->input->get;
	my $text = "";				# default: no text to parse
	
	if (defined $line) {
		# convert to Asm::Preproc::Line if needed
		ref($line) or $line = Asm::Preproc::Line->new($line);
		$text = $line->text;
		$text = "" unless defined $text;		# make sure we have something
	}
	
	$self->_line( $line );		# line to return at each token
	$self->[TEXT] = $text;		# text to parse
	
	return $line;
}
#------------------------------------------------------------------------------
# capture the last match
sub _capture {
	my($self, $pos0) = @_;
	return substr($_, $pos0, pos() - $pos0);
}	
#------------------------------------------------------------------------------

=head2 from

Inserts the given input at the head of the input queue to the tokenizer.
The input is either a list of L<Asm::Preproc::Line|Asm::Preproc::Line>
objects, or an interator function that returns a 
L<Asm::Preproc::Line|Asm::Preproc::Line> object on each call.

The input list and interator can also return plain scalar strings, that 
are converted to L<Asm::Preproc::Line|Asm::Preproc::Line> on the fly, but
the information on input file location for error messages will not be available.

The new inserted input is processed before continuing with whatever was 
already in the queue.

=cut

#------------------------------------------------------------------------------
# my($self, @input) = @_;
sub from { shift->input->unget(@_); }
#------------------------------------------------------------------------------

=head2 get

Retrieves the next token from the input strean as a L<Asm::Preproc::Token|Asm::Preproc::Token> object. 

Returns C<undef> on end of input.

Dies with an error message indicating the location in the input if the 
source does not match any of the tokens.

=cut

#------------------------------------------------------------------------------
sub get { goto $_[0]->_lexer; }
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------

=head2 stream

Returns a L<Asm::Preproc::Stream|Asm::Preproc::Stream> object that will 
return the result of C<get> on each call.

=cut

#------------------------------------------------------------------------------
sub stream {
	my($self) = @_;
	return Asm::Preproc::Stream->new(sub {$self->get});
}
#------------------------------------------------------------------------------

1;
