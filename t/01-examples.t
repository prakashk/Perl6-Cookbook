#!/usr/bin/perl
use strict;
use warnings;

use File::Spec::Functions qw(catfile catdir);
use File::Temp            qw(tempdir);
use Test::More;
my $tests;

if (not $ENV{PARROT_PATH}) {
	plan skip_all => 'Need to have PARROT_PATH configured for this test';
}
my $parrot = catfile( $ENV{PARROT_PATH}, 'parrot' );
if (not -e $parrot) {
	plan skip_all => "Parrot '$parrot' must be compiled for this test";
}

my $rakudo = catfile( $ENV{PARROT_PATH}, qw(languages perl6 perl6.pbc));
if (not -e $rakudo) {
	plan skip_all => "Rakudo '$rakudo' must be compiled for this test";
}

my @files = glob catdir('eg', '*', '*.p6');

plan tests => 2 * @files;

my %TODO = map {$_ => 1} qw(
	eg/01_Strings/02_Establishing_a_Default_Value.p6
);


my $dir = tempdir( CLEANUP => 1 );
my $err = catfile( $dir, 'err.txt' );
my $out = catfile( $dir, 'out.txt' );
foreach my $file (sort @files) {
	
	system ("$parrot $rakudo $file > $out 2> $err");

	foreach my $std (qw(out err)) {
		my $expected_file = catdir('t', 'files') . substr($file, 2, -2) . $std;
		#diag $expected_file;
		my @expected      = slurp($expected_file);
		my @received      = slurp( catfile( $dir, "$std.txt" ) );
		my $name          = "STD" . uc($std) . " of $file";
		if ($TODO{$file}) {
			TODO: {
				local $TODO = "Feature of $file no implemented yet in Rakudo";
				is_deeply(\@received, \@expected, $name);
			}
		} else {
			is_deeply(\@received, \@expected, $name);
		}
	}
}


sub slurp {
	my $file = shift;
	if (open my $fh, '<', $file) {
		if (wantarray) {
			return <$fh>;
		} else {
			local $/ = undef;
			return <$fh>;
		}
	}
	return;
}
