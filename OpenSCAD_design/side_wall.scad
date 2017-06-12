include <constants.scad>
include <dovetail.scad>
include <basic_functions.scad>












h1=158;
h2 = h1-78;
WallThick = 6; 







// cube([18,6.5,1],true);
//
// translate([20,0,0])cube([6,6.5,1],true);
//
// translate([0,10,0])cube([11,6.5,1],true);
 
module wall_enclosure_vertical(x,y,h1,W){
    vertical_rods(x,y,h1-2*x+3,W);
}

module wall_enclosure_horizontal(x,y,z,h2){
    
    translate([0,0,h2-2])cube([x,y,z]);
}

module wall_enclosure(){
#translate([-2,-W/2+4.5,0])wall_enclosure_horizontal(1,W-9,3,h1);

#translate([-2,-W/2+4.5,0])wall_enclosure_horizontal(1,W-9,3,h2+0.5);


translate([-2,-W/2+1.5,0])wall_enclosure_vertical(1,3,h1,W-6);
}
wall();
translate([-10,0,0])wall_enclosure();
module wall(){    

    
difference(){
   
translate([0,-W/2,0])wall_structure(WallThick,WallThick,BaseThick,h1,h2,W);
translate([0,-W/2+1.5,0])cable_holes(3,3,h1,W-6,h2);
    
translate([0,0,h2 +BaseThick/2])tightening_holes(0,BoardScrewHolePosY,BoardScrewLength,BoardScrewHoleDiam/2);
    
    translate([0,0,h1 + BaseThick/2])tightening_holes(0,BoardScrewHolePosY,20,BoardScrewHoleDiam/2);
    
    translate([0,0,BaseThick/2])tightening_holes(0,BoardScrewHolePosY,20,BoardScrewHoleDiam/2);
    
    screw_head_holes(-1,BoardScrewHolePosY,h1+BaseThick/2,7.2,3);
    screw_head_holes(-1,BoardScrewHolePosY,h2+BaseThick/2,7.2,3);
    screw_head_holes(-1,BoardScrewHolePosY,BaseThick/2,7.2,3);
}




enclosure_holder(2,0.5,h1,h2,W);

}

module screw_head_holes(x,distY,h,diam,depth){
    translate([x,-distY,h])rotate([0,90,0])cylinder(depth,diam/2,diam/2,$fn=60,true);
    translate([x,distY,h])rotate([0,90,0])cylinder(depth,diam/2,diam/2,$fn=60,true);
        
}


module wall_structure(x,y,z,h1,h2,W){
    vertical_rods(x,y,h1,W-y);
    horizontal_rods(x,W,z,h1,h2);
}

module cable_holes(x,y,h1,W,h2){
   cable_hole_up(x,y,h1,W);
   cable_hole_down(x,y,h2,W);
   vertical_rods(x,y,h1,W);
} 
module cable_hole_up(x,y,h2,W){
    #translate([2,W/2-ButtonY/4-0.1,h2+5.4])cube([3*x,ButtonY,x]);
   translate([0,W/2-ButtonY/4-0.1,h2])cube([x,ButtonY,3*x]);
   translate([0,0,h2-2.5])cube([x,W+y,x]);
}
module cable_hole_down(x,y,h2,W){
    translate([-1,W/2-ButtonY/4,h2+x-2])cube([5*x,ButtonY,x]);
    translate([0,0,h2-2])cube([x,W+y,x]);
}

module enclosure_holder(x,y,h1,h2,W){
    difference(){
        union(){
            //vertical holders
            translate([3-x,-W/2+4,0])vertical_rods(x,y,h1+1,W-6);
            translate([3-x,-W/2+1.5,0])vertical_rods(x,y,h1+1,W-6);
            
            //horizontal holders up
            translate([3-x,-W/2+4,h1])cube([x,W-8,y]);
            translate([3-x,-W/2+4,h1-2.5])cube([x,W-8,y]);
            translate([3-x,-ButtonY/2,h1])cube([x,y,BaseThick-1]);
            translate([3-x,ButtonY/2-0.5,h1])cube([x,y,BaseThick-1]);
            
            //horizontal holders down 
            translate([3-x,-W/2+4,h2+0.5])cube([x,W-8,y]);
            translate([3-x,-W/2+4,h2-2])cube([x,W-8,y]);
        }
        //delete overlap
        translate([0,-2.7,h1])cube([3,ButtonY-1,3]);
        translate([0,-3.1,h2])cube([3,ButtonY,3]);
        translate([0,-W/2+3,h2-1.5])cube([3,W-6,2]);
        translate([0,-W/2+3,h1-2])cube([3,W-6,2]);
    }
}
//module s

module vertical_rods(l,w,h,dist){
    cube([l,w,h]);
    translate([0,dist,0])cube([l,w,h]);
}

module horizontal_rods(l,w,h,h1,h2){
    translate([0,0,h1-h/2])cube([l,w,h*1.5]);
    translate([0,0,h2-h/2])cube([l,w,h*1.5]);
    cube([l,w,h]);
}