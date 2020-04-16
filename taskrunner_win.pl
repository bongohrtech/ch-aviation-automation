#!/usr/bin/env perl
use Data::Dumper qw(Dumper);

use YAML::XS 'LoadFile';
use feature 'say';
use 5.010;
use lib './';
use TaskHandler;
binmode STDOUT, ":utf8";

my $config = LoadFile('config_win.yaml');

my $SQL_JSON = $config->{sqlfile};

my $DSN = $config->{DSN};
my $month = $config->{month};

my $steps = $config->{steps};

for ( @{ $config->{steps} } ) {
    print "Loop\n";
    print $_->{step}[0]{details}{'name'};

    my $disabled = (!exists( $_->{step}[0]{details}{enabled} )
        || $_->{step}[0]{details}{enabled} eq "false");

    my $wrongmonth = (exists( $_->{step}[0]{details}{dependancy} )
        && $_->{step}[0]{details}{dependancy} ne $month);
    if (  $disabled || $wrongmonth )
    {
        print ".... SKIPPING\n";
    }
    else {
        my $start = time;

        print ".... Running\n";
        $item = $_;
        foreach $item ( @{ $_->{step} } ) {

            $item = $item->{task};
            print $item->{inputs}->{type}, "\n";

            if ( $item->{inputs}->{type} eq 'transform' ) {
                my $param1 = $item->{inputs}->{type};
                my $script = $item->{inputs}->{script};

            }
            elsif ( $item->{inputs}->{type} eq 'import' ) {
                my $param1  = $item->{inputs}->{type};
                my $csvfile = $item->{inputs}->{file};
                my $table   = $item->{inputs}->{table};
                my $sql     = $item->{inputs}->{sql};

                print $sql, "\n", "\n";

                my $sql = read_json_sql( $SQL_JSON, $sql );
                print $sql, "\n", "\n";

                print $csvfile, $table, $sql, "\n";

                import_csv( $csvfile, $table, $sql );
            }
            elsif ( $item->{inputs}->{type} eq 'execute' ) {
                my $name   = $item->{inputs}->{name};
                my $script = $item->{inputs}->{sql};
                my $sql    = read_json_sql( $SQL_JSON, $script );
                print "Running ", $name, "\n", "\n";
                print "****************", "\n";
                binmode STDOUT, ":utf8";

                print "SQL: ", $sql, "\n", "\n";
                execute_sql( $DSN, $sql );
            }
        }

        print "------------\n";
        my $duration = time - $start;
        print "Execution time: $duration s\n";

        print "Finished\n";
        print "------------\n";
    }
    print "End Loop\n";

}
