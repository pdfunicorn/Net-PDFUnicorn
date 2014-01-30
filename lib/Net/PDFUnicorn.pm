package Net::PDFUnicorn;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Net::PDFUnicorn::UserAgent;
use Net::PDFUnicorn::Documents;
use Net::PDFUnicorn::Images;

sub new {
    my($class, %args) = @_;
    die '!! We need an api key !!' unless $args{api_key};
    my $ua = Net::PDFUnicorn::UserAgent->new(%args);    
    bless { ua => $ua }, $class;
}

sub documents {
    Net::PDFUnicorn::Documents->new( ua => shift->{ua} );
}

sub images {
    Net::PDFUnicorn::Images->new( ua => shift->{ua} );
}


1;
__END__

=encoding utf-8

=head1 NAME

Net::PDFUnicorn - API Client for PDFUnicorn

=head1 SYNOPSIS

  use Net::PDFUnicorn;

=head1 DESCRIPTION

Net::PDFUnicorn is a client for the PDFUnicorn API.

=head1 AUTHOR

Jason Galea E<lt>lecstor@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2014- Jason Galea

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
