use strict;
use Test::More;
use Net::PDFUnicorn;

use Data::Dumper;
use Try;

# run test with:
#
# PDFUNICORN_API_KEY=[Your-API-Key] prove -lv t

my $API_KEY = $ENV{PDFUNICORN_API_KEY};
my $HOST = $ENV{PDFUNICORN_HOST};
my $PORT = $ENV{PDFUNICORN_PORT};

ok $API_KEY, 'api key set';

my $client = Net::PDFUnicorn->new(
    api_key => $API_KEY,
    host => $HOST || 'localhost',
    port => $PORT || 3000,
);

ok $client, 'client';


# create image and get image meta-data
my $image = $client->images->create({
    file => 't/unicorn_48.png',
    src => '/stock/logo.png',
});

is($image->{src}, "stock/logo.png", "image src");
ok($image->{id}, "image id");
ok($image->{uri}, "image uri");
ok($image->{created}, "image created");


# try to create a doc without providing source
my $doc;

try{
    $doc = $client->documents->create({});
} catch {
    my $ex = $_;
    ok $ex->isa('PDFU::InvalidRequestError'), 'exception isa InvalidRequestError';
    is_deeply $ex->errors, ['Document - Missing required attribute value: "source"'], 'doc errors correct';
    #warn Data::Dumper->Dumper($exception);
};


# create doc from source and get binary

my $doc2 = $client->documents->create({
    source => '<doc><page>Hello World! <img src="stock/logo.png" /></page></doc>',
}, { pdf => 1 });
ok($doc2 =~ /^%PDF/, 'doc is a PDF');


# create doc from source and get metadata

$doc = $client->documents->create({
    source => '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>'
});
is($doc->{source}, '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>', "doc source");
ok($doc->{id}, "doc id");
ok($doc->{uri}, "doc uri");
ok($doc->{created}, "doc created");
ok(!$doc->{file}, "doc file");

# fetch doc metadata

my $doc3 = $client->documents->fetch($doc);
is($doc3->{source}, '<doc size="b5"><page>Hello World! <img src="stock/logo.png" /></page></doc>', "doc source");
ok($doc3->{id}, "doc id");
ok($doc3->{uri}, "doc uri");
ok($doc3->{created}, "doc created");
ok(!$doc3->{file}, "doc file");


# create template

my $tmpl = $client->templates->create({ 
    source => '<doc size="b5"><page>Hello World! <img src="[% logo %]" /></page></doc>'
});
is($tmpl->{source}, '<doc size="b5"><page>Hello World! <img src="[% logo %]" /></page></doc>', "template source");
ok($tmpl->{id}, "template id");
ok($tmpl->{uri}, "template uri");
ok($tmpl->{created}, "template created");

# create doc from template and get binary

$doc = $client->documents->create({
    template_id => $tmpl->{id},
    data => { logo => 'stock/logo.png' },
}, { pdf => 1 });
ok($doc =~ /^%PDF/, 'doc is a PDF');

# create doc from template and get metadata

$doc = $client->documents->create({
    template_id => $tmpl->{id},
    data => { logo => 'stock/logo.png' },
});
ok($doc->{template_id}, "doc template_id");
ok($doc->{id}, "doc id");
ok($doc->{uri}, "doc uri");
ok($doc->{created}, "doc created");
ok(!$doc->{file}, "doc file");


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
    ok $_->isa('PDFU::NotFound'), 'doc not found';
}


# get deleted image

try {
    $client->images->fetch($image);
} catch {
    ok $_->isa('PDFU::NotFound'), 'image not found';
}

done_testing;
