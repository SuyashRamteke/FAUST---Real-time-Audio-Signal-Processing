import("stdfaust.lib");
freq = hslider("freq", 440, 100, 1000, 0.01);
gain = hslider("gain", 0.5, 0, 1, 0.01);
gate = button("gate") ; //en.adsr(0.01, 0.01, 0.9, 0.1);
//timbre(f) = os.sawtooth(f)*0.5 + os.sawtooth(f*2)*0.25 + os.sawtooth(f*4)*0.125;

dxOsc(ctfreq, a, d, s, r) =  os.osc(ctfreq)*envelope*0.5
with{
  
  //freq = hslider("[0]Center Frequency[style:knob]",440,50,1000,0.1);
  //mod  = hslider("[1]Modulating Frequency[style:knob]",5,0.1,20,0.01);
  //index = hslider("[2]Index", 2, 1, 10, 0.01);
  //t   =   button("Gate");
  envelope = hgroup("Envelope", en.adsr(a,d,s,r))
  with{
		a	= 	hslider("[0]Attack	[style:knob]",	0.01, 0.01, 1, 0.01) : si.smoo;
		d	= 	hslider("[1]Decay 	[style:knob]",	0.1, 0.01, 1, 0.01) : si.smoo;
		s 	= 	hslider("[2]Sustain	[style:knob]",	0.5, 0, 1, 0.01) : si.smoo;
		r 	= 	hslider("[3]Release	[style:knob]",	0.5, 0.01, 1, 0.01) : si.smoo;
		
  };
};

simplepatch = dxOsc(freq, 0.01, 0.01, 1, 0.01) : dxOsc(freq, 0.01, 0.01, 1, 0.01) ;

peakfilters(n) = hgroup("PeakFIlters",  seq(i,n,Filters(i)))
with{
 Filters(j) = vgroup("Bank %j", fi.peak_eq(Lfx, Fx, B))
  with{
	//freq = hslider("[1]freq",440,50,2000,0.01);
	ctFreq = hslider("[0]Center Frequency[style:knob]",441,50,1000,0.1);
  	lfoFreq = hslider("[1]LFO Frequency[style:knob]",5,0.1,20,0.01);
    B = hslider("[2]LFO Depth[style:knob]",500*(j+1),1,10000,1);
    //ResFreq = os.osc(lfoFreq)*lfoDepth + ctFreq : max(30);
	//B = Fx/hslider("[1]Q[style:knob]",5,1,30,0.1);
	Fx = os.osc(lfoFreq)*B + ctFreq ;
	Lfx = hslider("[3]Gain(dB)[style : knob]", 0, -20, 20, 0.1);
  };
};

envelope = hgroup("Env", en.adsr(a,d,s,r))
  with{
		a	= 	hslider("[0]Attack	[style:knob]",	0.01, 0.01, 1, 0.01) : si.smoo;
		d	= 	hslider("[1]Decay 	[style:knob]",	0.1, 0.01, 1, 0.01) : si.smoo;
		s 	= 	hslider("[2]Sustain	[style:knob]",	0.5, 0, 1, 0.01) : si.smoo;
		r 	= 	hslider("[3]Release	[style:knob]",	0.5, 0.01, 1, 0.01) : si.smoo;
		
  };
};

process = gain*gate : simplepatch : peakfilters(2) ;
//effect = dm.zita_light;
			