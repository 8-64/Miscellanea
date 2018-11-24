#!/path/to/perl6

use v6;

constant $PBPORT = 80;

sub MAIN (
    Str :$from = 'hosts.csv'
) {
    $from.IO.r or die("Cannot read $from!");

    my (@hosts, %result);

    for $from.IO.lines -> $line {
        $line ~~ /^ ( <-[,;:]>+ ) /;
        $0.defined or next;
        @hosts.push($0);
    }

    my (@tasks, @report);
    for @hosts -> $host {
        push @tasks, start {
            try {
                my $connection = IO::Socket::INET.new(:host("$host"), :port($PBPORT));
                #say $connection.gist;
                #push(@report, 1);
                push(@report, $connection.gist);
                $connection.print('Probing!');
                $connection.close;

                CATCH {
                    default {
                        #say $_.payload;
                        given ($_.payload) {
                            when m:s:i/Failed to resolve/ { %result{$host}<resolved port> = <No No> }
                            when m:s:i/Could not connect/ { %result{$host}<resolved port> = <Yes No> }
                        }
                    }
                }

                %result{$host}<resolved port> = <Yes Yes>;
            }
        }
    }
    await @tasks;

    say 'Host;Resolved?;Has client?';
    for %result.keys -> $host {
        say join(':', $host, %result{$host}<resolved port>);
    }

    say '=' x 80;
    say @report;

}
