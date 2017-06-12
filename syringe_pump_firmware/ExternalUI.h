/**
   	External communication logic of the syringe pump firmware

    @author Adam Polak
    @version 1.0
*/

#ifndef ExternalUI_h
#define ExternalUI_h
#include "Arduino.h"
#include "MotorControl.h"
#include "Calibration.h"

class ExternalUI{
	
	private:
		MotorControl *motorRef;
		Calibration *calRef;

	public:
		ExternalUI(MotorControl *motor=nullptr, Calibration *cal = nullptr);
		void readData();
		void init();



};
#endif
