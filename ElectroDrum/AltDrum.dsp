import("stdfaust.lib");


gen = hgroup("gen", osc1 * gain1, osc2 * gain2, osc3 * gain3 :> _) with {
        osc1 = os.osc(freq / 2.0);
        osc2 = os.sawtooth(freq);
        osc3 = os.triangle(freq * 3./2.);

        freq = hslider("note",50,0,88,1) : ba.midikey2hz;
        gain1 = hslider("gain1",0,-60,0,0.1) : ba.db2linear;
        gain2 = hslider("gain2",0,-60,0,0.1) : ba.db2linear;
        gain3 = hslider("gain3",0,-60,0,0.1) : ba.db2linear;
};


amplitudeTracker = abs : fi.pole(pole) : _ with {
    pole = hslider("[1]tau",0.5,0,100,0.1) / 1000. : ba.tau2pole;
};

pkHolder = ba.peakholder(length) with {
    length = hslider("length",100,1,1000,1) / 1000 : ba.sec2samp;
}

en.adsr(attack, decay, sustain, release) with {
    attack =
    deca =
    sustain =
    release = 
}

voice = _ : filtering : filterSet : amplitudeTracker : pkHolder : gen(i) * _
