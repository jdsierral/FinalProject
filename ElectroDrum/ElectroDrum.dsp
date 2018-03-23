import("stdfaust.lib");

delay = hslider("delay",10,1,1000,0.1) / 1000. : si.smoo;
delLine = de.delay( ma.np2(ba.sec2samp(1.)), delay );

dm.parametric_eq_demo()

process = voice;
