include<constants.scad>

module base_board_round(l,w,h,r){
    minkowski(){
        cube([l-2*r,w-2*r,h/2],true);
        cylinder(h/2,r,r,$fn=60,true);
    }   
}

module hexagon(size, height) {
  boxWidth = size/(3/sqrt(3));
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height],true);
}


module base_board_halfround(l,w,h,r){
    union(){
         minkowski(){
            cube([l-2*r,w-2*r,h/2],true);
            cylinder(h/2,r,r,$fn=60,true);
        }
        translate([-l/4,0,0]){cube([l/2,w,h],true);
        }
    }   
}


module screw_holes(dist,r,h){
    union(){
        translate ([dist,dist,0]) { cylinder(h,r,r,$fn=60,true);
        }
        translate ([-dist,dist,0]) { cylinder(h,r,r,$fn=60,true);
        }
        translate ([dist,-dist,0]) { cylinder(h,r,r,$fn=60,true);
        }
        translate ([-dist,-dist,0]) { cylinder(h,r,r,$fn=60,true);
        }
        
    }
}

module rod_holes(distY,r,h){
        for(y = [distY,-distY]) translate ([0,y,0]) cylinder( h,r,r,$fn=60,true);
}

module tightening_holes(posX,posY,depth,r){
    for(y = [posY,-posY])rotate([0,90,0]) translate ([posX,y,0]) cylinder( depth,r,r,$fn=60,true);
}
module middle_hole(r,h){
        cylinder(h,r,r,$fn=60,true);
}

module nut_capsule(nutDiam,nutH,holeDiam,wall){
        capsuleH = nutH + wall;
        translate([0,0,capsuleH/2-BaseThick/2]){
        difference(){
            union(){
                cylinder( capsuleH,nutDiam/2+wall,nutDiam/2+wall,$fn=60,true);
            }
            
            translate([0,0,wall/2])cylinder( nutH,nutDiam/2,nutDiam/2,$fn=60,true);
            translate([0,0,-nutH/2-wall])cylinder(nutH,holeDiam/2,holeDiam/2,$fn=60,true);
        }
       
    }
}
module syringe_tightening(x,y,h,r,holeY,nutSize,nutHeight,screwDiam){
    union(){
        cube([x,y,h],true);
        translate([x/2,0,0])cylinder( h+20,r,r,$fn=60,true);
        translate([0,holeY,-h+nutHeight/2+h/10])hexagon(nutSize,nutHeight);
        translate([0,-holeY,-h+nutHeight/2+h/10])hexagon(nutSize,nutHeight);
        translate([nutSize/2,-holeY,-h+nutHeight/2+h/10])cube([nutSize,nutSize,nutHeight],true);
        translate([nutSize/2,holeY,-h+nutHeight/2+h/10])cube([nutSize,nutSize,nutHeight],true);
        translate([0,holeY,0])cylinder(BaseThick+20,screwDiam/2,screwDiam/2,$fn=60,true);
        translate([0,-holeY,0])cylinder(BaseThick+20,screwDiam/2,screwDiam/2,$fn=60,true);
    }
}
//button_hole(ButtonX,ButtonY,ButtonThick,BaseThick);
module button_hole(l,w,h,baseH){
      difference(){
          union(){
          translate([-l/2,0,-baseH+h])cube([2*l,w,w],center=true);
          difference(){

                cube([l,w,baseH+5],center=true);
                translate([0,0,-h/2])cube([l-4,w,baseH -h],center=true); 
           }   
       }
           translate([-l/2,w/2,-baseH/2+h-w/4])cube([2*l,w/8,w/4],true);
           translate([-l/2,-w/2,-baseH/2+h-w/4])cube([2*l,w/8,w/4],true);
   }
}
