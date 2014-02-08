package Net::PDFUnicorn::Templates;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use JSON;
use Try;
use Scalar::Util qw( blessed );


sub new {
    my($class, %args) = @_;
    bless \%args, $class;
}

sub create {
    my ($self, $doc) = @_;
    my $path = '/v1/templates';
    my $res = $self->{ua}->post($path, to_json($doc));
    return from_json($res);
}

sub update {
    my ($self, $doc) = @_;
    my $path = '/v1/templates/' . $doc->{id};
    my $res = $self->{ua}->put($path, to_json($doc));
    return from_json($res);
}

sub fetch {
    my ($self, $doc) = @_;
    my $path = '/v1/templates/' . $doc->{id};
    my $res = $self->{ua}->get($path);
    return from_json($res);
}

sub delete {
    my ($self, $doc) = @_;
    my $path = '/v1/templates/' . $doc->{id};
    my $res = $self->{ua}->delete($path);
    return $res;
}



1;
__END__

