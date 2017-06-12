/*Syringe holder body*/
include <constants.scad>
include <basic_functions.scad>

//stepper_mount();\

module stepper_mount(){
difference(){
    base_board_halfround(ScrewHoleDist+(BaseDiam*2)+LengthCompl,    ScrewHoleDist+(BaseDiam*2)+WidthCompl,BaseThick,4);
    
    screw_holes(ScrewHoleDist/2,ScrewHoleDiam/2,BaseThick+5);
    
    rod_holes(SmoothRodDistFromCenter,RodDiam/2,BaseThick+5);
    
    middle_hole(MidHoleDiam/2,BaseThick+5);
    
    tightening_holes(BoardScrewHolePosX,BoardScrewHolePosY,BoardScrewLength,BoardScrewHoleDiam/2);
}
}



