import("stdfaust.lib");



voice(i) = _ : filtering : filterSet : amplitudeTracker : gen(i) * _ : delay(delLen) : _ with {
    gen(i) = hgroup("[0]generator", osc1 * g1, osc2 * g2, osc3 * g3 :> _) with {

        osc1 = os.osc(freq / 2);
        osc2 = os.osc(freq);
        osc3 = os.triangle(freq * 3. / 2.);

        g1 = vslider("gain1[midi:ctrl 21][style:knob]",0.5,0,1,0.01) : si.smooth(ba.tau2pole( 100 / 1000. ));
        g2 = vslider("gain2[midi:ctrl 22][style:knob]",0.5,0,1,0.01) : si.smooth(ba.tau2pole( 100 / 1000. )) * 0.5;
        g3 = vslider("gain3[midi:ctrl 23][style:knob]",0.5,0,1,0.01) : si.smooth(ba.tau2pole( 100 / 1000. ));

        freq = vslider("note[style:knob]",50,0,88,1) : ba.midikey2hz;
    };

    delLen = hslider("[2]delay",0,0,1000,0.1);
    delay(len) = de.sdelay(maxDelayLen, 1024, len) with {
        maxDelayLen = ba.sec2samp(1);
    };
    amplitudeTracker = _ * 0.1 : abs : min(_,  0.5) : fi.pole(pole) : _ with {
        pole = hslider("[3]tau",50,0,100,0.1) / 1000. : si.smooth(ba.tau2pole(0.1)) : ba.tau2pole;
    };

    filtering = fi.peak_eq_cq(-23.0, 95, 0.27) : fi.peak_eq_cq(10.5, 166, 0.64) : fi.low_shelf(2, 890) : fi.high_shelf(-9.5, 2400);

    filterSet = hgroup("[1]filters", HPSection : ParametricSection : LPSection)
    with {
        HPSection = vgroup("[-1]hp", fi.highpass(hpfOrder, hpfFreq)
        with {
            hpfOrder = 2;
            hpfFreq = vslider("note[style:knob]", 1, 1, 88, 0.01) : si.smoo : ba.pianokey2hz;
        });
        LPSection = vgroup("[9]lp", fi.lowpass(lpfOrder, lpfFreq)
        with {
            lpfOrder = 2;
            lpfFreq = vslider("note[style:knob]", 88, 1, 88, 0.01) : si.smoo : ba.pianokey2hz;
        });
        ParametricSection = seq(i, 4, vgroup("[%i]pk%i", fi.peak_eq_cq(gain, freq, q)
                with {
                    gain = vslider("gain%i[style:knob]",0,-12,12,0.1) : si.smoo;
                    freq = vslider("note%i[style:knob]", 44, 1, 88, 0.01) : si.smoo : ba.pianokey2hz;
                    q = vslider("q%i[style:knob]",1,0.01,100,0.01) : si.smoo;
                }
            )
        );
    };
};


timbre = tgroup("[1]timbre", par(i, 5, _ : vgroup("voice%i", voice(i)) : _ ));

processing = vgroup("[2]Processing", par(i, 5, _ : filtering : fx : masterGain )) with {
    filtering = hgroup("MoogVCF", fi.resonlp(freq, q, 0.8) ) with {
            freq = vslider("Cutoff[style:knob]",1000,20,20000,0.01) : si.smoo;
            q = vslider("q[style:knob]", 5, 0.1, 10, 0.01) : si.smoo;
    };
    fx = _ <: dm.zita_rev1 :> _ ;
    masterGain = _ * gain with {
        gain = hslider("[9]MasterGain[units:dB]",0 , -60, 12, 0.1) : si.smoo : ba.db2linear;
    };
};


process = vgroup("speakrum", timbre : processing );
