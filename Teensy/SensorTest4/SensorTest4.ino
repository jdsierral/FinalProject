#include <ResponsiveAnalogRead.h>

class OnePoleFilter {
    float a = 0;
    float b = 1;
    float s = 0;
    float fs;

    void setPole(float newPole) {
      a = newPole;
      b = 1 - a;
    }


    float tick(float newVal) {
      s += b * (newVal - s);
      return s;
    }
};

const int chan = 1;
const int A_PINS = 3;

const int ANALOG_PINS[A_PINS] = {A1, A3, A5};
const int CCID[A_PINS] = {21, 22, 23};


const int cc1 = 10;
const int cc2 = 11;
const int cc3 = 91;

int lag1 = 0;
int lag2 = 0;
int lag3 = 0;

byte data[A_PINS];
byte dataLag[A_PINS];

ResponsiveAnalogRead analog[] {
  {ANALOG_PINS[0], true},
  {ANALOG_PINS[1], true},
  {ANALOG_PINS[2], true}
};

void setup() {
}

void loop() {
  getAnalogData();

  while (usbMIDI.read()) {
  }
}

void getAnalogData() {
  for (int i = 0; i < A_PINS; i++) {
    // update the ResponsiveAnalogRead object every loop
    analog[i].update();
    // if the repsonsive value has change, print out 'changed'
    if (analog[i].hasChanged()) {
      data[i] = analog[i].getValue() >> 3;
      if (data[i] != dataLag[i]) {
        dataLag[i] = data[i];
        usbMIDI.sendControlChange(CCID[i], data[i], chan);
      }
    }
  }
}
