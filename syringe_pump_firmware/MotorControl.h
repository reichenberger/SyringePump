/**
    Motor control logic of the syringe pump firmware 

    @author Adam Polak
    @version 1.0
*/



#ifndef MotorControl_h
#define MotorControl_h

#include "Arduino.h"
#include "AccelStepper.h"

class MotorControl{
	

	private:

		uint8_t dirPin;
		uint8_t stepPin;
		uint8_t enablePin;
		uint8_t limitPin;

		uint8_t mode0;
		uint8_t mode1;
		uint8_t mode2;


		int motorSteps;
		float maxSpeed;
		float volumeToSteps;
		uint8_t countDown;
		uint8_t atLimit;
		bool moveOn;
		bool stopped;
		int8_t direct;
		long steps;
		float speed;
		int mstep;
		int accel;
		float oneRotConstant;

		AccelStepper stepper;


	public:

		MotorControl(uint8_t dirPin, uint8_t stepPin, uint8_t enablePin, uint8_t limitPin, uint8_t mode0, uint8_t mode1, uint8_t mode2,int motorSteps, float maxSpeed);
		void moveDirect();
		bool move();
		void enable();
		void disable();
		void init();
		void setMove(long target,float speed);
		void setMicrostepping(int mstep);
		bool isRunning();
		void limit();
		void endLimit();
		void stop();
		uint8_t getAtLimit();
		int getMotorSteps();
		void setMoveOn(bool moveOn);
		void setDirect(int8_t direct);
		void setSpeed(float speed);
		void setSteps(long steps);
		void controlMotor();
		int8_t getDirect();
		void setMaxSpeed(float speed);
		long getDistanceToGo();
		void setAccelerationRate(int accelRate);

		void setVolume(float volume);
		void setFlow(float flow);
		void setOneRotConst(float constant);
		float getOneRotConst();
		void softReset();
};
#endif
