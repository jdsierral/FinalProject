5 => int numDrums;
Gain inputGain[numDrums];
Gain outputGain[numDrums];
Faust fck[numDrums];
[50, 53, 55, 57, 60] @=> int notes[];
[10.0, 5.65, 7.71, 16.49, 6.82] @=> float hpNotes[];


0 => int fckSel;

1::second / 1::samp => float fs;

<<< fs >>>;



for (0 => int i; i < numDrums; i++) {
    fck[i].eval(`import("/Users/juans/Developer/CCRMA/250a/FinalProject/ElectroDrum/Drum.dsp"); process = voice;`);
    inputGain[i].gain(1.0);
    outputGain[i].gain(1.0);
    
    fck[i].v("/voice/note", notes[i] );
    fck[i].dump();
    adc.chan(i) => inputGain[i] => fck[i] => outputGain[i] => dac.chan(i);
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
//                <<< "down:", msg.which, "(code)", msg.key, "(usb key)", msg.ascii, "(ascii)" >>>;
                if (msg.ascii >= 49 && msg.ascii <= 53) {
                    msg.ascii - 49 => fckSel;
                    <<< "fck: ", fckSel + 1, " selected">>>;
                }
                
                fckSel => int i;
                
                if (msg.ascii == 44) {
                } else if (msg.ascii == 46) {
                } else if (msg.ascii == 77) {             
                } else if (msg.ascii == 47) {              
                }
            }
        }
    }

}

while(true) {
    1::samp => now;
}
