#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

plan skip_all => "ENV SENDGRID_APIKEY is required.\n"
    unless $ENV{SENDGRID_APIKEY};

use WebService::SendGrid3;
use Data::Dumper;

my $SendGrid = WebService::SendGrid3->new(
    api_key => $ENV{SENDGRID_APIKEY}
);

my $res = $SendGrid->contactdb_add_recipient([
    { email => 'test@example.com', first_name => 'FN', last_name => 'LN' }
]);
is $res->{new_count} + $res->{updated_count}, 1, 'new or updated';
sleep 2;

$res = $SendGrid->contactdb_recipients();
diag Dumper(\$res);
my ($row) = grep { $_->{email} eq 'test@example.com' } @{$res->{recipients}};
ok($row, 'it is there');

# try delete
$res = $SendGrid->contactdb_delete_recipient([
    $row->{id}
]);
is $res, 1, 'deleted';
sleep 2;

$res = $SendGrid->contactdb_recipients();
diag Dumper(\$res);
$row = grep { $_->{email} eq 'test@example.com' } @{$res->{recipients}};
ok(! $row, 'it is removed');

done_testing();