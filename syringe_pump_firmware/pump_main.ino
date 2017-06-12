/**
    Syringe pump firmware

    @author Adam Polak
    @version 1.0
*/


#include "Arduino.h"
#include "MotorControl.h"
#include "DisplayUI.h"
#include "ExternalUI.h"
#include "Calibration.h"


#define INT_PIN 2
#define BACK_PIN 3


void setup();
void loop();




MotorControl motor(8,9,4,INT_PIN,12,11,10,200,1000);


DisplayUI display(7,6,5,3,&motor);

ExternalUI external(&motor);

Calibration cal;

bool ext = 0;

unsigned long last_interrupt_time = 0;

void setup() {
  motor.init();
  display.init();
  // motor.enable();
  Serial.begin(9600);
  Serial.setTimeout(50);
  // float syrConstant;
  // syrConstant= cal.loadConstant();
  // if(!isnan(syrConstant)){
  // motor.setOneRotConst(syrConstant);
  // }
  motor.setMicrostepping(4);
  Serial.begin(9600);
  Serial.setTimeout(50);
  // Serial.println(syrConstant);
  delay(50);
  pinMode(INT_PIN, INPUT_PULLUP);
  pinMode(BACK_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(INT_PIN), limit, FALLING);
  attachInterrupt(digitalPinToInterrupt(BACK_PIN), stop, FALLING);

}

void loop() {
  if(Serial.available()>0){
    if(display.getExt()){
    		external.readData();
    }
  }
  display.draw();
  motor.controlMotor();
}

void stop(){
  unsigned long interrupt_time = millis();
  if (interrupt_time - last_interrupt_time > 500) {
    Serial.println("STOP");
    motor.stop();
    display.goBack();
  }
  last_interrupt_time = interrupt_time;
}

void limit(){
	unsigned long interrupt_time = millis();
	if (interrupt_time - last_interrupt_time > 100) {
		// Serial.println("The pump reached limit!!!");
		motor.limit();
    display.goBack();
    // detachInterrupt(digitalPinToInterrupt(INT_PIN));
    Serial.println("Interrupt limit-falling. limit()");
		attachInterrupt(digitalPinToInterrupt(INT_PIN), endLimit, RISING);
	}
	last_interrupt_time = interrupt_time;
}

void endLimit(){
	unsigned long interrupt_time = millis();
	if (interrupt_time - last_interrupt_time > 100) {
		// Serial.println("The pump is free again!!!");
		motor.endLimit();
    display.goBack();
    // detachInterrupt(digitalPinToInterrupt(INT_PIN));
    Serial.println("Interrupt limit-rising. endLimit()");
		attachInterrupt(digitalPinToInterrupt(INT_PIN), limit, FALLING);
	}
	last_interrupt_time = interrupt_time;
}
