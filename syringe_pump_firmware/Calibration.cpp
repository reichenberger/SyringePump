#include "Calibration.h"

Calibration::Calibration(){
	
}

void Calibration::saveConstant(float newConstant){
	 EEPROM.put(0, newConstant);
	 Serial.println("New constant is saved.");
	 Serial.println(newConstant);
}

float Calibration::loadConstant(){
	float constant = 0.00f; 
	EEPROM.get(0, constant);
	Serial.println("Constant is loaded.");
	Serial.println(constant);
	return constant;
}