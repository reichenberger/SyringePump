include <constants.scad>
include <linear_bearing.scad>
include <hexagon.scad>
include <basic_functions.scad>


//Distance from the wall of the body part, changes length of the piece, while keeping the holes fixed

//translate the model down
//syringeMove();
//moving_part();


module moving_part(){
l = ScrewHoleDist+(BaseDiam*2)+LengthCompl+ LengthDiffDown;
w = ScrewHoleDist+(BaseDiam*2)+WidthCompl;
//
    BodyDist = 5;
            translate([0,-SmoothRodDistFromCenter,0]) linear_bearing();
        //
        ////add bearing
        translate ([0,SmoothRodDistFromCenter,0]) linear_bearing();
translate([0,0,BaseThick/2]){
difference(){
    
    union(){
        
        difference(){
                union(){
                    translate([LengthDiffDown/2,0,0])base_board_halfround(l,w, BaseThick,4);
                    #translate([ButtonXPos,0,BearingHeight/2-BaseThick/2])cylinder(BearingHeight,ButtonX/2,ButtonX/2,$fn=60,true);
                }
                rod_holes(SmoothRodDistFromCenter,BearingDiam/2,BaseThick+5);
            
                middle_hole(NutDiam/2+NutWall,BaseThick+20);
            
            
                translate([l/2-PlateX/2+LengthDiffDown/2,0,BaseThick/2])syringe_tightening(PlateX,PlateY,BaseThick,SyrDiamUp/2,PlateHolesYPos,SyrNutSize,SyrNutHeight,ScrewHoleDiam);
                #translate([-l/2+LengthDiffDown/2,0,0])cube([BodyDist*2,w,BaseThick+5],true);
                
            
        }
        nut_capsule(NutDiam,NutHeight,NutHoleDiam,NutWall);
}
}
}
}
