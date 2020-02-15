#!/usr/bin/perl

use v5.24;
use warnings;

use Test::More;

# Fibonacci sequence implemented using signatures
# No logic within the function body!
{
    use feature 'signatures';
    use experimental 'signatures';

    sub fib ($, $z = ($_[0] < 2) ? (return $_[0]) : (return(fib($_[0] - 1) + fib($_[0] - 2))) ) {}

    ok((
        fib(0) == 0
    and fib(1) == 1
    and fib(2) == 1
    and fib(5) == 5
    and fib(10) == 55
        ), 'Fibonacci sequence works as expected');
}

# Use glob() to generate carthesian product
{
    sub carthesian_by_glob :prototype($@) {
        my ($separator, @elements) = @_;

        # ex: "{green,red}-{apple,banana}-{fruit}"
        my @result = glob(join($separator, map { '{' . join(',', @$_) . '}' } @elements));
        return @result;
    }

    ok((
        scalar(carthesian_by_glob('-', ([qw[green yellow red]], [qw[apple banana]], ['fruit']))) == 6
    and scalar(carthesian_by_glob('-', ([qw[green yellow red]], [qw[apple apricot banana]], ['fruit']))) == 9
    and scalar(carthesian_by_glob('-', ([qw[green yellow red]], [qw[apple apricot banana]], [qw[fruit plant]]))) == 18
        ), 'Carthesian calculated using glob as expected');
}

# Use "qw" or "qq" to check whether parentheses are balanced. Surprisingly efficient!
{
    sub AreBalanced {
        my ($data) = @_;
        my $result = 1;

        eval("qq($data)");
        $result = 0 if ($@);
        $result;
    }

    ok((
        AreBalanced('()')
    and !AreBalanced(')(')
    and !AreBalanced('())')
    and AreBalanced('(()()())()'),
        ), 'Is the parentheses balance determined?');
}

done_testing();

=encoding UTF-8

=head1 perversions.pl

Collections of short code snippets that implement something in Perl using
rather "unorthodox" approach.

=cut
