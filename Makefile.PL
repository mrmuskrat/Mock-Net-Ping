use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'Mock::Net::Ping',
    AUTHOR          => 'Matthew Musgrove <mr.muskrat@gmail.com>',
    VERSION_FROM    => 'lib/Mock/Net/Ping.pm',
    ABSTRACT_FROM   => 'lib/Mock/Net/Ping.pm',
    PL_FILES        => {},
    PREREQ_PM       => {
        'Net::Ping' => 0,
    },
    INSTALLDIRS     => 'site',
    dist            => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean           => { FILES => 'Mock-Net-Ping-*' },
);
