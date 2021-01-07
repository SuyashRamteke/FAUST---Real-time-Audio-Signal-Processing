import("stdfaust.lib");
string(i) = hgroup("String[0]",+~(de.fdelay4(maxDelLength,delLength-1) : dispersionFilter : *(damping)))
with{
  index = i+1;
  freq = vslider("[0]freq%index",16*9*index ,50,5000,1) : si.smoo;
  damping = hslider("[1]Damping[style:knob]",0.99,0,1,0.01);
  maxDelLength = 1024;
  dispersionFilter = _ <: _,_' :> /(2);
  delLength = ma.SR/freq*2;
};


nStrings = 7;

pluck(index, n) = hgroup("[1]Pluck",gate : ba.impulsify*gain)
with{
  gain = hslider("gain[style:knob]",1,0,1,0.01);
  gate = n == index;
};

// harp = par(i,nStrings,(gate : string)) :> _;
strum = vslider("strum",0,0,nStrings,1) <: par(i, nStrings, (pluck(i,_) : string(i))) :> _;

process = hgroup("Harp", strum);