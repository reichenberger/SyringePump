include<constants.scad>
use<basic_functions.scad>

EnclWallThick = 2;
//EnclLength = 61 + EnclWallThick*2;
//EnclWidth = 41 + EnclWallThick*2;
LengthComplBott =0;
EnclLength = 61 + EnclWallThick*2+LengthComplBott;
UIcoverLength = EnclLength -LengthComplBott ;
echo(UIcoverLength);
echo(L);
echo(EnclLength);
UIcoverThick = 5;   
EnclWidth = W+4;
EnclWallBottHeight = 26+EnclWallThick ;
BoardScrewHolesDistX = 56/2;
BoardScrewHolesDistY = 36/2;
BoardScrewHolesDiam = 2;
HoleDepth=EnclWallThick*3;
ColumnHeight = 3;
microUSBH = 14+ColumnHeight + EnclWallThick;
echo(microUSBH);
//powerH = 8+ColumnHeight+EnclWallThick;
powerH = 3+EnclWallThick + ColumnHeight;
signalH = 8+EnclWallThick+ColumnHeight;
displayW=38.5;
displayH = 4.5;
displayX = 13.5;
//
//enclosure_cover(UIcoverLength,EnclWidth,UIcoverThick);
enclosure();

//
//
//
//x =3.5;
//y=3;
// for(i =[UIcoverLength/2-x,-UIcoverLength/2+x])for(j = [-displayW/2-y,displayW/2+y])   translate([i,j,EnclWallBottHeight-2])hexagon(4,1.6);

module triangl_supp(){
    difference(){
    #rotate([0,0,-45])cube([8,2.7,0.9],true);
    #translate([0,-3,0])cube([8,1.9,1],true);
    #translate([-3,0,0])cube([2,7.9,1],true);
    }
}
module enclosure(){
//    translate([-(EnclLength)/2+9,0,EnclWallBottHeight+2])stepper_sidewall(11.6,2);
difference(){
union(){
translate([0,0,EnclWallThick/2])enclosure_bottom(EnclLength,EnclWidth,EnclWallThick,EnclWallBottHeight,BoardScrewHolesDistX,BoardScrewHolesDistY,BoardScrewHolesDiam,HoleDepth,ColumnHeight);
translate([-LengthComplBott/2,0,EnclWallThick+EnclWallBottHeight/2 - 0.1]) {wall_vertical(EnclLength,EnclWidth,EnclWallThick,EnclWallBottHeight,4,true);}
    
//    translate([0,0,EnclWallBottHeight+UIcoverThick/2 +10]){enclosure_cover(UIcoverLength,EnclWidth,UIcoverThick);}
x =3.5;
y=3;
    
     for(i =[UIcoverLength/2-x,-UIcoverLength/2+x])for(j = [-displayW/2-y,displayW/2+y]){
    #translate([i,j,EnclWallBottHeight+EnclWallThick-2.1])cylinder(4,2,2,$fn=60,true);
        
    }
    translate([-UIcoverLength/2+x+0.5,-displayW/2-y+0.5,EnclWallBottHeight+EnclWallThick-0.55]){
    triangl_supp();
}
translate([UIcoverLength/2-x-0.5,-displayW/2-y+0.5,EnclWallBottHeight+EnclWallThick-0.55]){
    rotate([0,0,90])triangl_supp();
}
translate([-UIcoverLength/2+x+0.5,displayW/2+y-0.5,EnclWallBottHeight+EnclWallThick-0.55]){
    rotate([0,0,-90])triangl_supp();
}
translate([UIcoverLength/2-x-0.5,displayW/2+y-0.5,EnclWallBottHeight+EnclWallThick-0.55]){
    rotate([0,0,180])triangl_supp();
}

//   translate([UIcoverLength/2-x+1,-displayW/2-y-1,EnclWallBottHeight+EnclWallThick-13])rotate([-5,-5,0])cylinder(20,0.4,2,$fn=60,true);
//    translate([UIcoverLength/2-x+1,displayW/2+y+1,EnclWallBottHeight+EnclWallThick-13])rotate([5,-5,0])cylinder(20,0.4,2,$fn=60,true);
//   translate([-UIcoverLength/2+x-1,displayW/2+y+1,EnclWallBottHeight+EnclWallThick-13])rotate([5,5,0])cylinder(20,0.4,2,$fn=60,true);
    
    
    //support columns
translate([-UIcoverLength/2+x-1,-displayW/2-y-1,EnclWallBottHeight+EnclWallThick-13])rotate([-5,5,0])cylinder(20,0.4,2,$fn=60,true);
    translate([UIcoverLength/2-x+1,-displayW/2-y-1,EnclWallBottHeight+EnclWallThick-13])rotate([-5,-5,0])cylinder(20,0.4,2,$fn=60,true);
    translate([UIcoverLength/2-x+1,displayW/2+y+1,EnclWallBottHeight+EnclWallThick-13])rotate([5,-5,0])cylinder(20,0.4,2,$fn=60,true);
   translate([-UIcoverLength/2+x-1,displayW/2+y+1,EnclWallBottHeight+EnclWallThick-13])rotate([5,5,0])cylinder(20,0.4,2,$fn=60,true);
}
//translate([-(EnclLength)/2+9,0,EnclWallBottHeight+2])stepper_sidewall(11.6,2);


//hexagon
x =3.5;
y=3;
 #for(i =[UIcoverLength/2-x,-UIcoverLength/2+x])for(j = [-displayW/2-y,displayW/2+y])   translate([i,j,EnclWallBottHeight+EnclWallThick-1.8])hexagon(4,1.6);
            
//screw holes
#for(i =[UIcoverLength/2-x,-UIcoverLength/2+x])for(j = [-displayW/2-y,displayW/2+y]){
    translate([i,j,EnclWallBottHeight+2])cylinder(4,1.25,1.25,$fn=60,true);
    }
#microusb_hole((EnclLength-LengthComplBott)/2);
#power_hole((EnclLength-LengthComplBott)/2);
#signal_holes(-EnclLength/2);
}
}
//display_hole(13,displayW,4.1);
//difference(){
//cube([13,displayW-1,1],true);
//cube([11,27,2],true);
//}


