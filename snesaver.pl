#!/usr/bin/perl


# snesaver.pl - perl xscreensaver script for running zsnes movies
#               Author:      Hunter Davis, www.hunterdavis.com 2008
#               License:     GPLV3 - see licence.txt or google gplv3
#               Function:    For each rom, it is assumed a saved zsnes video state resides in state 0
#                            Loads zsnes fullscreen to play each state as as screensaver 
#		Assumptions: 1.  zsnes is executed fullscreen with custom resolution 22, otherwise $cmdline will need to be changed
#			     2.  for each rom in your rompath, there is a saved zsnes session at slot 0, otherwise change $cmdline
#			     3.  you've added snesaver.pl to your path, and to the programs section of your ~/.xscreensaver file
#			     4.  you don't mind hitting escape, sometimes twice or with wiggling mouse to exit your screensaver
#			     5.  you've installed zsnes32 (for those of us running amd64bit), otherwise change references to zsnes
#


# used for our recursive game video directory search
use File::Find;

# executable to call
# amd64 = zsnes32
# generic = zsnes
$zsnesex = "zsnes32";

#set our directory full of game roms here - recurses
$dir = '/home/hunter/projects/SNES-SCREENSAVER/gamevids/';

#global storage for gamevids list
my @gamevids=();

# verbose output
$debugmode = 0;

# our Wanted function should push files only into gamevids
# used by file::find, adds each game roms absolute path to the gamevids array
sub Wanted
{
        # gotta be a file
        push(@gamevids,$_) if (-f "$_");

        if($debugmode > 0)
        {
                print $_ , "\n" if (-f "$_"); # print all files found
        }
}


# our terminate signal handler - signal 15 TERM
# xscreensaver sends a running screensaver process the TERM signal
# unfortunately, mouse initialization in zsnes causes xscreensaver to TERM
# this TERM signal handler ignores this first TERM and allows zsnes to continue
# until an actual TERM command is received, at which time zsnes32 is killed, script exits
# unfortunately, this is also why you must hit escape to quit

$terms = 0;
sub termHandler {
	$terms = $terms + 1;
	local($sig) = @_;
	if($debugmode == 1)
	{
	    print "signal: " . $sig . " \n";
	}
	if($terms > 1){
		system "killall " . $zsnesex; #better way?
		$ENV{SNESAVER} = 0;
		exit(0);
	}
}
$SIG{TERM} = \&termHandler;



# Get all our saved game sessions
$File::Find::no_chdir = 1;
find( { wanted => \&Wanted, no_chdir => 1} , $dir);


# how many sessions do we have?
$numvids = @gamevids;
if ($debugmode == 1){
        print "$numvids", "\n";
}



# when this script spawns a zsnes session, the environment var SNESAVER
# is set.  If a xscreensaver process attempts to re-activate xscreensaver
# and this var is active, no process is spawned
system "xscreensaver-command -deactivate";
$instanced = $ENV{SNESAVER};
if($instanced == 0)
{
		# our processing kernel

		# kill any floating zsnes sessions
		system "killall " . $zsnesex;

		# generate our command line with a random game session
		$random_num = int(rand($numvids));
		$cmdline = $zsnesex . " -dd -k 1 -r 0 -z -m -mc -v 22 -zm 0 " . @gamevids[$random_num] . "   ";

		# execute/wait for command line, and wrap in env variable defs
		$ENV{SNESAVER} = 1;
		system $cmdline;
		$ENV{SNESAVER} = 0;

		# start the whole thing over again
		# without which screensaver not guaranteed to be on
		system "xscreensaver-command -activate";
		
		# let us know our command line if verbose output
		if($debugmode == 1){
		        print "\n", $cmdline, "\n";
		}
}
