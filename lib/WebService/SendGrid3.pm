use strict;
use warnings;
package WebService::SendGrid3;

use Moo;
with 'WebService::Client';

# VERSION

# ABSTRACT: Client library for SendGrid API v3

use MIME::Base64;
use Carp 'croak';

has username => ( is => 'ro' );
has password => ( is => 'ro' );
has api_key  => ( is => 'ro' );

has '+base_url' => ( default => 'https://api.sendgrid.com/v3' );

sub BUILD {
    my ($self) = @_;

    if (my $api_key = $self->api_key) {
        $self->ua->default_header(Authorization => "Bearer " . $self->api_key);
    } elsif (my $u = $self->username and my $p = $self->password) {
        my $base64_encoded_auth = encode_base64("$u:$p");
        $self->ua->default_header(Authorization => "Basic " . $self->api_key);
    } else {
        croak "either api_key or username/password is required.\n";
    }
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

## ContactDB: https://sendgrid.com/docs/API_Reference/Web_API_v3/Marketing_Campaigns/contactdb.html
sub contactdb_list {
    my ($self, %args) = @_;

    return $self->get("/contactdb/lists", $args{query} || {});
}

sub contactdb_recipients {
    my ($self, %args) = @_;

    return $self->get("/contactdb/recipients", $args{query} || {});
}

sub contactdb_search_recipients {
    my ($self, %args) = @_;

    return $self->get("/contactdb/recipients/search", $args{query} || {});
}

sub contactdb_add_recipient {
    return (shift)->post("/contactdb/recipients", @_);
}

sub contactdb_delete_recipient {
    return (shift)->x_delete("/contactdb/recipients", @_);
}

sub contactdb_segments {
    my ($self, %args) = @_;

    return $self->get("/contactdb/segments", $args{query} || {});
}

use HTTP::Request::Common qw(DELETE);
sub x_delete {
    my ($self, $path, $data, %args) = @_;
    my $headers = $self->_headers(\%args);
    my $url = $self->_url($path);
    my $req = DELETE $url, %$headers, $self->_content($data, %args);
    return $self->req($req, %args);
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

=head1 SYNOPSIS

  use WebService::SendGrid3;
  my $SendGrid = WebService::SendGrid3->new(
    username => 'user',
    password => 'pass'
  );

  # or use API Key
  my $SendGrid = WebService::SendGrid3->new(
    api_key => 'my_api_key',
  );

  my $response = $SendGrid->get_stats_global(
     query => {
            start_date => '2015-01-01',
            end_date => '2015-01-03',
            aggregated_by => 'day',
     }
  );

=head1 DESCRIPTION

Simple client for talking to SendGrid API v3.

=head1 METHODS

=head2 username

=head2 password

=head2 api_key

=head2 BUILD

=head1 CATEGORIES

=head2 get_categories

=head1 SETTINGS

=head2 get_enforced_tls

=head1 STATISTICS

=head2 get_stats_global

=head2 get_stats_category

=head2 get_stats_category_sums

=head2 get_stats_subusers

=head2 get_stats_subusers_sums

=head2 get_stats_geo

=head2 get_stats_devices

=head2 get_stats_clients

=head2 get_stats_for_client

=head2 get_stats_esp

=head2 get_stats_browsers

=head2 get_stats_parse

=cut
