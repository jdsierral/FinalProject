import("stdfaust.lib");

gain = hslider("gain",0.1,0,1,0.01) : si.smoo;

process = _ * gain : _ ;
