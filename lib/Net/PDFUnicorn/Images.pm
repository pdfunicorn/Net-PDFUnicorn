package Net::PDFUnicorn::Images;

use strict;
use 5.008_005;
our $VERSION = '0.01';

sub new {
    my($class, %args) = @_;
    bless \%args, $class;
}


1;
__END__

