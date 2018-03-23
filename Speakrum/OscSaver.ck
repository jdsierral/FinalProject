3// launch with OSC_recv.ck

5 => int numDrums;

[[50, 53, 55, 57, 57],
 [50, 55, 57, 60, 62],
 [50, 53, 55, 57, 62],
 [50, 53, 57, 60, 62],
 [50, 50, 57, 65, 62],
 [62, 65, 57, 70, 74]] @=> int chordMap[][];

// host name and port
"localhost" => string hostname;
5510 => int port;
// send object
OscOut xmit;

// aim the transmitter
xmit.dest( hostname, port );

fun void sndMsg(string address, float value) {
    xmit.start( address );
    value => xmit.add;
    xmit.send();
}

sndMsg("/speakrum/timbre/voice0/filters/hp/note", 00);
sndMsg("/speakrum/timbre/voice0/filters/pk/note", 40);
sndMsg("/speakrum/timbre/voice0/filters/pk/gain", 00);
sndMsg("/speakrum/timbre/voice0/filters/pk/q", 1.0);
sndMsg("/speakrum/timbre/voice0/filters/lp/note", 88);
sndMsg("/speakrum/timbre/voice0/tau", 50);
sndMsg("/speakrum/timbre/voice0/delay", 0);
sndMsg("/speakrum/timbre/voice0/generator/note", 50);


sndMsg("/speakrum/timbre/voice1/filters/hp/note", 00);
sndMsg("/speakrum/timbre/voice1/filters/pk/note", 40);
sndMsg("/speakrum/timbre/voice1/filters/pk/gain", 00);
sndMsg("/speakrum/timbre/voice1/filters/pk/q", 1.0);
sndMsg("/speakrum/timbre/voice1/filters/lp/note", 88);
sndMsg("/speakrum/timbre/voice1/tau", 50);
sndMsg("/speakrum/timbre/voice1/delay", 0);
sndMsg("/speakrum/timbre/voice1/generator/note", 53);

sndMsg("/speakrum/timbre/voice2/filters/hp/note", 00);
sndMsg("/speakrum/timbre/voice2/filters/pk/note", 40);
sndMsg("/speakrum/timbre/voice2/filters/pk/gain", 00);
sndMsg("/speakrum/timbre/voice2/filters/pk/q", 1.0);
sndMsg("/speakrum/timbre/voice2/filters/lp/note", 88);
sndMsg("/speakrum/timbre/voice2/tau", 50);
sndMsg("/speakrum/timbre/voice2/delay", 0);
sndMsg("/speakrum/timbre/voice2/generator/note", 55);

sndMsg("/speakrum/timbre/voice3/filters/hp/note", 00);
sndMsg("/speakrum/timbre/voice3/filters/pk/note", 40);
sndMsg("/speakrum/timbre/voice3/filters/pk/gain", 00);
sndMsg("/speakrum/timbre/voice3/filters/pk/q", 1.0);
sndMsg("/speakrum/timbre/voice3/filters/lp/note", 88);
sndMsg("/speakrum/timbre/voice3/tau", 50);
sndMsg("/speakrum/timbre/voice3/delay", 0);
sndMsg("/speakrum/timbre/voice3/generator/note", 57);

sndMsg("/speakrum/timbre/voice4/filters/hp/note", 00);
sndMsg("/speakrum/timbre/voice4/filters/pk/note", 40);
sndMsg("/speakrum/timbre/voice4/filters/pk/gain", 00);
sndMsg("/speakrum/timbre/voice4/filters/pk/q", 1.0);
sndMsg("/speakrum/timbre/voice4/filters/lp/note", 88);
sndMsg("/speakrum/timbre/voice4/tau", 50);
sndMsg("/speakrum/timbre/voice4/delay", 0);
sndMsg("/speakrum/timbre/voice4/generator/note", 60);

spork ~ initializeKeyboard();
spork ~ initializeMidi();

fun void initializeMidi() {
    MidiIn midiIn;
    MidiMsg msg;
    
    midiIn.open("Teensy MIDI");
    
    <<< midiIn.name() >>>;
    
    while ( true ) {
        midiIn => now;
        while(midiIn.recv(msg)) {
            //<<< msg.data1, msg.data2, msg.data3 >>>;
            if        (msg.data2 == 21) {
                for (0 => int i; i < numDrums; i++) {
                    sndMsg("/speakrum/timbre/voice" + i + "/generator/gain1", msg.data3 / 127.);
                }
            } else if (msg.data2 == 22) {
                for (0 => int i; i < numDrums; i++) {
                    sndMsg("/speakrum/timbre/voice" + i + "/generator/gain2", msg.data3 / 127.);
                }
            } else if (msg.data2 == 23) {
                for (0 => int i; i < numDrums; i++) {
                    sndMsg("/speakrum/timbre/voice" + i + "/generator/gain3", msg.data3 / 127.);
                }
            }
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
                if (msg.ascii >= 49 && msg.ascii <= 58) {
                    msg.ascii - 49 => int n;
                    for (0 => int i; i < numDrums; i++) {
                        sndMsg("/speakrum/timbre/voice" + i + "/generator/note", chordMap[n][i]);
                    }
                }
                
             
                
                if (msg.ascii == 44) {
                } else if (msg.ascii == 46) {
                } else if (msg.ascii == 77) {             
                } else if (msg.ascii == 47) {              
                }
            }
        }
    }
}

while(true){
    1::second => now;
}


