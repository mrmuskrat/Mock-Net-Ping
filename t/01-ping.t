use strict;
use warnings;
use Test::More;

use Net::Ping;

my $p;

subtest "Verify Net::Ping::new" => sub {
    can_ok 'Net::Ping', 'new';
    $p = new_ok( 'Net::Ping' );
};

# Test with the real Net::Ping::Ping
subtest "Verify Net::Ping::ping" => sub {
    can_ok 'Net::Ping', 'ping';
    my ( $ok, $elapsed, $host ) = $p->ping( '127.0.0.1' );
    is( $ok, 1, '127.0.0.1 is pingable' );
    like( $elapsed, qr/^\d+|\d+\.\d+$/, 'Elapsed time was returned' );
    is( $host, '127.0.0.1', '127.0.0.1 was returned' );
};

diag( "Override Net::Ping::ping now");

# Override Net::Ping::ping so that we don't slow down the rest of the tests...
# localhost and 127.0.0.1 will always pass.
# Other hosts and IPs will fail.
require Mock::Net::Ping;

# Test with the mocked version
subtest "Verify localhost" => sub {
    my ( $ok, $elapsed, $host ) = $p->ping( 'localhost' );
    is( $ok, 1, 'localhost is pingable' );
    like( $elapsed, qr/^\d+|\d+\.\d+$/, 'Elapsed time was returned' );
    is( $host, '127.0.0.1', '127.0.0.1 was returned' );
};

subtest "Verify localhost IP" => sub {
    my ( $ok, $elapsed, $host ) = $p->ping( '127.127.127.127' );
    is( $ok, 1, '127.127.127.127 is pingable' );
    like( $elapsed, qr/^\d+|\d+\.\d+$/, 'Elapsed time was returned' );
    is( $host, '127.127.127.127', '127.127.127.127 was returned' );
};

subtest "Verify 10.0.0.0/8 IP" => sub {
    my ( $ok, $elapsed, $host ) = $p->ping( '10.10.10.10' );
    is( $ok, 1, '10.10.10.10 is pingable' );
    like( $elapsed, qr/^\d+|\d+\.\d+$/, 'Elapsed time was returned' );
    is( $host, '10.10.10.10', '10.10.10.10 was returned' );
};

subtest "Verify 172.16.0.0/12 IP" => sub {
    my ( $ok, $elapsed, $host ) = $p->ping( '172.16.16.16' );
    is( $ok, 1, '172.16.16.16 is pingable' );
    like( $elapsed, qr/^\d+|\d+\.\d+$/, 'Elapsed time was returned' );
    is( $host, '172.16.16.16', '172.16.16.16 was returned' );
};

subtest "Verify 192.168.0.0/16 IP" => sub {
    my ( $ok, $elapsed, $host ) = $p->ping( '192.168.168.168' );
    is( $ok, 1, '192.168.168.168 is pingable' );
    like( $elapsed, qr/^\d+|\d+\.\d+$/, 'Elapsed time was returned' );
    is( $host, '192.168.168.168', '192.168.168.168 was returned' );
};

subtest "Verify public IP" => sub {
    my ( $ok, $elapsed, $host ) = $p->ping( '8.8.8.8' ); # Google DNS server
    is( $ok, 0, '8.8.8.8 is not pingable' );
    like( $elapsed, qr/^\d+|\d+\.\d+$/, 'Elapsed time was returned' );
    is( $host, '8.8.8.8', '8.8.8.8 was returned' );
};

done_testing;
