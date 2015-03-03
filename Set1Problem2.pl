#Matt Kauper mhk4g@virginia.edu Lab1 Problem2

use RT;

rtsetparams(44100, 2);
load("WAVETABLE");

#My attempt to create an envelope
setline(0,0,0.1,1,1,1,1.2,0);

#Starts the amplitude of the waveform at 501
$ampstart = 501;
$starttime = 0.0

#Each iteration of the loop reduces the amplitude by 100. Iterates 5 times, stopping at 1.
for ($i = 0; $i < 5; $i = $i+1) {
	
	#Creates a table with the proper partials based on which iteration is running
	if (i = 0) {
	makegen(2, 10, 1000, 1, 0);
	} 
	else if (i = 1) {
	makegen(2, 10, 1000, 1, 0, .33, 0);
	}
	else if (i = 2) {
	makegen(2, 10, 1000, 1, 0, .33, 0, .2, 0);
	}
	else if (i = 3) {
	makegen(2, 10, 1000, 1, 0, .5, 0, .2, 0, .14, 0);
	}
	else if (i = 4) {
	makegen(2, 10, 1000, 1, 0, .5, 0, .2, 0, .14, 0, .11, 0);
	}
	
	#plays the sound with the correct parameters
	WAVETABLE($starttime, 3.0, $ampstart, 200);

	#Increases the start time by 3 and reduces the amplitude by 100
	$starttime = $starttime + 3.0;
	$ampstart = $ampstart - 100;
	}