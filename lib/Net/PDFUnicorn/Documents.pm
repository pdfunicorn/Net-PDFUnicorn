package Net::PDFUnicorn::Documents;

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
    my ($self, $doc, $opts) = @_;
    my $return_pdf = $opts->{pdf} ? '.pdf' : '';
    my $path = '/v1/documents' . $return_pdf;
    my $res = $self->{ua}->post($path, to_json($doc));
    return $opts->{pdf} ? $res : from_json($res);
}

sub fetch {
    my ($self, $doc, $opts) = @_;
    my $fetch_pdf = $opts->{pdf} ? '.pdf' : '';
    
    my $path = '/v1/documents/' . $doc->{id} . $fetch_pdf;
    my $res;
    my $start = time;
    
    while(1){
        try {
            $res = $self->{ua}->get($path);
        } catch {
            my $ex = $_;
            die $ex unless blessed $ex && $ex->can('rethrow');
            if ($ex->code == 503 && $opts->{retry_for}){
                warn sprintf "rethrow if %s - %s (%s) > %s", time, $start, time-$start, $opts->{retry_for};
                $ex->rethrow if time - $start > $opts->{retry_for};
                sleep($ex->retry_after || 5);
                $ex->rethrow if time - $start > $opts->{retry_for};
            } else {
                $ex->rethrow;
            }
        }
        last if $res;
    }    
    return $fetch_pdf ? $res : from_json($res);
}

sub delete {
    my ($self, $doc) = @_;
    my $path = '/v1/documents/' . $doc->{id};
    my $res = $self->{ua}->delete($path);
    return $res;
}



1;
__END__

