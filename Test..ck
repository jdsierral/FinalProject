// HID
Hid hi;
HidMsg msg;

Gain input;
Gain output;


adc.chan(2) => LPF lpf => input;

lpf.freq(1000);
output => dac.chan(0); 


SinOsc osc => Gain env => output;

osc.freq(440);

env.gain(1.0);

spork ~ trackEnvelope();
spork ~ keyTracker();

fun void keyTracker() {
    hi.openKeyboard( 0 );
    while( true )
    {
        // wait for event
        hi => now;
        
        // get message
        while( hi.recv( msg ) )
        {
            // check
            if( msg.isButtonDown() )
            {
                <<< msg.which >>>;
                Std.mtof( msg.which + 24 ) => float freq;
                if( freq > 20000 ) continue;
                
                freq => osc.freq;
                
                80::ms => now;
            }
        }
    }
}




fun void trackEnvelope() {
    input => FullRect rect => OnePole op => blackhole;
    op.pole(0.999);
    while(true) {
        op.last() => float val;
        env.gain(val);
        1::samp => now;
    }    
}




while(true) {
    1::second => now;
}

