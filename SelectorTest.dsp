import("stdfaust.lib");

type = int(nentry("SignalType",0,0,2,1));



switcher = _, _, _ : ba.selectn(3, type) : _ ;

process = os.osc(440), no.noise, no.pink_noise : switcher ;