module enclosure_cover(l,w,h){
    difference(){
    translate([0,0,2])base_board_round(l,w,h,4);
        
        for(i =[displayW/2-ButtonY/2,displayW/4-ButtonY/2-1,-displayW/2+ButtonY/2,-displayW/4+ButtonY/2+1] )translate([l/5,i,0])rotate([0,0,90])button_hole(ButtonX,ButtonY,ButtonThick,BaseThick);
        
    translate([-l/6,0,-4.5/2])display_hole(displayX,displayW,displayH);
    //screw holes
        x =3.5;
        y=3;
        
        #for(i =[l/2-x,-l/2+x])for(j = [-displayW/2-y,displayW/2+y])translate([i,j,0])cylinder(70,1.25,1.25,$fn=60,true);
    //screw head hole
        for(i =[l/2-x,-l/2+x])for(j = [-displayW/2-y,displayW/2+y])    translate([i,j,4])cylinder(2,2,2,$fn=60,true);        
    }
    
    
}
//snap_male(3,0.5,5,0.5);
//translate([6,0,0])snap_female(3,0.5,5,0.5,1);


module enclosure_bottom(l,w,wallT,wallH,holeX,holeY,holeD,holeDp,columnH){
difference(){
    union(){
    translate([-LengthComplBott/2,0,0])enclosure_lid(EnclLength,EnclWidth,EnclWallThick);

   //screw columns  
         for(i=[holeX,-holeX])for(j=[holeY,-holeY])translate([i,j,columnH/2+wallT/2])cylinder(columnH,holeD,holeD,$fn=60,true);
    }//end union
    
    //screw holes
       
    for(i=[holeX,-holeX])for(j=[holeY,-holeY])translate([i,j,wallT])cylinder(holeDp,holeD/2,holeD/2,$fn=60,true); 
}//end difference
}

