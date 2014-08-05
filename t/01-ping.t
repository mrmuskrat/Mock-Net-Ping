use strict;
use warnings;
use Test::More;

use Net::Ping;

my $np;

subtest "Verify Net::Ping::new" => sub {
    can_ok 'Net::Ping', 'new';
    $np = new_ok( 'Net::Ping' );
};

# Test with the real Net::Ping::Ping
subtest "Verify Net::Ping::ping" => sub {
    can_ok 'Net::Ping', 'ping';
    my ( $ok, $elapsed, $host ) = $np->ping( '127.0.0.1' );
    is( $ok, 1, '127.0.0.1 is pingable' );
    like( $elapsed, qr/\d+\.\d+/, 'Elapsed time was returned' );
    is( $host, '127.0.0.1', '127.0.0.1 was returned' );
};

# Override Net::Ping::ping so that we don't slow down the rest of the tests...
# localhost and 127.0.0.1 will always pass.
# Other hosts and IPs will fail.
require Mock::Net::Ping;

# Test with the mocked version
subtest "Verify Mock::Net::Ping::ping" => sub {
    can_ok 'Net::Ping', 'ping';
    my ( $ok, $elapsed, $host ) = $np->ping( 'localhost' );
    is( $ok, 1, 'localhost is pingable' );
    like( $elapsed, qr/\d+\.\d+/, 'Elapsed time was returned' );
    is( $host, '127.0.0.1', '127.0.0.1 was returned' );
    ( $ok, $elapsed, $host ) = $np->ping( '10.10.10.10' );
    is( $ok, 0, '10.10.10.10 is not pingable' );
    like( $elapsed, qr/\d+\.\d+/, 'Elapsed time was returned' );
    is( $host, '10.10.10.10', '10.10.10.10 was returned' );
};

done_testing;
