package Net::PDFUnicorn::UserAgent;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use LWP::UserAgent;
use MIME::Base64 qw/encode_base64/;
use HTTP::Headers;
use HTTP::Request;
use Data::Dumper;
use JSON;

use Net::PDFUnicorn::Exceptions;


sub new {
    my($class, %args) = @_;
    
    my $host = $args{host} || 'pdfunicorn.com';
    my $port = $args{port} || 443;
    
    my $lwp = LWP::UserAgent->new(
        agent => 'Net::PDFUnicorn',
        default_headers => HTTP::Headers->new(
            Authorization => "Basic " . encode_base64($args{api_key} . ':')
        ),
        from => $args{from},
        ssl_opts => $args{ssl},
        timeout => 30,
    );
    
    bless {
        lwp => $lwp,
        host => $port == 443 ? "https://$host" : "http://$host",
    }, $class;
}

sub post {
    my ($self, $path, $data) = @_;
    my $req = HTTP::Request->new(POST => $self->{host} . $path);
    $req->content_type('application/json');
    $req->content($data);
    
    my $res = $self->{lwp}->request($req);
    if ($res->is_success) { # 200 OK
        return $res->decoded_content;
    } else {
        $self->throw_exception($res);
    }
}

sub get {
    my ($self, $path, $opts) = @_;
    my $res = $self->{lwp}->get($self->{host} . $path);
    #warn "ua get res: ".Data::Dumper->Dumper($res);
    if ($res->is_success) { # 200 OK
        return $res->decoded_content;
    } else {
        $self->throw_exception($res);
    }
}

sub throw_exception {
    my ($self, $res) = @_;
    my $code = $res->code;
    my $content = from_json($res->content) if $res->content;
    if ($code == 503){
        PDFU::TemporaryError->throw(
            code => $code,
            message => $res->message,
            retry_after => $res->header('retry-after')
        );
    } elsif ($code == 422){
        PDFU::InvalidRequestError->throw(
            code => $code,
            errors => $content ? $content->{errors} : $res->{error}
        );
    } elsif ($code == 401){
        PDFU::AuthenticationError->throw(
            code => $code,
            errors => $content ? $content->{errors} : $res->{error}
        );
    } else {
        PDFU::PDFUnicornError->throw(
            code => $code,
            errors => $content ? $content->{errors} : $res->{error}
        );
    }
}


1;
__END__

