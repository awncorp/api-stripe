# ABSTRACT: Stripe.com API Client
package API::Stripe;

use Data::Object::Class;
use Data::Object::Signatures;

use Data::Object::Library qw(
    Str
);

extends 'API::Client';

# VERSION

our $DEFAULT_URL = "https://api.stripe.com";

# ATTRIBUTES

has username => (
    is       => 'rw',
    isa      => Str,
    required => 1,
);

# DEFAULTS

has '+identifier' => (
    default  => 'API::Stripe (Perl)',
    required => 0,
);

has '+url' => (
    default  => $DEFAULT_URL,
    required => 0,
);

has '+version' => (
    default  => 1,
    required => 0,
);

# CONSTRUCTION

method BUILD () {

    my $identifier = $self->identifier;
    my $username   = $self->username;
    my $version    = $self->version;
    my $agent      = $self->user_agent;
    my $url        = $self->url;

    $agent->transactor->name($identifier);

    $url->path("/v$version");
    $url->userinfo($username);

    return $self;

}

method PREPARE ($ua, $tx, %args) {

    my $headers = $tx->req->headers;
    my $url     = $tx->req->url;
    my $method  = $tx->req->method;
    my $content = 'application/json';

    if (grep lc $method eq $_, qw(delete patch post put)) {

        $content = 'application/x-www-form-urlencoded';

    }

    # default headers
    $headers->header('Content-Type' => $content);

    return $self;

}

method resource (@segments) {

    # build new resource instance
    my $instance = __PACKAGE__->new(
        debug      => $self->debug,
        fatal      => $self->fatal,
        retries    => $self->retries,
        timeout    => $self->timeout,
        user_agent => $self->user_agent,
        identifier => $self->identifier,
        username   => $self->username,
        version    => $self->version,
    );

    # resource locator
    my $url = $instance->url;

    # modify resource locator if possible
    $url->path(join '/', $self->url->path, @segments);

    # return resource instance
    return $instance;

}

1;

=encoding utf8

=head1 SYNOPSIS

    use API::Stripe;

    my $stripe = API::Stripe->new(
        username   => 'USERNAME',
        identifier => 'APPLICATION NAME',
    );

    $stripe->debug(1);
    $stripe->fatal(1);

    my $charge = $stripe->charges('ch_163Gh12CVMZwIkvc');
    my $results = $charge->fetch;

    # after some introspection

    $charge->update( ... );

=head1 DESCRIPTION

