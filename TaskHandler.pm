#!/usr/bin/env perl
package TaskHandler;
use Exporter;
our @ISA       = qw( Exporter );
our @EXPORT_OK = qw( import_csv read_json_sql execute_sql );
our @EXPORT    = qw( import_csv read_json_sql execute_sql );

use Parse::CSV;
use Text::CSV;
use DBI;
use JSON;
use Data::Dumper qw(Dumper);

sub read_json_sql {
    my $filename = shift;
    my $name     = shift;

    my $json_text = do {
        open( my $json_fh, "<:encoding(UTF-8)", $filename )
          or die("Can't open \$filename\": $!\n");
        local $/;
        <$json_fh>;
    };

    my $json = JSON->new;
    my $data = $json->decode($json_text);

    return $data->{commands}->{$name}{'sql'};
}

sub execute_sql {
    my $DSN      = shift;
    my $SQLquery = shift;
    
    print Dumper $SQLquery;

    my $dbh = DBI->connect( "DBI:ODBC:$DSN", undef, undef )
      or die "$DBI::err+str\n";

    my $sth = $dbh->prepare($SQLquery);
    $dbh->{LongReadLen} = 1024 * 1024;
    $dbh->{LongTruncOk} = 1;

    my $rc = $sth->execute;

    $sth->finish();

    $dbh->disconnect;
    return 0;
}

sub read_csv {
    my $table  = shift;
    my $CSVFile = shift;

    if ( -e $CSVFile ) {
        print "Using existing file:$CSVFile\n";
    }

    # stuff
    my $dbh   = DBI->connect(qq{DBI:CSV:csv_sep_char=,;});
    $dbh->{'csv_tables'}->{$table} = { 'file' => $CSVFile };

    my $query = "SELECT * FROM $table";
    my $sth   = $dbh->prepare($query);
    $sth->execute();
    return $sth;
}

sub import_csv {
    my $CSVFile   = shift;
    my $table     = shift;
    my $SQLquery = shift;

    my $sth = read_csv( $table, $CSVFile );

    my $DSN = "CHaviation";
    print $DSN;
    my $dbh = DBI->connect( "DBI:ODBC:$DSN", undef, undef )
      or die "$DBI::err+str\n";

    $dbh->{LongReadLen} = 1024 * 1024;
    $dbh->{LongTruncOk} = 1;

#while (@row = $sth->fetchrow_array) {  # retrieve one row
#    print join(", ", @row), "\n";
#}
#while($ref = $sth->fetchrow_hashref) {
#print join (", ", keys %$ref), "\n";
#print join (", ", values %$ref), "\n";
#}
#timeout, category, hours, department, comments, firstname, unpaidleave, timein, employeeid, _lastname, type, office
#while (my $row = $sth->fetchrow_array) {
#    print "Found result row: id = ", $row->{employeeid}, ", name = ", $row->{firstname};
#}

    while ( @row = $sth->fetchrow_array ) {
        print $SQLquery;
        my $sth1 = $dbh->prepare(qq($SQLquery));
        my $rc   = $sth1->execute(@row);
    }
    $sth->finish();

    $dbh->disconnect;
    return 0;
}
