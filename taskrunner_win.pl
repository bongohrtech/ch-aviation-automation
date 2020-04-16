#!/usr/bin/env perl

use YAML::XS 'LoadFile';
use feature 'say';
use 5.010;

use lib './';
use TaskHandler;

my $config = LoadFile('config_win.yaml');

my $SQL_JSON = $config->{sqlfile};
#print $SQL_JSON,"\n";
my $DSN = $config->{DSN};
#print $DSN,"\n";

for (@{$config->{steps}})  { task }

my $steps = $config->{steps};

for (@{$config->{steps}}) {
  for ($_->{task}) {
    print $_->{inputs}->{type},"\n";
    #system("$script $param1");

    if($_->{inputs}->{type} eq 'transform'){
      my $param1 = $_->{inputs}->{type};
      my $script = $_->{inputs}->{script};
      #system("$script $param1");
    }elsif($_->{inputs}->{type} eq 'import'){
      my $param1 = $_->{inputs}->{type};
      my $csvfile = $_->{inputs}->{file};
      my $table = $_->{inputs}->{table};
      my $sql = $_->{inputs}->{sql};
      
      print $sql,"\n","\n";

      my $sql = read_json_sql($SQL_JSON, $sql);
      print $sql,"\n","\n";

      print $csvfile, $table, $sql,"\n";
      import_csv($csvfile, $table, $sql);
    }elsif($_->{inputs}->{type} eq 'execute'){
      my $param1 = $_->{inputs}->{type};
      my $param2 = $_->{inputs}->{dbfile};
      my $param3 = $_->{inputs}->{sql};
      my $script = $_->{inputs}->{script};
      my $sql = read_json_sql($SQL_JSON, $param3);
      print $sql,"\n","\n";
      execute_sql($DSN, $sql)
    }
  }
}



#print $steps->[0]->{task},"\n";

# access the scalar emailName
my $emailName = $config->{emailName};

# access the array emailAddresses directly
my $firstEmailAddress = $config->{emailAddresses}->[0];
my $secondEmailAddress= $config->{emailAddresses}->[1];

# loop through and print emailAddresses
for (@{$config->{emailAddresses}}) { say }

# access the credentials hash key values directly
my $username = $config->{credentials}->{username};
my $password = $config->{credentials}->{password};

# loop through and print credentials
for (keys %{$config->{credentials}}) {
    say "$_: $config->{credentials}->{$_}";
}
