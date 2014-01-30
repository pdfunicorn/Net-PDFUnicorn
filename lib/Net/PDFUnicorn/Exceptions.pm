package Net::PDFUnicorn::Exceptions;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Exception::Class (
    'PDFU::Exception' => {
        fields => [ 'code', 'errors' ],
    },

    'PDFU::InvalidRequestError' => {
        isa => 'PDFU::Exception',
        description => 'The request was invalid',
#        fields => [ 'grandiosity', 'quixotic' ],
#        alias  => 'throw_fields',
    },

    'PDFU::AuthenticationError' => {
        isa => 'PDFU::Exception',
        description => 'The api key was invalid',
#        fields => [ 'grandiosity', 'quixotic' ],
#        alias  => 'throw_fields',
    },

    'PDFU::APIConnectionError' => {
        isa => 'PDFU::Exception',
        description => 'There was an error connecting to the PDFUnicorn service',
#        fields => [ 'grandiosity', 'quixotic' ],
#        alias  => 'throw_fields',
    },

    'PDFU::TemporaryError' => {
        isa => 'PDFU::Exception',
        description => 'This resource is temporarily unavailable',
        fields => [ 'retry_after' ],
#        alias  => 'throw_fields',
    },

    'PDFU::PDFUnicornError' => {
        isa => 'PDFU::Exception',
        description => 'PDFUnicorn had a meltdown',
#        fields => [ 'grandiosity', 'quixotic' ],
#        alias  => 'throw_fields',
    },
);