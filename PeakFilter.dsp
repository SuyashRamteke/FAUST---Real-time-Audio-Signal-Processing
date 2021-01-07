import("stdfaust.lib");
waveGenerator = hgroup("[0]Wave Generator",no.noise,os.triangle(freq),os.square(freq),os.sawtooth(freq) : ba.selectn(4,wave))
with{
  wave = nentry("[0]Waveform",3,0,3,1);
  freq = hslider("[1]freq",440,50,2000,0.01);
};


peakfilters(n) = seq(i,n,Filters(i))
with{
  Filters(j) = vgroup("Bank %j", fi.peak_eq(Lfx, Fx, B))
  with{
	//freq = hslider("[1]freq",440,50,2000,0.01);
	ctFreq = hslider("[0]Center Frequency[style:knob]",441,50,1000,0.1);
  	lfoFreq = hslider("[2]LFO Frequency[style:knob]",5,0.1,20,0.01);
    B = hslider("[3]LFO Depth[style:knob]",500*(j+1),1,10000,1);
    //ResFreq = os.osc(lfoFreq)*lfoDepth + ctFreq : max(30);
	//B = Fx/hslider("[1]Q[style:knob]",5,1,30,0.1);
	Fx = os.osc(lfoFreq)*B + ctFreq ;
	Lfx = hslider("[0]Gain(dB)[style : knob]", 0, -20, 20, 0.1);
  };
};

subtractive = waveGenerator : hgroup("[1]Filter", peakfilters(2));
envelope = hgroup("[2]Envelope",en.adsr(attack,decay,sustain,release,gate)*gain*0.7)
with{
  attack = hslider("[0]Attack[style:knob]",50,1,1000,1)*0.001;
  decay = hslider("[1]Decay[style:knob]",50,1,1000,1)*0.001;
  sustain = hslider("[2]Sustain[style:knob]",0.8,0.01,1,1);
  release = hslider("[3]Release[style:knob]",50,1,1000,1)*0.001;
  gain = hslider("[4]gain[style:knob]",1,0,1,0.01);
  gate = button("[5]gate");
};

process = vgroup("Subtractive Synthesizer",subtractive*envelope) ;
//effect = dm.zita_light;
//process = subtractive;