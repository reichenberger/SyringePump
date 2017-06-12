/**
    Calibration class, providing methods of saving and loading to the EEPROM memory.

    @author Adam Polak
    @version 1.0
*/


#ifndef Calibration_h
#define Calibration_h

#include <EEPROM.h>
#include "Arduino.h"


class Calibration{



public:


	Calibration::Calibration();
	void saveConstant(float newConstant);
	float loadConstant();

};
#endif
