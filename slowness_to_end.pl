#!/usr/bin/perl

# For some reason Perl takes quite some time to end the script

use v5.20;
use warnings;

use Time::HiRes 'gettimeofday';

my $n = $ARGV[0] // 2000;

# Error messages are used as a base for the test data
&tick;
my @test_data;
my $message = join('', map { $! = $_; "$!" } 1..$n);
foreach (0..length $message) {
    push (@test_data, $message);
    chop $message;
}
&tock('Time to generate the test data');

&tick;
END {
    &tock('Time to end the script');
}

sub tick { ${^T0} = gettimeofday() }
sub tock { say "$_[0]: " . (gettimeofday() - ${^T0}) }
