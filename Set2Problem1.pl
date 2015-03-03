#wavetable instrument for generating soundwaves


# NOTE: in Perl, # indicates a comment 
# p0=start_time
# p1=duration
# p2=amplitude
# p3=frequency or oct.pc
#  p4=stereo spread (0-1) <optional>
#  function slot 1 is amp envelope, slot 2 is waveform
 
use RT;
rtsetparams(44100, 1);
load("WAVETABLE");
makegen(1, 7, 1000, 0, 50, 1, 900, 1, 50, 0);  #Amplitude envelope
makegen(2, 10, 1000, 1);  #Sine wave with 3 partials. You can try changing these amounts (from 0-1), 
#and or adding additional partials to change the timbre.

$start = 0.0;
$freq = 120.0;  #This is in Cycles per second
$duration = 20;
$amplitude = 5000;

#Incrment the frequency by 25 Herz each time through the loop
for ($a = 0; $a < 20; $a+=2) {
		WAVETABLE($start, $duration, $amplitude, $freq);
		$start += 2;
		$freq *= (1+$a);
		$duration -= 2;
		$amplitude *= 1/(a+2);
		}
 