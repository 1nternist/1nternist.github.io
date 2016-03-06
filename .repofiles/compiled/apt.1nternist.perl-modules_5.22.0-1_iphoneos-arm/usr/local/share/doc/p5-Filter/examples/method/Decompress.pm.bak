package Filter::Decompress ;
 
use Filter::Util::Call ;
use Compress::Zlib ;
use Carp ;

use strict ;
use warnings ;

our $VERSION = '1.01' ;

sub filter 
{ 
    my ($self) = @_ ;
    my ($status) ;
    my ($inf) = $$self ;

    if (($status = filter_read()) >0) {
        ($_, $err) = $inf->inflate($_) ;
        return -1 unless $err == Z_OK or $err == Z_STREAM_END ;
    }
    $status ;
}

sub import
{
    my ($self) = @_ ;

    # Initialise an inflation stream.
    my $x = inflateInit() 
        or croak "Internal Error" ;
    filter_add(\$x) ;
}

1 ;
__END__
