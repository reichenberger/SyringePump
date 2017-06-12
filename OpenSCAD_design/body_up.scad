
/*Syringe holder body*/
include <constants.scad>
include <basic_functions.scad>

//body_up();

module body_up(){
    difference(){
        
        union(){
            difference(){
                base_board_halfround(ScrewHoleDist+(BaseDiam*2)+LengthCompl,    ScrewHoleDist+(BaseDiam*2)+WidthCompl,BaseThick,4);
                
                rod_holes(SmoothRodDistFromCenter,RodDiam/2,BaseThick+5);
                
                middle_hole(ThreadedRodDiam/2+1,BaseThick+5);
                
                tightening_holes(BoardScrewHolePosX,BoardScrewHolePosY,BoardScrewLength,BoardScrewHoleDiam/2);
                

            }
                wallThick = 2;
                translate([0,0,-(BaseThick-wallThick)/2])base_board_halfround(ScrewHoleDist+(BaseDiam*2)+LengthCompl,    ScrewHoleDist+(BaseDiam*2)+WidthCompl,wallThick,4);
    }
    translate([ButtonXPos,0,0])button_hole(ButtonX,ButtonY,ButtonThick,BaseThick);
    }
}
