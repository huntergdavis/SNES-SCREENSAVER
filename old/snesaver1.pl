#!/usr/bin/perl

#use term:readkey for waiting loop input
use Term::ReadKey;
ReadMode('cbreak');


# open up stdin output from xscreensaver-command and use it
open (IN, "xscreensaver-command -watch |");

$blanked = 0;
$runnin = 1;
while ($runnin == 1){
	$inlin = <IN>;
	if ($inlin == 'BLANK' ) {
		system "xscreensaver-command -deactivate";
		if ($blanked == 0){
			system "./snesaver2.pl ";
		}
		$blanked = 1;		
	}
        # check for waiting input
        if (defined ($char = ReadKey(-1)) ) {
                $blanked = 0;
		system "killall snesaver2.pl";
		system "killall zsnes32";
        }
}

