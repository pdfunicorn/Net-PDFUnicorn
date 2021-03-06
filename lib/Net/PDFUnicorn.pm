package Net::PDFUnicorn;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Net::PDFUnicorn::UserAgent;
use Net::PDFUnicorn::Documents;
use Net::PDFUnicorn::Templates;
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

sub templates {
    Net::PDFUnicorn::Templates->new( ua => shift->{ua} );
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
    
    my $API_KEY = $ENV{PDFUNICORN_API_KEY};
    
    my $client = Net::PDFUnicorn->new(
        api_key => $API_KEY,
    );

    # create (upload) an image
    
    # file is the file path to the local image.
    # src is the path that will be used in the document image tag to reference
    # the image.

    my $image_metadata = $client->images->create({
        file => 't/unicorn_48.png',
        src => '/stock/logo.png',
    });

    # create a document from source and fetch

    my $doc_meta = $client->documents->create({
        source => '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>'
    });

    my $pdf_file = $client->documents->fetch($doc_meta);

    # create a document from source and fetch in a single request
    
    my $pdf_file = $client->documents->create({
        source => '<doc><page>Hello World! <img src="stock/logo.png" /></page></doc>',
    }, { pdf => 1 });

    # create a document from template and data

    my $template = $client->templates->create({
        source => '<doc><page>Hello World! <img src="[% logo_image %]" /></page></doc>',
    });
    
    my $pdf_file = $client->documents->create({
        template_id => $template->{id},
        data => { logo_image => "stock/logo.png" },
    }, { pdf => 1 });
    
    

=head1 DESCRIPTION

Net::PDFUnicorn is a client for the PDFUnicorn API.

see L<https://pdfunicorn.com/docs/api>

=head1 AUTHOR

Jason Galea E<lt>jason@pdfunicorn.comE<gt>

=head1 COPYRIGHT

Copyright >= 2014 - Jason Galea

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<https://pdfunicorn.com>

=cut
