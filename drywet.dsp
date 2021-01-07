import("stdfaust.lib");

echo(d,f) = + ~ (@(d) : *(f));
drywet(fx) = _ <: _, fx : *(1-w), *(w) :> _ 
  with {
  		w = vslider("dry-wet[style : knob]", 0.5, 0, 1, 0.01);
	};

process = button("Play") : pm.djembe(60, 0.3, 0.4, 1) : drywet(echo(44000/4, 0.75));
