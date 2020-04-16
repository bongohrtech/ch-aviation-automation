#!/usr/bin/env perl
package TaskHandler;
use Exporter;
our @ISA= qw( Exporter );
our @EXPORT_OK = qw( import_csv volume);
our @EXPORT = qw( import_csv volume );

use  Parse::CSV;
use  Text::CSV;
use DBI;

sub read_csv{
    my $param1 = shift;
    my $CSVFile = shift;

    if (-e $CSVFile){
       print "Using existing database:$CSVFile\n";
    }
      # stuff
    my $table = $param1;
    my $dbh = DBI->connect(qq{DBI:CSV:csv_sep_char=,;});
        $dbh->{'csv_tables'}->{$table} = { 'file' => $CSVFile};

     my $query = "SELECT * FROM $table";
     my $sth   = $dbh->prepare ($query);
     $sth->execute ();
     return $sth;
}

sub import_csv {
  my $param1 = shift;
  my $CSVFile = shift;
  my $DBFile = shift;
  my $table = shift;
  my $SQLScript = shift;


  if (-e $SQLScript){
     print "Using existing script:$SQLScript\n";

     open($fh, $SQLScript) or die "File '$SQLScript' can't be opened";
     # Reading First line from the file
     $SQLquery = <$fh>;
     close($fh)
         or warn "Unable to close the file handle: $!";
  }
  my $sth = read_csv($param1, $CSVFile, $table);

   my $DSN = "CHaviation";
   print $DSN;
   my $dbh = DBI->connect("DBI:ODBC:$DSN", undef,undef) or die "$DBI::err+str\n";


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

   while (@row = $sth->fetchrow_array) {
       print $SQLquery;
       my $sth1 = $dbh->prepare(qq($SQLquery));
       my $rc = $sth1->execute(@row);
       }
   $sth->finish ();

   $dbh->disconnect;
   return 0;
}
