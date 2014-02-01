use strict;
use Test::More;
use Net::PDFUnicorn;

use Data::Dumper;
use Try;

# run test with:
#
# PDFUNICORN_API_KEY=[Your-API-Key] prove -lv t

my $API_KEY = $ENV{PDFUNICORN_API_KEY};

ok $API_KEY, 'api key set';

my $client = Net::PDFUnicorn->new(
    api_key => $API_KEY,
);

ok $client, 'client ok';


# create image and get image meta-data
my $image = $client->images->create({
    file => 't/unicorn_48.png',
    src => '/stock/logo.png',
});

is($image->{src}, "stock/logo.png", "src ok");
ok($image->{id}, "id ok");
ok($image->{uri}, "uri ok");
ok($image->{created}, "created ok");


# try to create a doc without providing source
my $doc;

try{
    $doc = $client->documents->create({});
} catch {
    my $ex = $_;
    ok $ex->isa('PDFU::InvalidRequestError'), 'exception isa InvalidRequestError';
    is_deeply $ex->errors, ['Document - Missing required attribute value: "source"'], 'errors correct';
    #warn Data::Dumper->Dumper($exception);
};


# create doc and get binary

my $doc2 = $client->documents->create({
    source => '<doc><page>Hello World! <img src="stock/logo.png" /></page></doc>',
}, { pdf => 1 });
ok($doc2 =~ /^%PDF/, 'doc is a PDF');


# create doc and get metadata

$doc = $client->documents->create({source => '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>'});
is($doc->{source}, '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>', "source ok");
ok($doc->{id}, "id ok");
ok($doc->{uri}, "uri ok");
ok($doc->{created}, "created ok");
ok(!$doc->{file}, "file ok");


# fetch doc metadata

my $doc3 = $client->documents->fetch($doc);
is($doc3->{source}, '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>', "source ok");
ok($doc3->{id}, "id ok");
ok($doc3->{uri}, "uri ok");
ok($doc3->{created}, "created ok");
ok(!$doc3->{file}, "file ok");


# fetch pdf

my $doc4 = $client->documents->fetch($doc, { pdf => 1, retry_for => 30 });
ok($doc4 =~ /^%PDF/, 'doc is a PDF');

# and again
my $doc5 = $client->documents->fetch($doc, { pdf => 1, retry_for => 30 });
ok($doc5 =~ /^%PDF/, 'doc is a PDF');


# delete document

ok $client->documents->delete($doc), 'delete document';


# delete image

ok $client->images->delete($image), 'delete image';


# get deleted document

try {
    $client->documents->fetch($doc);
} catch {
    ok $_->isa('PDFU::NotFound');
}


# get deleted image

try {
    $client->images->fetch($image);
} catch {
    ok $_->isa('PDFU::NotFound');
}

done_testing;
