use strict;
use warnings;

use inc::Module::Install;

if (not $ENV{PARROT_PATH}) {
	warn "PARROT_PATH needs to be defined\n";
	exit 0;
}

name           'Perl6-Cookbook';
license        'perl';
author         'Gabor Szabo <szabgab@gmail.com>';
all_from       'lib/Perl6/Cookbook.pm';
requires       'perl'                     => '5.008000';
test_requires  'Test::More'              => '0.47';
no_index       'directory'               => qw{ t xt share inc };
install_share  'eg';

WriteAll;
