#include "DisplayUI.h"


DisplayUI::DisplayUI(uint8_t uiKeyPrevPin,uint8_t uiKeyNextPin,uint8_t uiKeySelectPin,uint8_t uiKeyBackPin, MotorControl *motor= nullptr)
: display(U8GLIB_SSD1306_128X32(U8G_I2C_OPT_NONE)),motorRef(motor){
    this->uiKeyPrevPin = uiKeyPrevPin;
    this->uiKeyNextPin = uiKeyNextPin;
    this->uiKeySelectPin = uiKeySelectPin;
    this->uiKeyBackPin =  uiKeyBackPin;
}

void DisplayUI::init(){
    menuCurrent = 0;
    submenuCurrent = OFF;
    settingsCurrent = OFF;
    subsettingsCurrent = OFF;
    redrawRequied = 1;
    display.setRot180();

    speedIncrement = 0;
    flow = 20.5;
    volume = -20.5;
    mstep =16;



    uiKeyCodeFirst = KEY_NONE;
    uiKeyCodeSecond = KEY_NONE;
    uiKeyCode = KEY_NONE;
    lastKeyCode = KEY_NONE;

    pinMode(uiKeyPrevPin, INPUT_PULLUP);
    pinMode(uiKeyNextPin, INPUT_PULLUP);
    pinMode(uiKeySelectPin, INPUT_PULLUP);
    pinMode(uiKeyBackPin, INPUT_PULLUP);
}

void DisplayUI::draw(){
  uiStep();
if(submenuCurrent == SETTINGS){
  updateSettingsMenu();
}else{
  updateMenu();
}
  if(submenuCurrent!=EXTERNAL){
    toMotor(); 
  }
	if (  redrawRequied != 0) {
    display.firstPage();
    do  {
      if(submenuCurrent == OFF){
        drawMenu(menuCurrent,MENU_ITEMS,MENU_STRINGS);
      }else if(submenuCurrent == SETTINGS){
        if(subsettingsCurrent != OFF){
            drawSubsettings();
        }else{
          drawMenu(settingsCurrent,SETTINGS_ITEMS,SETTINGS_STRINGS);
        }
      } else{
        drawSubmenu();
      }

    } while ( display.nextPage() );
    redrawRequied = 0;
  }
  
}

void DisplayUI::drawMenu(uint8_t item, uint8_t item_count,const char** itemStrings){
	uint8_t i, h;
	u8g_uint_t w, d,diff;
	display.setFont(u8g_font_6x13);
	display.setFontRefHeightText();
	display.setFontPosTop();

	h = display.getFontAscent() - display.getFontDescent();
	w = display.getWidth();
	if(item >2){
		diff = 3;
	}else{
		diff = 0;
	}
	for ( i = diff; i < item_count; i++ ) {
		d = (w - display.getStrWidth(itemStrings[i])) / 2;
		display.setDefaultForegroundColor();
		if ( i == item ) {
		  display.drawBox(0, (i-diff) * h + 1 , w, h);
		  display.setDefaultBackgroundColor();
		}
		display.drawStr(d, (i-diff) * h, itemStrings[i]);
	}
}


void DisplayUI::drawSubmenu() {
  uint8_t i, h;
  u8g_uint_t w, d;

  display.setFont(u8g_font_6x13);
  display.setFontRefHeightText();
  display.setFontPosTop();

  // h = display.getFontAscent()-display.getFontDescent();
  h = 0;
  w = display.getWidth();

  display.setDefaultForegroundColor();

  char message[20] = {0};
  switch (submenuCurrent) {
    case DOWN:
      snprintf(message, sizeof(message), "%s", "Moving down.");
      break;
    case UP:
       snprintf(message, sizeof(message), "%s", "Moving up.");
      break;
    case EXTERNAL:
      snprintf(message, sizeof(message), "%s %d", "External. ", motorRef->getAtLimit());
      break;
  }
  d = (w - display.getStrWidth(message)) / 2;
  display.drawStr(d, h, message);

}

void DisplayUI::doSpeedIncrement(bool dir){
  switch(subsettingsCurrent){
    case FLOW:
      if(dir == 0 && flow >0){
        flow -= 0.1;
      }else if(dir == 1 && flow <30){
        flow += 0.1;
      }
    break;
    case VOLUME:
      if(dir == 0){
         volume -=0.1;
        }else{
          volume +=0.1;
        }
    break;
  }
  redrawRequied=1;
}

void DisplayUI::goBack(){
  if(subsettingsCurrent != OFF){
    subsettingsCurrent = OFF;
  }else if(submenuCurrent!=  OFF){
    submenuCurrent = OFF;
  }
  redrawRequied = 1;
}

void DisplayUI::uiStep() {
  static unsigned long lastPushTime = 0;
  unsigned long pushTime = millis();

  if(pushTime - lastPushTime >50){
    uiKeyCodeSecond = uiKeyCodeFirst;
    if ( digitalRead(uiKeyPrevPin) == LOW ){
      uiKeyCodeFirst = KEY_PREV;
      if (speedIncrement){
        doSpeedIncrement(1);
      }
      // Serial.println("prev");
    }
    else if ( digitalRead(uiKeyNextPin) == LOW ){
      uiKeyCodeFirst = KEY_NEXT;
      if (speedIncrement){
        doSpeedIncrement(0);
      } 
      // Serial.println("next");
    }
    else if ( digitalRead(uiKeySelectPin) == LOW ){
      uiKeyCodeFirst = KEY_SELECT;
      // Serial.println("select");
    }
    else if ( digitalRead(uiKeyBackPin) == LOW ){
      uiKeyCodeFirst = KEY_BACK;
      // Serial.println("back");
    }

    else
      uiKeyCodeFirst = KEY_NONE;

    if ( uiKeyCodeSecond == uiKeyCodeFirst )
      uiKeyCode = uiKeyCodeFirst;
    else{
      uiKeyCode = KEY_NONE;
      speedIncrement=0;
    }
  lastPushTime = pushTime;
  }

}