module microusb_hole(x){
    translate([x,9,microUSBH+2.5])cube([10,8,5],true);
}

module power_hole(x){
    translate([x,-11,powerH+11/2])cube([10.5,9.5,11.5],true);
    }
    
module signal_holes(x){
    for(y=[6.5,-12])translate([x,y,signalH+3.5])cube([10,12,7],true);
}    
//body_down(L+6,W,8);
module body_down(l,w,h){
    difference(){
        union(){
            for(i = [W/2-3.5,-W/2+3.5])for(j=[-l/2+4,l/2-8])translate([j,i,0])cylinder(h,2.5,2.5,$fn=60,true);
            
        difference(){
            union(){
            rotate([0,0,180])base_board_halfround(l,w,h,4);

                
        }
            translate([0,0,3])rotate([0,0,180])base_board_halfround(l-4,w-4,h,4);
            translate([l/2,0,0])cube([6.5,13,8],true);

        }
        
    }
       for(i = [W/2-3.5,-W/2+3.5])for(j=[-l/2+4,l/2-8])translate([j,i,0])cylinder(h+1,1.25,1.25,$fn=60,true);
        
}
}

//stepper_sidewall(L+6,11.6,2);
module stepper_sidewall(l,h,wThick){
difference(){
    union(){
         for(i = [W/2-3.5,-W/2+3.5])for(j=[-l/2+4,l/2-8])translate([j,i,0])cylinder(h,2.5,2.5,$fn=60,true);

  
    difference(){
        union(){

            rotate([0,0,180])base_board_halfround(l,W,h,4);
           
            }
        translate([L/2+3,0,0])cube([6.5,13,h+1],true);
        rotate([0,0,180])base_board_halfround(l-wThick*2,W-wThick*2,h+1,4);
        for(i = [(W-6)/2,-(W-6)/2])translate([L/2+1,i,0])cube([2,2,h+1],true);
            
      
        }
    }
    for(i = [W/2-3.5,-W/2+3.5])for(j=[-l/2+4,l/2-8])translate([j,i,0])cylinder(h+1,1.25,1.25,$fn=60,true);
   }
}

module wall_vertical(l,w,wallT,wallH,r,center){
        difference(){
            union(){
                minkowski(){
                    #cube([l-2*r,w-2*r,wallH/2],true);
                    #cylinder(wallH/2,r,r,$fn=60,true);
                }
            }
            cube([l-wallT*2,w-wallT*2,wallH+1],true);
            
        }
    }
module snap_male(x,y,z,r){
    union(){
        cube([x,y,z],true);
        translate([0,y/3,z/3])sphere(r,$fn=60,true);
    }
}
module snap_female(x,y,z,r,wall){
    difference(){
        cube([x+wall,y+wall,z],true);
        cube([x,y,z],true);
        translate([0,y/3,z/3])cube(r,$fn=60,true);
    }
}


//enclosure_lid(EnclLength,EnclWidth,EnclWallThick);
module enclosure_lid(l,w,wallT){
    minkowski(){
           cube([l-8,w-8,wallT/2],true);
           cylinder(wallT/2,4,4,$fn=60,true);
    }
}


module display_hole(x,y,z){
    difference(){
        union(){
        #translate([0,0,z])cube([x,y,z],true);
        #translate([0,y/2-2,0])cube([x-1,4,7],true);
        }
        #translate([x/2-0.25,0,z/2+(z-1)/2])cube([0.5,y,z-1],true);
        #translate([-x/2+0.25,0,z/2+(z-1)/2])cube([0.5,y,z-1],true);
    }
}
    