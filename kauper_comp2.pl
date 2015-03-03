# Matt Kauper
# MUSI4540 
# 2/5/2015
# Kauper_composition2.pl

use RT;

rtsetparams(44100, 2);
load("MIXN");

# Output disabled
# set_option("clobber_on","audio_off");
# rtoutput("Kauper_Composition_2" , "aiff");

#Import the whack sound effect
rtinput("/snd/Public_Sounds/shaker.aiff");

#Global variables
$dur = DUR();
$start = 0;
$inskip = 0;
$amp=.5;
$loop = 0;

#Variables for manipulation of time
$tempoincr = 0.15;
$measure = $tempoincr * 12;
$length = $measure * 13;

#Amplitude envelope
setline(0,0, 1, 1, 9,1, 11,0);

#Creates identical arrays of size 12 representing the original score in 8th notes
@array1 = (1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0);
@array2 = (1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0);

#The clapping rhythm starts and stops in a synchronized position, resulting in 13 total iterations
for ($i = 0; $i < 13; $i++) {
	
	#variable to identify which loop you are in
	$loop++;
	
	#sets the start time as a function of i, the loop control variable, and the length of 12 notes
	$start = $i * $measure;

	#Prints a visual representation of each array
	print "\n\nStep " . $loop . ":\n";
	print @array1;
	print "\n";
	
	#Iterates over each array in 12 steps, one step for each 8th note
	for ($n = 0; $n < 12; $n++) {

		print @array2[($n + $i) % 12];
		
		# Array 1, which remains constant throughout
		if (@array1[$n]) {
			MIXN($start + ($n * $tempoincr), $inskip, $dur, 0, $amp, 0, .7);
			}
		
		# Array 2, which changes by one step each iteration
		if (@array2[($n + $i) % 12]) {
			MIXN($start + ($n * $tempoincr), $inskip, $dur, 0, $amp, .7, 0);
			}
	}
	
}	
