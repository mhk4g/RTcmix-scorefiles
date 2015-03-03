#This scorefile, from the RTcmix 4.0 release, uses random to control
# start, frequency and partials. Remember that random() ranges from 0 - 1

use RT;  

rtsetparams(44100, 2);  
load("MIXN");   

#It is unclear to me how I should write the file names given that they will be downloaded
# and placed in whatever directory the user selects.

#Set a default amplitude envelope
setline(0,0, 1, 1, 9,1, 11,0);

$startime=0;
$inskip=0;
$dur=DUR();
$inchan=0;
$global_amp=0.5;
$left_amp=0.5;
$right_amp=0.5;

rtinput("/snd/Public_Sounds/GRITO1.aiff");  

MIXN($startime, $inskip, $dur, $inchan, $global_amp, $left_amp, $right_amp);
$outskip = $outskip + $dur;

for ($start = 0; $start < 7; $start += 0.25) {
	#resets the start time with each iteration of the outer loop
	$startime = 0;
   for ($i = 0; $i < 3; $i += 1) {
      rtinput("/snd/Public_Sounds/GRITO1.aiff");
      MIXN($startime, $inskip, $dur, $inchan, $global_amp, $left_amp, $right_amp);      
      if ($start > 1 && $start < 2 )  {
         rtinput("/snd/Public_Sounds/GRITO1.aiff");
	      MIXN($startime, $inskip, $dur, $inchan, $global_amp, $left_amp, $right_amp);
      }
      $freq += 125; # Effects pitch in the inside loop
   }
}
