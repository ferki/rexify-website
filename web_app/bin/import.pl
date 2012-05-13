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

   my $s = join("\n", @c);
   my ($title) = ($s =~ m/<title>([^<]+)<\/title>/ims);

   print "$file > $title\n";

   my ($keywords) = ($s =~ m/name="keywords" content="([^"]+)"/);
   my ($desc) = ($s =~ m/name="description" content="([^"]+)"/);
   my ($page) = ($s =~ m/<div id="page">(.*?)<!\-\-\{\$page_footer\}\-\->/msi);
   $page =~ s/<\/div>\s*$//;

   $page =~ s/href=\"([^"]+)\"/fix_link($file, $1)/egmsi;

   my $sth = $dbh->prepare("REPLACE INTO `content` (`path`, `title`, `keywords`, `desc`, `content`) VALUES(?, ?, ?, ?, ?)");

   $title    ||= '';
   $keywords ||= '';
   $desc     ||= '';
   $page     ||= '';

   $sth->bind_param(1, "/".substr($file, 2));
   $sth->bind_param(2, $title);
   $sth->bind_param(3, $keywords);
   $sth->bind_param(4, $desc);
   $sth->bind_param(5, $page);

   $sth->execute;
}

sub fix_link {
   my ($file, $link) = @_;
   print "FIX LINK ($file -> $link)\n";



   if($link !~ m/^\// && $link !~ m/^http/) {
      my $dir = dirname($file);
      $dir =~ s/^\.\//\//;

      return 'href="' . "$dir/$link" . '"';
   }

   return 'href="' . $link . '"';
}

