package Net::PDFUnicorn::Documents;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use JSON;
use Try;


sub new {
    my($class, %args) = @_;
    bless \%args, $class;
}

sub create {
    my ($self, $doc, $pdf) = @_;
    my $path = '/v1/documents' . ($pdf ? '.pdf' : '');
    my $res = $self->{ua}->post($path, to_json($doc));
    return $pdf ? $res : from_json($res);
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
            
            warn '!!!!!'.Data::Dumper->Dumper($ex);
            
            if ($ex->code == 503 && $opts->{retry_for}){
                warn sprintf "rethrow if %s - %s (%s) > %s", time, $start, time-$start, $opts->{retry_for};
                $ex->rethrow if time - $start > $opts->{retry_for};
                sleep($ex->retry_after || 5);
                $ex->rethrow if time - $start > $opts->{retry_for};
            } else {
                $ex->rethrow;
            }
        }
        #warn sprintf "last if %s || %s - %s (%s) <= %s", ($res ? 'true' : 'false'), time, $start, time-$start, $opts->{retry_for};
        last if $res;
    }
#    warn "pdf: $fetch_pdf";
#    warn "res: $res";
    
    return $fetch_pdf ? $res : from_json($res);
}

1;
__END__

