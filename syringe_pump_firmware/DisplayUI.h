/**
    Display logic of the syringe pump firmware

    @author Adam Polak
    @version 1.0
*/

#ifndef DisplayUI_h
#define DisplayUI_h

#include "Arduino.h"
#include "U8glib.h"
#include "MotorControl.h"

//UI menu item counts
#define SETTINGS_ITEMS  6
#define MENU_ITEMS 4

//UI main menu options
#define OFF -1
#define DOWN 1
#define UP 2
#define SETTINGS 0
#define EXTERNAL 3
 
//UI settings menu options
#define FLOW 2
#define VOLUME 1
#define MOVE 0
#define MICROSTEP 3
#define CALIBRATION 4
#define RESET 5

//UI keys 
#define KEY_NONE 0
#define KEY_PREV 1
#define KEY_NEXT 2
#define KEY_SELECT 3
#define KEY_BACK 4


class DisplayUI{
	

	private:

		U8GLIB_SSD1306_128X32 display;

		uint8_t uiKeyPrevPin;
		uint8_t uiKeyNextPin;
		uint8_t uiKeySelectPin;
		uint8_t uiKeyBackPin;

		uint8_t menuCurrent;
		int8_t submenuCurrent;
		int8_t settingsCurrent;
		int8_t subsettingsCurrent;

		bool redrawRequied;

		uint8_t uiKeyCodeFirst;
		uint8_t uiKeyCodeSecond;
		uint8_t uiKeyCode;
		uint8_t lastKeyCode;

		bool speedIncrement;
		float flow;
		float volume;
		int mstep;
		MotorControl *motorRef;

    	const char *MENU_STRINGS[MENU_ITEMS] = { "Set Move","Direct Down", "Direct Up","External Control" };
		const char *SETTINGS_STRINGS[SETTINGS_ITEMS] = {"Move","Volume","Flow","Microstepping","Calibration","Software Reset"};
		
		void drawMenu(uint8_t menuCurrent, uint8_t item_count,const char** itemStrings);
		void drawSubmenu();
		void updateMenu();
		void uiStep();
		void toMotor();
		void updateSettingsMenu();
		void drawSubsettings();
		void doSpeedIncrement(bool dir);
		void softReset();


	public:
		DisplayUI(uint8_t uiKeyPrevPin, uint8_t uiKeyNextPin, uint8_t uiKeySelectPin, uint8_t uiKeyBackPin, MotorControl *motor = nullptr);
		void draw();
		void init();
		bool getExt();
		void goBack();
};
#endif