This distribution provides an object-oriented thin-client library for
interacting with the Stripe (L<https://stripe.com>) API. For usage and
documentation information visit L<https://stripe.com/docs/api>. API::Stripe is
derived from L<API::Client> and inherits all of it's functionality. Please read
the documentation for API::Client for more usage information.

=cut

=attr identifier

    $stripe->identifier;
    $stripe->identifier('IDENTIFIER');

The identifier attribute should be set to a string that identifies your app.

=cut

=attr username

    $stripe->username;
    $stripe->username('USERNAME');

The username attribute should be set to an API key associated with your account.

=cut

=attr debug

    $stripe->debug;
    $stripe->debug(1);

The debug attribute if true prints HTTP requests and responses to standard out.

=cut

=attr fatal

    $stripe->fatal;
    $stripe->fatal(1);

The fatal attribute if true promotes 4xx and 5xx server response codes to
exceptions, a L<API::Client::Exception> object.

=cut

=attr retries

    $stripe->retries;
    $stripe->retries(10);

The retries attribute determines how many times an HTTP request should be
retried if a 4xx or 5xx response is received. This attribute defaults to 0.

=cut

=attr timeout

    $stripe->timeout;
    $stripe->timeout(5);

The timeout attribute determines how long an HTTP connection should be kept
alive. This attribute defaults to 10.

=cut

=attr url

    $stripe->url;
    $stripe->url(Mojo::URL->new('https://api.stripe.com'));

The url attribute set the base/pre-configured URL object that will be used in
all HTTP requests. This attribute expects a L<Mojo::URL> object.

=cut

=attr user_agent

    $stripe->user_agent;
    $stripe->user_agent(Mojo::UserAgent->new);

The user_agent attribute set the pre-configured UserAgent object that will be
used in all HTTP requests. This attribute expects a L<Mojo::UserAgent> object.

=cut

=method action

    my $result = $stripe->action($verb, %args);

    # e.g.

    $stripe->action('head', %args);    # HEAD request
    $stripe->action('options', %args); # OPTIONS request
    $stripe->action('patch', %args);   # PATCH request


The action method issues a request to the API resource represented by the
object. The first parameter will be used as the HTTP request method. The
arguments, expected to be a list of key/value pairs, will be included in the
request if the key is either C<data> or C<query>.

=cut

=method create

    my $results = $stripe->create(%args);

    # or

    $stripe->POST(%args);

The create method issues a C<POST> request to the API resource represented by
the object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=method delete

    my $results = $stripe->delete(%args);

    # or

    $stripe->DELETE(%args);

The delete method issues a C<DELETE> request to the API resource represented by
the object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=method fetch

    my $results = $stripe->fetch(%args);

    # or

    $stripe->GET(%args);

The fetch method issues a C<GET> request to the API resource represented by the
object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=method update

    my $results = $stripe->update(%args);

    # or

    $stripe->PUT(%args);

The update method issues a C<PUT> request to the API resource represented by
the object. The arguments, expected to be a list of key/value pairs, will be
included in the request if the key is either C<data> or C<query>.

=cut

=resource account

    $stripe->account;

The account method returns a new instance representative of the API
I<Account> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#account>.

=cut

=resource application_fees

    $stripe->application_fees;

The application_fees method returns a new instance representative of the API
I<Application Fees> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#application_fees>.

=cut

=resource balance

    $stripe->balance->history;

The balance method returns a new instance representative of the API
I<Balance> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#balance>.

=cut

=resource bitcoin_receivers

    $stripe->bitcoin->receivers;

The bitcoin_receivers method returns a new instance representative of the API
I<Bitcoin Receivers> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#bitcoin_receivers>.

=cut

=resource cards

    $stripe->cards;

The cards method returns a new instance representative of the API
I<Cards> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#cards>.

=cut

=resource charges

    $stripe->charges;

The charges method returns a new instance representative of the API
I<Charges> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#charges>.

=cut

=resource coupons

    $stripe->coupons;

The coupons method returns a new instance representative of the API
I<Coupons> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#coupons>.

=cut

=resource customers

    $stripe->customers;

The customers method returns a new instance representative of the API
I<Customers> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#customers>.

=cut

=resource discounts

    $stripe->discounts;

The discounts method returns a new instance representative of the API
I<Discounts> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#discounts>.

=cut

=resource disputes

    $stripe->disputes;

The disputes method returns a new instance representative of the API
I<Disputes> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#disputes>.

=cut

=resource events

    $stripe->events;

The events method returns a new instance representative of the API
I<Events> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#events>.

=cut

=resource fee_refunds

    $stripe->application_fees('fee_6HiNDgLZ85q6KD')->refunds('fr_6HiNza7kmLzMFc');

The fee_refunds method returns a new instance representative of the API
I<Application Fee Refunds> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#fee_refunds>.

=cut

=resource file_uploads

    $stripe->files;

The file_uploads method returns a new instance representative of the API
I<File Uploads> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#file_uploads>.

=cut

=resource invoiceitems

    $stripe->invoiceitems;

The invoiceitems method returns a new instance representative of the API
I<Invoice Items> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#invoiceitems>.

=cut

=resource invoices

    $stripe->invoices;

The invoices method returns a new instance representative of the API
I<Invoices> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#invoices>.

=cut

=resource plans

    $stripe->plans;

The plans method returns a new instance representative of the API
I<Plans> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#plans>.

=cut

=resource recipients

    $stripe->recipients;

The recipients method returns a new instance representative of the API
I<Recipients> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#recipients>.

=cut

=resource refunds

    $stripe->refunds;

The refunds method returns a new instance representative of the API
I<Refunds> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#refunds>.

=cut

=resource subscriptions

    $stripe->subscriptions;

The subscriptions method returns a new instance representative of the API
I<Subscriptions> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#subscriptions>.

=cut

=resource tokens

    $stripe->tokens;

The tokens method returns a new instance representative of the API
I<Tokens> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#tokens>.

=cut

=resource transfer_reversals

    $stripe->transfers('tr_164xRv2eZvKYlo2CZxJZWm1E')->reversals;

The transfer_reversals method returns a new instance representative of the API
I<Transfer Reversals> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#transfer_reversals>.

=cut

=resource transfers

    $stripe->transfers;

The transfers method returns a new instance representative of the API
I<Transfers> resource requested. This method accepts a list of path
segments which will be used in the HTTP request. The following documentation
can be used to find more information. L<https://stripe.com/docs/api#transfers>.

=cut

