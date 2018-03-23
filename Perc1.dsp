import("stdfaust.lib");

freq = hslider("freq",1000,20,20000,1);
gain = hslider("gain",0.5,0,1,0.01);
gate = button("gate");

gen(freq) = hgroup("Generator", osc1, osc2, osc3)
with {
    gain1 = vslider("Gain1",0,-60,12,0.1) : si.smoo : ba.db2linear;
    gain2 = vslider("Gain2",0,-60,12,0.1) : si.smoo : ba.db2linear;
    gain3 = vslider("Gain3",0,-60,12,0.1) : si.smoo : ba.db2linear;

    pitch1 = 2^(vslider("Pitch1",0,-40,40,1) / 12.0);
    pitch2 = 2^(vslider("Pitch2",0,-40,40,1) / 12.0);

    tunning1 = 2^(vslider("Tunning1",0,-100,100,1)/1200.0);
    tunning2 = 2^(vslider("Tunning2",0,-100,100,1)/1200.0);

    osc1 = os.osc(freq * pitch1 * tunning1) * gain1;
    osc2 = os.square(freq * pitch2 * tunning2) * gain2;
    osc3 = no.noise * gain3;
};

env(gate) = hgroup("Envelope", en.ar(att, rel, gate))
with {
    att = hslider("Attack[midi:ctrl 1]",0.01,0,1,0.001);
    rel = hslider("Release[midi:ctrl 2]",0.01,0,1,0.001);
};

filt = hgroup("Filters", _, filt2, filt3)
with{
    filtFreq2 = hslider("filtFreq2",60,0,100,1) : si.smoo : ba.midikey2hz;
    filtFreq3 = hslider("filtFreq3",60,0,100,1) : si.smoo : ba.midikey2hz;
    Q2 = 10^(hslider("Q2",0,-2,2,0.01) : si.smoo);
    Q3 = 10^(hslider("Q3",0,-2,2,0.01) : si.smoo);
    type = nentry("FiltType",0,0,2,1);
    filt2 = ve.moog_vcf(Q2, filtFreq2);
    filt3 = _ <: fi.resonlp(filtFreq3, Q3, 1.0), fi.resonbp(filtFreq3, Q3, 1.0), fi.resonhp(filtFreq3, Q3, 1.0) : ba.selectn(3, type) : _;
};

lfoGain = hslider("LFOGain", -60, -60, 0, 0.1) : si.smoo;
LFO = 1 + os.osc(lfoFreq) * lfoGain;


process =  gen : filt :> _ * LFO <: _, _;
