import("stdfaust.lib");

filterSet = hgroup("FilterSet", HPSection : ParametricSection : LPSection)
with {
    HPSection = vgroup("[-1]HighPass", fi.highpass(hpfOrder, hpfFreq)
    with {
        hpfOrder = 2;
        hpfFreq = vslider("hpfreq[style:knob][unit:PK]", 1, 1, 88, 0.01) : si.smoo : ba.pianokey2hz;
    });
    LPSection = vgroup("[9]LowPass", fi.lowpass(lpfOrder, lpfFreq)
    with {
        lpfOrder = 2;
        lpfFreq = vslider("lpfreq[style:knob][unit:PK]", 88, 1, 88, 0.01) : si.smoo : ba.pianokey2hz;
    });
    ParametricSection = seq(i, 8, vgroup("[%i] filter %i", fi.peak_eq_cq(gain, freq, q)
            with {
                gain = vslider("gain %i[style:knob]",0,-12,12,0.1) : si.smoo;
                freq = vslider("freq %i[style:knob][unit:PK]", 44, 1, 88, 0.01) : si.smoo : ba.pianokey2hz;
                q = vslider("q %i[style:knob]",1,0.01,100,0.01) : si.smoo;
            }
        )
    );
};

distortion = hgroup("[011]Distortion", ef.cubicnl(drive, offset) : fi.dcblocker
with {
    drive = hslider("drive",0,0,1,0.01) : si.smoo;
    offset = hslider("offset",0,0,1,0.01) : si.smoo;
});

delay = hgroup("[012]Delay", de.delay(maxDelayLen, delLen)
with {
    maxDelayLen = ba.sec2samp(1);
    delLen = hslider("delLenInMs",0,0,40,1) / 1000.0 : ba.sec2samp : (int);
});

process = _ : filterSet : distortion : delay : _;
