# NAME

Net::PDFUnicorn - API Client for PDFUnicorn

# SYNOPSIS

    use Net::PDFUnicorn;
    
    my $client = Net::PDFUnicorn->new(
        api_key => $API_KEY,
    );

    my $image_metadata = $client->images->create({
        file => 't/unicorn_48.png',
        src => '/stock/logo.png',
    });

    my $pdf_file = $client->documents->create({
        source => '<doc><page>Hello World! <img src="stock/logo.png" /></page></doc>',
    }, { pdf => 1 });

    my $doc_meta = $client->documents->create({
        source => '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>'
    });
    
    my $pdf_file2 = $client->documents->fetch($doc_meta);
    

# DESCRIPTION

Net::PDFUnicorn is a client for the PDFUnicorn API.

see [https://pdfunicorn.com/docs/api](https://pdfunicorn.com/docs/api)

# AUTHOR

Jason Galea <jason@pdfunicorn.com>

# COPYRIGHT

Copyright >= 2014 - Jason Galea

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[https://pdfunicorn.com](https://pdfunicorn.com)