void DisplayUI::updateMenu() {
  if ( uiKeyCode != KEY_NONE  && lastKeyCode == uiKeyCode ) {
    return;
  }
  lastKeyCode = uiKeyCode; 
  switch ( uiKeyCode ) {
    case KEY_NEXT:
      menuCurrent++;
      if ( menuCurrent >= MENU_ITEMS ) {
        menuCurrent = 0;
      }
      redrawRequied = 1;
      break;
    case KEY_PREV:
      if ( menuCurrent == 0 ) {
        menuCurrent = MENU_ITEMS;
      }
      menuCurrent--;
      redrawRequied = 1;
      break;
    case KEY_SELECT:
      if(submenuCurrent == OFF){
        submenuCurrent = menuCurrent;
      }
      if(submenuCurrent == SETTINGS){
        settingsCurrent = 0;
      }
      redrawRequied = 1;
      break;
    case KEY_BACK:
      if ( submenuCurrent != OFF) {
        submenuCurrent = OFF;
        redrawRequied = 1;
      }
      break;
  }
}

void DisplayUI::drawSubsettings(){
  uint8_t i, h;
  u8g_uint_t w, d;
  char str_temp[6];

  display.setFont(u8g_font_6x13);
  display.setFontRefHeightText();
  display.setFontPosTop();

  h = display.getFontAscent() - display.getFontDescent();
  w = display.getWidth();

  display.setDefaultForegroundColor();

  char message1[20] = {0};
  char message2[20] = {0};
  switch (subsettingsCurrent) {
    case FLOW:
      snprintf(message1, sizeof(message1), "%s %d.%02d uL/s", "Flow:", (int)flow, abs((int)(flow*100)%100));
      break;
    case VOLUME:
      snprintf(message1, sizeof(message1), "%s %d.%02d uL", "Volume:", (int)volume, abs((int)(volume*100)%100));

      // distance = (float)motorRef->getSteps()/(motorRef->getVolumeToStepsConst());
      // sprintf(message2, "Ref: %d.%02d%c", (int)distance, abs((int)(distance*100)%100),(char)176);
      break;
    case MOVE:
      snprintf(message1, sizeof(message1), "%s", "Moving.");
      break;
    case MICROSTEP:
      snprintf(message1, sizeof(message1), "%s %d", "Microstepping:", mstep);
      break;
    case CALIBRATION:
      snprintf(message1, sizeof(message1), "%s %d", "Not supported yet.", mstep);
      break;
    case RESET:
      motorRef->softReset();  
    break;
  }
  d = (w - display.getStrWidth(message1)) /2;
  display.drawStr(d, 0, message1);
  d = (w - display.getStrWidth(message2)) /2;
  display.drawStr(d, h, message2);
}


void DisplayUI::updateSettingsMenu(void){
  if ( uiKeyCode != KEY_NONE  && lastKeyCode == uiKeyCode ) {
    return;
  }
  lastKeyCode = uiKeyCode; 
  switch ( uiKeyCode ) {
          case KEY_NEXT:
            if(subsettingsCurrent == OFF){
              settingsCurrent++;
              if ( settingsCurrent >= SETTINGS_ITEMS ) {
                settingsCurrent = 0;
              }
            }else if(subsettingsCurrent == FLOW){
              // flow--;
              speedIncrement = true;
            }
            else if(subsettingsCurrent == VOLUME){
              // volume--;
              speedIncrement = true;
            }else if(subsettingsCurrent == MICROSTEP){
              if(mstep>1){
              mstep = mstep/2;
              motorRef->setMicrostepping(mstep);
              }
            }
            redrawRequied = 1;
            break;
          case KEY_PREV:
          if(subsettingsCurrent == OFF){
              if ( settingsCurrent == 0 ) {
              settingsCurrent = SETTINGS_ITEMS;
              }
              settingsCurrent--;
            }else if(subsettingsCurrent == FLOW){
              // flow++;
              speedIncrement = true;
            }
            else if(subsettingsCurrent == VOLUME){
              // volume++;
              speedIncrement = true;
            }else if(subsettingsCurrent == MICROSTEP){
              if(mstep<32){
              mstep = mstep*2;
              motorRef->setMicrostepping(mstep);
              }
            }
            
            redrawRequied = 1;
            break;
          case KEY_SELECT:
            if(subsettingsCurrent == OFF){
              subsettingsCurrent = settingsCurrent;
              if(subsettingsCurrent == MOVE){
                motorRef->setMoveOn(true);
              }
            } 
            redrawRequied = 1;
            
            break;
          case KEY_BACK:
            if ( subsettingsCurrent!= OFF) {
              subsettingsCurrent = OFF;
            } else{
              submenuCurrent = OFF;
            }
            redrawRequied = 1;
            break;
    }
}

bool DisplayUI::getExt(){
    if(submenuCurrent == EXTERNAL){
      return true;
    }
    return false;
}

void DisplayUI::toMotor(){
  if (submenuCurrent == DOWN ) {
    motorRef->setMoveOn(true);
    motorRef->setDirect(1);
    motorRef->setFlow(-flow);
  } else if(submenuCurrent == UP){
    motorRef->setMoveOn(true);
    motorRef->setDirect(1);
    motorRef->setFlow(flow);
  } else if(subsettingsCurrent == MOVE){
    motorRef->setDirect(0);
    motorRef->setFlow(flow);
    motorRef->setVolume(volume);
  }
  else{
    motorRef->setMoveOn(false);
    motorRef->setDirect(0);
  }

}

