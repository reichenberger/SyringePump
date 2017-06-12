include<constants.scad>

//tightPlate();
tight_plate(PlateX,PlateY,BaseThick/2,PlateHolesYPos,ScrewHoleDiam/2+0.5,0);

module tight_plate(x,y,z,holeY,holeD,syrD){
    difference(){
    cube([x,y,z],true);
    
    translate([0,holeY,0])cylinder(z*2,holeD,holeD,$fn=60,true);
    translate([0,-holeY,0])cylinder(z*2,holeD,holeD,$fn=60,true);
    translate([x/2,0,0])cylinder(z*2,syrD,syrD,$fn=60,true);
    }
}