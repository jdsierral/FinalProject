import("stdfaust.lib");

freq = hslider("freq",440,20,20000,1) : si.smoo;
gain = hslider("gain",0.5,0,1,0.01) : si.smoo;
gate = button("gate") : si.smoo;

process =   os.osc(freq) * gain * gate,
            os.triangle(freq) * gain * gate,
            os.square(freq) * gain * gate,
            os.sawtooth(freq) * gain * gate;
