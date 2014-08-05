package Mock::Net::Ping;

use strict;
use warnings;
no warnings 'redefine';

use vars qw($VERSION);

$VERSION = '0.01';

# Override Net::Ping::ping
# localhost and 127.0.0.1 will always pass.
# Other hosts and IPs will fail.
*Net::Ping::ping = sub
{
    my ($self,
        $host,              # Name or IP number of host to ping
        $timeout,           # Seconds after which ping times out
    ) = @_;
    my ($ip,                # Packed IP number of $host
        $ret,               # The return value
        $ping_time,         # When ping began
        $address            # address of $host
    );

    croak("Usage: \$p->ping(\$host [, \$timeout])") unless @_ == 2 || @_ == 3;
    $timeout = $self->{"timeout"} unless $timeout;
    croak("Timeout must be greater than 0 seconds") if $timeout <= 0;

    return unless defined $host;

    # Dispatch to the appropriate routine.
    $ping_time = &Net::Ping::time();
    if ( $host eq 'localhost' || $host eq '127.0.0.1' )
    {
        $address = '127.0.0.1';
        $ret = 1;
    }
    elsif ( $host =~ /[^\d.]/ )
    {
        warn "host: $host\n";
        $host = $address = '10.10.10.10';
        $ret = 0;
    }
    else
    {
        $address = $host;
        $ret = 0;
    }

    return wantarray ? ($ret, &Net::Ping::time() - $ping_time, $address) : $ret;
};

1;
__END__

=head1 NAME

Mock::Net::Ping - Mock Net::Ping's ping method

=head1 SYNOPSIS

    use Net::Ping;
    require Mock::Net::Ping;

    my $p = Net::Ping->new();
    my $host = '127.0.0.1';
    my ( $ok, $elapsed ) = $p->ping( $host );
    printf "%s is %s reachable\n", $host, $ok ? '' : 'NOT';
    $host = '10.10.10.10';
    my ( $ok, $elapsed ) = $p->ping( $host );
    printf "%s is %s reachable\n", $host, $ok ? '' : 'NOT';

=head1 DESCRIPTION

This module overrides Net::Ping::ping.

=head2 Functions

=over 4

=item $p->ping($host [, $timeout]);

Pretend to ping the remote host and wait for a response. $host can 
be either the hostname or the IP number of the remote host. The 
optional timeout must be greater than 0 seconds and defaults to
whatever was specified when the ping object was created. Returns a
success flag. If the host is localhost or 127.0.0.1, the 
success flag will be 1. For all other hosts, the success flag will
be 0. In array context, the elapsed time as well as the host that
was passed (except localhost will be converted to 127.0.0.1). The 
elapsed time value will be a float, as returned by the 
Time::HiRes::time() function.

=back

=head1 ACKNOWLEDGEMENTS

This module would not exist without L<Net::Ping> and the 
documentation is based heavily on that of L<Net::Ping> itself.

=head1 AUTHOR

    Matthew Musgrove <mr.muskrat@gmail.com>

=head1 COPYRIGHT

Copyright (c) 2014, Matthew Musgrove. All rights reserved.

This program is free software; you may redistribute it and/or
modify it under the same terms as Perl itself.

=cut



