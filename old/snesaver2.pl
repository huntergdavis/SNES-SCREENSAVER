#!/usr/bin/perl

# use file find for recursive searching
use File::Find;

#global storage for gamevids list
my @gamevids=();

$debugmode = 1;

# our Wanted function should push files only into gamevids
sub Wanted
{
        # gotta be a file
        push(@gamevids,$_) if (-f "$_");

        if($debugmode > 0)
        {
                print $_ , "\n" if (-f "$_"); # print all files found
        }
}

# First, get all our saved game sessions
$dir = './gamevids/';
$File::Find::no_chdir = 1;
find( { wanted => \&Wanted, no_chdir => 1} , $dir);

# how many sessions do we have
$numvids = @gamevids;
if ($debugmode == 1){
        print "$numvids", "\n";
}

# verbose output
if ($debugmode == 1){
        print 'Running';        # Let us know we're running
}

# our processing kernel
$random_num = int(rand($numvids));
$cmdline = "zsnes32 -dd -k 1 -r 0 -z -m -mc -v 14 -zm 0 " . @gamevids[$random_num];
system $cmdline;	 
if($debugmode == 1){
	print "\n", $cmdline, "\n";
}       



