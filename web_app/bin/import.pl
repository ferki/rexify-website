#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use DBI;
use File::Basename;

my $dsn = "DBI:mysql:database=rexify;host=localhost;port=3306";
my $dbh = DBI->connect($dsn, $ARGV[0], $ARGV[1]);
$dbh->{'mysql_enable_utf8'} = 1;
$dbh->do("SET NAMES utf8");

my @dir = (".");

for my $dir (@dir) {
   opendir(my $dh, $dir) or die($!);
   while(my $entry = readdir($dh)) {
      next if($entry =~ m/^\./);

      if($entry =~ m/\.html$/) {
         import_file("$dir/$entry");
      }

      if(-d "$dir/$entry") {
         push(@dir, "$dir/$entry");
      }
   }
   closedir($dh);
}

sub import_file {
   my ($file) = @_;

   open(my $fh, "<:encoding(UTF-8)", $file) or die($!);
   my @c = <$fh>;
   close($fh);
   chomp @c;

   my $sth = $dbh->prepare("REPLACE INTO `content` (`path`, `title`, `keywords`, `desc`, `content`) VALUES(?, ?, ?, ?, ?)");

   $sth->bind_param(1, substr($file, 2));
   $sth->bind_param(2, '');
   $sth->bind_param(3, '');
   $sth->bind_param(4, '');
   $sth->bind_param(5, join("\n", @c));

   $sth->execute;
}

