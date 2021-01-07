import ("stdfaust.lib");

string = vgroup("String", +~(de.fdelay4(maxDelLength, delLength-1) : filter : *(damping)))
  with {
  	freq = hslider("[0]Frequency", 440, 50, 5000, 1);
  	damping = hslider("[1]Feedback", 0.99, 0, 1, 0.01);
    maxDelLength = 960; 								// Since the lowest frequency of our string is 50Hz, the maxDelayLength would be atleast 48000/50 = 960
    filter = _ <: _,_' :> /(2);  						// Divide by 2 to preserve stability in the loop
  	delLength = ma.SR/freq;	
};
pluck = hgroup("[1]Pluck", gate : ba.impulsify*gain)
  with{
  gain = hslider("Gain", 0.5, 0, 1, 0.01);
  gate = button("Gate");
};
process = vgroup("Karplus-Strong", pluck : string);

//Why is it not a polyphonic code??