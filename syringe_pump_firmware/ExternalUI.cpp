#include "ExternalUI.h"

ExternalUI::ExternalUI(MotorControl *motor= nullptr, Calibration *cal = nullptr):motorRef(motor),calRef(cal){

}

void ExternalUI::init(){
  
}

void ExternalUI::readData() {
  float speed;
  float steps;
  char data;
  int8_t direct;
  uint8_t i =0;
  while (data != '$') {
    if (Serial.available() > 0) {
      data = Serial.read();
      Serial.println(data);
      switch (data) {
        case  'F':
          speed = Serial.parseFloat();
          if(0<speed && speed<30){
          Serial.println(speed);
          motorRef->setFlow(speed);
          }else{
            Serial.println("Wrong value of flow.");
          }
          break;
        case 'V':
          steps = Serial.parseFloat();
          Serial.println(steps);
          motorRef->setMoveOn(true);
          motorRef->setDirect(0);
          motorRef->setVolume(steps);
          break;
        case 'U':
          speed = Serial.parseFloat();
          if(0<speed && speed<30){
      			Serial.println(speed);
            direct=2;
      			motorRef->setFlow(speed);
      			motorRef->setMoveOn(true);
      			motorRef->setDirect(direct);
          }else{
            Serial.println("Wrong value of speed.");
          }
          break;
        case 'D':
          speed = Serial.parseFloat();
          if(0<speed && speed<30){
          	Serial.println(speed);
            direct = 2;
      			motorRef->setFlow(-speed);
      			motorRef->setMoveOn(true);
      			motorRef->setDirect(direct);

          }else{
            Serial.println("Wrong value of speed.");
          }
          break;
        case 'M':
          int mstep;
          mstep = Serial.parseInt();
          if(mstep==1 ||mstep== 2 || mstep==4 || mstep==8 || mstep==16 || mstep==32){
          motorRef->setMicrostepping(mstep);
          Serial.println(mstep);
          }else{
            Serial.println("Wrong value of mstep.");
          }
          break;
        case 'A':
          int accel;
          accel = Serial.parseInt();
          if(accel<2000){
            motorRef->setAccelerationRate(accel);
          }
          break;
        case 'C':
          float cnst;
          cnst = Serial.parseFloat();
          if(cnst<1000 && cnst>0){
            motorRef->setOneRotConst(cnst);
            calRef->saveConstant(cnst);
          }
          break;
        case 'G':
          float cnstread;
          cnstread = motorRef->getOneRotConst();
          Serial.println(cnstread);
          cnstread = calRef->loadConstant();
          Serial.println(cnstread);
          break;
        case 'X':
           motorRef->softReset();
           break;
      }
      if (direct!=0) {
      // motorRef->setMoveOn(true);
      // motorRef->setDirect(2);
      motorRef->controlMotor();
      }
    }
  } 
}