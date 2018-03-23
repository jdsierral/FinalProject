Faust fck;

fck.eval(`import("/Users/juans/Developer/CCRMA/250a/FinalProject/ElectroDrum/Drum.dsp"); process = voice;`);


for (0 => int i; i < 5; i++) {
    adc.chan(i) => fck.chan(i) => dac.chan(i);
}


spork ~ initializeMidi();
spork ~ initializeKeyboard();

fun void initializeMidi() {
    MidiIn midiIn;
    MidiMsg msg;
    
    midiIn.open("Teensy MIDI");
    
    <<< midiIn.name() >>>;
    
    while ( true ) {
        midiIn => now;
        while(midiIn.recv(msg)) {
            //            <<< msg.data1, msg.data2, msg.data3 >>>;
            /* if        (msg.data2 == 21) {
            for (0 => int i; i < numDrums; i++) {
                fck[i].v("GainSine", val[0]);
            }
        } else if (msg.data2 == 22) {
            for (0 => int i; i < numDrums; i++) {
                fck[i].v("GainSaw", val[1]);
            }
        } else if (msg.data2 == 23) {
            for (0 => int i; i < numDrums; i++) {
                fck[i].v("GainSquare", val[2]);
            }
        } */
    }
}
}

fun void initializeKeyboard() {
    Hid hi;
    HidMsg msg;
    0 => int device;
    if( !hi.openKeyboard( device ) ) me.exit();
    <<< "keyboard '" + hi.name() + "' ready", "" >>>;
    while( true ) {
        // wait on event
        hi => now;
        // get one or more messages
        while( hi.recv( msg ) ) {
            // check for action type
            if( msg.isButtonDown() ) {
            }
        }
    }
    
}

while(true) {
    1::samp => now;
}
