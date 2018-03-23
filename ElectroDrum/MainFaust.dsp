import("stdfaust.lib");


gen = osc1 * gain1, osc2 * gain2, osc3 * gain3 :> _
with {
    freq = hslider("freq",100,20,20000,0.01) : si.smoo;
    osc1 = os.osc( freq / 2. );
    osc2 = os.sawtooth( freq * 3. / 2. );
    osc3 = os.square( freq );

    gain1 = hslider("GainSine[midi:ctrl 21]",-12,-60,12,0.1) : ba.db2linear;
    gain2 = hslider("GainSaw[midi:ctrl 22]",-12,-60,12,0.1) : ba.db2linear;
    gain3 = hslider("GainSquare[midi:ctrl 23]",-12,-60,12,0.1) : ba.db2linear;
};

fx = _ : _;
master = _ * masterGain
with {
    masterGain = hslider("Master",-12.0,-60,12,0.1) : ba.db2linear;
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


amplitudeTracker = _ : fi.pole(ba.tau2pole(tau)) : _
with {
    tau = hslider("Tau",0.5,0,10,0.1) / 1000. : si.smoo;
};

filtering = fi.peak_eq_cq(-23.0, 95, 0.27) : fi.peak_eq_cq(10.5, 166, 0.64) : fi.low_shelf(2, 890) : fi.high_shelf(-9.5, 2400);


voice(n, note) = vgroup("Voice %n", _ : amplitudeTracker : filtering : gen * _ : distortion : delay : fx : master);

process = tgroup("Voices", par(i, 5, voice(i, 60 + i)));
