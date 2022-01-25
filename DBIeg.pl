# Author:  <wblake@CB95043>
# Created: Dec 7, 2021
# Version: 0.01

use strict;
use diagnostics;
use Getopt::Std;
use DBI;
use DBD::Oracle;
use Time::HiRes qw( gettimeofday tv_interval);;
#use Data::Dumper;
use say;


#t tnsname u User p Password q SQL statement
our ($opt_t,$opt_u,$opt_p,$opt_q);
getopts('t:u:p:q:');


my $usage = "$0 -t tnsname -u user -p password -q sql";

#Test connection via sqlplus command line
#sqlplus user/pass@tnsname

my $local_filename=$0;
 $local_filename =~ s/.+\\([A-z]+.pl)/$1/;
    
    # Check for user and password
if (!defined $opt_t || !defined $opt_u || !defined $opt_p) {
    die ("[$local_filename" . ":" . __LINE__ . "]Usage: " . $usage);
}
         

#Oracle instaclient environment

my $ORACLE_HOME = qw(C:\oracle\instantclient_19_12);
my $TNS_ADMIN = qw(C:\oracle\instantclient_19_12\network\admin);

my $tnsname = $opt_t ;

#Oracle connection
 my $dbh=DBI->connect( "dbi:Oracle:$tnsname", $opt_u,$opt_p) || die($DBI::errstr . "\n");
 
 # Variables to reduce potential damage
 
  $dbh->{AutoCommit}    = 0;
  $dbh->{RaiseError}    = 1;
  $dbh->{ora_check_sql} = 0;
  $dbh->{RowCacheSize}  = 16;
 
 # Variables for query and results
 
 my $sql;
 my $sth;
# my @data;
 
 #$sql =
 # "SELECT * ".
 # "FROM BTY_V2";

$sql = $opt_q;

if (!($sth = $dbh->prepare ($sql)))
{
  die ("[$local_filename" . ":" . __LINE__ . "]Failed to prepare statement: " . DBI->errstr);
};

#time the operation length in seconds
my $t0 = [gettimeofday];

$sth->execute;

#while (@data = $sth->fetchrow_array())
#{
  #my $INSTBIT = $data[0];
  #my $BST = $data[1];
  #my $DESCRIPTION = $data[2];
#  printf ([]"%-20s %-20s %3d\n",$INSTBIT,$BST,$DESCRIPTION);
 #say ("[$local_filename" . ":" . __LINE__ . "]INSTBIT $INSTBIT BST $BST DESCRIPTION $DESCRIPTION");
# 
#}
#my $array_ref = $sth->fetchall_arrayref();
#foreach my $row ($array_ref)
#{
# 
# print Dumper($row);
#}

my $rows = $sth->dump_results();


my $elapsed = tv_interval ($t0) ;

say ("[$local_filename" . ":" . __LINE__ . "]DBI Call lapsed time $elapsed.");

$sth->finish;

$dbh->disconnect;