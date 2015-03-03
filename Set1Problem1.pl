#Matt Kauper mhk4g@virginia.edu Lab1 Problem1

use RT; 

rtsetparams(44100, 2); 

load("WAVETABLE");

makegen(1, 7, 1000, 0, 50, 1, 900, 1, 50, 0);
makegen(2, 10, 1000, 1, 0.3, 0.2);

#Establishes a start time and starting frequency for low and high frequency tests
$lowstart = 0.0;
$lowfreq = 2.0;
$highstart = 0.0;
$highfreq = 15000.0;

#Creates a sine wave and an envelope
makegen(2, 10, 1000, 1, 0.3, 0.2);
setline(0,0,0.1,1,1,1,1.2,0);

#Low Frequency Tester that starts at 10 Hz and increments by 1 until it hits 30 Hz
for ($i = 0; $i < 20; $i = $i+1) {
	WAVETABLE($lowstart, 3.0, 500, $lowfreq);
	$lowstart = $lowstart + 3.0;
	$lowfreq = $lowfreq + 1;
	}
	
#High Frequency Tester that starts at 15,000 and increments by 500 until it hits 25000 Hz
for ($i = 0; $i < 20; $i = $i+1) {
	WAVETABLE($highstart, 3.0, 500, $highfreq);
	$highstart = $highstart + 3.0;
	$highfreq = $highfreq + 500;
	}