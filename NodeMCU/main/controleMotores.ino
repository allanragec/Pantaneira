/****************************************
   Include Libraries
 ****************************************/
#include <Servo.h>
/****************************************
 * 
 */
 
#define LIGADO LOW
#define DESLIGADO HIGH
#define LEFTESCPIN D5
#define RIGHTESCPIN D6

Servo leftESC;
Servo rightESC;

void setupMotors() {
  leftESC.attach(LEFTESCPIN,1000,2000);
  rightESC.attach(RIGHTESCPIN,1000,2000);
}

void stopMotores() {
  updateLeftMotor(49); 
  updateRightMotor(49);
}

void updateLeftMotor(int value) {
   float mappedValue = map(value, 0, 100, 0, 180); //Map the 0-100 values from the slider to the 0-180 to use the servo lib.
   Serial.println(mappedValue);
   leftESC.write(mappedValue); //Send the value (PWM) to the ESC
}

void updateRightMotor(int value) {
  float mappedValue = map(value, 0, 100, 0, 180); //Map the 0-100 values from the slider to the 0-180 to use the servo lib.
  Serial.println(mappedValue);
  rightESC.write(mappedValue); //Send the value (PWM) to the ESC
}
