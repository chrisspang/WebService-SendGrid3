# NAME

WebService::SendGrid3 - Client library for SendGrid API v3

# VERSION

version 0.10

# SYNOPSIS

    use WebService::SendGrid3;
    my $SendGrid = WebService::SendGrid3->new(
      username => 'user',
      password => 'pass'
    );

    my $response = $SendGrid->get_stats_global(
       query => {
              start_date => '2015-01-01',
              end_date => '2015-01-03',
              aggregated_by => 'day',
       }
    );

# DESCRIPTION

Simple client for talking to SendGrid API v3.

# METHODS

## username

## password

## BUILD

# CATEGORIES

## get\_categories

# SETTINGS

## get\_enforced\_tls

# STATISTICS

## get\_stats\_global

## get\_stats\_category

## get\_stats\_category\_sums

## get\_stats\_subusers

## get\_stats\_subusers\_sums

## get\_stats\_geo

## get\_stats\_devices

## get\_stats\_clients

## get\_stats\_for\_client

## get\_stats\_esp

## get\_stats\_browsers

## get\_stats\_parse

# AUTHOR

Chris Hughes <chrisjh@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Chris Hughes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
