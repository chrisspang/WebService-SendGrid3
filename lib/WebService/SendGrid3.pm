use strict;
use warnings;
package WebService::SendGrid3;

use Moo;
with 'WebService::Client';

# VERSION

# ABSTRACT: Client library for SendGrid API v3

use MIME::Base64;

has username => ( is => 'ro', required => 1 );
has password => ( is => 'ro', required => 1 );

has '+base_url' => ( default => 'https://api.sendgrid.com/v3' );

sub BUILD {
    my ($self) = @_;

    my $u = $self->username();
    my $p = $self->password();
    my $base64_encoded_auth = encode_base64("$u:$p");

    $self->ua->default_header(Authorization => "Basic " . $base64_encoded_auth);
}

## CATEGORIES

sub get_categories {
    my ($self, %args) = @_;
    return $self->get("/categories/", $args{query} || {});
}

## SETTINGS

sub get_enforced_tls {
    my ($self, %args) = @_;
    return $self->get("/user/settings/enforced_tls", $args{query} || {});

}

## STATS

sub get_stats_global {
    my ($self, %args) = @_;
    return $self->get("/stats", $args{query} || {});
}

sub get_stats_category {
    my ($self, %args) = @_;

    if (defined($args{query}{categories})) {
        $args{query}{categories} = $self->_serialise_for_get(
            'categories',
            $args{query}{categories}
        );
    }

    return $self->get("/categories/stats", $args{query} || {});
}

sub get_stats_category_sums {
    my ($self, %args) = @_;

    return $self->get("/categories/stats/sums", $args{query} || {});
}

sub get_stats_subusers {
    my ($self, %args) = @_;

    use Data::Dumper;
    print Dumper \%args;

    if (defined($args{query}{subusers})) {
        $args{query}{subusers} = $self->_serialise_for_get(
            'subusers',
            $args{query}{subusers}
        );
    }

    return $self->get("/subusers/stats", $args{query} || {});
}

sub get_stats_subusers_sums {
    my ($self, %args) = @_;

    return $self->get("/subusers/stats/sums", $args{query} || {});
}

sub get_stats_geo {
    my ($self, %args) = @_;

    return $self->get("/geo/stats", $args{query} || {});
}

sub get_stats_devices {
    my ($self, %args) = @_;

    return $self->get("/devices/stats", $args{query} || {});
}

sub get_stats_clients {
    my ($self, %args) = @_;

    return $self->get("/clients/stats", $args{query} || {});
}

sub get_stats_for_client {
    my ($self, $type, %args) = @_;

    return $self->get("/clients/$type/stats", $args{query} || {});
}

sub get_stats_esp {
    my ($self, %args) = @_;

    if (defined($args{query}{esps})) {
        $args{query}{esps} = $self->_serialise_for_get(
            'esps',
            $args{query}{esps}
        );
    }

    return $self->get("/esp/stats", $args{query} || {});
}

sub get_stats_browsers {
    my ($self, %args) = @_;

    if (defined($args{query}{browsers})) {
        $args{query}{browsers} = $self->_serialise_for_get(
            'browsers',
            $args{query}{browsers}
        );
    }

    return $self->get("/browsers/stats", $args{query} || {});
}

sub get_stats_parse {
    my ($self, %args) = @_;

    return $self->get("/parse/stats", $args{query} || {});
}

## PRIVATE

sub _serialise_for_get {
    my ($self, $name, $ra) = @_;

    # We need to serialise arrays into query strings due to a limitation
    # in WebService::Client - HACK
    my $first = shift @$ra;
    my @rest = map { "&$name=$_" } @$ra;
    return $first . join('', @rest);
}

1;
