#!/usr/bin/env perl

use YAML::XS 'LoadFile';
use feature 'say';
use 5.010;

use lib './';
use TaskHandler;

my $config = LoadFile('config_win.yaml');

for (@{$config->{steps}})  { task }

my $steps = $config->{steps};

for (@{$config->{steps}}) {
  for ($_->{task}) {
    print $_->{inputs}->{type},"\n";
    #system("$script $param1");

    if($_->{inputs}->{type} eq 'transform'){
      my $param1 = $_->{inputs}->{type};
      my $script = $_->{inputs}->{script};
      system("$script $param1");
    }elsif($_->{inputs}->{type} eq 'import'){
      my $param1 = $_->{inputs}->{type};
      my $param2 = $_->{inputs}->{file};
      my $param3 = $_->{inputs}->{dbfile};
      my $param4 = $_->{inputs}->{table};
      my $param5 = $_->{inputs}->{import};
      my $script = $_->{inputs}->{script};
      import_csv($param1, $param2, $param3, $param4, $param5);
    }elsif($_->{inputs}->{type} eq 'execute'){
      my $param1 = $_->{inputs}->{type};
      my $param2 = $_->{inputs}->{dbfile};
      my $param3 = $_->{inputs}->{sql};
      my $script = $_->{inputs}->{script};
      system("$script $param1 $param2 $param3");
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
