requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';

requires 'LWP::UserAgent';
requires 'LWP::Protocol::https';
requires 'JSON';
requires 'MIME::Base64';
requires 'HTTP::Headers';
requires 'HTTP::Request';
requires 'Exception::Class';
requires 'Try::Tiny';


on test => sub {
    requires 'Test::More', '0.88';
};
