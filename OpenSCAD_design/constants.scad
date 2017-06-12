    /*Project constants*/
//width = ScrewHoleDist+(BaseDiam*2)+ WidthCompl
//
//Distance of the holes for mounting, affects the width(y-axis)
ScrewHoleDist = 31;

//Thickness of the plate
BaseThick = 8.0;

 
//Diameter of the hole in the middle on the stepper holder
MidHoleDiam = 23;

//Diameter of the screw hole
ScrewHoleDiam = 3.1;
    
//Diameter of the corner cylinders,affects the width of the body(y-axis)
BaseDiam = 3;

//Body width complement (y-axis)
WidthCompl = 10;
//Body length complement (x-axis)
LengthCompl = 10;

//Body length complement for the upper part (x-axis)
LengthDiffUp = 5;

//Body length complement for the moving part (x)
LengthDiffDown = 5;

W = ScrewHoleDist+(BaseDiam*2)+WidthCompl;
L = ScrewHoleDist+(BaseDiam*2)+LengthCompl;



//Diameter of the smooth rods
RodDiam = 5;

SmoothRodDistFromCenter = 16.5; // 31/2;

//diameter of the bearing
BearingDiam = RodDiam+6;

BearingHeight = 20 + 2;

//Diameter of the threaded rod  
ThreadedRodDiam = 10.3;

//Diameter of the hole for the threaded rod
ThreadedRodHoleDiam = 10.8;

NutDiam = 22.0;
NutHeight =20;
NutWall=2;
NutHoleDiam = NutDiam-2*NutWall;


//size and height of the linear motion nut
ThreadedNutSize = 10.25;
ThreadedNutHeight = 4.95;

//size and height of the syringe tightening nut
SyrNutSize = 5.6; //5.41
SyrNutHeight = 2.4; //2.32

//Height of the syringe mounting body
BodyHeight = 190;

//Syringe mounting
SyrMountDownHeight = 110;

//Syringe radius for the mounting
SyrDiamDown =8;

SyrDiamUp = 4.6;

//Dimensions of the syringe fastening plate
PlateX=6;
PlateY=35;
PlateHolesYPos=13;

//Safety Button
ButtonX = 7;
ButtonY = 6.4;
ButtonThick = 3.4;
ButtonXPos = -15;

//Board screw holes
BoardScrewHolePosX = -23;
BoardScrewHolePosY = 11;
BoardScrewLength = 20;
BoardScrewHoleDiam= 2.5;


//Display board
DisplayX = 12;
DisplayY = 38.3;