
use RT;
rtsetparams(44100, 2);
load("FILTSWEEP");
load("REVERBIT");

# Output disabled
# set_option("clobber_on","audio_off");
# rtoutput(FiltSweepTest.aif);

#Configures duration of background drone
rtinput("./ah1min.aiff");
$dur = DUR();

#Global parameters
$inskip =0;
$amp=0.6;

#Parameters for the filter sweep instrument
$lowcf = 100;   
$highcf = 1000;
$startbw = 5;  #-.05
$stopbw = 25;
$balance = 0;
$sharpness = 1;
$ringdur =2;

#Parameters for the reverb instrument
$rvbtime = 6;
$rvbamt = 1;
$rtchandelay = .03;
$cutoff = 2000;  #LPF frequency

#Parameters for loops
$int1 = 4;
$int2 = 8;
$whackamp = 0.1;
$bellamp = 0.1;
$tempoincr = 0.15;

#Strings to store the file names
$myshaker = "/snd/Public_Sounds/shaker.aiff";
$mysnare = "/snd/Public_Sounds/ouchsnar.aiff";
$mykick = "./mykick.aiff";

#Amplitude envelope
setline(0,0, 2,1,10,1,12,0 );

#Automates the frequency envelope of the filter sweep instrument
makegen(2,18,2000, 0, $lowcf, $dur/4, $lowcf, $dur, $highcf);
makegen(3,18,2000, 0, $startbw, $dur, $stopbw);

#Plays the drone, slowly opening up the filter frequency over the course of the song
FILTSWEEP($start=0, $inskip, $dur, $amp, $ringdur, $sharpness, $balance, 0,0.5);

#Configures duration of whack sound
rtinput("/snd/Public_Sounds/whackshort.aiff");
$whackdur = DUR();

#Configures duration of tibetan bell sound
rtinput("/snd/Public_Sounds/tibetan.aiff");
$belldur = DUR();

#This outer loop says "Start at 5 seconds and continue until 60 seconds"
for ($i = 5; $i < 60; $i++) {

	#This says "If the number of seconds since the start of the song is evenly divisible by
	#the number 4 (stored in variable above), then play this sound. 
	if ( ($i > 0 ) && ( $i % $int1 == 0) ) {
	rtinput("/snd/Public_Sounds/whackshort.aiff");
	REVERBIT(0 + $i, $inskip, $whackdur, $whackamp, $rvbtime, $rvbamt, $rtchandelay, $cutoff);
	$whackamp += .03;
	}
	
	#This says "If the number of seconds since the start of the song is evenly divisible by
	#the number 8 (stored in variable above), then play this sound. 
	if ( ($i > 0 ) && ( $i % $int2 == 0) ) {
	rtinput("/snd/Public_Sounds/tibetan.aiff");
	REVERBIT(0 + $i, $inskip, $belldur, $bellamp, $rvbtime, $rvbamt, $rtchandelay, $cutoff);
	$bellamp += .05;
	}

	#The reverb time and amount applied to thse sounds slowly diminishes as time passes
	$rvbtime-= .1;
	$rvbamt -= .015
	
}

#Creates arrays for the various parts
@kickArray = ();
@snareArray = ();
@shakeArray = ();

#Stores the information for the shaker in an array of size 24 as a kind of step sequencer
rtinput($myshaker);
$shakedur = DUR();

#Adds shaker hits to the array on the first, second, and third of every four 16th notes.
for ($b = 1; $b < 25; $b++) {
		if ($b % 4 == 0) {
		@shakeArray[$b] = 0;
		}
		else {
		@shakeArray[$b] = 1;
		}
}


#Stores the information for the snare in an array of size 24 as a kind of step sequencer
rtinput($mysnare);
$snaredur = DUR();

#Fills the array with zeroes and adds a snare hit only on the 5th, 13th, and 21st 16th notes.
for ($s = 1; $s < 25; $s++) {
	@snareArray[$s] = 0;
}
@snareArray[5] = 1;
@snareArray[13] = 1;
@snareArray[21] = 1;


#Stores the information for the kick in an array of size 24 as a kind of step sequencer
rtinput($mykick);
$kickdur = DUR();

#Initially fills the array with zeroes to populate it
for ($i = 1; $i < 25; $i++) {
	@kickArray[$i] = 0;
}

#Changes the first and every third 16th notes to a kick
for ($i = 1; $i < 25; $i+=3) {
		@kickArray[$i] = 1;
}

#Resetting parameters for the reverb instrument so that the drums are unaffected by the
#previous instrument's changing reverb parameters
$rvbtime = 1;
$rvbamt = .5;
$rtchandelay = .03;
$cutoff = 2000;  #LPF frequency

#Individual amps for each drum sound
$shakeamp = .00001;
$kickamp = 0.001;
$snareamp = 0.001;

#Starts the drums at 24 seconds into the composition, replays them at intervals equal to the number of 
#entries in each array (24) times the tempo increment variable to enable seamless looping until the
#loop variable exceeds 61 seconds.
for ($m = 24; $m < 61; $m = $m + (24*$tempoincr)) {
	
	#Iterates over each array in 24 steps. Perl does not allow boolean variables but you can
	#evaluate integers as if they were booleans. This loop goes through the arrays and if there is 
	#a "1" at the current array index, it plays the appropriate sound.
	for ($n = 1; $n < 25; $n++) {
	
		#The shaker instrument gets some volume variation via a randomized amp argument
		if (@shakeArray[$n]) {
			$shakerand = rand(.0001);
			rtinput($myshaker);
			REVERBIT($m + $n * $tempoincr, $inskip, $shakedur, $shakeamp - ($shakerand/10), $rvbtime, $rvbamt, $rtchandelay, $cutoff);
			}
		
		#The snare array
		if (@snareArray[$n]) {
			rtinput($mysnare);
			REVERBIT($m + ($n * $tempoincr), $inskip, $snaredur, $snareamp, $rvbtime, $rvbamt, $rtchandelay, $cutoff);
		}
	
		#The kick array
		if (@kickArray[$n]) {
			rtinput($mykick);
			REVERBIT($m + $n * $tempoincr, $inskip, $kickdur, $kickamp, $rvbtime, $rvbamt, $rtchandelay, $cutoff);
		}
		
		#Increments each instrument up to varying degrees so that they become louder as time passes
		$shakeamp += .00001;
		$kickamp += 0.0025;
		$snareamp += 0.0004;
		
	}
}	

#Prints the shaker array for visual reference
print "\nShaker array: \n";
print @shakeArray;
print "\n\n";

print "Snare array: \n";
print @snareArray;
print "\n\n";

#Prints the kick array for reference
print "Kick array: \n";
print @kickArray;
print "\n\n";
