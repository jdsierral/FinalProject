#include <NewPing.h>

#define MAX_DISTANCE 15

NewPing sonar = NewPing(9, 10, MAX_DISTANCE); 

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

} 

void loop() {
  delay(50);
  float distance = sonar.ping_cm();

  Serial.print("Distance: ");
  Serial.println(distance);
}
