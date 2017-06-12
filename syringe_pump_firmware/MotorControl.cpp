#include "MotorControl.h"
#include <math.h>   

MotorControl::MotorControl(uint8_t dirPin, uint8_t stepPin, uint8_t enablePin,uint8_t limitPin, uint8_t mode0, uint8_t mode1, uint8_t mode2,int motorSteps, float maxSpeed)
: stepper(AccelStepper(1,stepPin,dirPin))
{
	this->dirPin= dirPin;
	this->stepPin = stepPin;
	this->enablePin = enablePin;
	this->mode0 = mode0;
	this->mode1 = mode1;
	this->mode2 = mode2;
	this->maxSpeed = maxSpeed;
	this->limitPin = limitPin;
	this->motorSteps = motorSteps;
}

void MotorControl::init(){
	stepper.setMaxSpeed(maxSpeed);
	stepper.setSpeed(-100);
	
	oneRotConstant = 34.699;
	atLimit = 0;
	moveOn = 0;
	stopped = 0;
	direct = 0;
	mstep = 16;

	accel = 300;
	steps = 1000;
	speed = 100;

	stepper.setAcceleration(accel);
  	pinMode(enablePin,OUTPUT);
	pinMode(mode0,OUTPUT);
	pinMode(mode1,OUTPUT);
	pinMode(mode2,OUTPUT);
	setMicrostepping(16);
}

void MotorControl::controlMotor(){
	if((atLimit == 1 &&speed<0)|| (atLimit == 2 && speed>0)){
		return;
	}
	if(countDown>0){
		countDown--;
		return;
	}
	if(moveOn){
		stepper.enableOutputs();
		enable();
		if(direct ==0){
			stepper.setCurrentPosition(0);
			setMove(steps,speed);
			while(stepper.distanceToGo()!=0){
				stepper.run();
				if(stopped){
					countDown = 10;
					break;
				}
			}
		}else if(direct >0 ){
			stepper.setSpeed(speed);
			while(true){
				stepper.runSpeed();
				if(stopped){
					countDown = 10;
					break;
				}
			}
		// }else if(direct ==2){
		// 	stepper.setSpeed(speed);
		// 	stepper.runSpeed();
		// 	if(stopped){
		// 		countDown = 100;
		// 	}
		}
		direct = 0;
	}
	stepper.disableOutputs();
	disable();
	moveOn = false;	
	stopped = false;

}

void MotorControl::setMove(long target,float speed){
	stepper.move(target);
	stepper.setMaxSpeed(speed);
}	

bool MotorControl::move(){
	 return stepper.run();	
}

void MotorControl::disable(){
	digitalWrite(enablePin,HIGH);
}

void MotorControl::enable(){
	digitalWrite(enablePin,LOW);
}
void MotorControl::moveDirect(){
	stepper.runSpeed();
}

void MotorControl::setMicrostepping(int mstep){
	this->mstep = mstep;
	int ms = (int)(log(mstep)/log(2)+0.1);
	byte pins[3]={0,0,0};
	if(mstep == 2){
		pins[0] = 1;
	}else if(mstep>2){
		for (byte i=0; i<3; i++) {
	    byte state = bitRead(ms, i);
	    pins[i] = state;
	  	}
  	}
  	digitalWrite(mode0, pins[0]);
  	digitalWrite(mode1, pins[1]);
  	digitalWrite(mode2, pins[2]);
  	volumeToSteps= (float)mstep*motorSteps/oneRotConstant;
  	setAccelerationRate(accel);
  	// Serial.println("New volume/steps constant is:");
  	// Serial.println(c);
}

bool MotorControl::isRunning(){
	return stepper.isRunning();
}

uint8_t MotorControl::getAtLimit(){
	return atLimit;
}

int MotorControl::getMotorSteps(){
	return motorSteps;
}

void MotorControl::limit(){
	if(moveOn){
		if(steps<0 || speed<0){
		  atLimit=1;
		}else{
		  atLimit=2;
		}
		stopped = true;
	}
}

void MotorControl::stop(){
	stopped = true;
	// Serial.println("Stopped on purpose.");
}

void MotorControl::endLimit(){
    stopped = false;
  	atLimit = 0;
}


void MotorControl::setMoveOn(bool moveOn){
	this->moveOn = moveOn;
}
void MotorControl::setDirect(int8_t direct){
	this->direct = direct;
}
void MotorControl::setSpeed(float speed){
	this->speed = speed;
}
void MotorControl::setSteps(long steps){
	this->steps = steps;
}
void MotorControl::setMaxSpeed(float maxSpeed){
	this->maxSpeed = maxSpeed;
}

int8_t MotorControl::getDirect(){
	return this->direct;
}


void MotorControl::setVolume(float volume){
	steps = (long)volumeToSteps*volume;
}
void MotorControl::setFlow(float flow){
	speed = volumeToSteps*flow;

}
void MotorControl::setOneRotConst(float constant){
	oneRotConstant = constant;
	volumeToSteps= (float)mstep*motorSteps/oneRotConstant;


}
float MotorControl::getOneRotConst(){
	return oneRotConstant;
}

long MotorControl::getDistanceToGo(){
	return stepper.distanceToGo();
}
void MotorControl::setAccelerationRate(int accelRate){
	accel = accelRate*mstep;
	stepper.setAcceleration(accel);
	// Serial.println("Acceleration rate set.");
}

void MotorControl::softReset(){
asm volatile ("  jmp 0");
}


