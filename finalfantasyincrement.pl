#!/usr/bin/perl

# Here is a perl script to increment the final fantasy # of rom
# add the boss name to the description, and copy em ova fool

#set our directory full of game roms here 
$dirv = '/home/hunter/projects/SNES-SCREENSAVER/gamevids/rpg/';

#set our zsnes directory here - recurses
$dirs = '/home/hunter/.zsnes/';

$bossnum = $ARGV[0];
$bossname = $ARGV[1];

$oldbossnum = $bossnum - 1;


$command1 = "cp " . $dirs . "FinalFantasy2Boss" . $oldbossnum . "*.srm " . $dirs . "FinalFantasy2Boss" . $bossnum . "-" . $bossname . ".srm";

system $command1;

$command2 = "cp " . $dirv . "FinalFantasy2Boss" . $oldbossnum . "*.smc " . $dirv . "FinalFantasy2Boss" . $bossnum . "-" . $bossname . ".smc";

system $command2;