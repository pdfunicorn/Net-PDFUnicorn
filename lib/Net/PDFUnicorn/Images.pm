package Net::PDFUnicorn::Images;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use JSON;


sub new {
    my($class, %args) = @_;
    bless \%args, $class;
}

sub create {
    my ($self, $doc) = @_;
    my $path = '/v1/images';
    my $res = $self->{ua}->upload($path, $doc);
    return from_json($res);
}

sub delete {
    my ($self, $doc) = @_;
    my $path = '/v1/images/' . $doc->{id};
    my $res = $self->{ua}->delete($path);
    return $res;
}

sub fetch {
    my ($self, $doc) = @_;
    my $path = '/v1/images/' . $doc->{id};
    my $res = $self->{ua}->get($path);
    return $res;
}

1;
__END__

