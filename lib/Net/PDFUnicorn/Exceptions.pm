package Net::PDFUnicorn::Exceptions;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Exception::Class (
    'PDFU::Exception' => {
        fields => [ 'code', 'errors' ],
        description => 'Unexpected Error',
#        alias  => 'throw_fields',
    },

    'PDFU::InvalidRequestError' => {
        isa => 'PDFU::Exception',
        description => 'The request was invalid',
    },

    'PDFU::AuthenticationError' => {
        isa => 'PDFU::Exception',
        description => 'The api key was invalid',
    },

    'PDFU::APIConnectionError' => {
        isa => 'PDFU::Exception',
        description => 'There was an error connecting to the PDFUnicorn service',
    },

    'PDFU::TemporaryError' => {
        isa => 'PDFU::Exception',
        description => 'This resource is temporarily unavailable',
        fields => [ 'retry_after' ],
    },

    'PDFU::PDFUnicornError' => {
        isa => 'PDFU::Exception',
        description => 'PDFUnicorn had a meltdown',
    },
    
    'PDFU::NotFound' => {
        isa => 'PDFU::Exception',
        description => 'Resource Not Found',
    },
);

PDFU::Exception->Trace(1);

sub PDFU::Exception::full_message {
    my $self = shift;
    my $msg = $self->message;
    $msg .= "\n".join("\n", @{$self->errors}) if $self->errors;
}